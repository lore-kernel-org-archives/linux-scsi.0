From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 02/10] scsi: Correct size of envp[]
Date: Thu,  1 Aug 2013 16:57:31 -0400
Message-ID: <1375390659-12495-3-git-send-email-emilne@redhat.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3HAU5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:44 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvivj015647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:44 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvgvb031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:44 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The envp[] array in scsi_evt_emit() only needs to have 2 entries.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f6499db..6585049 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2180,7 +2180,7 @@ EXPORT_SYMBOL(scsi_device_set_state);
 static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 {
 	int idx = 0;
-	char *envp[3];
+	char *envp[2];
 
 	switch (evt->evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
-- 
1.7.11.7

