Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F00DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 11:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECB4364E52
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Feb 2021 11:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBOL7r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Feb 2021 06:59:47 -0500
Received: from m12-15.163.com ([220.181.12.15]:47597 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhBOL7m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Feb 2021 06:59:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=ofhekfWoKyP3/jsnFp
        c0DJOkSRIngNH40Nad1PKnttU=; b=O3NRBvUDXwezNmlCI633bS1niQmv/NeQ3I
        qWRDWkovGEUYBQSR4IGuyhKyxEdrMkjt0ql7c87a0fmbjTkFx5/u+2531cGmu3Bu
        wowdnmk1oZwAZ0n3srdba2JHErlEY9KHNMLrzOANAZmm9mwmBQ+2QHoVyVlqdIPs
        JTFtXDHWE=
Received: from localhost.localdomain (unknown [125.70.196.55])
        by smtp11 (Coremail) with SMTP id D8CowABnuijTXSpg4hjXBQ--.7508S2;
        Mon, 15 Feb 2021 19:41:14 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Lin <chen.lin5@zte.com.cn>
Subject: [PATCH] scsi: aic7xxx: Remove unused function pointer typedef ahc_bus_suspend/resume_t
Date:   Mon, 15 Feb 2021 19:40:49 +0800
Message-Id: <1613389249-3409-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: D8CowABnuijTXSpg4hjXBQ--.7508S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gry3tw4DWr1kuw1UGw4Uurg_yoW3CFX_Cr
        1FvrsrGrWrKF4xK3WxJFyqyFyY9r4kX3y8Ww1avasava10q3yDXF1UWryUZ397CFWSgF17
        t3srXr4Yyw1IqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU01UDJUUUUU==
X-Originating-IP: [125.70.196.55]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBRxg6nlPABzyOIAABs8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Chen Lin <chen.lin5@zte.com.cn>

Remove the 'ahc_bus_suspend/resume_t' typedef as it is not used.

Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
---
 drivers/scsi/aic7xxx/aic7xxx.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 11a0979..9bc755a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -896,8 +896,6 @@ struct ahc_pci_softc {
 
 typedef void (*ahc_bus_intr_t)(struct ahc_softc *);
 typedef int (*ahc_bus_chip_init_t)(struct ahc_softc *);
-typedef int (*ahc_bus_suspend_t)(struct ahc_softc *);
-typedef int (*ahc_bus_resume_t)(struct ahc_softc *);
 typedef void ahc_callback_t (void *);
 
 struct ahc_softc {
-- 
1.7.9.5


