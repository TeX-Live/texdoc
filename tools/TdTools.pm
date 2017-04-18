#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use open qw(:std utf8);
use Getopt::Long ();

package TdTools;

# defaults
my $texdoc_path = -d '.git' ? '.' : -d '../.git' ? '..' : $ENV{TEXDOCDEV};
my $texlive_path = $ENV{TLROOT} ? "$ENV{TLROOT}/bin/x86_64-linux" : undef;

# setup the controled environment and return texdoc path
sub setup {
    my ($usage, $check_branch) = @_;

    # get options
    my $dont_check_branch = not $check_branch;
    Getopt::Long::GetOptions(
        'td=s'              => \$texdoc_path,
        'tl=s'              => \$texlive_path,
        'dont-check-branch' => \$dont_check_branch,
    ) or die "Unkown option.\n$usage";

    # possibly check branch
    check_branch() unless $dont_check_branch;

    # derived (and exported) path
    my $texdoc_scriptdir = "$texdoc_path/script";
    my $texdoc_toolsdir  = "$texdoc_path/tools";

    # check the paths
    -d $texdoc_scriptdir or die "Bad texdoc_path";
    -d $texdoc_toolsdir  or die "Bad texdoc_path";
    -d $texlive_path and -x "$texlive_path/texlua" or die "Bad texlive_path";

    # use a controled environment
    $ENV{PATH} = "$texlive_path:$ENV{PATH}";    # use the right texlive
    $ENV{TEXMFHOME} = "$texdoc_toolsdir/texmf"; # use the right texdoc
    $ENV{LC_ALL} = 'C';                         # neutral lang setting

    return {
        texdoc_path     => $texdoc_path,
        texlive_path    => $texlive_path,
    }
}

# call this to make sure we are in the right branch
sub check_branch {
    my $hint = "use --dont-check-branch if you mean it.";
    if (open my $git_head_fh, '<', "$texdoc_path/.git/HEAD") {
        my $git_head = <$git_head_fh>;
        close $git_head_fh;
        my ($git_branch_name) = $git_head =~ m"^ref: refs/heads/(.*)";
        $git_branch_name ||= '(no branch)';
        ($git_branch_name eq 'texlive')
            or die "Bad branch `$git_branch_name'; $hint\n";
    } else {
        die "No a git repo; $hint\n";
    }
}

1;
