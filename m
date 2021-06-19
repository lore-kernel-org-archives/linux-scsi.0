Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED29C48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A1461261
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhFSAyr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 20:54:47 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:44813 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSAyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 20:54:46 -0400
Received: by mail-pj1-f49.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so4817802pjo.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 17:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dFCUh8AHqMJP7kSpmjI7xIMzZJEoJkJCfqWauS0eZGE=;
        b=NUCtPR7w99jSrizCWyFdPdD2MgAt4Fc59I76lwCuONIA6kcWxzzNzftUhMAx1wqYCq
         Ct9R817opNs+S/lQ53WXBFEafiMVAjxw7Xu45U2DgVFGXHZKScwyjM5RW1HGk8Vawa5b
         Pg2IWI92DCKT4Lx6qQPET9zswwAkBW7xaAsQUhku7yOf0Oykw6EoPduc8dUM3OMMH/p/
         nop6Jpqn9zEZWpg8DhP8x/mYCFO32sk8bBahhNSA4zOH0eEao91yWjFIeNtOVjSvZQek
         MOrC3lNIq0YULrGmvjmvC0LU7oXV9ohtp0OiI8yDa/v2ZTUz+cnWPLZcUKJu/ueON33x
         d53A==
X-Gm-Message-State: AOAM532m+NyQs3uNo3KpopxLHu3iA7zBBzzKysSPVmGYzgx7hzxjX/Hv
        TSX4BMCGEBbC2BPKCplkHbg=
X-Google-Smtp-Source: ABdhPJyWyrYXyOeSQtLodoLjyYc6k8pRXhYMf26OlVa9xHfFGjmHV8+/+M1Z4MfHWaOY96lsyfLYIQ==
X-Received: by 2002:a17:90a:af95:: with SMTP id w21mr24955586pjq.72.1624063955500;
        Fri, 18 Jun 2021 17:52:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p6sm9934460pjh.24.2021.06.18.17.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 17:52:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 0/4] UFS patches for Linux kernel v5.14
Date:   Fri, 18 Jun 2021 17:52:24 -0700
Message-Id: <20210619005228.28569-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The four patches in this series are what I came up with while reviewing
recent UFS patches. These patches are intended for kernel v5.14. These
patches have been posted as an "RFC" because these have been compile tested
only.

Thanks,

Bart.

Bart Van Assche (4):
  ufs: Rename the second ufshcd_probe_hba() argument
  ufs: Remove a check from ufshcd_queuecommand()
  ufs: Improve static type checking for the host controller state
  ufs: Make host controller state change handling more systematic

 drivers/scsi/ufs/ufshcd.c | 96 +++++++++++++++++----------------------
 drivers/scsi/ufs/ufshcd.h | 25 +++++++++-
 2 files changed, 65 insertions(+), 56 deletions(-)

