Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE77C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D4C1206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 03:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgD0DDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 23:03:22 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53150 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgD0DDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 23:03:21 -0400
Received: by mail-pj1-f65.google.com with SMTP id a5so6897391pjh.2
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 20:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fRauz+j8J2uP/NRkN0t8vhcmoKds5BpQaEyxqqvTMZc=;
        b=UF97+SCCy6+qHULkiy2xlwGWcOGBwchqSNuDq/zPjkvWe3J8SnBtQdUOiLWeHy+gyv
         knS7HlyVkF8Z1hkQSxD+FOC7uQhZZBqvYdyRElFZN4miMgDxqbg5ebity6tJO8guHatQ
         IlB/vUMKwDYqIZGFYuIGTIXE+jsa8g9RoaAqeiySW3yANLf8CrAiMqEC9KUR+l2rjTI+
         jh9hp9jQrZeRUE5uvNA+cWEX0Os1+KTCOSTnpPBxhg4qSGRDPYXokfo87Tjr4hqZagn+
         kLwraoqGDc5Q3pxSnO7vZXq91GRyuLEy0lf/KxYDy49wFXZA7mAhk8NpryZXE7GEj4um
         QjKg==
X-Gm-Message-State: AGi0PuYaN7UE0sF5DPjOocCtV+wgEW7+h5G5Wg50Q9pxnk1HXAm5keu9
        6sC9hUnSnqTCj7vUe0ybIStpa1+uF+o=
X-Google-Smtp-Source: APiQypLyRVrLkc+IrG2B8goRGxGzblA8EQwaWsO2TxjejFUBlFlOOF/k8lFBQozu4SZjq7TH3O3szw==
X-Received: by 2002:a17:902:24b:: with SMTP id 69mr20221880plc.52.1587956601073;
        Sun, 26 Apr 2020 20:03:21 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:612a:373a:aa97:7fa7])
        by smtp.gmail.com with ESMTPSA id v94sm9982617pjb.39.2020.04.26.20.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 20:03:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v4 03/11] qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
Date:   Sun, 26 Apr 2020 20:03:02 -0700
Message-Id: <20200427030310.19687-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427030310.19687-1-bvanassche@acm.org>
References: <20200427030310.19687-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before adding more BUILD_BUG_ON() statements, sort the existing statements
alphabetically.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d190db5ea7d9..497544413aa0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7835,11 +7835,11 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
 	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
+	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
+	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
 	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
-	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
-	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
