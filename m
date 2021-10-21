Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82828C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A5D86109F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhJUHey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 03:34:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48284 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230385AbhJUHer (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 03:34:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KMsQa8002523
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2hom7P3rI9M0Oo58EDymgFn3nX3eXSNJYZ263gT85sM=;
 b=FYeEs2Ym8hzvjYWGVLkTJyOwfF7ymZBUVfLOpAJCIY2wglxwIcHdJ+5dviKonsfJHoIB
 y8Hz9+dBtACDcMtQfhNuCbs6QWqoqDOw4D/tJb9MdUE/9l+8QotIKcbGIKpOU5Dt8SMV
 +D4O8L4zKSo47OM8zZV29Q/yhZDnajJWMHh3tRmnJnVaT/uUvBDT2Rn24ROv9aJLPijs
 mGJnr66QKzwM/1Hs9FRaV6FUT50llXan50xQogR0spFRD3NzyedoDFMU2SzDgqOH8/hX
 pKYqyGK7HPWcmGIftslR8ajc/DP6AgRgpzVwWq09U/KPisws+3M2Ve8JrcbU2h4W9eHl Ww== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3btjwdmrxn-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:31 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 00:32:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 21 Oct 2021 00:32:27 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CAF913F708E;
        Thu, 21 Oct 2021 00:32:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19L7WRti027669;
        Thu, 21 Oct 2021 00:32:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19L7WRbG027668;
        Thu, 21 Oct 2021 00:32:27 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 13/13] qla2xxx: Update version to 10.02.07.200-k
Date:   Thu, 21 Oct 2021 00:32:08 -0700
Message-ID: <20211021073208.27582-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211021073208.27582-1-njavali@marvell.com>
References: <20211021073208.27582-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: sh7LBKUI43W1_VzOFyVRI-L-ziJ0QLUF
X-Proofpoint-ORIG-GUID: sh7LBKUI43W1_VzOFyVRI-L-ziJ0QLUF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_02,2021-10-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 4b117165bf8b..27e440f8a702 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.07.100-k"
+#define QLA2XXX_VERSION      "10.02.07.200-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	7
-#define QLA_DRIVER_BETA_VER	100
+#define QLA_DRIVER_BETA_VER	200
-- 
2.19.0.rc0

