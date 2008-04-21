From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/qla2xxx/qla_os.c: make 2 functions static
Date: Mon, 21 Apr 2008 11:49:42 +0300
Message-ID: <20080421084942.GV26897@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41090 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYDUIuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 04:50:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- qla2x00_alloc_work()
- qla2x00_post_work()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qla2xxx/qla_os.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

e65698d54a14771ffd54797e87790a00aa7d1e0a diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8b33b16..d2dfd08 100644
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

