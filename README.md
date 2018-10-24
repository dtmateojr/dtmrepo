dtmrepo
=======

dtmrepo is a mrepo replacement

It offers advantages over mrepo with the addition of the following features:

1. sync with Red Hat's subscription manager thus allowing it to fetch RHEL7 packages
2. keep the latest N number of packages in a repo
3. protect a list of packages so that they would never be deleted from the repos
4. protect entire repos so that no packages will be deleted from the repos
5. freeze repos to prevent updates and deletions.
6. download specific package versions and automatically resolve dependencies
7. register and fetch packages from multiple Spacewalk (base) channels.

Please refer to instructions.txt for installation and documentation.
