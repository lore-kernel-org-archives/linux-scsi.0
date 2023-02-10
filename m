Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35817C636D4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 20:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjBJUwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 15:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbjBJUw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 15:52:26 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA5D60E7C
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:52:26 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id nn4-20020a17090b38c400b00233a6f118d0so4216268pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:52:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8yFkkTyOydU05r8QB+wGoWUuCeZkXFPJh1+t0M9q03Y=;
        b=BAuYy8j/HH4DrPSWp99gW0ULLvQNzXzGbxdHCpnAL6IOTHPMVvYZj45bgGHTKiB2HR
         UVNyhiM3QeP4OcsUomdjy3uXqWLckzQfOqHtAfRLFQXhWtvJJRH+gICgSvJP5GG4F5FL
         x913KxXGlSzivswI2BvioL8rQ8fPRW3Fjya7xjkCHmQnecEWvkE4XOXj1YwFm/07zhnm
         FVojKHf2EF6vv/wVXTn1aJlyFuBgow4QeiUbJZqgce3WUW1JSGvcri1F2R539fCE1dHl
         PpS/zikr9cTTuM3hvwwMqUnlVQiU/nfrnSFn78UHvV/P/LVhGHtB72VreS5udm5xrW6P
         1auw==
X-Gm-Message-State: AO0yUKUo9FHV6igzcBf79/qqTmQQzzESc7Kr+omU/c+v2jPpoMwKX4lw
        6//52f6gD66t7Z7gXJCjgaM=
X-Google-Smtp-Source: AK7set8PRP7uY408Ogrb8Lq45b9KUsOiR8qD+K2NDKt9fqXWfnAczwK7CU8Qhh6+D0L3ox2Ctql8cQ==
X-Received: by 2002:a17:903:41cd:b0:19a:6f28:ec2c with SMTP id u13-20020a17090341cd00b0019a6f28ec2cmr5645108ple.62.1676062345477;
        Fri, 10 Feb 2023 12:52:25 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id jm13-20020a17090304cd00b001948ff5cc32sm3745752plb.215.2023.02.10.12.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:52:24 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Remove the /proc/scsi/${proc_name} directory earlier
Date:   Fri, 10 Feb 2023 12:51:58 -0800
Message-Id: <20230210205200.36973-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a race condition in the SCSI core. Please consider
this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core: Fix a source code comment
  scsi: core: Remove the /proc/scsi/${proc_name} directory earlier

 drivers/scsi/hosts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

