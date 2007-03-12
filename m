From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/6] qla2xxx: Add scan_[start|finish]() callbacks for ISP24xx HBAs.
Date: Mon, 12 Mar 2007 10:41:27 -0700
Message-ID: <1173721291295-git-send-email-andrew.vasquez@qlogic.com>
References: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25532 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXCLRld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 13:41:33 -0400
In-Reply-To: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 68f5d24..f67ef38 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -157,6 +157,8 @@ static struct scsi_host_template qla24xx_driver_template = {
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
+	.scan_finished		= qla2xxx_scan_finished,
+	.scan_start		= qla2xxx_scan_start,
 	.change_queue_depth	= qla2x00_change_queue_depth,
 	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
-- 
1.5.0.3.382.g34572

