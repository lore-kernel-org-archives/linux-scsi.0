Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9F6CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ABD22053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504588AbfJYQNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728051AbfJYQNA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:00 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG92r1066060
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:12:59 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv1ycwsjb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:12:59 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:57 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCs2851183738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6730311C064;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5234911C050;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cs-00074u-2N; Fri, 25 Oct 2019 18:12:54 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 10/11] zfcp: proper indentation to reduce confusion in zfcp_erp_required_act
Date:   Fri, 25 Oct 2019 18:12:52 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0020-0000-0000-0000037E9B76
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0021-0000-0000-000021D4E94C
Message-Id: <df4f897f6e83eaa528465d0858d5a22daac47a2f.1572018132.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=804 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Steffen Maier <maier@linux.ibm.com>

No functional change.

The unary not operator only applies to the sub expression before
the logical or. So we return early if (not running) or failed.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 96f0d34e9459..93655b85b73f 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -174,7 +174,7 @@ static enum zfcp_erp_act_type zfcp_erp_required_act(enum zfcp_erp_act_type want,
 			return 0;
 		p_status = atomic_read(&port->status);
 		if (!(p_status & ZFCP_STATUS_COMMON_RUNNING) ||
-		      p_status & ZFCP_STATUS_COMMON_ERP_FAILED)
+		    p_status & ZFCP_STATUS_COMMON_ERP_FAILED)
 			return 0;
 		if (!(p_status & ZFCP_STATUS_COMMON_UNBLOCKED))
 			need = ZFCP_ERP_ACTION_REOPEN_PORT;
@@ -190,7 +190,7 @@ static enum zfcp_erp_act_type zfcp_erp_required_act(enum zfcp_erp_act_type want,
 			return 0;
 		a_status = atomic_read(&adapter->status);
 		if (!(a_status & ZFCP_STATUS_COMMON_RUNNING) ||
-		      a_status & ZFCP_STATUS_COMMON_ERP_FAILED)
+		    a_status & ZFCP_STATUS_COMMON_ERP_FAILED)
 			return 0;
 		if (p_status & ZFCP_STATUS_COMMON_NOESC)
 			return need;
-- 
2.21.0

