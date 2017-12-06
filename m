From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Subject: [PATCH 18/45] drivers: scsi: qla2xxx: remove duplicate includes
Date: Wed,  6 Dec 2017 22:38:03 +0530
Message-ID: <1512580083-5750-1-git-send-email-pravin.shedge4linux@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39457 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbdLFRIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2017 12:08:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, pravin.shedge4linux@gmail.com

These duplicate includes have been found with scripts/checkincludes.pl but
they have been removed manually to avoid removing false positives.

Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 0aa9c38..525ac35 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -11,8 +11,6 @@
 #include "qla_def.h"
 #include "qla_gbl.h"
 
-#include <linux/delay.h>
-
 #define TIMEOUT_100_MS 100
 
 static const uint32_t qla8044_reg_tbl[] = {
-- 
2.7.4
