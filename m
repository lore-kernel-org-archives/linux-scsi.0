From: wolf2k5 <wolf2k5@gmail.com>
Subject: Swapping HDs with HW RAID 1 or cloning HDs over the network?
Date: Wed, 20 Apr 2005 20:12:27 +0200
Message-ID: <8d8ba2bb050420111256646ec5@mail.gmail.com>
Reply-To: wolf2k5 <wolf2k5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.204]:42178 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261708AbVDTSM1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 14:12:27 -0400
Received: by zproxy.gmail.com with SMTP id 13so191532nzp
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 11:12:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I have a Dell PowerEdge 1650 with a PERC 3/Di and a PowerEdge 1655MC
with a PERC 4/IM.

Both servers are running Red Hat Enterprise Linux 3 and hardware RAID
1 (mirroring).

'fdisk' output is slightly different on the two servers:

PE1650
Disk /dev/sda: 36.3 GB, 36397645824 bytes
255 heads, 63 sectors/track, 4425 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

PE1655MC
Disk /dev/sda: 36.3 GB, 36362519040 bytes
255 heads, 63 sectors/track, 4420 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

I need to migrate PE1655MC's applications and data to the PE1650 asap.

Can I just swap the 1655MC's two hard drives with 1650's ones?
I am not sure how the PERC 3/Di and PERC 4/IM handle RAID 1 and if
each RAID controller will be able to read the data written by the
other one.

I am only interested in migrating PE1655MC's data and application to
the PE1650, I don't care if PE1650's data and application get lost in
the migration.

If the swapping the HDs won't work, what is the best way to clone
PE1655MC's HDs to PE1650's ones over the network? Is there any special
Linux distribution that can be booted off the network (PXE) for it?

Thanks a lot.
