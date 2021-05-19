Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29340C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 20:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02519611C2
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 20:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhESUWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 16:22:25 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:35518 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhESUWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 16:22:24 -0400
Received: by mail-pg1-f171.google.com with SMTP id m190so10268584pga.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 May 2021 13:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1lKuVpmpAgB4kht69eY1AHzmU1UZrTex5nuPNtqWcys=;
        b=XxWlymDxy/9X47bbfNNo79cABftC/GNPBeohlrxjCfzYVkQ9AJHsP7fqct8xtZTKU+
         KSGmBQSIjfm+IelBfm7BTvgYDR+SR8+5x6TqHNuDLVDPEQY9v/IYh2CJmizD6Sp86qQ7
         QMkEIKK8cL7b8wuOPKieDs+vmn054zX86LYd4NvCqDxx86zAsTV6whiHGAB0Z6LAQ+Km
         eHf3C9jatZWY8MGpfTW5MyH31AaDJ45B7KpO6jYeuYivFh5GooeCW7kAssBumhcMM6/M
         jg2kviZUORG+1BHX2ZjJbu8maE4rM2lXma+obpar9zYhkjFTW9ggRUKTzUxMEx048uHC
         uilQ==
X-Gm-Message-State: AOAM5325qC/xA2sEHz2do4DmRBWo4jbJ6KPU6xL8Ha//XNwHJpEemx23
        gV7rarbtj0KBXgeSHiLM6mda4E8Viv4=
X-Google-Smtp-Source: ABdhPJzfqxxTRCa4pLmlsQ865gdeBi9qDC7AZWEvhpOBC9qYimfp74ajcuW2sjN1qxf6+ydYtOJvug==
X-Received: by 2002:a63:5a5d:: with SMTP id k29mr864317pgm.215.1621455664199;
        Wed, 19 May 2021 13:21:04 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:db5a:2bf3:3617:be1c])
        by smtp.gmail.com with ESMTPSA id o4sm220338pfk.15.2021.05.19.13.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 13:21:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Two additional UFS patches
Date:   Wed, 19 May 2021 13:20:56 -0700
Message-Id: <20210519202058.12634-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

There are two UFS patches in this series. One bug fix and one cleanup patch.
Please consider the bug fix for kernel v5.13 and the cleanup patch for kernel
v5.14.

Thanks,

Bart.

Bart Van Assche (2):
  ufs: Suppress false positive unhandled interrupt messages
  ufs: Use designated initializers in ufs_pm_lvl_states[]

 drivers/scsi/ufs/ufshcd.c | 17 +++++++++--------
 drivers/scsi/ufs/ufshcd.h | 14 +++++++-------
 2 files changed, 16 insertions(+), 15 deletions(-)

