From: Joe Perches <joe@perches.com>
Subject: [PATCH 17/25] drivers/scsi: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:55 -0700
Message-ID: <f36b9f69b71b2c6efe3bee1a39722a1534338b92.1284406639.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1902 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab0IMTsh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:37 -0400
In-Reply-To: <cover.1284406638.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c        |    6 +++---
 drivers/scsi/lpfc/lpfc_init.c         |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 90cef71..bd01994 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1919,10 +1919,10 @@ static void bnx2i_process_iscsi_error(struct bnx2i_hba *hba,
 {
 	struct bnx2i_conn *bnx2i_conn;
 	u32 iscsi_cid;
-	char warn_notice[] = "iscsi_warning";
-	char error_notice[] = "iscsi_error";
+	static const char warn_notice[] = "iscsi_warning";
+	static const char error_notice[] = "iscsi_error";
 	char additional_notice[64];
-	char *message;
+	const char *message;
 	int need_recovery;
 	u64 err_mask64;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index da9ba06..7e61349 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -281,7 +281,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	uint32_t prog_id_word;
 	char dist = ' ';
 	/* character array used for decoding dist type. */
-	char dist_char[] = "nabx";
+	static const char dist_char[] = "nabx";
 
 	if (pmboxq->u.mb.mbxStatus != MBX_SUCCESS) {
 		mempool_free(pmboxq, phba->mbox_mem_pool);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index a7810a1..7eddde3 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1536,9 +1536,9 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 	mbox64_t		*mbox64;
 	mbox_t			*mbox;
 	scb_t			*scb;
-	char			skip[] = "skipping";
-	char			scan[] = "scanning";
-	char			*ss;
+	static const char	skip[] = "skipping";
+	static const char	scan[] = "scanning";
+	const char		*ss;
 
 
 	/*
-- 
1.7.3.rc1

