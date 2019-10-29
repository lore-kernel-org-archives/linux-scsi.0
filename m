Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77868CA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5302F2086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbfJ2XHR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:07:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40529 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ2XHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 19:07:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id 15so127055pgt.7
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 16:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I39axrVHT/WerMUx6b8I9qn2r4dM4ojTYATvGvwHGt0=;
        b=YCbIHzxp+NCZrOO3E1idtgjm91zscE7qJ61jGKabItagQgstYxGB2q+eNz4WnwvXbu
         iODsFb7H766Fg2HVGyKiFgJdZQJLTJMrq2yb+VHJcGx6OHgxdHiqHJ0U2XzzommBmJu6
         Bqt4hFBj+kKFDXx3cNS5hKq7UkriPb5jxyJ+fJqrqtS0LWP/1Q6yN5NL1QeVXZV8oYFk
         WVWFT4oDw46N1uLreot4/oQowtTmGsNltkQ7ykIg4OZvrd2tWUZz26C8mQy5Jm5NLl/m
         GpPdQJ7UJGJOcV90SLDJweeE8Q+kimmytVIaVFeVwQQEdAK93cXseAB4y5Yg4W3+TnkQ
         D2Lw==
X-Gm-Message-State: APjAAAXK3ute1FT0g1v71uXqTXBJcMMu7x5GCAXNWBd7mjpjdYnXKYWD
        KYdYA7cFuisJI8vTeoEZE7A=
X-Google-Smtp-Source: APXvYqxVwYGKKbglXDGM/+OUBZ/6fpy1ZSuKTmUdNAJcIqn0SHGBsyLySIPTLAuI4JkH+BVBRkT7JA==
X-Received: by 2002:a63:dd17:: with SMTP id t23mr7605467pgg.134.1572390436841;
        Tue, 29 Oct 2019 16:07:16 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z21sm170500pfa.119.2019.10.29.16.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 16:07:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Three small UFS patches
Date:   Tue, 29 Oct 2019 16:07:07 -0700
Message-Id: <20191029230710.211926-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

These three patches are what I came up with after having reviewed the compiler warnings
triggered by the UFS driver and after having reviewed its source code. Please consider
these patches for kernel version v5.5.

Thanks,

Bart.

Bart Van Assche (3):
  ufs: Fix kernel-doc warnings
  ufs: Use enum dev_cmd_type where appropriate
  ufs: Remove .setup_xfer_req()

 drivers/scsi/ufs/ufs_bsg.c |  1 +
 drivers/scsi/ufs/ufshcd.c  |  8 +++-----
 drivers/scsi/ufs/ufshcd.h  | 10 ----------
 3 files changed, 4 insertions(+), 15 deletions(-)

-- 
2.24.0.rc0.303.g954a862665-goog

