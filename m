From: Wayne <warnold@fairfield.com>
Subject: getting linux 7.3 to see scsi devices lun0 &lun1
Date: Thu, 09 Jan 2003 23:47:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1E6C7A.2070701@fairfield.com>
Reply-To: warnold@fairfield.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: gadio@netvision.net.il, linux-scsi@vger.kernel.org

To whoever is in the mood;

Help..

Have read the 'howto' on the scsi section and can not get the os to see 
lun1.
We are using a dual PIII 700mhz system 500meg of memory.  This system 
was running
linux 6.0 . We had a raid device attached to this system and the os saw 
the raid as /dev/sda and
/dev/sdb. That was good. But only to find out that we were loosing 
several hundred meg of space.
The file system was the /ext2 file system.
We needed to go to the /ext3 file system that creates the journald file 
system so it would know how to handle the larger file sizes.
Tried changing the .config file for the kernel to look for multiple luns 
by repacing the line;
  CONFIG_SCSI=Y  to read  CONFIG_SCSI_MULTI_LUN
(from the document about scsi).   No luck, still only lun0 shows up. 
 Were unable to try the
  scsidev  command.  Tried the make config  command, tried the 
rescan-scsi-bus.sh command as well.  No luck.
The scsi adaptor card is the   adaptec high voltage  aha-2944uw.
The raid is a tera-byte in size, has been used by a sun ultra as its 
controller, reformatted and recreated to go from solaris to linux. 
 Again, linux 6.0 saw both raid data sets that were created.

Help, if you could, please.

Regards,
Wayne Arnold

