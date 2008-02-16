From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] qla2xxx: fix compilation compile
Date: Sat, 16 Feb 2008 15:24:41 +0900
Message-ID: <200802160624.m1G6OgC1027039@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51480 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761476AbYBPGZL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Feb 2008 01:25:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, fujita.tomonori@lab.ntt.co.jp

scsi/qla2xxx/qla_dfs.c: In function 'qla2x00_dfs_fce_show':
scsi/qla2xxx/qla_dfs.c:26: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'uint64_t'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla2xxx/qla_dfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 1479c60..2cd899b 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -23,7 +23,7 @@ qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
 	mutex_lock(&ha->fce_mutex);
 
 	seq_printf(s, "FCE Trace Buffer\n");
-	seq_printf(s, "In Pointer = %llx\n\n", ha->fce_wr);
+	seq_printf(s, "In Pointer = %llx\n\n", (unsigned long long)ha->fce_wr);
 	seq_printf(s, "Base = %llx\n\n", (unsigned long long) ha->fce_dma);
 	seq_printf(s, "FCE Enable Registers\n");
 	seq_printf(s, "%08x %08x %08x %08x %08x %08x\n",
-- 
1.5.3.4

