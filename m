From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [TRIVIAL PATCH 1/2] scsi: Add missing @sdev parameter description to scsi_report_sense()
Date: Mon, 26 Aug 2013 13:06:39 -0400
Message-ID: <1377536800-2298-2-git-send-email-emilne@redhat.com>
References: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab3HZRGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 13:06:42 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QH6gdZ010720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:06:42 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QH6fkL003198
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:06:42 -0400
In-Reply-To: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 598afd9..cf6fd20 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -241,6 +241,7 @@ static void scsi_report_lun_change(struct scsi_device *sdev)
 /**
  * scsi_report_sense - Examine scsi sense information and log messages for
  *		       certain conditions, also issue uevents for some of them.
+ * @sdev:	Device reporting sense information
  * @sshdr:	sshdr to be examined
  */
 static void scsi_report_sense(struct scsi_device *sdev,
-- 
1.7.11.7

