From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 1/2] scsi: fix warning with unused variable
Date: Mon, 26 Aug 2013 23:19:27 +0900
Message-ID: <003301cea267$45ea3070$d1be9150$%jun@samsung.com>
References: <60A4377E7BEE4B2EA7855F9701B34BF0@chingDT>
 <1377512423.20958.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37910 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3HZOT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 10:19:29 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MS500ITW6GD0S50@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 26 Aug 2013 23:19:28 +0900 (KST)
In-reply-to: <1377512423.20958.7.camel@dabdike>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'James Bottomley' <James.Bottomley@HansenPartnership.com>

drivers/scsi/scsi_error.c:246:16: warning: unused variable 'flags' [-Wunused-variable]

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/scsi_error.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f16d1a6..83e591b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -243,7 +243,6 @@ static void scsi_report_sense(struct scsi_device *sdev,
 			      struct scsi_sense_hdr *sshdr)
 {
 	enum scsi_device_event evt_type = SDEV_EVT_MAXBITS;	/* i.e. none */
-	unsigned long flags;
 
 	if (sshdr->sense_key == UNIT_ATTENTION) {
 		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03) {
-- 
1.7.0.4


