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
class  dotfiles($username = 'vagrant') {

    $home_dir = "/home/${username}"

    exec {
        "chsh -s /bin/zsh ${username}":
            unless  => "grep -E '^${username}.+:/bin/zsh$' /etc/passwd",
            require => [ Package['zsh'], USER[$username]];

        'clone_dotfiles':
            cwd     =>"${home_dir}/htdocs",
            group   => $username,
            user    => $username,
            command => "git clone https://github.com/salimane/dotfiles.git ${home_dir}/htdocs/dotfiles",
            creates => "${home_dir}/htdocs/dotfiles",
            require => [Package['git'], Package['zsh'], USER[$username], File["${home_dir}/htdocs"]];

        'hub':
            command => "curl http://defunkt.io/hub/standalone -sLo /home/${username}/bin/hub && chmod +x /home/${username}/bin/hub",
            unless  => "[ -f /home/${username}/bin/hub]",
            require => [Package['git'], Class['rubysetup'], File["/home/${username}/bin"]],
            cwd     => "/home/${username}",
            user    => $username,
            group   => $username,
            timeout => 0;
    }

    file {
        "/home/${username}/htdocs":
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
            target  => "${home_dir}/htdocs/dotfiles/zsh/.zshrc",
            require => [Exec['clone_dotfiles'], File["${home_dir}/.zsh/etc"]];

        "${home_dir}/.zsh/etc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/zsh/.zsh/etc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.wgetrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/wget/.wgetrc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.nanorc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/nano/.nanorc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.gitconfig":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/git/.gitconfig",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.gitattributes":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/git/.gitattributes",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.gemrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/rb/.gemrc",
            require => Exec['clone_dotfiles'];

        "${home_dir}/.valgrindrc":
            ensure  => link,
            group   => $username,
            owner   => $username,
            target  => "${home_dir}/htdocs/dotfiles/valgrind/.valgrindrc",
            require => Exec['clone_dotfiles'];
    }


    exec { 'copy-binfiles':
        cwd     => "${home_dir}/htdocs/dotfiles",
        group   => $username,
        user    => $username,
        command => "cp bin/* ${home_dir}/bin/ && chmod +x ${home_dir}/bin/*",
        require => Exec['clone_dotfiles'],
    }
}
