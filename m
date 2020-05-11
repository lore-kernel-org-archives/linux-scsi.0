Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D911FC54E4B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C6F20736
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbgEKUKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:10:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37908 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731541AbgEKUKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:10:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id u5so2448580pgn.5
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 13:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HXy5NDrl0buftrqTdyJG2GAAC0q7pSw2avZdGHUkAfM=;
        b=OiahT3dm9ER70TzezClxnVvM6FH/u128COku8/oU6zyNv7+E8Bh3iAbJ+gqxIluILP
         LTxFuD/1ZD2O9k8XEWClnsIHBLitxx4PO488GjO+ELpQT6nwai4uppTUEl4mCAPOBCUB
         qJ1goi+asUZv7RTKQuu2IDonMNt5egCo2XlRMyQ+oZioqzjI+tI1i+aDPRsBdCseYszc
         2mmlLBQ6zNR7OavHBSgbPiOIaXWr/6JYyw54dajccsYdfuBmv4C3y/UIC942eGcw5fgr
         S4sS4YLVwMBvICwu8EEsfmlNJbToc98nHAbDHm/fH6M0/icyfRtRn4rLNLcnGq3zke9D
         mAuw==
X-Gm-Message-State: AGi0Pua7KrBlBAi27HGMZ+gRDW66oZOkEBLWkPCtPYeVe6XDlxADlbl9
        uGEGGjE9wU2enxpGh1g+BVQ=
X-Google-Smtp-Source: APiQypIviIutJcfwK73bmLAjXBNOAYr2zCWwCbjgnTQy7uzMU4BKu4d0s4o7V61BvLD9bGAKXGNSEA==
X-Received: by 2002:a62:7912:: with SMTP id u18mr16720344pfc.239.1589227799257;
        Mon, 11 May 2020 13:09:59 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id 30sm8610265pgp.38.2020.05.11.13.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:09:58 -0700 (PDT)
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
Subject: [PATCH v5 04/15] qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
Date:   Mon, 11 May 2020 13:09:35 -0700
Message-Id: <20200511200946.7675-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511200946.7675-1-bvanassche@acm.org>
References: <20200511200946.7675-1-bvanassche@acm.org>
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
index 8f96d37a866c..bc8ae0c81980 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7842,11 +7842,11 @@ qla2x00_module_init(void)
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
