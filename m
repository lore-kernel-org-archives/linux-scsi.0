From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [TRIVIAL PATCH 2/2] scsi: Remove unused variable "flags" from scsi_report_sense()
Date: Mon, 26 Aug 2013 13:06:40 -0400
Message-ID: <1377536800-2298-3-git-send-email-emilne@redhat.com>
References: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3HZRGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Aug 2013 13:06:43 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7QH6hnk000494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:06:43 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r7QH6fkM003198
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 13:06:42 -0400
In-Reply-To: <1377536800-2298-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cf6fd20..7f95236 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -248,7 +248,6 @@ static void scsi_report_sense(struct scsi_device *sdev,
 			      struct scsi_sense_hdr *sshdr)
 {
 	enum scsi_device_event evt_type = SDEV_EVT_MAXBITS;	/* i.e. none */
-	unsigned long flags;
 
 	if (sshdr->sense_key == UNIT_ATTENTION) {
 		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03) {
-- 
1.7.11.7

