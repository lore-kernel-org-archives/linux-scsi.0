From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: fix sparse warnings
Date: Thu,  5 Feb 2015 09:41:08 +0000
Message-ID: <1423129268-16220-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warnings:
scsi_sysfs.c:201:25: warning: symbol 'dev_attr_hstate' was not declared. Should it be static?
scsi_sysfs.c:376:24: warning: symbol 'scsi_shost_attr_group' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/scsi/scsi_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1ac38e7..0eac0f7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -198,7 +198,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -373,7 +373,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
-- 
1.9.1
