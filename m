From: Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 2/3][V3] scsi: sd: remove sysfs_match_string() dense array comment
Date: Wed, 8 May 2019 14:19:12 +0300
Message-ID: <20190508111913.7276-2-alexandru.ardelean@analog.com>
References: <20190508111913.7276-1-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190508111913.7276-1-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com, jic23@kernel.org, lars@metafoo.de, Alexandru Ardelean <alexandru.ardelean@analog.com>
List-Id: linux-scsi@vger.kernel.org

The comment is no longer valid, since it supports arrays with gaps now.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---

Changelog v2 -> v3:
* after fixing __sysfs_match_string() this comment is no longer valid

 drivers/scsi/sd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2b2bc4b49d78..73ce390956c1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -376,7 +376,6 @@ thin_provisioning_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(thin_provisioning);
 
-/* sysfs_match_string() requires dense arrays */
 static const char *lbp_mode[] = {
 	[SD_LBP_FULL]		= "full",
 	[SD_LBP_UNMAP]		= "unmap",
@@ -424,7 +423,6 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(provisioning_mode);
 
-/* sysfs_match_string() requires dense arrays */
 static const char *zeroing_mode[] = {
 	[SD_ZERO_WRITE]		= "write",
 	[SD_ZERO_WS]		= "writesame",
-- 
2.17.1
