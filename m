From: Jeff Garzik <jeff@garzik.org>
Subject: What's left in libata-dev.git?
Date: Thu, 25 Oct 2007 05:55:09 -0400
Message-ID: <472067FD.3060400@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38629 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756230AbXJYJzO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 05:55:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, Jason Gaston <jason.d.gaston@intel.com>


This is a summary of items and issues that remain outstanding for 
libata.  Whenever a git branch is mentioned, it is referring to a branch 
at git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git


Current push just sent to Linus: 
http://marc.info/?l=linux-ide&m=119329974119307&w=2


Changes in 'upstream' branch pending for 2.6.24-rc, but not included in 
the above push:
     Tejun Heo (2):
	libata: relocate and fix post-command processing
	libata: track SLEEP state and issue SRST to wake it up


Active libata branches:
   ALL			Superset branch for -mm testing
   alpm			Link power management (2.6.24-rc hopefully)
   an			Async notify (2.6.24-rc hopefully)
   for-testing		Interesting-but-not-ready stuff
   master		Vanilla linux-2.6.git clone
   mv-ahci-pata		Marvell 6141 PATA support (incomplete)
   mv-ncq		sata_mv NCQ support (incomplete)
   new-eh		sata_qstore, sata_sx4 new-EH conversions
			(TEST ME! they have been in -mm for a while)
   pmask			proto_mask introduction
   sii-lbt		sata_sil large block transfer enablement
   upstream		pending for 2.6.24-rc
   upstream-linus	just pushed upstream for 2.6.24-rc


Patches and tasks in mbox queue, not yet in git:

1) Axboe: kill sg_last(), libata is last remaining user

2) Bart points out bugs in "Re: [git patches] libata update"

3) Tejun: libata: implement ata_wait_after_reset()

	^^^  Tejun, what case does this solve?  Still needed?

4) Alan: [PATCH] libata: Deal with ATA8-ACS proposed Trusted/Treacherous 
Computing features

5) Need a pass through bz.kernel.org


Please speak up if there is something missing.

	Jeff


