From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/10] qla2xxx: make qla2x00_issue_iocb_timeout() static
Date: Thu, 24 Apr 2008 15:21:28 -0700
Message-ID: <1209075691-6539-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYDXWVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:41 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Adrian Bunk <bunk@kernel.org>

From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global qla2x00_issue_iocb_timeout()
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    4 ----
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 76eb4fe..f882706 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -152,10 +152,6 @@ extern int
 qla2x00_issue_iocb(scsi_qla_host_t *, void *, dma_addr_t, size_t);
 
 extern int
-qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *, dma_addr_t, size_t,
-    uint32_t);
-
-extern int
 qla2x00_abort_command(scsi_qla_host_t *, srb_t *);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d10cb06..875c418 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -681,7 +681,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
  * Context:
  *	Kernel context.
  */
-int
+static int
 qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
     dma_addr_t phys_addr, size_t size, uint32_t tov)
 {
-- 
1.5.5.1.67.gbdb8

