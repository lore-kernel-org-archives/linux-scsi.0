Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889D3C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71AB06137D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhFPDr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:47:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4792 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFPDrz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 23:47:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4WDb6LGHzXgPd;
        Wed, 16 Jun 2021 11:40:47 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:44 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:43 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "megaraidlinux . pdl" <megaraidlinux.pdl@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 0/4] scsi: use DEVICE_ATTR_*() macros to simplify code
Date:   Wed, 16 Jun 2021 11:44:15 +0800
Message-ID: <20210616034419.725-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 --> v2:
Combine these individual patches into a series.

Zhen Lei (4):
  scsi: qedi: use DEVICE_ATTR_RO macro
  scsi: qedf: use DEVICE_ATTR_RO macro
  scsi: megaraid_mbox: use DEVICE_ATTR_ADMIN_RO macro
  scsi: mvsas: use DEVICE_ATTR_RO/RW macro

 drivers/scsi/megaraid/megaraid_mbox.c | 18 ++++++++----------
 drivers/scsi/mvsas/mv_init.c          | 26 +++++++++-----------------
 drivers/scsi/qedf/qedf_attr.c         | 14 ++++++--------
 drivers/scsi/qedi/qedi_sysfs.c        | 14 +++++++-------
 4 files changed, 30 insertions(+), 42 deletions(-)

-- 
2.26.0.106.g9fadedd


