From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 1/2] libiscsi: Add a missing break statement
Date: Mon, 22 Jul 2013 07:46:09 -0400
Message-ID: <1374493570-17390-2-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1374493570-17390-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:53368
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab3GVMNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jul 2013 08:13:35 -0400
Received: from mail134-co1 (localhost [127.0.0.1])	by
 mail134-co1-R.bigfish.com (Postfix) with ESMTP id 8398C18007E	for
 <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2013 12:13:34 +0000 (UTC)
Received: from CO1EHSMHS025.bigfish.com (unknown [10.243.78.253])	by
 mail134-co1.bigfish.com (Postfix) with ESMTP id EA4BB5E020A	for
 <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2013 12:13:31 +0000 (UTC)
In-Reply-To: <1374493570-17390-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 86153e0..afc6c3f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3350,6 +3350,7 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 		break;
 	case ISCSI_PARAM_BOOT_TARGET:
 		len = sprintf(buf, "%s\n", session->boot_target);
+		break;
 	case ISCSI_PARAM_AUTO_SND_TGT_DISABLE:
 		len = sprintf(buf, "%u\n", session->auto_snd_tgt_disable);
 		break;
-- 
1.7.1


