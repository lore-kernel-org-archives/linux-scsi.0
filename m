From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 12/22] lpfc 8.1.2: Remove hba_list from struct lpfc_hba
Date: Tue, 28 Feb 2006 19:25:26 -0500
Message-ID: <20060301002526.GA15483@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:46502 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932740AbWCAAZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:27 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PQss015489
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:26 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PQaJ015488
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove hba_list from struct lpfc_hba

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -169,7 +169,6 @@ struct lpfc_sysfs_mbox {
 };
 
 struct lpfc_hba {
-	struct list_head hba_list;	/* List of hbas/ports */
 	struct lpfc_sli sli;
 	struct lpfc_sli2_slim *slim2p;
 	dma_addr_t slim2p_mapping;
