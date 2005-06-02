From: Eric Wagar <eric@deadhookers.org>
Subject: RH9 upgrade to FC3 fails with I2O ZCR raid
Date: Thu, 02 Jun 2005 12:40:18 -0700
Message-ID: <429F60A2.1090207@deadhookers.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:47028 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S261262AbVFBTkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2005 15:40:20 -0400
Received: from nodin.corp.sgi.com (nodin.corp.sgi.com [192.26.51.193])
	by omx3.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id j52KAoKo021260
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 13:10:50 -0700
Received: from [192.26.74.95] (janus.corp.sgi.com [192.26.74.95])
	by nodin.corp.sgi.com (SGI-8.12.5/8.12.10/SGI_generic_relay-1.2) with ESMTP id j52JeJbT79564067
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 12:40:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I attempted to upgrade my RH9 (2.4.20-37.9) system to FC3 (2.6.9 I
believe is the release on the CDs).

I was able to get into Anaconda (by adding the I2O Block driver at the
"add Driver" screen) and to the section where I chose either a Fresh
install or an upgrade.

The first time I reached that point, the upgrade portion specified the
hdb (sdb) drive, which is my "backup" drive.  The drive I need to
upgrade is hda (sda).  I then power cycled the system and removed the
sdb drive to make sure nothing on that drive is touched.

I reached the same Fresh or Upgrade point, and this time the hda
(/dev/i2o/hda8) drive showed properly.  I chose upgrade, and this error
appears:
Error mounting device sda8 as /: No such file or directory
This most likely means this partition has not been formatted.
Press OK to reboot your system.
The only action at this point is to push the "OK" button for the reboot.
 I select "OK" and reboot to get back to the Fresh or Upgrade point, and
chose Fresh this time.  I did verify that the partitions shown are
hda{1-8}, with all sizes correct but no mount points specified.

I did not go any further.

The system has a 2010S ZCR Adaptec card with 2x36G RAID1 config, and a
36G standalone drive (so three cards).  It is a SuperMicro 6023P-8R with
2x2.4G Xeon and 1G RAM.

Since FC3 disk has 2.6.9, I didn't put the i2o_block into the CD's
because the i2o webpage shows that it is already in the 2.6.8.  (I do
see that some people have posted on the i2o website that they have had
successful installs.)

Currently the system is up with RH9 still on it.  I'd like to get FC3+
installed, but I can't seem to figure out what piece I am missing.

Any one give me some pointers?  Are there any alternatives to getting
FC3+ installed?  Unfortunately, don't look for immediate trial, as this
system is the only one I have.  I don't have a test system with the same
config.  Why?!, that'd be too easy!  :)

Thanks
eric

