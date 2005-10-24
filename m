From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 1/9] kill unused scsi_scan_single_target()
Date: Mon, 24 Oct 2005 18:01:11 -0400
Message-ID: <20051024220111.GA10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:48271 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751317AbVJXWBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:01:11 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 7A4651C0A827
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:01:11 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM1BNi010623
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:01:11 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit c2b1cdfc6ddc0d7bbcad57735bccb7f9ec774ad1
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 14:57:38 2005 -0400

    [SCSI] kill unused scsi_scan_single_target()

 drivers/scsi/scsi_scan.c |   13 -------------
 include/scsi/scsi_host.h |    2 --
 2 files changed, 15 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 327c5d7..cff0a70 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1452,19 +1452,6 @@ void scsi_scan_host(struct Scsi_Host *sh
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
-/**
- * scsi_scan_single_target - scan the given SCSI target
- * @shost:         adapter to scan
- * @chan:          channel to scan
- * @id:            target id to scan
- **/
-void scsi_scan_single_target(struct Scsi_Host *shost, 
-	unsigned int chan, unsigned int id)
-{
-	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 1);
-}
-EXPORT_SYMBOL(scsi_scan_single_target);
-
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 69313ba..26b3f70 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -634,8 +634,6 @@ extern void scsi_flush_work(struct Scsi_
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
-extern void scsi_scan_single_target(struct Scsi_Host *, unsigned int,
-	unsigned int);
 extern void scsi_rescan_device(struct device *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
