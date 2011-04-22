package Dist::Zilla::PluginBundle::GENEHACK;
# ABSTRACT: BeLike::GENEHACK when you zilla your dist

=head1 SYNOPSIS

Loads the stuff I find myself using all the time. Currently equivalent to
this:

    [@Git]
    [Git::NextVersion]
    first_version = 0.1

    [@Basic]

    [AutoPrereqs]
    [Authority]
    authority = 'cpan:GENEHACK'
    do_metadata = 1
    [MinimumPerl]
    [PkgVersion]
    [PodWeaver]
    [Bugtracker]
    [Homepage]
    [MetaConfig]
    [MetaJSON]
    [Repository]
    github_http = 0
    [GitFmtChanges]
    [InstallGuide]
    [ReadmeFromPod]
    [ExtraTests]
    [PodCoverageTests]
    [PodSyntaxTests]
    [CompileTests]
    [EOLTests]
    [KwaliteeTests]
    [Twitter]
    [ArchiveRelease]
    [InstallRelease]
    [NextRelease]

=cut

use Moose;
use namespace::autoclean;
use Dist::Zilla;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Git;

use Dist::Zilla::Plugin::ArchiveRelease;
use Dist::Zilla::Plugin::Authority;
use Dist::Zilla::Plugin::AutoPrereqs;
use Dist::Zilla::Plugin::Bugtracker;
use Dist::Zilla::Plugin::CompileTests;
use Dist::Zilla::Plugin::EOLTests;
use Dist::Zilla::Plugin::ExtraTests;
use Dist::Zilla::Plugin::GitFmtChanges;
use Dist::Zilla::Plugin::Git::NextVersion;
use Dist::Zilla::Plugin::Homepage;
use Dist::Zilla::Plugin::InstallGuide;
use Dist::Zilla::Plugin::InstallRelease;
use Dist::Zilla::Plugin::KwaliteeTests;
use Dist::Zilla::Plugin::MetaConfig;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::MinimumPerl;
use Dist::Zilla::Plugin::NextRelease;
use Dist::Zilla::Plugin::PkgVersion;
use Dist::Zilla::Plugin::PodCoverageTests;
use Dist::Zilla::Plugin::PodSyntaxTests;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::ReadmeFromPod;
use Dist::Zilla::Plugin::Repository;
use Dist::Zilla::Plugin::Twitter;

sub configure {
  my $self = shift;

  $self->add_bundle('Git');

  $self->add_plugins(
    # auto-versioning from git
    [ 'Git::NextVersion' => { first_version => '0.1' } ],
  );

  $self->add_bundle('Basic' );

  ## PLUGINS WHAT MUNGE MAKEFILE
  $self->add_plugins(
    # automatically build deps list
    'AutoPrereqs' ,
  );


  ## PLUGINS WHAT MUNGE CODE FILES
  $self->add_plugins(
    # munge files to add authority info
    [ 'Authority' => { authority => 'cpan:GENEHACK' , do_metadata => 1 } ],

    # automagically determine minimum required perl version
    'MinimumPerl' ,

    # include $VERSION in all files
    'PkgVersion',

    # weave together POD bits
    'PodWeaver' ,

  );

  ## PLUGINS WHAT MUNGE META.* FILES
  $self->add_plugins(
    # auto-set info about bugtracker URL and mailto
    'Bugtracker' ,

    # auto-set homepage info
    'Homepage' ,

    # include a bunch of dist::zilla meta info in META.* files
    'MetaConfig' ,

    # include a META.json file in addition to META.yml
    'MetaJSON' ,

    # auto-set info about repository based on git config
    #   specify 'github_http'=>0 b/c META.json has distinct keys for
    #   repository url/web info
    [ 'Repository' => { github_http => 0 } ],

  );

  ## PLUGINS WHAT AUTO-GENERATE FILES
  $self->add_plugins(
    # auto-generate CHANGES
    'GitFmtChanges' ,

    # auto-make INSTALL
    'InstallGuide' ,

    # auto-generate a README
    'ReadmeFromPod' ,

    # munge Changes
    'NextRelease' ,
  );

  ## PLUGINS WHAT ADD TESTS
  $self->add_plugins(
    # testing is good.
    'ExtraTests' ,

    # really good
    'PodCoverageTests' ,
    'PodSyntaxTests' ,

    # oh, so very good
    'CompileTests' ,
    'EOLTests' ,
    'KwaliteeTests' ,
  );

  ## PLUGINS WHAT DO STUFF
  $self->add_plugins(
    # tweet releases. because i can.
    'Twitter' ,
    # install dist after release
    [ 'InstallRelease' => { install_command => 'cpanm .' } ] ,
  );

  ## PLUGINS WHAT NEED TO LOAD LATER THAN OTHERS
  $self->add_plugins(
    # save released dists under ./releases
    'ArchiveRelease'
  );


}

1;

=for Pod::Coverage configure

=cut
