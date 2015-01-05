From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] ses: clear warning for unused variable
Date: Mon, 5 Jan 2015 11:33:51 -0800
Message-ID: <1420486431-1700177-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55682 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355AbbAETd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 14:33:57 -0500
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t05JUYdG008869
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2015 11:33:56 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1rqwx614ts-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2015 11:33:56 -0800
Received: from facebook.com (2401:db00:20:701c:face:0:3f:0)	by
 mx-out.facebook.com (10.212.232.63) with ESMTP	id
 c8dbff60951111e4aed80002c992ebde-d46dd390 for <linux-scsi@vger.kernel.org>;
	Mon, 05 Jan 2015 11:33:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org, dan.j.williams@intel.com, Song Liu <songliubraving@fb.com>

Remove the declaration of variable "err" in function
'enclosure_component_alloc':

 All warnings:
  drivers/misc/enclosure.c: In function 'enclosure_component_alloc':
  >> drivers/misc/enclosure.c:295:6: warning: unused variable 'err'
  >> [-Wunused-variable]
     int err, i;
         ^
Signed-off-by: Song Liu <songliubraving@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/misc/enclosure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 3289d4d..38552a3 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -295,7 +295,7 @@ enclosure_component_alloc(struct enclosure_device *edev,
 {
 	struct enclosure_component *ecomp;
 	struct device *cdev;
-	int err, i;
+	int i;
 	char newname[COMPONENT_NAME_SIZE];
 
 	if (number >= edev->components)
-- 
1.8.1

