From: akpm@linux-foundation.org
Subject: [patch 12/16] drivers/scsi/qla2xxx/qla_os.c: suppress uninitialized-var warning
Date: Thu, 03 Jul 2008 23:47:31 -0700
Message-ID: <200807040647.m646lVWF017502@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYGDGrf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 02:47:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, andrew.vasquez@qlogic.com

From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/qla2xxx/qla_os.c: In function 'qla2x00_post_work':
drivers/scsi/qla2xxx/qla_os.c:2158: warning: 'flags' may be used uninitialized in this function

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -2156,7 +2156,7 @@ qla2x00_alloc_work(struct scsi_qla_host 
 static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!locked)
_
