From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 0/9] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 18:00:13 -0400
Message-ID: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:47503 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751331AbVJXWAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:00:14 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 0D54C1C0A80A
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:00:14 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM0Dsc010561
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:00:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The following patches are in the 'submit9' branch of
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/scsilun-2.6.git

1     [SCSI] kill unused scsi_scan_single_target()
2     [SCSI] remove cpqfcTS driver, long uncompilable
3     [SCSI] misc cleanups
4     [SCSI] s/scsi_scan_target/spi_scan_target/
5     [SCSI] split up __spi_scan_target()
6     [SCSI] introduce sfoo_printk, sfoo_id, sfoo_channel helpers
7     [SCSI] use {sdev,scmd,starget,shost}_printk in generic code
8     [SCSI] use sfoo_printk() in drivers
9     [SCSI] use scmd_id(), scmd_channel() throughout code

Except for patch #2, which is too large to post, the above patches will
follow this email.

If you are pulling the git repo, then you may branches submit0 (==Linus)
through submit9 (==all patches).  Each is cumulative:  submit0 is empty.
submit1 contains patch #1.  submit2 contains patch #1 and #2.  etc.

These patches are properly split up, and should be OK for upstream
once 2.6.14 is released (any day now).

