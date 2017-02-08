From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] scsi: sd: make sd_devt_release() static
Date: Wed,  8 Feb 2017 16:24:24 +0000
Message-ID: <20170208162424.6279-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34392 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbdBHQYb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 11:24:31 -0500
Received: by mail-pf0-f196.google.com with SMTP id y143so11993090pfb.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 08:24:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/scsi/sd.c:3087:6: warning:
 symbol 'sd_devt_release' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb6e68d..b9b32f58 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3084,7 +3084,7 @@ struct sd_devt {
 	struct disk_devt disk_devt;
 };
 
-void sd_devt_release(struct disk_devt *disk_devt)
+static void sd_devt_release(struct disk_devt *disk_devt)
 {
 	struct sd_devt *sd_devt = container_of(disk_devt, struct sd_devt,
 			disk_devt);
