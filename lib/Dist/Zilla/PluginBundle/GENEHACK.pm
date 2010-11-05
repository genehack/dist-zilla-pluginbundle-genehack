package Dist::Zilla::PluginBundle::GENEHACK;

# ABSTRACT: BeLike::GENEHACK when you zilla your dist

=head1 SYNOPSIS

Loads the stuff I find myself using all the time. Currently equivalent to
this:

    [@Git]
    [Git::NextVersion]
    first_version = 0.01

    [@Basic]

    [AutoPrereqs]
    [CriticTests]
    [ExtraTests]
    [PodCoverageTests]
    [PodSyntaxTests]
    [PodWeaver]

=cut

use Moose;
use namespace::autoclean;
use Dist::Zilla;
with 'Dist::Zilla::Role::PluginBundle::Easy';

BEGIN {
  $Dist::Zilla::PluginBundle::GENEHACK::VERSION = '1.004';
}

use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Git;

sub configure {
  my $self = shift;

  $self->add_bundle('Git');
  $self->add_plugins(
    [ 'Git::NextVersion' => { first_version => '0.01 '} ],
  );

  $self->add_bundle('Basic');
  $self->add_plugins(
    'AutoPrereqs' ,
    'CriticTests' ,
    'ExtraTests' ,
    'MetaConfig' ,
    'MetaJSON' ,
    'PodCoverageTests' ,
    'PodSyntaxTests' ,
    'PodWeaver' ,
    'Repository' ,
  )
}

1;

=for Pod::Coverage configure

=cut
