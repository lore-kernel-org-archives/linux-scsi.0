Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F99C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 06:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B1761107
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 06:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhFPGj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 02:39:58 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7321 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhFPGj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 02:39:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G4b4H2LK7z6y6k;
        Wed, 16 Jun 2021 14:33:51 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:37:50 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:37:49 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "Sesidhar Baddela" <sebaddel@cisco.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "Adaptec OEM Raid Solutions" <aacraid@microsemi.com>,
        Brian King <brking@us.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Hannes Reinecke <hare@suse.de>,
        "Manish Rangankar" <mrangankar@marvell.com>,
        Adam Radford <aradford@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 00/20] scsi: remove unnecessary oom message
Date:   Wed, 16 Jun 2021 14:36:54 +0800
Message-ID: <20210616063714.778-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 --> v2:
Combine these individual patches into a series.


Zhen Lei (20):
  scsi: zorro_esp: remove unnecessary oom message
  scsi: zorro7xx: remove unnecessary oom message
  scsi: bvme6000: remove unnecessary oom message
  scsi: vmw_pvscsi: remove unnecessary oom message
  snic: remove unnecessary oom message
  scsi: devinfo: remove unnecessary oom message
  scsi: tcm_qla2xxx: remove unnecessary oom message
  scsi: pmcraid: remove unnecessary oom message
  scsi: mvme16x: remove unnecessary oom message
  scsi: libsas: remove unnecessary oom message
  scsi: ips: remove unnecessary oom message
  scsi: ipr: remove unnecessary oom message
  scsi: fnic: remove unnecessary oom message
  scsi: fcoe: remove unnecessary oom message
  scsi: libcxgbi: remove unnecessary oom message
  scsi: bnx2i: remove unnecessary oom message
  scsi: aic94xx: remove unnecessary oom message
  scsi: aacraid: remove unnecessary oom message
  scsi: a100u2w: remove unnecessary oom message
  scsi: 3w-xxx: remove unnecessary oom message

 drivers/scsi/3w-xxxx.c              |  4 +---
 drivers/scsi/a100u2w.c              |  8 ++------
 drivers/scsi/aacraid/comminit.c     |  8 ++------
 drivers/scsi/aic94xx/aic94xx_init.c |  4 +---
 drivers/scsi/aic94xx/aic94xx_sds.c  |  4 +---
 drivers/scsi/bnx2i/bnx2i_iscsi.c    |  2 --
 drivers/scsi/bvme6000_scsi.c        |  5 +----
 drivers/scsi/cxgbi/libcxgbi.c       |  7 +++----
 drivers/scsi/fcoe/fcoe_transport.c  |  4 +---
 drivers/scsi/fnic/fnic_trace.c      |  2 --
 drivers/scsi/fnic/vnic_rq.c         |  4 +---
 drivers/scsi/fnic/vnic_wq.c         |  4 +---
 drivers/scsi/ipr.c                  |  5 +----
 drivers/scsi/ips.c                  |  4 +---
 drivers/scsi/libsas/sas_ata.c       |  4 +---
 drivers/scsi/mvme16x_scsi.c         |  5 +----
 drivers/scsi/pmcraid.c              | 10 ++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c  | 16 ++++------------
 drivers/scsi/scsi_devinfo.c         |  4 +---
 drivers/scsi/snic/vnic_wq.c         |  5 +----
 drivers/scsi/vmw_pvscsi.c           |  5 +----
 drivers/scsi/zorro7xx.c             |  4 +---
 drivers/scsi/zorro_esp.c            |  4 +---
 23 files changed, 29 insertions(+), 93 deletions(-)

-- 
2.26.0.106.g9fadedd


