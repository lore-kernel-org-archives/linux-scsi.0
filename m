From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/10] qla2xxx: qla_os.c, make 2 functions static
Date: Thu, 24 Apr 2008 15:21:27 -0700
Message-ID: <1209075691-6539-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbYDXWVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:37 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Adrian Bunk <bunk@kernel.org>

From: Adrian Bunk <bunk@kernel.org>

This patch makes the following needlessly global functions static:
- qla2x00_alloc_work()
- qla2x00_post_work()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a7c20f8..878a37a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2135,7 +2135,7 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	kfree(ha->nvram);
 }
 
-struct qla_work_evt *
+static struct qla_work_evt *
 qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
     int locked)
 {
@@ -2152,7 +2152,7 @@ qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
 	return e;
 }
 
-int
+static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
 	unsigned long flags;
-- 
1.5.5.1.67.gbdb8

