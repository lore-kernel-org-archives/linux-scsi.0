From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] bnx2i: Make boot_nic entry visible in the sysfs session objects
Date: Mon, 19 May 2014 07:32:13 -0400
Message-ID: <1400499133-32196-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:28203 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589AbaESMCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2014 08:02:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 166543f..cabc8c1 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2234,6 +2234,9 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
 		case ISCSI_PARAM_TGT_RESET_TMO:
 		case ISCSI_PARAM_IFACE_NAME:
 		case ISCSI_PARAM_INITIATOR_NAME:
+		case ISCSI_PARAM_BOOT_ROOT:
+		case ISCSI_PARAM_BOOT_NIC:
+		case ISCSI_PARAM_BOOT_TARGET:
 			return S_IRUGO;
 		default:
 			return 0;
-- 
1.8.2.GIT

