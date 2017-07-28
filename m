From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 03/22] zfcp: Remove unneeded linux/miscdevice.h include
Date: Fri, 28 Jul 2017 12:30:49 +0200
Message-ID: <c4922afd6accd970bfadf89f438aa01fd979c3cb.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751671AbdG1KbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:12 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASvK0015468
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:12 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2byyg8344q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:11 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:10 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAV96314942678
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57B12420B8
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:18 +0100 (BST)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AD2C420BC
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:18 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:18 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Corentin Labbe <clabbe.montjoie@gmail.com>

drivers/s390/scsi/zfcp_aux.c does not contain any miscdevice so the
inclusion of linux/miscdevice.h is unnecessary.

[maier@linux.vnet.ibm.com: just for the records, this is in fact a
 minor missing code cleanup of the following older "feature"
 which also dropped the only former use of a misc device in zfcp:
 commit 663e0890e31c ("[SCSI] zfcp: remove access control tables
				    interface")
 commit b5dc3c4800cc ("[SCSI] zfcp: remove access control tables
				    interface (keep sysfs files)")
 commit 1b33ef23946a ("zfcp: remove access control tables interface
			     (port leftovers)")]

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index bcc8f3dfd4c4..82ac331d9125 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -29,7 +29,6 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
-#include <linux/miscdevice.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-- 
2.11.2
