Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52759C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC052084C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 07:35:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ky8fll2f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBHfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 03:35:03 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgIBHfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 03:35:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0827Pbs6023781
        for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2020 00:35:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=1KMMLJ9yzceNv/3oyFczhoIgsxAdks8BXhkeaFBgCzU=;
 b=Ky8fll2f3a654jjJRlsJ9fRq5fe/uBqXnvxT/6ycP+i5DcTVA7AyuhZTYR2WVFWwnysx
 fzyi/4zXe+0cTXyWLKOUPoETuK3EhMEYrCYd2qOmA3RlQuAcFE2blVa/+VoH9lCpP7mp
 X66Xp6qcTEeKOeFxsSMK3pu0nlujhkOd7c7K5MscYFDDTpjK7ckua5dfF6rIWpWykN0F
 b7l/JECl8To5SYwqyOxiYZkPoD/qpdrKccFT4+oGCuIGsv8xyeLIRNRlWdUDFJGr08z7
 zKs7nORCbtj9HdF34H5y5yIQ557VytPoN3nd7eg2aMl76Pxcvu9vyi+q8HYTAg8f/kA/ SQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 337phq55kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2020 00:35:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:34:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Sep
 2020 00:34:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Sep 2020 00:34:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 38E0E3F703F;
        Wed,  2 Sep 2020 00:34:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0827YspD011822;
        Wed, 2 Sep 2020 00:34:54 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0827Ysku011821;
        Wed, 2 Sep 2020 00:34:54 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] MAINTAINERS: update Marvell owned driver maintainers
Date:   Wed, 2 Sep 2020 00:34:30 -0700
Message-ID: <20200902073430.11787-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_03:2020-09-02,2020-09-02 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update Marvell owned driver maintainers and
add Marvell Upstream email alias to the maintainers list.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 MAINTAINERS | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index deaafb617361..0d06517cb2f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3506,13 +3506,17 @@ F:	drivers/net/ethernet/broadcom/bnx2.*
 F:	drivers/net/ethernet/broadcom/bnx2_*
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:	QLogic-Storage-Upstream@qlogic.com
+M:	Saurav Kashyap <skashyap@marvell.com>
+M:	Javed Hasan <jhasan@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2fc/
 
 BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
-M:	QLogic-Storage-Upstream@qlogic.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	Manish Rangankar <mrangankar@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2i/
@@ -14161,13 +14165,17 @@ S:	Supported
 F:	drivers/infiniband/hw/qib/
 
 QLOGIC QL41xxx FCOE DRIVER
-M:	QLogic-Storage-Upstream@cavium.com
+M:	Saurav Kashyap <skashyap@marvell.com>
+M:	Javed Hasan <jhasan@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/qedf/
 
 QLOGIC QL41xxx ISCSI DRIVER
-M:	QLogic-Storage-Upstream@cavium.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	Manish Rangankar <mrangankar@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/qedi/
@@ -14211,7 +14219,9 @@ F:	Documentation/networking/device_drivers/ethernet/qlogic/LICENSE.qla3xxx
 F:	drivers/net/ethernet/qlogic/qla3xxx.*
 
 QLOGIC QLA4XXX iSCSI DRIVER
-M:	QLogic-Storage-Upstream@qlogic.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	Manish Rangankar <mrangankar@marvell.com>
+M:	GR-QLogic-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/LICENSE.qla4xxx
-- 
2.19.0.rc0

