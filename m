From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 18/20] qla2xxx: Correctly set the read_optrom pointer for ISP8044.
Date: Fri, 13 Dec 2013 15:03:58 -0500
Message-ID: <1386965040-20611-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:58720 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab3LMUgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:36:49 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3f69e7c..24af8e0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2017,7 +2017,7 @@ static struct isp_operations qla8044_isp_ops = {
 	.beacon_on		= qla82xx_beacon_on,
 	.beacon_off		= qla82xx_beacon_off,
 	.beacon_blink		= NULL,
-	.read_optrom		= qla82xx_read_optrom_data,
+	.read_optrom		= qla8044_read_optrom_data,
 	.write_optrom		= qla8044_write_optrom_data,
 	.get_flash_version	= qla82xx_get_flash_version,
 	.start_scsi             = qla82xx_start_scsi,
-- 
1.7.7

