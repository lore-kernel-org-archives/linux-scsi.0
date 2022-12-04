Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA78C4332F
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Dec 2022 07:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLDH4B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Dec 2022 02:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiLDH4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Dec 2022 02:56:00 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55438175AE
        for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2022 23:55:59 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NPzRd3S53zkXn3;
        Sun,  4 Dec 2022 15:52:29 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500004.china.huawei.com
 (7.192.104.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 4 Dec
 2022 15:55:56 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/6] scsi: libsas: Some coding style fixes and cleanups
Date:   Sun, 4 Dec 2022 16:16:37 +0800
Message-ID: <20221204081643.3835966-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A few coding style fixes and cleanups. There should be no functional
changes in this series besides the debug log prints.

Jason Yan (6):
  scsi: libsas: move sas_get_ata_command_set() up to save the
    declaration
  scsi: libsas: delete wrapper function sas_discover_end_dev()
  scsi: libsas: rename sas_discover_sata() and related refactors
  scsi: libsas: remove useless dev_list delete in
    sas_ex_discover_end_dev()
  scsi: libsas: factor out sas_ata_add_dev()
  scsi: libsas: factor out sas_ex_add_dev()

 drivers/scsi/libsas/sas_ata.c      |  94 ++++++++++++++++++----
 drivers/scsi/libsas/sas_discover.c |  21 +----
 drivers/scsi/libsas/sas_expander.c | 125 ++++++++++-------------------
 include/scsi/libsas.h              |   3 -
 include/scsi/sas_ata.h             |  15 ++++
 5 files changed, 135 insertions(+), 123 deletions(-)

-- 
2.31.1

