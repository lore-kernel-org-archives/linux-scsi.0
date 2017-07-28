From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 18/22] zfcp: clean up redundant code with fall through in link down SRB switch case
Date: Fri, 28 Jul 2017 12:31:04 +0200
Message-ID: <7334912a2cfb4c46ce7bf41ce53c851187891d5d.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36987 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751882AbdG1KbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:14 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASwlC015497
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2byyg8346j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:12 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVAPm34865176
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADF51AE0A3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94B15AE0A0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Martin Peschke <mpeschke@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
[maier@linux.vnet.ibm.com: re-worded short description for more details]
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index cc923c71a0fa..eefb474a9e42 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -197,8 +197,6 @@ static void zfcp_fsf_status_read_link_down(struct zfcp_fsf_req *req)
 
 	switch (sr_buf->status_subtype) {
 	case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-		zfcp_fsf_link_down_info_eval(req, ldi);
-		break;
 	case FSF_STATUS_READ_SUB_FDISC_FAILED:
 		zfcp_fsf_link_down_info_eval(req, ldi);
 		break;
-- 
2.11.2
