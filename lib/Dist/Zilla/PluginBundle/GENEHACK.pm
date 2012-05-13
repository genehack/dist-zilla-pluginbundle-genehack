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
    [CheckChangesHasContent]
    [MinimumPerl]
    [PkgVersion]
    [PodWeaver]
    [Bugtracker]
    [Homepage]
    [MetaConfig]
    [MetaJSON]
    [GithubMeta]
    [Repository]
    [InstallGuide]
    [ReadmeMarkdownFromPod]
    [CopyFilesFromBuild]
    copy = README.mkdn
    [ExtraTests]
    [PodCoverageTests]
    [PodSyntaxTests]
    [EOLTests]
    [Test::Compile]
    [Twitter]
    [Git::Commit]
    [Git::Tag]
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
use Dist::Zilla::Plugin::CheckChangesHasContent;
use Dist::Zilla::Plugin::EOLTests;
use Dist::Zilla::Plugin::ExtraTests;
use Dist::Zilla::Plugin::Git::NextVersion;
use Dist::Zilla::Plugin::GithubMeta;
use Dist::Zilla::Plugin::Homepage;
use Dist::Zilla::Plugin::InstallGuide;
use Dist::Zilla::Plugin::InstallRelease;
use Dist::Zilla::Plugin::MetaConfig;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::MinimumPerl;
use Dist::Zilla::Plugin::NextRelease;
use Dist::Zilla::Plugin::PkgVersion;
use Dist::Zilla::Plugin::PodCoverageTests;
use Dist::Zilla::Plugin::PodSyntaxTests;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::ReadmeMarkdownFromPod;
use Dist::Zilla::Plugin::Repository;
use Dist::Zilla::Plugin::TaskWeaver;
use Dist::Zilla::Plugin::Test::Compile;
use Dist::Zilla::Plugin::Twitter;

has is_task => (
  is      => 'ro',
  isa     => 'Bool',
  lazy    => 1,
  default => sub { $_[0]->payload->{task} },
);

sub configure {
  my $self = shift;

  $self->add_bundle('Git');

  $self->add_plugins(
    # auto-versioning from git
    [ 'Git::NextVersion' => { first_version => '0.1' } ],
  );

  $self->add_bundle('Basic');

  ## PLUGINS WHAT MUNGE MAKEFILE
  $self->add_plugins(
    # automatically build deps list
    'AutoPrereqs' ,
  );

  ## PLUGINS WHAT MAKE SURE WE DON'T LOOK STUPID
  $self->add_plugins(
    # does what it says on the tin
    'CheckChangesHasContent' ,
  );

  ## PLUGINS WHAT MUNGE CODE FILES
  $self->add_plugins(
    # munge files to add authority info
    [ 'Authority' => { authority => 'cpan:GENEHACK' , do_metadata => 1 } ],

    # automagically determine minimum required perl version
    'MinimumPerl' ,

    # include $VERSION in all files
    'PkgVersion',
  );

  # weave together POD bits or build a task module
  if ($self->is_task) { $self->add_plugins('TaskWeaver') }
  else {                $self->add_plugins('PodWeaver')  }

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
    # auto-make INSTALL
    'InstallGuide' ,

    # auto-generate a README.mkdn
    'ReadmeMarkdownFromPod' ,

    # and copy it from the build
    [ 'CopyFilesFromBuild' => { copy => 'README.mkdn' } ],

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
    'EOLTests' ,
    'Test::Compile' ,
  );

  ## PLUGINS WHAT DO STUFF
  $self->add_plugins(
    # tweet releases. because i can.
    'Twitter' ,
    # git magic
    'Git::Commit',
    'Git::Tag',
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
