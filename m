From: Viktor Rosenfeld <rosenfel@informatik.hu-berlin.de>
Subject: root on LVM on RAID?
Date: Fri, 2 Aug 2002 19:01:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802190158.C1725@mitte.informatik.hu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mitte.informatik.hu-berlin.de (root@mitte [141.20.21.141])
	by sigma.informatik.hu-berlin.de (8.11.3/8.11.3/INF-2.0-MA-SOLARIS-2.8) with ESMTP id g72H1xB28447
	for <linux-scsi@vger.kernel.org>; Fri, 2 Aug 2002 19:01:59 +0200 (MEST)
Received: (from rosenfel@localhost)
	by mitte.informatik.hu-berlin.de (8.11.6/8.11.6/SuSE Linux 0.5) id g72H1x001762
	for linux-scsi@vger.kernel.org; Fri, 2 Aug 2002 19:01:59 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I tried to install a root partition on a LVM device that sits on a
RAID-1 device and failed.

The partition type of the RAID-1 partitions is fd, and the RAID-1 device
is automatically detected at boot time.  However, the LVM device is not
automatically detected, since the partition type is not 8e.  Therefore I
get a kernel panic with the message: I have no root and I want to
scream.

So, in my very uninformed imponion, wouldn't it be possible to add
support for this kind of functionality?  When a RAID device is
autodetected at boot up, couldn't the md driver simply look for a LVM
signature and queue this device for autodetection of the LFM device at
bootup?

Also, is there any documentation of the Linux LVM and RAID drivers,
besides the source?

Thanks in advance,
Viktor
