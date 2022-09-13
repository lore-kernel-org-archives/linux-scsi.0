Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68F07C6FA83
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 02:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiIMCh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 22:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIMCh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 22:37:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92514331D;
        Mon, 12 Sep 2022 19:37:25 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MRSFc2xR7zmVMV;
        Tue, 13 Sep 2022 10:33:40 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 13 Sep 2022 10:37:23 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <andrew.vasquez@qlogic.com>, <James.Bottomley@SteelEye.com>,
        <giridhar.malavali@qlogic.com>, <James.Bottomley@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <quinn.tran@cavium.com>,
        <himanshu.madhani@cavium.com>, <bart.vanassche@sandisk.com>,
        <nab@linux-iscsi.org>, <cuigaosheng1@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: [PATCH 0/2] Remove unused declarations for scsi
Date:   Tue, 13 Sep 2022 10:37:20 +0800
Message-ID: <20220913023722.547249-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains a few cleanup patches, to remove unused
declarations which have been removed. Thanks!

Gaosheng Cui (2):
  scsi: qla2xxx: remove unused declarations for qla2xxx
  scsi: target: remove unused se_tmr_req_cache declaration

 drivers/scsi/qla2xxx/qla_gbl.h        | 12 ------------
 drivers/scsi/qla2xxx/qla_target.h     |  2 --
 drivers/target/target_core_internal.h |  2 --
 3 files changed, 16 deletions(-)

-- 
2.25.1

