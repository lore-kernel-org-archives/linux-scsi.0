Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7586CCA47C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 06:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiGOGCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 02:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiGOGCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 02:02:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5020F7A53F
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:35 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EMB5Z7009903
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=NCcU5ixjsW/8Aefo6/rDOEom1BBytsch+1NmNvKhxwg=;
 b=gN9ESHWCnazinFMIzTbAqWJhmgnzEgUvI+vOet02iV3zJwlQNy8h753EzoU2Q6EkWLaG
 CfQ2H5VZIKyRHaWZYOCIFBpDoXGWZ4v662zCQH6Du4LuKs+0ln9QUk920WQe+3/bDDMp
 T46rAiN9vIfgshvj2e3n+u7O5sIiVECKSm/GLn/8RAwgmGR6Q+oIzvZ30Po2k3ezHIQG
 WzpiSlXwJwGiSP/MuDMIRCx6Itjx4s5f01ZYxcbm11NX65ioPNsmTbGCyczHnMNxS0O4
 fPpMhln2xmVpmb5zAKHEaVWEDislNBQIMtJ6n6EWrAG/egwxDb4NejjBF+1PasHvnNcW yA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h9udu8g1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2022 23:02:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jul
 2022 23:02:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 Jul 2022 23:02:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0246A3F7059;
        Thu, 14 Jul 2022 23:02:31 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 0/6] qla2xxx driver features
Date:   Thu, 14 Jul 2022 23:02:21 -0700
Message-ID: <20220715060227.23923-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -Z0Y67RrHkXXlm2ZWeZHqeWwLeYtwsnP
X-Proofpoint-ORIG-GUID: -Z0Y67RrHkXXlm2ZWeZHqeWwLeYtwsnP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_02,2022-07-14_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver features to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Anil Gurumurthy (1):
  qla2xxx: Add NVMe parameters support in Auxiliary Image Status

Arun Easi (4):
  qla2xxx: Add debugfs create/delete helpers
  qla2xxx: Add a generic tracing framework
  qla2xxx: Add driver console messages tracing
  qla2xxx: Add srb tracing

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.900-k

 drivers/scsi/qla2xxx/qla_bsg.c     |   8 +-
 drivers/scsi/qla2xxx/qla_bsg.h     |   3 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  26 ++-
 drivers/scsi/qla2xxx/qla_dbg.h     | 286 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h     |  55 +++++-
 drivers/scsi/qla2xxx/qla_dfs.c     | 239 ++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_fw.h      |   3 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   1 +
 drivers/scsi/qla2xxx/qla_init.c    |   8 +-
 drivers/scsi/qla2xxx/qla_inline.h  |  12 ++
 drivers/scsi/qla2xxx/qla_iocb.c    |   4 +
 drivers/scsi/qla2xxx/qla_isr.c     |   5 +
 drivers/scsi/qla2xxx/qla_os.c      |  35 ++++
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 14 files changed, 675 insertions(+), 14 deletions(-)


base-commit: f095c3cd1b694a73a5de276dae919f05a8dd1811
-- 
2.19.0.rc0

