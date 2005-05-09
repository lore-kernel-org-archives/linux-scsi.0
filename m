From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: Machine locked up after cat /proc/scsi/dpt_i2o/0
Date: Mon, 09 May 2005 17:25:42 +0200
Message-ID: <d5nv1n$t1f$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:63461 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S261450AbVEIRaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2005 13:30:00 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1DVB2E-0003i4-6P
	for linux-scsi@vger.kernel.org; Mon, 09 May 2005 18:23:19 +0200
Received: from merlin2.provinz.bz.it ([62.101.0.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2005 18:23:00 +0200
Received: from andreas.moroder by merlin2.provinz.bz.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2005 18:23:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

as posted in another post i added two disks to a dpt_i2o raid system an 
dconfigured them as RAID

I type
cat /proc/scsi/dpt_io2/0
and the machine freezed completely.

We did restart the maschine and now linux lists the new drives.

The last entry in /var/log/messages was

May  9 16:51:47 galileost kernel: scsi singledevice 1 0 0 0
May  9 16:51:47 galileost kernel: blk: queue e01b0018, I/O limit 4095Mb 
(mask 0xffffffff)
May  9 16:51:47 galileost kernel: scsi singledevice 1 0 1 0
May  9 16:51:48 galileost kernel: scsi singledevice 1 0 2 0
May  9 16:51:48 galileost kernel: scsi singledevice 1 0 3 0
May  9 16:51:48 galileost kernel: scsi singledevice 1 0 4 0

... ( many of them )

Is this a bug in the dpt_i2o driver of 2.4.19-64GB-SMP
( SLES 8 )

Regards
Andreas

