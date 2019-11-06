Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58D1C5DF64
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00042075C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbfKFEmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:42:37 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32921 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729784AbfKFEmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:42:36 -0500
Received: by mail-pg1-f195.google.com with SMTP id u23so16277855pgo.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 20:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SQ9oM0QF6lMXsy/WycLkPXzM32zey87RAjzy8hYB4cE=;
        b=T3rQx67jRhujRTw1DTnOsQXgs+aEhaAhuGK8i1XehRNyzYSb4hhi/2PtfbTjRenaG8
         rs41cSlvW+FtmuonHn1cqzt0YZF5hqdXqlOiNfzXjdbmGeZPzTUaLs295dZOaAgvWy9l
         kfkRcMr0+nffYjGw4TdtLX9CuAIaxsi7CQ7cyPugKfcbgEve0c6uhGPbbtJwidMLF91B
         q7HZ0mfF4HqsvCvT4y6onp5/mU6k3vHBTEGAFekLJVz4rzCbkWfOonIP5kiBZfsHiEDs
         XeVdsDyCZDvQlNy0Ud/IaW7R5cc0F35KN2dAq+Bmrbe7m6vYI7yQj6/5Gfox/oB/55jo
         +hqQ==
X-Gm-Message-State: APjAAAUlQHwWB6omeS/4/8rxtrXiRu+P9i+BUIPR5yXNJbX+0tlXC09K
        mptK+jlilAOfnZddM4nJY5c=
X-Google-Smtp-Source: APXvYqxl1w9OKiDIJvvERLSuk3SOaFktacquIn9g8fwDzU8X8Q3nKXDCYX6uNOIJXpYI51fdKUdA+A==
X-Received: by 2002:a62:ceca:: with SMTP id y193mr791925pfg.219.1573015354733;
        Tue, 05 Nov 2019 20:42:34 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:a0dc:7f54:c925:d679])
        by smtp.gmail.com with ESMTPSA id m15sm10262501pfh.19.2019.11.05.20.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 20:42:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH 1/2] qla2xxx: Remove an include directive
Date:   Tue,  5 Nov 2019 20:42:25 -0800
Message-Id: <20191106044226.5207-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191106044226.5207-1-bvanassche@acm.org>
References: <20191106044226.5207-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the code in qla_init.c is initiator code, remove the SCSI target
core include directive.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7cb7545de962..c1004d47514c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -17,7 +17,6 @@
 #include <asm/prom.h>
 #endif
 
-#include <target/target_core_base.h>
 #include "qla_target.h"
 
 /*
-- 
2.23.0

