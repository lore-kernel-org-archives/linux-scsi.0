Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA498CD13D8
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjIRQ2l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjIRQ21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:28:27 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B8DAD0F
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:21:42 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1c465d59719so11979615ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695054067; x=1695658867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jhv1EdSwgAWv97Hc8hG0X7Hjxem0XnlXgPch3HxM9x4=;
        b=IPLJ730PzjXZNVm3O3tunGoFHYTPtn3RaGwUzJGKkUID4TaTTKZpwKsooQEjlJbiMv
         ltgWSfFVo4db36C9+lW2s+6qKksxkIMRa7byRmtCPbaNE+yR9A59+uRN+HsDtiTlNj0a
         JTKT+5oEq5dAfS4CoxGS8PjpNBCS6LliF75DKV/Qo1tg7eEfBAxpoWMM/MLZUQIOa88W
         Zvm4iIRmeVk/sw0u+6RZK5i1elkT8JUniUIhsXHaGJ9HwRKa8pzMs2sDyvfU+TNQE+Uk
         KbVOVBBVCHTK1rby+uPMF+2Qkl9PDYxG8k4z9jN43PUA/yrCJ1+zQC7Q0JGHsrSGrTw/
         7jFw==
X-Gm-Message-State: AOJu0YxpWhVmBzruh9J6cs5jGMQ81a8irsPm3T3i77TjIIo395W/aAMY
        ze0GWr665QpbZZRTpIUgyOyg2oS+tb8=
X-Google-Smtp-Source: AGHT+IGxvsKd+8/5Ktf559OvPEFJOwPZrnppPQU9pk2MGSP2F4CZMavGa3VOanI6dV4s9hpC5DVpAw==
X-Received: by 2002:a17:903:41c2:b0:1c3:eb43:65bf with SMTP id u2-20020a17090341c200b001c3eb4365bfmr9333223ple.32.1695054066908;
        Mon, 18 Sep 2023 09:21:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902d54e00b001bd28b9c3ddsm8489414plf.299.2023.09.18.09.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:21:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] UFS core patches
Date:   Mon, 18 Sep 2023 09:20:11 -0700
Message-ID: <20230918162058.1562033-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these UFS core patches for the next merge window.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: ufs: Return in case of an invalid tag
  scsi: ufs: Move the 4K alignment code into the Exynos driver
  scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
  scsi: ufs: Set the Command Priority (CP) flag for RT requests

 drivers/ufs/core/ufshcd.c     | 42 +++++++++++++++++++----------------
 drivers/ufs/host/ufs-exynos.c |  9 ++++++--
 include/ufs/ufs.h             |  3 ++-
 include/ufs/ufshcd.h          |  7 ++----
 4 files changed, 34 insertions(+), 27 deletions(-)

