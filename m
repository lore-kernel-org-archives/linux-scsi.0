From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 22/42] qla2xxx: Include <delay.h> file for msleep declartion in qla_nx2.c file.
Date: Fri, 11 Apr 2014 16:54:27 -0400
Message-ID: <1397249687-32666-23-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:37361 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754775AbaDKVcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:00 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Atul Deshmukh <atul.deshmukh@qlogic.com>

Signed-off-by: Atul Deshmukh <atul.deshmukh@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index e631db4..73ca8ed 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/vmalloc.h>
+#include <linux/delay.h>
 
 #include "qla_def.h"
 #include "qla_gbl.h"
-- 
1.7.7

