Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6711AC77B7E
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 08:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243215AbjD0IEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 04:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242902AbjD0IEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 04:04:05 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44AD2D69
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:04 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7CHrA006786
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=TWVuPzU4iMgkqgoAUbV/XHwf7mNckO4GWjz3NE/8jXg=;
 b=UQtbgqblcOYxxk6ENo/1rGpYvkw4Hogq0hBTYc4qGXit1Yh+z5/30rOHxgj3jrBeAbot
 qWbO/xwE6g68XlnpdDm/XbphjDDm/MHpgPAEikyhK12PlrXLvYP6DTMNUxyKRoXgjC6b
 DcW2v7gu3qIJDvaWJnMgM7lQ+pFS6aATCJvCaBjCZYA1/6Vcsr8QzdpEfOdG1Ygm4ps3
 W/ImU+31CysZzdt9kywFwefLTo6s9FL/t5HbEcbjDZcjcgToBqjA5/kxfv+Gacxne90Q
 JkQnlQXtm9UnNhAaPQ68Wz7mUcqaFrOKlOFtDNMq/XJ3iAITClaImrndzNcKDZzqr7aE 0g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q7apa2khg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2023 01:04:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 27 Apr
 2023 01:04:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 27 Apr 2023 01:04:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A9DE93F7075;
        Thu, 27 Apr 2023 01:04:02 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 0/7] qla2xxx driver update
Date:   Thu, 27 Apr 2023 01:03:44 -0700
Message-ID: <20230427080351.9889-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sSHMHjB3RkZQHKPjmpiKwpjUO4G_8KN_
X-Proofpoint-GUID: sSHMHjB3RkZQHKPjmpiKwpjUO4G_8KN_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qla2xxx driver enhancement and bug fixes to
the scsi tree at your earliest convenience.

Thanks,
Nilesh

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.08.300-k

Quinn Tran (6):
  qla2xxx: Multi-que support for TMF
  qla2xxx: Fix task management cmd failure
  qla2xxx: Fix task management cmd fail due to unavailable resource
  qla2xxx: Fix hang in task management
  qla2xxx: Fix mem access after free
  qla2xxx: Wait for io return on terminate rport

 drivers/scsi/qla2xxx/qla_attr.c    |  13 ++
 drivers/scsi/qla2xxx/qla_def.h     |  21 +++
 drivers/scsi/qla2xxx/qla_gbl.h     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c    | 254 ++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_iocb.c    |  33 +++-
 drivers/scsi/qla2xxx/qla_isr.c     |  64 ++++++--
 drivers/scsi/qla2xxx/qla_os.c      | 130 ++++++++-------
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 8 files changed, 417 insertions(+), 104 deletions(-)


base-commit: c8e22b7a1694bb8d025ea636816472739d859145
-- 
2.23.1

