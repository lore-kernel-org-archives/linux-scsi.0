From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: osst: fix sparse warnings
Date: Wed,  4 Feb 2015 18:48:05 +0000
Message-ID: <1423075685-7397-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warnings:

osst.c:5699:1: warning: symbol 'dev_attr_ADR_rev' was not declared. Should it be static?
osst.c:5713:1: warning: symbol 'dev_attr_media_version' was not declared. Should it be static?
osst.c:5726:1: warning: symbol 'dev_attr_capacity' was not declared. Should it be static?
osst.c:5740:1: warning: symbol 'dev_attr_BOT_frame' was not declared. Should it be static?
osst.c:5754:1: warning: symbol 'dev_attr_EOD_frame' was not declared. Should it be static?
osst.c:5767:1: warning: symbol 'dev_attr_file_count' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.8.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/osst.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 5033223..4c100bf 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5696,7 +5696,7 @@ static ssize_t osst_adr_rev_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
+static DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
 
 static ssize_t osst_linux_media_version_show(struct device *dev,
 					     struct device_attribute *attr,
@@ -5710,7 +5710,7 @@ static ssize_t osst_linux_media_version_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
+static DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
 
 static ssize_t osst_capacity_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
@@ -5723,7 +5723,7 @@ static ssize_t osst_capacity_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
+static DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
 
 static ssize_t osst_first_data_ppos_show(struct device *dev,
 					 struct device_attribute *attr,
@@ -5737,7 +5737,7 @@ static ssize_t osst_first_data_ppos_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
+static DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
 
 static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 					struct device_attribute *attr,
@@ -5751,7 +5751,7 @@ static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
+static DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
 
 static ssize_t osst_filemark_cnt_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -5764,7 +5764,7 @@ static ssize_t osst_filemark_cnt_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
+static DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
 
 static struct class *osst_sysfs_class;
 
-- 
1.9.1
