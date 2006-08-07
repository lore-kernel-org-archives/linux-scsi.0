From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 03/10] qla4xxx: make one file funcs static 01
Date: Mon, 07 Aug 2006 10:37:13 -0500
Message-ID: <20060807153713.31019.5359.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:34466 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932163AbWHGPjm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:39:42 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- make defns static as they are used only in file scope.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6ae7079..aa30a86 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1496,7 +1496,7 @@ static int qla4xxx_eh_wait_on_command(st
  * qla4xxx_wait_for_hba_online - waits for HBA to come online
  * @ha: Pointer to host adapter structure
  **/
-int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
+static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
 {
 	unsigned long wait_online;
 
@@ -1545,8 +1545,8 @@ static int qla4xxx_eh_abort(struct scsi_
  * This function waits for all outstanding commands to a lun to complete. It
  * returns 0 if all pending commands are returned and 1 otherwise.
  **/
-int qla4xxx_eh_wait_for_active_target_commands(struct scsi_qla_host *ha, int t,
-					       int l)
+static int qla4xxx_eh_wait_for_active_target_commands(struct scsi_qla_host *ha,
+						      int t, int l)
 {
 	int cnt;
 	int status;
