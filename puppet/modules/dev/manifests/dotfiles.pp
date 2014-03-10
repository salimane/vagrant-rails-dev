# Definition: dotfilesSetup
#
# Description
#
# Parameters:
#
# Actions:
#
# Requires:
#  This definition has no requirements.
#
# Sample Usage:
#  dotfilesSetup
class  dev::dotfiles($username = 'vagrant') {

    $home_dir = "/home/${username}"

    exec {
        # "chsh -s /bin/zsh ${username}":
        #     unless  => "grep -E '^${username}.+:/bin/zsh$' /etc/passwd",
        #     require => [ Package['zsh'], USER[$username]];

        'clone_dotfiles':
            cwd     =>"${home_dir}/src",
            group   => $username,
            user    => $username,
            command => "git clone https://github.com/salimane/dotfiles.git ${home_dir}/src/dotfiles",
            creates => "${home_dir}/src/dotfiles",
            require => [Package['git'], Package['zsh'], USER[$username], File["${home_dir}/src"]];

        'hub':
            command => "gem install hub && hub hub standalone > ${home_dir}/bin/hub && chmod +x ${home_dir}/bin/hub",
            unless  => "[ -f /home/${username}/bin/hub]",
            require => [Package['git'], Class['rubysetup'], File["/home/${username}/bin"]],
            cwd     => "/home/${username}",
            user    => $username,
            group   => $username,
            timeout => 0;
    }

    file {
        "/home/${username}/src":
            ensure => 'directory',
            group  => $username,
            owner  => $username;

        "${home_dir}/bin":
            ensure => 'directory',
            group  => $username,
            owner  => $username;

        "${home_dir}/.zsh":
            ensure => 'directory',
            group  => $username,
            owner  => $username;

        "${home_dir}/.zshrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/zsh/.zshrc",
            require => [Exec['clone_dotfiles'], File["${home_dir}/.zsh/etc"]];

        "${home_dir}/.zsh/etc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/zsh/.zsh/etc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.wgetrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/wget/.wgetrc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.nanorc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/nano/.nanorc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.gitconfig":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/git/.gitconfig",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.gitattributes":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/git/.gitattributes",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.gemrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/rb/.gemrc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.valgrindrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/src/dotfiles/valgrind/.valgrindrc",
            require => Exec['clone_dotfiles'];
    }


    exec { 'copy-binfiles':
        cwd     => "${home_dir}/src/dotfiles",
        group   => $username,
        user    => $username,
        command => "cp bin/* ${home_dir}/bin/ && chmod +x ${home_dir}/bin/*",
        require => Exec['clone_dotfiles'],
    }
}
