Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB238C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 09:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbiCJJ12 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Mar 2022 04:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240755AbiCJJ10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2022 04:27:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96934139CD6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:25 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22A1dmHO025048
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Ml4FSqTxg1HDs21wRELUfDOhJ5YuOjxmMtoaTLrjLJI=;
 b=DqB1Qxbn0vxvsPM0Lako4+FaDizm0nmIxf7xnKVELxOCqevEWwHgA/7Qx2aGO4nXwJ+B
 9nAzPuE07WTHueKqsYeLjbeRyyoLdxpEPP6BZDbpxL0fM4Tbl+4ZlGsij+v9CZ4clT+F
 YQtLu41pNVo4I5zRkV+56IxkoQQSmO7m5UfJIFA/77zEvXQmr9dLp5rrGb7VLRVy0E6t
 dAXhZo3jvKBJAUwZdU82QR8DjmRxRDuVS6oWPfny2HZTYzguYlYRRT8rKlOqWvfB7vxU
 /SW5x3ICf/Rp7pVHGJWQDltensogRDq2ZWVRUwnJ33nBiL4XeovlDhgGSE//EXNOgEeX Vw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38pmd7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 10 Mar 2022 01:26:24 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Mar
 2022 01:26:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Mar 2022 01:26:22 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C6A0B3F7058;
        Thu, 10 Mar 2022 01:26:22 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 22A9QJAr022985;
        Thu, 10 Mar 2022 01:26:19 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 22A9Q4Bi022984;
        Thu, 10 Mar 2022 01:26:04 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 00/13] qla2xxx driver fixes
Date:   Thu, 10 Mar 2022 01:25:51 -0800
Message-ID: <20220310092604.22950-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: RGvvhujCEkBORX1qIRjMPv6ILdD-An37
X-Proofpoint-ORIG-GUID: RGvvhujCEkBORX1qIRjMPv6ILdD-An37
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_03,2022-03-09_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver misc bug fixes to the scsi tree
at your earliest convenience.

v2:
- Incorporate all minor review comments
- Add Fixes tag to 11/13
- Add Reviewed-by tag

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Fix loss of NVME namespaces after driver reload test
  qla2xxx: Fix missed DMA unmap for NVME ls requests
  qla2xxx: Fix crash during module load unload test

Manish Rangankar (1):
  qla2xxx: Use correct feature type field during rffid processing

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.07.400-k

Quinn Tran (7):
  qla2xxx: Fix incorrect reporting of task management failure
  qla2xxx: Fix disk failure to rediscover
  qla2xxx: fix n2n inconsistent plogi
  qla2xxx: Fix hang due to session stuck
  qla2xxx: Fix laggy FC remote port session recovery
  qla2xxx: reduce false trigger to login
  qla2xxx: Fix stuck session of prli reject

Shreyas Deodhar (1):
  qla2xxx: Increase max limit of ql2xnvme_queues

 drivers/scsi/qla2xxx/qla_def.h     |  5 +++
 drivers/scsi/qla2xxx/qla_gs.c      |  5 +--
 drivers/scsi/qla2xxx/qla_init.c    | 36 ++++++++++------
 drivers/scsi/qla2xxx/qla_iocb.c    |  8 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |  1 +
 drivers/scsi/qla2xxx/qla_nvme.c    | 67 +++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_nvme.h    |  1 -
 drivers/scsi/qla2xxx/qla_os.c      | 23 ++++++++--
 drivers/scsi/qla2xxx/qla_version.h |  4 +-
 9 files changed, 107 insertions(+), 43 deletions(-)


base-commit: ac2beb4e3bd75b0049068516b9d42201bda0ded3
-- 
2.19.0.rc0

