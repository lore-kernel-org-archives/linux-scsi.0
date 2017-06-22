From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] block: cciss: constify cciss_host_attr_group and cciss_dev_attr_group
Date: Thu, 22 Jun 2017 17:42:36 +0530
Message-ID: <23589a90f5c2c7b6d633f036b04edb0356284efc.1498133475.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33698 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdFVMNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2017 08:13:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com, esc.storagedev@microsemi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

File size before:
   text	   data	    bss	    dec	    hex	filename
  40911	   1432	    304	  42647	   a697	drivers/block/cciss.o

File size After adding 'const':
   text	   data	    bss	    dec	    hex	filename
  41039	   1304	    304	  42647	   a697	drivers/block/cciss.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/block/cciss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cd37550..8932cf6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -853,7 +853,7 @@ static ssize_t cciss_show_usage_count(struct device *dev,
 	NULL
 };
 
-static struct attribute_group cciss_host_attr_group = {
+static const struct attribute_group cciss_host_attr_group = {
 	.attrs = cciss_host_attrs,
 };
 
@@ -879,7 +879,7 @@ static ssize_t cciss_show_usage_count(struct device *dev,
 	NULL
 };
 
-static struct attribute_group cciss_dev_attr_group = {
+static const struct attribute_group cciss_dev_attr_group = {
 	.attrs = cciss_dev_attrs,
 };
 
-- 
1.9.1
