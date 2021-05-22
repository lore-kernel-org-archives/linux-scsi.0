Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2B6C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E4916121E
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhEVImI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3652 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhEVImE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:04 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FnH1S0PNvzmWnV;
        Sat, 22 May 2021 16:38:20 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:37 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>
Subject: [PATCH 00/24] scsi: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:04 +0800
Message-ID: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Hui Tang (24):
  scsi: aacraid: remove leading spaces before tabs
  scsi: aic7xxx: remove leading spaces before tabs
  scsi: arm: remove leading spaces before tabs
  scsi: sym53c8xx: remove leading spaces before tabs
  scsi: qla2xxx: remove leading spaces before tabs
  scsi: arcmsr: remove leading spaces before tabs
  scsi: ibmvfc: remove leading spaces before tabs
  scsi: megaraid: remove leading spaces before tabs
  scsi: zalon: remove leading spaces before tabs
  scsi: wd33c93: remove leading spaces before tabs
  scsi: sun3_scsi: remove leading spaces before tabs
  scsi: scsi_transport_spi: remove leading spaces before tabs
  scsi: scsi_transport_fc: remove leading spaces before tabs
  scsi: proc: remove leading spaces before tabs
  scsi: qlogicfas408: remove leading spaces before tabs
  scsi: qla1280: remove leading space before tabs
  scsi: pcmcia: remove leading spaces before tabs
  scsi: ncr53c8xx: remove leading spaces before tabs
  scsi: mesh: remove leading spaces before tabs
  scsi: mac53c94: remove leading spaces before tabs
  scsi: ips: remove leading spaces before tabs
  scsi: dpt_i2o: remove leading spaces before tabs
  scsi: dc395x: remove leading spaces before tabs
  scsi: aha1740: remove leading spaces before tabs

 drivers/scsi/aacraid/sa.c              |  2 +-
 drivers/scsi/aha1740.c                 |  2 +-
 drivers/scsi/aic7xxx/aic7770_osm.c     |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c | 14 ++++-----
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c       |  2 +-
 drivers/scsi/arm/fas216.c              |  2 +-
 drivers/scsi/arm/fas216.h              |  2 +-
 drivers/scsi/dc395x.c                  | 22 +++++++-------
 drivers/scsi/dpt_i2o.c                 |  4 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c       |  4 +--
 drivers/scsi/ips.c                     |  4 +--
 drivers/scsi/mac53c94.c                | 24 +++++++--------
 drivers/scsi/megaraid/mega_common.h    |  2 +-
 drivers/scsi/mesh.c                    | 54 +++++++++++++++++-----------------
 drivers/scsi/ncr53c8xx.c               | 32 ++++++++++----------
 drivers/scsi/ncr53c8xx.h               |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c           |  2 +-
 drivers/scsi/qla1280.c                 |  4 +--
 drivers/scsi/qla2xxx/qla_dbg.c         |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c         | 32 ++++++++++----------
 drivers/scsi/qlogicfas408.c            |  4 +--
 drivers/scsi/scsi_proc.c               |  2 +-
 drivers/scsi/scsi_transport_fc.c       |  2 +-
 drivers/scsi/scsi_transport_spi.c      |  4 +--
 drivers/scsi/sun3_scsi.c               |  2 +-
 drivers/scsi/sym53c8xx_2/sym_defs.h    |  2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c    | 40 ++++++++++++-------------
 drivers/scsi/wd33c93.c                 |  4 +--
 drivers/scsi/zalon.c                   |  2 +-
 30 files changed, 140 insertions(+), 140 deletions(-)

--
2.8.1

