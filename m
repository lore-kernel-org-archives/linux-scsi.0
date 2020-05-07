Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 210C9C47257
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00E4420838
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 04:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgEGE2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 00:28:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44232 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEGE2s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 00:28:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id b8so1424578plm.11
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2020 21:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6AnAyPqn2ZRIU9imi2L+OH5PAmp9GV+rU8lSH+ha3oA=;
        b=ebKHtWNZreoBhSzse57IZDY4cw0HeMmFLRzszDnr2Uc7x/IXlDNQeQzGvVc+mXSNJS
         L+12Pkyeq470YlEmv71uOuQjRv+PQfAkg+ooqpB64OKpiKywD4b8zgVUwjIzYg+WVBlk
         T6xXdwDDvjF6nipilUf9SaE50N52UyT16dCDePEW2qDQ9u8+BX8YeBQ9Mm3uWxdkmroY
         SPTyUX2vSET005sckOx0m0H+9pe27m/pqjFIErxImadmGBWGF6udz1QqPNHQH9OTNsES
         qAmFQ0pO9grHEMhz+YqjnYL164xpnr7o9k0qBn9V54mZy1yPSg5sLmcNgooUbPZWZkUT
         Yngw==
X-Gm-Message-State: AGi0PubyAVKch7+J+C1WsdqKLyaVDLjzyMLL5WvWA+gI+UR/QjgExQ1e
        uoM9/PZnF2Sgeu3bq7bXwLsEW27x0KE=
X-Google-Smtp-Source: APiQypK/PVAJHj97uHEIZrL5tR0MigPiqSWrLtV/uCgefiIHDPM/F6i4SQMlj/OrAxAYcnwq5pcyxg==
X-Received: by 2002:a17:90a:d517:: with SMTP id t23mr11446148pju.210.1588825727433;
        Wed, 06 May 2020 21:28:47 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:246f:3453:e672:e40c])
        by smtp.gmail.com with ESMTPSA id z28sm3471028pfr.3.2020.05.06.21.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 21:28:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v5 03/11] qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
Date:   Wed,  6 May 2020 21:28:27 -0700
Message-Id: <20200507042835.9135-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507042835.9135-1-bvanassche@acm.org>
References: <20200507042835.9135-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before adding more BUILD_BUG_ON() statements, sort the existing statements
alphabetically.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4c645d568cf7..03245b0f95c5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7841,11 +7841,11 @@ qla2x00_module_init(void)
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
