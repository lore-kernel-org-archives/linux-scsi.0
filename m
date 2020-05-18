Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B8BFC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F0B207F9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 21:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgERVR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 17:17:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41562 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgERVR1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 17:17:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id 23so5533842pfy.8
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2020 14:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hR7AV16y5dLgr6bh/88dL0P5OUTf90Nxt+lW7XAZDBo=;
        b=XIJv2Oyyl8vWV9TBFQOMbN6ei1NHpfoOvBaKJmJz+NW80HtRXkxe39OgM41oIIj9Nh
         TisLSLbR1sqv0MYdgaGEw3hr8a15aUB9+odzl5XdWLhkIohzo6hZ53SQ74D9zW2gb2mo
         qSU80ckj38hbZZ0L6ESHRZ+VyMyVQf/3Aj8c7lWaFSessQ8mLyRK2htFCfxPFUskzHu+
         dfeSmXCkyemORAXj6rL8HkUWcehf9GDOaYngKo+FJ/zfCgj55SWh14U6XJLjQbCkzU+1
         auRXNO2s2w9Nc70Fs6jz6pHthLFyAnrB+UYUKs+w90kGaho1Xbk9UA3C+iWIMLo7aMjD
         4mvg==
X-Gm-Message-State: AOAM533EQheWJdfVXm6AAjnopn7uAayWdURndlwzfzPUxYRawkm59DUC
        /kO/VBnjhZ55TwdqxzOkUEw=
X-Google-Smtp-Source: ABdhPJz4/pzVXfwgfzZRZXG35wYkVgZRND4WWZzPgDacwrKpCyg24k1Ckemj5R4G46W4W+e5fduk2Q==
X-Received: by 2002:aa7:988a:: with SMTP id r10mr10512554pfl.267.1589836645411;
        Mon, 18 May 2020 14:17:25 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:dc5d:b628:d57b:164])
        by smtp.gmail.com with ESMTPSA id i184sm8813123pgc.36.2020.05.18.14.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:17:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Arun Easi <aeasi@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v7 04/15] qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
Date:   Mon, 18 May 2020 14:17:01 -0700
Message-Id: <20200518211712.11395-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518211712.11395-1-bvanassche@acm.org>
References: <20200518211712.11395-1-bvanassche@acm.org>
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
Reviewed-by: Arun Easi <aeasi@marvell.com>
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
