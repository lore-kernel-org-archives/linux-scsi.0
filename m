Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029ECC5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB05D21929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="W5T05oin"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389183AbfKEPH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:27 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389083AbfKEPH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5F0OY7015364;
        Tue, 5 Nov 2019 07:07:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=a96PmbKJvWq6WlN/eAt+kG/TjTfwZBJKPZS9daHVlMY=;
 b=W5T05oinJt65a+K5xpLEFCvPnVWf5Bnhczt6K042IsZJaYdQn674zJDF2QOzsonBajNi
 kllLiuKTjCBmZqMZcW/PZ/KVceU2+f7xwFTtHKfJ7VorpQ+ODnNfV5alFDoM3T8O55ZT
 YgwHIS1zL35pS+XAE3XKF4ykRDYquACLDC71v41D2TCNvAr7DAdCmWO3e2xUv2kU1eVT
 UgujWGy2dTQbdDMqIdvXKMStz7YXW6n7gjOmdfoVm0qcm3amUieyQxcJ0ZnHB+R07pIN
 J1qXDQxxkfneUvW1p23lzLBPo8uvZc8KZ67htALw7GCpRg15hUJFWNS1sS2Q97qlgJss 3A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amtrmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:25 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:23 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:22 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D55913F703F;
        Tue,  5 Nov 2019 07:07:22 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F7MYn008167;
        Tue, 5 Nov 2019 07:07:22 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F7MJ1008166;
        Tue, 5 Nov 2019 07:07:22 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 8/8] qla2xxx: Update driver version to 10.01.00.21-k
Date:   Tue, 5 Nov 2019 07:06:57 -0800
Message-ID: <20191105150657.8092-9-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105150657.8092-1-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 225e401b62fa..03bd3b712b77 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.01.00.20-k"
+#define QLA2XXX_VERSION      "10.01.00.21-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	1
-- 
2.12.0

