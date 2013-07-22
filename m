From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 2/2] libiscsi: Add missing prints for session and connection sysfs attrs
Date: Mon, 22 Jul 2013 07:46:10 -0400
Message-ID: <1374493570-17390-3-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1374493570-17390-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:28829
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab3GVMNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jul 2013 08:13:35 -0400
Received: from mail138-co1 (localhost [127.0.0.1])	by
 mail138-co1-R.bigfish.com (Postfix) with ESMTP id 33B417801B9	for
 <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2013 12:13:34 +0000 (UTC)
Received: from CO1EHSMHS025.bigfish.com (unknown [10.243.78.227])	by
 mail138-co1.bigfish.com (Postfix) with ESMTP id 4BFFA68004C	for
 <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2013 12:13:32 +0000 (UTC)
In-Reply-To: <1374493570-17390-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index afc6c3f..f757617 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3312,6 +3312,9 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 	case ISCSI_PARAM_DATASEQ_INORDER_EN:
 		len = sprintf(buf, "%d\n", session->dataseq_inorder_en);
 		break;
+	case ISCSI_PARAM_DEF_TASKMGMT_TMO:
+		len = sprintf(buf, "%d\n", session->def_taskmgmt_tmo);
+		break;
 	case ISCSI_PARAM_ERL:
 		len = sprintf(buf, "%d\n", session->erl);
 		break;
@@ -3522,6 +3525,9 @@ int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_IPV6_TC:
 		len = sprintf(buf, "%u\n", conn->ipv6_traffic_class);
 		break;
+	case ISCSI_PARAM_IPV6_FLOW_LABEL:
+		len = sprintf(buf, "%u\n", conn->ipv6_flow_label);
+		break;
 	case ISCSI_PARAM_IS_FW_ASSIGNED_IPV6:
 		len = sprintf(buf, "%u\n", conn->is_fw_assigned_ipv6);
 		break;
-- 
1.7.1


