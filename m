Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06E6C5DF62
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA9912075C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbfKFEme (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:42:34 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44043 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbfKFEme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:42:34 -0500
Received: by mail-pg1-f195.google.com with SMTP id f19so7153634pgk.11
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 20:42:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=itI465xaKW+nl5ZeGkYAhg1+FghCLTPODNZkZ4uEbBg=;
        b=UWzvdzxurd+lEXk4v7WnFh7Y3iVJZof1Qq/mcvy1mxE85wIfLBG26bvF9REVRs2NlY
         jJ9odXXYQyprvd11AJVh6p7TwONA/O1S/yhf51z7v8EJk1qQp57RonAyW3rWZyKTn48I
         Bn5vyd1elRQKl7EAhtpfxLnIBR5UuFOM7KNyBz8qp3j4jDuMf/SXggahHE8DE1s0Lq9l
         n3/ylF5lWsTm3K4qpYnqoUQQqDUdeOHpV9W9WLOgCP+ro4i8BBjR0HbnOkv/1HEr7nrj
         66ba05ntc836vjI8ue++36YVg6bJlCMPyrIEdVdk1XqPEnjO9+pD/6KALQAdurxfiwTU
         1ySQ==
X-Gm-Message-State: APjAAAXFBAb6lyRCHssOW7PvLcB+x0wSZhejXco0fkGZcvDAw8KxNSv2
        c12mk66DqzwshlRrNQrzNag=
X-Google-Smtp-Source: APXvYqy+xcS31lD8QeTl84BmV7luT/QHUzNKx49/Q+YQi1lhxzsPjiqwSmm6AflTnUaXLGsRbieUeg==
X-Received: by 2002:a17:90a:33ce:: with SMTP id n72mr1070975pjb.17.1573015353503;
        Tue, 05 Nov 2019 20:42:33 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:a0dc:7f54:c925:d679])
        by smtp.gmail.com with ESMTPSA id m15sm10262501pfh.19.2019.11.05.20.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:42:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Two qla2xxx fixes
Date:   Tue,  5 Nov 2019 20:42:24 -0800
Message-Id: <20191106044226.5207-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the two patches in this series for kernel version v5.5.

Thanks,

Bart.

Bart Van Assche (2):
  qla2xxx: Remove an include directive
  qla2xxx: Fix a dma_pool_free() call

 drivers/scsi/qla2xxx/qla_init.c | 1 -
 drivers/scsi/qla2xxx/qla_os.c   | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.23.0

