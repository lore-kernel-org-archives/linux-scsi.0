Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E24C2D0E7
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 07:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 259BE207FC
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 07:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="zM0EQ/dB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgCZHIg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 03:08:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56940 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgCZHIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Mar 2020 03:08:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q710pv017922;
        Thu, 26 Mar 2020 00:08:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7gGr11O9pJ8x+bhlsX0sq/SG/BniIeMo/dlvqZux8FM=;
 b=zM0EQ/dBKmFioJ3D6szG1DL5tyIq/lDZDIv8sJhAV8Oud8VYrLS63l4Dcro0qdTXUGYO
 pfbvDDHw/072M1swaltZw+XEZruHTRsWG8iHZXHdY9dtjyMFTRRl7ZpfO7eCdBE6VxI7
 wSHBWpgVbYU01pFqeTArO+rFkLDEZr4hDMkqpJtdtbUkRrcjepfbt8zWBdDeZeLDHTPR
 lsZxkVip7KsNLPKz8w66fr9+QlhAaDY5I8AxPYyjVdwq9nFPU+Q54Faq9PGsnE+v6+tL
 f8MRW88+GiDs5Zm7uRSkMRH2vH/WqpaXc7SqJk/52LbFI7R8UaaKY1ERhwoD7IHPWI2d mw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 300bpctndt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 00:08:34 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Mar
 2020 00:08:32 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Mar 2020 00:08:31 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3707C3F7041;
        Thu, 26 Mar 2020 00:08:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02Q78WnB025561;
        Thu, 26 Mar 2020 00:08:32 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02Q78Wl6025559;
        Thu, 26 Mar 2020 00:08:32 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 8/8] qedf: Update the driver version to 8.42.3.5.
Date:   Thu, 26 Mar 2020 00:08:06 -0700
Message-ID: <20200326070806.25493-9-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200326070806.25493-1-skashyap@marvell.com>
References: <20200326070806.25493-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

- Update version to 8.42.3.5.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index b0e37af..7661a5d 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -4,9 +4,9 @@
  *  Copyright (c) 2016-2018 Cavium Inc.
  */
 
-#define QEDF_VERSION		"8.42.3.0"
+#define QEDF_VERSION		"8.42.3.5"
 #define QEDF_DRIVER_MAJOR_VER		8
 #define QEDF_DRIVER_MINOR_VER		42
 #define QEDF_DRIVER_REV_VER		3
-#define QEDF_DRIVER_ENG_VER		0
+#define QEDF_DRIVER_ENG_VER		5
 
-- 
1.8.3.1

