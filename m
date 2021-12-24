Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A30C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351752AbhLXHHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:07:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36534 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1351760AbhLXHHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2Oa0p005254
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=5Zixxu3b3w/kx9d/77Ug3/+W+JAwYm8VIKz3Ds0/Q7k=;
 b=G02t+NmxFfFJqvk3GGAPxxbEv86CR9yu4IW/2I4kroQ8jT7dzFJWkBxrLI6P/x5wRiZw
 SolowsqVCd5amtnv1cDTM22X2YZ7UPbFlgcROFp2fDdDfEAqz4zGoVL8ymIsFlOqq7X4
 Lirsc2Jsrv9q1dtuEH324Phb87cvTdpM29lZrqDbWcRo3RSim40jvrEXO7sGzlO3tKhC
 ssbvWxMsNZioYcEzDhdi0uK5FfQWCdb3bGp7n9+4+PIhNgGXd67jbF9yAPKQZ7jW2N1t
 svT94Uiaa6raebnU5qGoYCTdOv1JyhSCEfrJHQ488GU7TLodJe0wwLzcDWOgrhbzyzgW fQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3d55d2rqkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:39 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 23:07:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:39 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 087153F7063;
        Thu, 23 Dec 2021 23:07:38 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77RlM017940;
        Thu, 23 Dec 2021 23:07:27 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77C6S017939;
        Thu, 23 Dec 2021 23:07:12 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 00/16] qla2xxx misc bug fixes and features
Date:   Thu, 23 Dec 2021 23:06:56 -0800
Message-ID: <20211224070712.17905-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: u4_ijRKJ2jGs7kGUunJtD7pHlffcYLjp
X-Proofpoint-GUID: u4_ijRKJ2jGs7kGUunJtD7pHlffcYLjp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver misc bug fixes and features to the scsi
tree at your earliest convenience.

Thanks,
Nilesh

Arun Easi (3):
  qla2xxx: Fix device reconnect in loop topology
  qla2xxx: Fix T10 PI tag escape and IP guard options for 28XX adapters
  qla2xxx: Add devid's and conditionals for 28xx

Bikash Hazarika (1):
  qla2xxx: Show wrong FDMI data for 64G adaptor

Daniel Wagner (1):
  qla2xxx: Refactor asynchronous command initialization

Nilesh Javali (2):
  qla2xxx: fix warning for missing error code
  qla2xxx: Update version to 10.02.07.300-k

Quinn Tran (6):
  qla2xxx: fix stuck session in gpdb
  qla2xxx: Fix warning message due to adisc is being flush
  qla2xxx: Fix premature hw access after pci error
  qla2xxx: Fix scheduling while atomic
  qla2xxx: add retry for exec fw
  qla2xxx: edif: Fix clang warning

Saurav Kashyap (2):
  qla2xxx: Implement ref count for srb
  qla2xxx: Suppress a kernel complaint in qla_create_qpair()

Shreyas Deodhar (1):
  qla2xxx: Add ql2xnvme_queues module param to configure number of NVME
    queues

 drivers/scsi/qla2xxx/qla_attr.c    |   7 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   6 +-
 drivers/scsi/qla2xxx/qla_def.h     |  17 ++-
 drivers/scsi/qla2xxx/qla_edif.c    |  25 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   5 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 155 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c    | 200 ++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_inline.h  |   2 +
 drivers/scsi/qla2xxx/qla_iocb.c    |  70 ++++++----
 drivers/scsi/qla2xxx/qla_mbx.c     |  40 ++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   9 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  11 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  16 ++-
 drivers/scsi/qla2xxx/qla_nvme.h    |   4 +
 drivers/scsi/qla2xxx/qla_os.c      |  40 +++++-
 drivers/scsi/qla2xxx/qla_sup.c     |   4 +-
 drivers/scsi/qla2xxx/qla_target.c  |  14 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |   9 +-
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 19 files changed, 392 insertions(+), 246 deletions(-)


base-commit: 4be6181fea1dbfd21a8d73f69d87a6cae2d3023d
-- 
2.23.1

