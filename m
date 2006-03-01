From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 2/22] lpfc 8.1.2: Remove unreferenced cfg_fcp_bind_method from struct lpfc_hba
Date: Tue, 28 Feb 2006 19:25:12 -0500
Message-ID: <20060301002512.GA15359@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:41382 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932736AbWCAAZO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:14 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PC0H015365
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:12 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PCAJ015364
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove unreferenced cfg_fcp_bind_method from struct lpfc_hba

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -290,7 +290,6 @@ struct lpfc_hba {
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
 	uint32_t cfg_fdmi_on;
-	uint32_t cfg_fcp_bind_method;
 	uint32_t cfg_discovery_threads;
 	uint32_t cfg_max_luns;
 	uint32_t cfg_poll;
