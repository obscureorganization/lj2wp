# lj2wp: LiveJournal to WordPress legacy export / import toolkit

_Some assembly required_

The current WordPress LiveJournal importer is broken as of 2017-04-09, but an older path exists that can enable you to import your LiveJournal to WordPress.

The tool (ljdump)[https://github.com/ghewgill/ljdump] still works to export LiveJournal content. It contains a converter called `convertdump` that exports that to an older WordPress XML import format. Unfortunately, WordPress.com and recent versions of WordPress no longer import this format. In order to import it, you need an older version of WordPress, sucn as 2.7.1. If you have that on hand, you can go through this process to get your Journal on a modern version of WordPress:

# Export your LiveJournal using `ljdump.py`
# Use `convertdump.py` to get a legacy WordPress LiveJournal XML import file
# (_Optional_) edit the dump file to remove entries and comments you do not want to keep
# Import that into a freshly installed WordPress 2.7.1 instance
# (_Optional_) edit the posts in WordPress to change settings, privacy of posts for example
# Export the site from the WordPress 2.7.1 instance
# Import the site into a modern WordPress instance, either https://wordpress.com/, another hosted version, or a self-hosted installation.

Unfortunately running WordPress 2.7.1 on any public network in 2017 is an [invitation to disaster](https://www.cvedetails.com/vulnerability-list/vendor_id-2337/product_id-4096/version_id-79030/Wordpress-Wordpress-2.7.1.html). Fortunately, you can use Vagrant and Virtualbox to run this on a private network on your own computer instead.

This project contains a `Vagrantfile` that sets up a WordPress 2.7.1 environment that can import the output from `convertdump.py`.

While the WordPress 2.7.1 importer functions to import entries and comments, it has *no support* for public / private posts. It will import _all_ your LiveJournal posts as public WordPress posts. You might want to redact the journal either before or after importing it. Patches and pull requests to add a patch to WordPress 2.7.1 to back-port this functionality would be welcome.

Some recent LiveJournal posts are also infested by spam comments. You might want to cut those out before importing.

To make this easier, there is a small [pretty.py](pretty.py) script that you can use to pretty-print the XML file or files so that it is easier to edit them before import.

# Instructions

## Export your existing LiveJournal

Make sure you have Vagrant (at least version 1.6.5) and VirtualBox (at least version 4.3.14r95030) installed. 

Change directory to the same directory as this project's `Vagrantfile` and type:

    vagrant up

This will take several minutes to download and install Linux, Apache, MySQL, PHP, WordPress, and `ljdump`. When this is done, use the Vagrant guest's python environment to run `ljdump` and `convertdump.py`:

    vagrant ssh
    # Now you are on the guest
    cd /vagrant/ljdump
    # Read the fine manual
    less README.md       
    # Set up a config file with your credentials
    cp ljdump.config.sample ljdump.config
    # edit this to include your LJ credentials and preference
    vim ljdump.config    
    # Run ljdump.py according to the instructions. 
    ./ljdump
    # Convert the export to LiveJournal XML compatible with the export module
    # Note: specifying "-i will make it export private and friends-locked entries
    # Note: "-l 1000" will put up to 1000 entries in one file, this might be too many
    #       as I only tested with a 90-entry LJ account
    ./convertdump.py -u myljusername -i -l 1000

This will create an one or more XML files containing the entries and comments from your LiveJournal.

## Optional: edit the XML file

It is likely that there will be spam comments or things you want to redact before you post the journal elsewhere.

You can edit the XML file or files directly, but be careful not to make changes that will break it, XML must be [well formed](https://en.wikipedia.org/wiki/Well-formed_document). To make this easier, you can run the included `pretty.py` XML pretty printer on the XML output, for example:

    ../pretty.py myljusername\ -\ 90.xml > myljusername-formatted.xml
    # Edit this either on the host or guest
    vim myljusername-formatted.xml

## Import the export file to the local WordPress

After running `vagrant up`, WordPress is almost ready to go. Finish installing WordPress through your web browser by visiting:  http://192.168.33.21/wordpress/

Follow the instructions to name the blog and give it an email address, then login as administrator with the credentials it gives you.

In the left menu, go to "Tools...Import" and then choose "LiveJournal". Upload the XML file or files that the `convertdump.py` file created, or the edited copy of any XML export file you made changes to.

## Optional: edit the imported WordPress posts and comments

Once the WordPress posts are available, you might want to use WordPress to edit them. 

Concerning the privacy of posts, this older importer does not support adding a password to friends-locked posts. If you want to keep some posts "friends-locked" you might need to make them password protected instead, the best that WordPress can do in this area. It might be easiest to just give them all the same password, that is what the current WordPress LJ import would do _if it worked_ but do what you feel is best. This is workable in less than an hour if you have less than 100 or so posts that are friends-locked or private. Use a text editor to find posts that have the `<security>usemask</security>` element in the XML file and then search for the same posts in the WordPress editor and make them password protected with a password that you can distribute to friends. 

I'm not sure what the legacy WordPress LiveJournal importer does with posts that are marked Private in LJ, you should verify that those are Private in WordPress too. You can search for those by looking in the XML file for `<security>private</security>` entries.

I found it easier to nuke comments in the WordPress comment editor than to try to edit out spam comments in the source XML file.

## Export the posts

Once you have edited the posts, changed privacy settings on posts you want to keep back, and done some smoke testing by viewing the blog from a couple different browsers, you can export the blog in WordPress format.

In the left menu, choose "Tools...Export" and export the WordPress blog. This will save the file onto your host wherever you download files in your browser.

## Import the posts to a modern WordPress

The end goal of all this work is to have content that you can import into a modern WordPress instance. I used this to import to [my WordPress.com blog](https://obscurerichard.wordpress.com/) but this process should be useful for blogs hosted elsewhere and self-hosted WordPress instances also.

Sign into as an administrative user to your new permanent WordPress instance and go to "Tools...Import" and then import the exported file Take the file from the export in the last step and 

# Acknowledgements

I got the idea from [an older partially translated WordPress Codex entry](https://codex.wordpress.org/zh-cn:%E5%AF%BC%E5%85%A5%E5%86%85%E5%AE%B9#LiveJournal) which talked about getting an older version of WordPress and using that to do the LiveJournal import.

Many thanks go to Greg Hewgill (@ghewgill) for writing ljdump.

Thanks also go to Daniel Pataki (@danielpataki)'s work on setting up a quick Vagrant / LAMP stack:

*  https://gist.github.com/danielpataki/0861bf91430bf2be73da#file-way-sh
*  https://premium.wpmudev.org/blog/vagrant-wordpress-test-environment/

Thanks also go to Jeffrey Way (@JeffreyWay) work on a LAMP stack setup script, which @danielpataki adapted:

* https://gist.github.com/JeffreyWay/9244714/
* https://gist.github.com/JeffreyWay/af0ee7311abfde3e3b73

The versions of their scripts adapted here are less focused on development finesse and more on just getting WordPress 2.7.1 running with minimal effort.

# Legal

MIT Licensed. See [LICENSE.md](LICENSE.md) for details.
