Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D87C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbjDYXgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDYXgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:36:04 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF17C17A
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:03 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-63b5c830d5eso5135168b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465763; x=1685057763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T9p9RTNg0CH340YbC/6UKSSRitWMNUwf6k81A53aSE8=;
        b=PIWY4eAlvtzwQu39bzfWZ/yPRaZ2e3GiwNQy9IYz3pJqbXYCDy42nplu0GmqtCgaRN
         WGIf6/JLlXUq5yeaVFB+BeuZlQeU2/9rjZmnkahd5v2f2wWdj0o8BJ1ZDrio6hxzAF0x
         ROj7dHCXIuwfJyL41HRP1ipxj1MYpyj//BwiDPQMJ3n1W3+c5wW4gHoELkFdmtChaKXI
         Oa7yJAzLt6S68F+ttbxDphirohmwosB90wci7CaP/YmA5fN3guF8Fwnw5tdh2FZOvcYL
         ci+44413sqdnhJ/UH6sTeLUEY3eNGvJv3YA2NNIxug0GQCevN1Wf5rI8ei/OEEuUrBFq
         u3+A==
X-Gm-Message-State: AAQBX9fiBaynaQLcx7zrmId/IeDafihZaR/KdQnLCn7qijZxrns0J+/O
        95fXV+W+ijGex/MXevLI0xs=
X-Google-Smtp-Source: AKy350Yd/uRflJmgSOzs57VlRSyWaMfdCy7nkbzRf9/CKnjUAl4jWyHGzYrIE9p+NoAvoYFaHwPMTQ==
X-Received: by 2002:a05:6a00:1143:b0:63b:6149:7ad6 with SMTP id b3-20020a056a00114300b0063b61497ad6mr23733003pfm.34.1682465762837;
        Tue, 25 Apr 2023 16:36:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm10146984pfc.143.2023.04.25.16.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:36:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] SCSI core patches
Date:   Tue, 25 Apr 2023 16:34:42 -0700
Message-ID: <20230425233446.1231000-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these SCSI core patches for the next merge window.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: core: Use min() instead of open-coding it
  scsi: core: Update a source code comment
  scsi: Only kick the requeue list if necessary
  scsi: Trace SCSI sense data

 drivers/scsi/scsi_common.c  |  3 +--
 drivers/scsi/scsi_error.c   |  2 ++
 drivers/scsi/scsi_lib.c     | 16 +++++++++++-----
 include/scsi/scsi_host.h    |  2 +-
 include/trace/events/scsi.h | 17 +++++++++++++++--
 5 files changed, 30 insertions(+), 10 deletions(-)

