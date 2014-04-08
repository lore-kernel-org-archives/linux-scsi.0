From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH] scsi: Fix the comment of sd_major
Date: Tue, 8 Apr 2014 13:29:50 +0800
Message-ID: <5343894E.7000902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:51671 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbaDHFaF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 01:30:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hujianyang@huawei.com

Fix the comment of sd_major to right major numbers.

Signed-off-by: hujianyang <hujianyang@huawei.com>

---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954a..02ff975 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -529,7 +529,7 @@ static struct kobject *sd_default_probe(dev_t devt, int *partno, void *data)
  * ones with major1, ... Disk 256 is for major0 again, disk 272
  * for major1, ...
  * As we stay compatible with our numbering scheme, we can reuse
- * the well-know SCSI majors 8, 65--71, 136--143.
+ * the well-know SCSI majors 8, 65--71, 128--135.
  */
 static int sd_major(int major_idx)
 {
-- 
1.6.0.2

