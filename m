Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CC2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236599AbiFGErG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbiFGEqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06DED4108
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:45 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXaft025411
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ohFE8qLkvKY31wUHz6/LXf3OuyRR+/JRIclRIZrDzhg=;
 b=dABOMlWGSv2PjNVLMsZlu+JqCXi8lXqGM8A5G634JWeddLEzHK5vHdiKzBN/A6USPajZ
 e0U7flttvGU9suBGcGE9ovSyx9BFhaFqKiRqV324VC+5/2Jj0Fwesc1fd16ogsNfArAd
 YQ/17fS/5Egmw0a0VmO3RGX/N0UqUWi5Vs/gOYV1peICANNpQq+hAd8HcgL2AgEQVk7w
 D3k0n9JT++p7ssf60fkaoRlPKKALFhHNyXwbr+h3jfZw13cpFbwmzjo/KIBbe3zz75P/
 Csgc+QmH1sqfKpgWWA4igrQDCgbHRO/dwYSMK5Z7c34r4KrbMsN45cHDLiK0iWHEiGzA Ug== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8e-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jun
 2022 21:46:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:42 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 37C8E3F7075;
        Mon,  6 Jun 2022 21:46:42 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/11] qla2xxx: Update version to 10.02.07.500-k
Date:   Mon, 6 Jun 2022 21:46:27 -0700
Message-ID: <20220607044627.19563-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: poVh4Cvw_MkUVWk3a1BTKLWX8O8_Y5ZM
X-Proofpoint-GUID: poVh4Cvw_MkUVWk3a1BTKLWX8O8_Y5ZM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index b09d7d2080c0..e5ce7599cae2 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.400-k"
+#define QLA2XXX_VERSION      "10.02.07.500-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	400
+#define QLA_DRIVER_BETA_VER	500
-- 
2.19.0.rc0

