Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF7BC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB5F6115B
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhDJGsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16888 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhDJGsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ5d6RzkhsC;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:43 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 0/8] scsi: megaraid: some misc clean up patches
Date:   Sat, 10 Apr 2021 14:47:59 +0800
Message-ID: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are several kinds of error are reported by checkpatch.pl.

So fix them together.

Luo Jiaxing (8):
  scsi: megaraid: clean up for white space
  scsi: megaraid_sas: use parentheses to enclose macros with complex
    values
  scsi: megaraid: clean up for blank lines
  scsi: megaraid: clean up for open/close brace
  scsi: megaraid: clean up for "foo * bar"
  scsi: megaraid: clean up for code indent
  scsi: megaraid: clean up for trailing statements
  scsi: megaraid: clean up for static variable initialise to 0

 drivers/scsi/megaraid/mbox_defs.h            |  23 +++---
 drivers/scsi/megaraid/mega_common.h          |  18 ++---
 drivers/scsi/megaraid/megaraid_ioctl.h       |  12 +--
 drivers/scsi/megaraid/megaraid_mbox.c        | 115 ++++++++++++---------------
 drivers/scsi/megaraid/megaraid_mbox.h        |   2 +-
 drivers/scsi/megaraid/megaraid_mm.c          |  66 +++++++--------
 drivers/scsi/megaraid/megaraid_mm.h          |   1 -
 drivers/scsi/megaraid/megaraid_sas.h         |  52 +-----------
 drivers/scsi/megaraid/megaraid_sas_base.c    |  69 +++++++---------
 drivers/scsi/megaraid/megaraid_sas_debugfs.c |   1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c  |  16 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h  |   1 -
 12 files changed, 149 insertions(+), 227 deletions(-)

-- 
2.7.4

