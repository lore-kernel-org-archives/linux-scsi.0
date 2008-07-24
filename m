From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/5] qla2xxx: drivers/scsi/qla2xxx/qla_os.c: suppress uninitialized-var warning
Date: Thu, 24 Jul 2008 08:31:48 -0700
Message-ID: <1216913510-14767-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080724153108.GI561@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:23068 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbYGXPbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:31:52 -0400
In-Reply-To: <20080724153108.GI561@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Morton <akpm@linux-foundation.org>

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/qla2xxx/qla_os.c: In function 'qla2x00_post_work':
drivers/scsi/qla2xxx/qla_os.c:2158: warning: 'flags' may be used uninitialized in this function

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0f44914..8fc712b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2178,7 +2178,7 @@ qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
 static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!locked)
-- 
1.6.0.rc0.42.g186458

