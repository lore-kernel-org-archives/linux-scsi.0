Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF842C3A59B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9328E23431
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GIXdAsJj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfH3WY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:24:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728138AbfH3WY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 18:24:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMJjih006169;
        Fri, 30 Aug 2019 15:24:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Xp1jTREgtFS7wAN4cVQ+VeA3PaBDwU/7B/+bvqa2w2Y=;
 b=GIXdAsJjKp7VyFYMBvcnaO5kGRQ+Ecnzjn/jMuux+AZ68/ecEFfztaaH0P6lrpxJeZ15
 b4SSUGPW4MthGzeI/Ca8e/4bObUyeRAlgkOto8EgJKIuKIR5zsT+073eixxTD3D9x91g
 HQulFyHl2q7c6GZU+c8+pp9vh03ZS//jCztmFphc06w/RbOIFevlaZX3looKG2Q6modP
 Wu0o3ZFhizWWxMNAanaKeOjZFeiBjXKAYIFf75+6FQRHZlLMJRgVSKHTWuPEovtrR6U3
 hJrbexhVoHWwHwfvCJMNoU3U4bSLWABMju+V2POebMEHtgInSX5ww67Gt8FDa63FwnKg QQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2upmepn44s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:24:24 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 15:24:22 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 15:24:22 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B774F3F703F;
        Fri, 30 Aug 2019 15:24:21 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7UMOLxQ023748;
        Fri, 30 Aug 2019 15:24:21 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7UMOL1J023746;
        Fri, 30 Aug 2019 15:24:21 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 6/6] qla2xxx: Update driver version to 10.01.00.19-k
Date:   Fri, 30 Aug 2019 15:24:02 -0700
Message-ID: <20190830222402.23688-7-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830222402.23688-1-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 0833546a1b43..a8f2a953ceff 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.01.00.18-k"
+#define QLA2XXX_VERSION      "10.01.00.19-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	1
-- 
2.12.0

