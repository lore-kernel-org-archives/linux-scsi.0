Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B07C77B75
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 09:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjDUJjO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Apr 2023 05:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbjDUJiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2023 05:38:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1A6903A
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2023 02:38:53 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q2qDt4HbKzsRMY;
        Fri, 21 Apr 2023 17:37:18 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm100004.china.huawei.com
 (7.192.105.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 21 Apr
 2023 17:38:50 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v3 0/3] scsi: libsas: remove empty branches and code simplification
Date:   Fri, 21 Apr 2023 17:37:41 +0800
Message-ID: <20230421093744.1583609-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Three patches to remove two empty branches and a little code
simplification.

v2->v3:
  1. Drop patch #3.
  2. Factor out sas_check_edge_expander_topo().
  3. Factor out sas_check_fanout_expander_topo().

v1->v2:
  1. Add blank line after declaration in sas_eeds_valid().
  2. Drop the inner-most and outter-most parenthesis in sas_eeds_valid().
  3. Break the long line in the declaration of sas_check_phy_topology().
  4. Move "else if" to the same line after "}".

Jason Yan (3):
  scsi: libsas: Simplify sas_check_eeds()
  scsi: libsas: Remove an empty branch in sas_check_parent_topology()
  scsi: libsas: factor out sas_check_fanout_expander_topo()

 drivers/scsi/libsas/sas_expander.c | 124 +++++++++++++++++------------
 1 file changed, 71 insertions(+), 53 deletions(-)

-- 
2.31.1

