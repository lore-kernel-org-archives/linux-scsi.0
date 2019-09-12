Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C32CC4CEC7
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E1872081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 18:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WdoYOPsK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfILSLK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 14:11:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbfILSLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 14:11:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8CI9Th2019956;
        Thu, 12 Sep 2019 11:10:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=6npNO3G0R2nlJQgYnOrtJa1H56jGc580q2o7rqlwtgQ=;
 b=WdoYOPsKDIFNPAfC2NFejRBoQOYWdIHNzo18WFkyg0+fhO1RPIKugUHnbxEPX20Ra+lq
 WbjPx3VHFG5lgaQcUO4V2uBvPfi2O9oSe306o1zMk8p8EA/780MDcaeYNDne/H2N9QT6
 WNAN64A+hJsP6R9pvQmKYmZRuai6z1/qGmENJn0JzXwxb0+gogQF+3+4L3IUkVrGjHS1
 wBnQji+43uyOhPhNkMvW+47Q+4PcT+RG0sMOy8fp5klpxJK1sGJoTbr4NZG6pqZL9Fcb
 C+KQfj2vdcVHheXGNEHbAZUk9o93ATk7EZQslaf3p0sSsmJaPJulRED9vHkwpSV23b1J WQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uytdfg5s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Sep 2019 11:10:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 12 Sep
 2019 11:10:07 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 12 Sep 2019 11:10:07 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EB0E83F7040;
        Thu, 12 Sep 2019 11:10:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x8CIA6Gc006592;
        Thu, 12 Sep 2019 11:10:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x8CIA6kt006591;
        Thu, 12 Sep 2019 11:10:06 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 14/14] qla2xxx: Update driver version to 10.01.00.20-k
Date:   Thu, 12 Sep 2019 11:09:18 -0700
Message-ID: <20190912180918.6436-15-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190912180918.6436-1-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-12_09:2019-09-11,2019-09-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index a8f2a953ceff..225e401b62fa 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.01.00.19-k"
+#define QLA2XXX_VERSION      "10.01.00.20-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	1
-- 
2.12.0

