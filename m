From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 17/22] zfcp: fix kernel doc comment typos for struct zfcp_dbf_scsi
Date: Fri, 28 Jul 2017 12:31:03 +0200
Message-ID: <b2d16f3a7d55cd063a7e931a6479c53d9b373abd.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751759AbdG1KbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:15 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SAScs5088238
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:14 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2c01s2530r-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:14 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:13 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVAFX13828576
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85A22AE09C
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7606AAE0A3
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
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

Improves commit 250a1352b95e ("[SCSI] zfcp: Redesign of the debug tracing
for SCSI records.")

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 33ccf15b63e0..3508c00458f4 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -208,12 +208,12 @@ enum zfcp_dbf_scsi_id {
  * @scsi_result: scsi result
  * @scsi_retries: current retry number of scsi request
  * @scsi_allowed: allowed retries
- * @fcp_rsp_info: FCP response info
+ * @fcp_rsp_info: FCP response info code
  * @scsi_opcode: scsi opcode
  * @fsf_req_id: request id of fsf request
  * @host_scribble: LLD specific data attached to SCSI request
- * @pl_len: length of paload stored as zfcp_dbf_pay
- * @fsf_rsp: response for fsf request
+ * @pl_len: length of payload stored as zfcp_dbf_pay
+ * @fcp_rsp: response for FCP request
  * @scsi_lun_64_hi: scsi device logical unit number, high part of 64 bit
  */
 struct zfcp_dbf_scsi {
-- 
2.11.2
