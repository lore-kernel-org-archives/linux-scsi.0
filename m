Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767E3C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5555061165
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 06:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhDHGTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:19:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16035 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhDHGTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 02:19:30 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FG9y701fQzPp0P;
        Thu,  8 Apr 2021 14:16:31 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.179.202) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 14:19:07 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux . pdl" <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/3] scsi: mptfusion: Clear the warnings indicating that the variable is not used
Date:   Thu, 8 Apr 2021 14:18:48 +0800
Message-ID: <20210408061851.3089-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix below warnings:
drivers/message/fusion/mptctl.c: In function ‘mptctl_do_taskmgmt’:
drivers/message/fusion/mptctl.c:324:17: warning: variable ‘time_count’ set but not used [-Wunused-but-set-variable]
  324 |  unsigned long  time_count;
      |                 ^~~~~~~~~~
drivers/message/fusion/mptctl.c: In function ‘mptctl_gettargetinfo’:
drivers/message/fusion/mptctl.c:1372:7: warning: variable ‘port’ set but not used [-Wunused-but-set-variable]
 1372 |  u8   port;
      |       ^~~~
drivers/message/fusion/mptctl.c: In function ‘mptctl_hp_hostinfo’:
drivers/message/fusion/mptctl.c:2337:8: warning: variable ‘retval’ set but not used [-Wunused-but-set-variable]
 2337 |  int   retval;
      |        ^~~~~~


Zhen Lei (3):
  scsi: mptfusion: Remove unused local variable 'time_count'
  scsi: mptfusion: Remove unused local variable 'port'
  scsi: mptfusion: Fix error return code of mptctl_hp_hostinfo()

 drivers/message/fusion/mptctl.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

-- 
2.21.1


