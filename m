Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98786C001B2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 06:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiLNGpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 01:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237451AbiLNGpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 01:45:33 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3DB10B67
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 22:45:26 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NX5PQ65wwzJpLH;
        Wed, 14 Dec 2022 14:41:46 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:45:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 0/5] scsi: libsas: Some coding style fixes and cleanups
Date:   Wed, 14 Dec 2022 15:06:03 +0800
Message-ID: <20221214070608.4128546-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A few coding style fixes and cleanups. There should be no functional
changes in this series besides the debug log prints.

v1->v2:
  1. Drop patch #2 in v1.
  2. Other misc changes suggested by John.

v2->v3:
  1. Add John's tag for patch #1 #3 #5.
  2. /s/sata/SATA/
  3. Make a global macro for prints of CONFIG_SCSI_SAS_ATA=N

Jason Yan (5):
  scsi: libsas: move sas_get_ata_command_set() up to save the
    declaration
  scsi: libsas: change the coding style of sas_discover_sata()
  scsi: libsas: remove useless dev_list delete in
    sas_ex_discover_end_dev()
  scsi: libsas: factor out sas_ata_add_dev()
  scsi: libsas: factor out sas_ex_add_dev()

 drivers/scsi/libsas/sas_ata.c      |  88 ++++++++++++++++----
 drivers/scsi/libsas/sas_discover.c |   6 --
 drivers/scsi/libsas/sas_expander.c | 125 ++++++++++-------------------
 include/scsi/libsas.h              |   1 -
 include/scsi/sas_ata.h             |  18 +++++
 5 files changed, 132 insertions(+), 106 deletions(-)

-- 
2.31.1

