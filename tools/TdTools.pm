#!/usr/bin/env perl
# Manuel Pégourié-Gonnard, 2010. WTFPL v2.
# Updated 2017 Karl Berry.

use warnings;
use strict;
use utf8;
use open qw(:std utf8);
use Getopt::Long ();

package TdTools;

# defaults
my $texdoc_path = -d '.svn' ? '.' : -d '../.svn' ? '..' : $ENV{TEXDOCDEV};
my $texlive_path = $ENV{TLROOT} ? "$ENV{TLROOT}/bin/x86_64-linux" : undef;

# setup the controlled environment and return texdoc path
sub setup {
    my ($usage) = @_;

    # get options
    Getopt::Long::GetOptions(
        'td=s'              => \$texdoc_path,
        'tl=s'              => \$texlive_path,
    ) or die "Unkown option.\n$usage";

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

1;
