Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20341C3F2D7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0466F20842
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 05:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgCDF3y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 00:29:54 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39537 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgCDF3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 00:29:54 -0500
Received: by mail-pj1-f65.google.com with SMTP id d8so402990pje.4
        for <linux-scsi@vger.kernel.org>; Tue, 03 Mar 2020 21:29:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lf1QL76ziI65U5gOivbA3x8nMKWkWYV8h3cJoAZMWyI=;
        b=SeKSzmqCiJCOLxiiBtyzFYzo+TYKy7w1EKXwojwZEFDe4RuisNVigbV5UYQTeb4tO0
         03ox1fS+f6QSZNDHPq8dFwTurDcX9NOxnYFDo6DXyAutkl7z6ykiES5LwgAd9fzwqUS9
         neCTnyaW8U3fcRxPg7ryil7dSoe3s7Xo7ajHzM4Xk4BEP+53mPN0d6rCoQtcyLMd3nXm
         e1kgNcfibmks2K9brcOZWP9AcUPkrsCCnGXoqnf6dfy83XJbM4YHw3Oc75Wre2gPD9/O
         L1+J+Tf8U5zOU9HaLsTNWLvX9o1CXXTuwcStpw4dLEBXi/BA/DKbni8nBk+lCN8E1dNT
         OItQ==
X-Gm-Message-State: ANhLgQ3FEBdM3hXmRzi1Y3M78Xzg7STQ82eEEloxvZK+n8UPJT5QUT/U
        4O+sr3Fah3C2FzIoIYjJPKk=
X-Google-Smtp-Source: ADFU+vvXzLjE3XV/CS3Ja43YN1XovnfkQx8He5tlEZQWLXYp9TEBUulAkczEZJBTHWl3vTrarioHNw==
X-Received: by 2002:a17:90a:1a51:: with SMTP id 17mr1340131pjl.118.1583299793318;
        Tue, 03 Mar 2020 21:29:53 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:a86e:343d:2eff:fb40])
        by smtp.gmail.com with ESMTPSA id p94sm972784pjp.15.2020.03.03.21.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 21:29:52 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 1/6] qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
Date:   Tue,  3 Mar 2020 21:29:40 -0800
Message-Id: <20200304052945.23250-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304052945.23250-1-bvanassche@acm.org>
References: <20200304052945.23250-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before adding more BUILD_BUG_ON() statements, sort the existing statements
alphabetically.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e65b8e9ed47..17d85c4d1e3e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7858,11 +7858,11 @@ qla2x00_module_init(void)
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
