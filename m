From: Ali Akcaagac <aliakc@web.de>
Subject: 2.4/2.6 - ATAPI Zip problem in SCSI mode (DEVFS)
Date: Sat, 30 Aug 2003 05:02:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062212548.14628.22.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp01.web.de ([217.72.192.180]:27399 "EHLO smtp.web.de")
	by vger.kernel.org with ESMTP id S262296AbTH3DCo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 23:02:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hello,

There is a problem with the ZIP driver that follows me for quite a
longer time now. I can't exactly tell if it's the ZIP driver or an devfs
or an scsi emulation problem but I try to describe the problemcase as
good as possible.

I have an ATAPI Zip drive which I run through the SCSI emulation mode on
2.4/2.6 for quite some time now and my devs entries are being created
with devfs and devfsd which I'm running successfully for a couple of
years now.

Around 1 year or so, something has changed and finally today I found the
time writing about it.

The problem is that when having Linux booted and placing a Zip disk into
the drive then mounting doesn't work. It tells me that the device
doesn't exist. But the drive was found during boot.

So far so good on early 2.4 you simply cd into /dev/scsi.../.../ made an
'ls' and voila it gave the device a kick and it created the entry for
the Zip disk you then can mount it (devfs).

For 2.5 this doesn't work anymore and whenever you want to mount a Zip
disk you need to boot Linux together with a Disk inside the Drive, so
during boot it detects the Zip drive + the Disk.

But this behaviour is not correct because this opens the points:

a) I run my ATAPI CD-Rom in SCSI mode as well and it doesn't require a
media loaded during bootup. I can put a CD in whenever I want enter
mount /cdrom and voila it realizes the CD and mounts it. The CD-Rom is
being detected on boot nicely.

b) The same I do expect for Zip. It's being detected during boot but
somehow doesn't allow to mount if the linux kernel wasn't booted with a
Zip disk in the drive. But it shouldn't do that. I should be able to
boot linux normally, the drive get's detected and put a disk in it
whenever I wish.

I hope you can follow me.

For further feedback please CC me because I am not subscribed to the
list.

