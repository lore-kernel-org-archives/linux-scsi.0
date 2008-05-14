From: akpm@linux-foundation.org
Subject: [patch 9/9] drivers/scsi/qla2xxx/qla_os.c: suppress uninitialized-var warning
Date: Wed, 14 May 2008 16:23:35 -0700
Message-ID: <200805142323.m4ENNZ6j026871@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726AbYENX0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 19:26:20 -0400
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
@@ -2155,7 +2155,7 @@ qla2x00_alloc_work(struct scsi_qla_host 
 static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
-	unsigned long flags;
+	unsigned long uninitialized_var(flags);
 
 	if (!locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
_
