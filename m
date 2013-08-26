From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 1/5] scsi: Fix incorrect function name in comment
Date: Mon, 26 Aug 2013 11:03:36 -0400
Message-ID: <1377529420-31775-2-git-send-email-emilne@redhat.com>
References: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3HZPDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 11:03:42 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3fOX023541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:41 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QF3eJX014378
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 11:03:41 -0400
In-Reply-To: <1377529420-31775-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The function name is "scsi_evt_emit", not "sdev_evt_emit".

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6dfb978..f6499db 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2171,7 +2171,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 EXPORT_SYMBOL(scsi_device_set_state);
 
 /**
- * 	sdev_evt_emit - emit a single SCSI device uevent
+ *	scsi_evt_emit - emit a single SCSI device uevent
  *	@sdev: associated SCSI device
  *	@evt: event to emit
  *
-- 
1.7.11.7

