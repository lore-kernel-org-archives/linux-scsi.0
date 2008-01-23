From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/10] [FCoE] Convert one ASSERT_NOTREACHED to WARN_ON(1)
Date: Tue, 22 Jan 2008 16:35:54 -0800
Message-ID: <20080123003554.8469.3245.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33841 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbYAWAuD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:50:03 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


---

 drivers/scsi/ofc/openfc/openfc_if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/ofc/openfc/openfc_if.c b/drivers/scsi/ofc/openfc/openfc_if.c
index 8725845..0b0c782 100644
--- a/drivers/scsi/ofc/openfc/openfc_if.c
+++ b/drivers/scsi/ofc/openfc/openfc_if.c
@@ -1059,7 +1059,7 @@ out_host_rem:
 	scsi_remove_host(openfcp->host);
 out_host_put:
 	scsi_host_put(openfcp->host);
-	ASSERT_NOTREACHED;	/* XXX caller doesn't check return yet */
+	WARN_ON(1);
 	return -1;
 }
 EXPORT_SYMBOL(openfc_register);

