# LiveJournal to WordPress crutches

_Some assembly required_

The current WordPress LiveJournal importer is broken, but there is a path that will let you import your LiveJournal to WordPress.

The tool (ljdump)[https://github.com/ghewgill/ljdump] still works to export LiveJournal content. It contains a converter called `convertdump` that exports that to an older WordPress XML import format. Unfortunately, WordPress.com and recent versions of WordPress no longer import this format. In order to import it, you need an older version of WordPress, sucn as 2.7.1. If you have that on hand, you can go through this process to get your Journal on a modern version of WordPress:

# Export your LiveJournal using `ljdump`
# Use `convertdump` to get a legacy WordPress LiveJournal XML import file
# (Optional) edit the dump file to remove entries and comments you do not want to keep
# Import that into a freshly installed WordPress 2.7.1 instance
# (Optional) edit the posts in WordPress to change settings, privacy of posts for example
# Export the site from the WordPress 2.7.1 instance
# Import the site into a modern WordPress instance, either https://wordpress.com/, another hosted version, or a self-hosted installation.

Unfortunately running WordPress 2.7.1 on any public network in 2017 is an invitation to disaster. Fortunately, you can use Vagrant and Virtualbox to run this on a private network on your own computer instead.

This contains a Vagrantfile that sets up a WordPres 2.7.1 environment that can import `ljdump/convertdump` output.

While the WordPress 2.7.1 importer functions to import entries and comments, it has *no support* for public / private posts. It will import _all_ your LiveJournal posts as public WordPress posts. You might want to redact the journal.

Some recent LiveJournal posts are also infested by spam comments. You might want to cut those out before importing.

To make this easier, there is a small [pretty.py](pretty.py) script that you can use to pretty-print the XML file or files so that it is easier to edit them before import.

I got the idea from [an older partially translated WordPress Codex entry](https://codex.wordpress.org/zh-cn:%E5%AF%BC%E5%85%A5%E5%86%85%E5%AE%B9#LiveJournal) which talked about getting an older version of WordPress 
