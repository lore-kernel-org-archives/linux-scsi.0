From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 7/8] [SCSI] osst: Staticize local symbols
Date: Thu, 08 Aug 2013 10:17:31 +0900
Message-ID: <002a01ce93d5$0e2a3f90$2a7ebeb0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48231 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab3HHBRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2013 21:17:33 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MR600DTGU976WC0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Aug 2013 10:17:31 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: 'Willem Riede' <osst@riede.org>, osst-users@lists.sourceforge.net, 'James Bottomley' <jejb@kernel.org>, linux-scsi@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/scsi/osst.c:5698:1: warning: symbol 'dev_attr_ADR_rev' was not declared. Should it be static?
drivers/scsi/osst.c:5712:1: warning: symbol 'dev_attr_media_version' was not declared. Should it be static?
drivers/scsi/osst.c:5725:1: warning: symbol 'dev_attr_capacity' was not declared. Should it be static?
drivers/scsi/osst.c:5739:1: warning: symbol 'dev_attr_BOT_frame' was not declared. Should it be static?
drivers/scsi/osst.c:5753:1: warning: symbol 'dev_attr_EOD_frame' was not declared. Should it be static?
drivers/scsi/osst.c:5766:1: warning: symbol 'dev_attr_file_count' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/scsi/osst.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 21883a2..2ec7ccf 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5695,7 +5695,7 @@ static ssize_t osst_adr_rev_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
+static DEVICE_ATTR(ADR_rev, S_IRUGO, osst_adr_rev_show, NULL);
 
 static ssize_t osst_linux_media_version_show(struct device *dev,
 					     struct device_attribute *attr,
@@ -5709,7 +5709,7 @@ static ssize_t osst_linux_media_version_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
+static DEVICE_ATTR(media_version, S_IRUGO, osst_linux_media_version_show, NULL);
 
 static ssize_t osst_capacity_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
@@ -5722,7 +5722,7 @@ static ssize_t osst_capacity_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
+static DEVICE_ATTR(capacity, S_IRUGO, osst_capacity_show, NULL);
 
 static ssize_t osst_first_data_ppos_show(struct device *dev,
 					 struct device_attribute *attr,
@@ -5736,7 +5736,7 @@ static ssize_t osst_first_data_ppos_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
+static DEVICE_ATTR(BOT_frame, S_IRUGO, osst_first_data_ppos_show, NULL);
 
 static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 					struct device_attribute *attr,
@@ -5750,7 +5750,7 @@ static ssize_t osst_eod_frame_ppos_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
+static DEVICE_ATTR(EOD_frame, S_IRUGO, osst_eod_frame_ppos_show, NULL);
 
 static ssize_t osst_filemark_cnt_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
@@ -5763,7 +5763,7 @@ static ssize_t osst_filemark_cnt_show(struct device *dev,
 	return l;
 }
 
-DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
+static DEVICE_ATTR(file_count, S_IRUGO, osst_filemark_cnt_show, NULL);
 
 static struct class *osst_sysfs_class;
 
-- 
1.7.10.4


