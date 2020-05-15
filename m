Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DF2C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB2A2078C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgEOORs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 10:17:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4791 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726163AbgEOORr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 10:17:47 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A9A0845C8F625EC14194;
        Fri, 15 May 2020 22:17:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 22:17:36 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 0/4] hisi_sas: Some misc patches
Date:   Fri, 15 May 2020 22:13:41 +0800
Message-ID: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series includes some misc patches, generally tidy-up. The most
significant is the patch to not reset the phy up timer for when the
phy is already up - the HW designers do not have an answer for why this
occurs, so we workaround.

John Garry (1):
  scsi: hisi_sas: Stop returning error code from slot_complete_vX_hw()

Luo Jiaxing (3):
  scsi: hisi_sas: Do not reset phy timer to wait for stray phyup
  scsi: hisi_sas: Modify the commit information for DSM method
  scsi: hisi_sas: Add SAS_RAS_INTR0 to debugfs register name list

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  5 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 ++++--------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 16 ++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 25 +++++++++++++------------
 4 files changed, 27 insertions(+), 31 deletions(-)

-- 
2.16.4

