From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 01/14] qla2xxx: Fix warnings reported by static checker.
Date: Thu, 9 Apr 2015 14:59:55 -0400
Message-ID: <1428606008-14976-2-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:65233 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933355AbbDITlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:41:35 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5f6b296..cdaf52e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2163,7 +2163,7 @@ struct ct_fdmi_hba_attr {
 		uint8_t node_name[WWN_SIZE];
 		uint8_t manufacturer[64];
 		uint8_t serial_num[32];
-		uint8_t model[16];
+		uint8_t model[16+1];
 		uint8_t model_desc[80];
 		uint8_t hw_version[32];
 		uint8_t driver_version[32];
@@ -2184,9 +2184,9 @@ struct ct_fdmiv2_hba_attr {
 	uint16_t len;
 	union {
 		uint8_t node_name[WWN_SIZE];
-		uint8_t manufacturer[32];
+		uint8_t manufacturer[64];
 		uint8_t serial_num[32];
-		uint8_t model[16];
+		uint8_t model[16+1];
 		uint8_t model_desc[80];
 		uint8_t hw_version[16];
 		uint8_t driver_version[32];
@@ -2252,7 +2252,7 @@ struct ct_fdmiv2_port_attr {
 		uint32_t cur_speed;
 		uint32_t max_frame_size;
 		uint8_t os_dev_name[32];
-		uint8_t host_name[32];
+		uint8_t host_name[256];
 		uint8_t node_name[WWN_SIZE];
 		uint8_t port_name[WWN_SIZE];
 		uint8_t port_sym_name[128];
@@ -2283,7 +2283,7 @@ struct ct_fdmi_port_attr {
 		uint32_t cur_speed;
 		uint32_t max_frame_size;
 		uint8_t os_dev_name[32];
-		uint8_t host_name[32];
+		uint8_t host_name[256];
 	} a;
 };
 
-- 
1.7.7

