From: Matthias =?iso-8859-1?Q?J=E4nichen?= <mj2@percomp.de>
Subject: 2.4.22-rc2/AIC7xxx
Date: Fri, 22 Aug 2003 14:45:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030822144509.00d99a10@127.0.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.percomp.de ([192.88.4.5]:63108 "HELO gateway.percomp.de")
	by vger.kernel.org with SMTP id S263147AbTHVMtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 08:49:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

my system drives me crasy  ;-(

The problems started already back with 2.4.18 suddenly there are I/O-Errors 
and you need to reboot. fsck brings a lot of something like "I_block size 
is xx should by yy" while yy is always smaller than xx.

Then I decided to try out 2.4.22-rc2 first it ran quite well but then after 
some time again IO-Errors with SCSI resets

System is a P2B-S with SCSI on board.
Cabeling/termination checked.
Adaptec and HDD bois latest available
DiskSelfTest runs OK
Adaptec verify is ok as well.
Temprature is OK

On the web I find problems with SCSI, AIC7xxx, ext2, ext3 and other related 
sile system stuff, but no soulution yet.

All errors seem to be only on dev/sda5 which is the partition for /var

df reports: /dev/sda5 10958172  8987292  1414232  87%

sda5 is a partition sda4 (extended). I thought there might be a problem 
with the size of the fs, so i reduced the number of files dramatically to
             /dev/sda5 10958172   871240  9530284   9%

I am waiting for the next occurrence after rebooting because the rduction 
allone did not help. which indicates to me that there might be  problem 
with the file cache or the fact that some files are scattered all over the 
disk.

Any Ideas?

Thanks
Matthias 

