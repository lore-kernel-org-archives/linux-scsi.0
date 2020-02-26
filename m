Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827EFC4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5374020658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:41:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="mDW29/IF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBZWla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:41:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbgBZWl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:41:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeN64006111;
        Wed, 26 Feb 2020 14:41:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=1+h9shHLcSF0M9J53an0unPEAuGsn33WmdnyR4mI/EA=;
 b=mDW29/IFhAuDMpJYZK984VgkVEWeWerzdOWzC34ZE2N/11kRR6ZNw2Ldoyo66u469EJg
 U65TwgQclmyLYi7tMqkRjKIMCVjSXPASXOzsDy2h7IUCbLgD9tWf/d9/jy4wpbsogaSl
 HUZOiTL+FZ0552J1ZI4p5xKwt2ofKsHYC3eN9GSDpSEfnAKbYdGjtAf92FhStrlJvtOO
 bJJzdyiHSgZnMm2JNcZEy4+wbt9BqLZxVCdAq6CFivpCPKhupGFphOPNBTcnnhthLugj
 bthMhjUFRLH/islW2q9sTYrWn9pa/7JT3LPDaMQunbkTMwGPUiARKitXcdUQerf/SU2C pA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:20 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:18 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:18 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:41:17 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DAA4D3F7048;
        Wed, 26 Feb 2020 14:41:17 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMfHlg024633;
        Wed, 26 Feb 2020 14:41:17 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMfHeG024632;
        Wed, 26 Feb 2020 14:41:17 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 18/18] qla2xxx: Update driver version to 10.01.00.25-k
Date:   Wed, 26 Feb 2020 14:40:22 -0800
Message-ID: <20200226224022.24518-19-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 6b4ca3ed8f22..8ccd9ba1ddef 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.01.00.24-k"
+#define QLA2XXX_VERSION      "10.01.00.25-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	1
-- 
2.12.0

