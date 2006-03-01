From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 15/22] lpfc 8.1.2: Make lpfc_els_rsp_rps_acc and lpfc_els_rsp_rpl_acc static
Date: Tue, 28 Feb 2006 19:25:30 -0500
Message-ID: <20060301002530.GA15521@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:48038 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964863AbWCAAZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:32 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PUts015527
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:30 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PUwt015526
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Make lpfc_els_rsp_rps_acc and lpfc_els_rsp_rpl_acc static

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2668,7 +2668,7 @@ lpfc_els_rcv_lirr(struct lpfc_hba * phba
 	return 0;
 }
 
-void
+static void
 lpfc_els_rsp_rps_acc(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 {
 	struct lpfc_sli *psli;
@@ -2795,7 +2795,7 @@ lpfc_els_rcv_rps(struct lpfc_hba * phba,
 	return 0;
 }
 
-int
+static int
 lpfc_els_rsp_rpl_acc(struct lpfc_hba * phba, uint16_t cmdsize,
 		 struct lpfc_iocbq * oldiocb, struct lpfc_nodelist * ndlp)
 {
