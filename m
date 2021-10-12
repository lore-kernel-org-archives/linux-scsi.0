Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83976C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B544610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhJLV4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:56:44 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:41817 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhJLV4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 17:56:44 -0400
Received: by mail-pj1-f50.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so748114pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 14:54:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nTofEgF+sQsTBdUAaYxJtCXdqar6Szlw2/mRxO6Y7jU=;
        b=Y1rGzGgF+o6p4PSmGADMtgQJ4zKSF2iT/1eM0N1VM+XPoQosnsuj2Edj5AWnjdJZS8
         CjqkSyqOMSXeom2S28VAtyZazvdl/+cd6L+1BLaDXmTYs1uCcc+NqOne72Z2ff/mlZ3x
         fu9bfTxifqG4jbqJSrM8RJ19tFIeHvKRd7AT9Kbne87G+31+ND+EHABa938giWXCN6d7
         iaeisZgGo7CtqZulbct8EmcP6lIzvBNj+Xloc/pDgsFRbLKAneHf859LP43399hWuVLT
         FxPDm4n3yHp+vT3hYHqiM7j003sAuSG+rfjSAnhnQchoN0xuhdeRNtzxIsqfZ3ugCqcg
         PswQ==
X-Gm-Message-State: AOAM531ztqOSbkAxD6el1aE3JHRCSSN3gJo/w+AANSq7lw3ionaFEf6U
        Xn70sAZWbG7W41AW4HDUhVA=
X-Google-Smtp-Source: ABdhPJzcTVfkmMzBqtvMVmzzW6oQ90xB37yzNdzsYF0SNLm2rd0cNWKvDd7xXO3+0OXMyDSGaWa3fQ==
X-Received: by 2002:a17:90a:6401:: with SMTP id g1mr8961507pjj.228.1634075681811;
        Tue, 12 Oct 2021 14:54:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m73sm12038730pfd.152.2021.10.12.14.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:54:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/5] UFS patches for kernel v5.16
Date:   Tue, 12 Oct 2021 14:54:28 -0700
Message-Id: <20211012215433.3725777-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series contains the UFS driver kernel patches I would like to see
included kernel v5.16. Please consider these patches for kernel v5.16.

Thank you,

Bart.

Bart Van Assche (5):
  scsi: ufs: Revert "Retry aborted SCSI commands instead of completing
    these successfully"
  scsi: ufs: Improve source code comments
  scsi: ufs: Improve static type checking
  scsi: ufs: Log error handler activity
  scsi: ufs: Add a sysfs attribute for triggering the UFS EH

 Documentation/ABI/testing/sysfs-driver-ufs |  10 ++
 drivers/scsi/ufs/ufshcd.c                  | 105 +++++++++++++++------
 drivers/scsi/ufs/ufshci.h                  |   9 +-
 3 files changed, 94 insertions(+), 30 deletions(-)

