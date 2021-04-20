Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8A6C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61228613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhDTAKd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:33 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:33286 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhDTAKZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:25 -0400
Received: by mail-pf1-f178.google.com with SMTP id h11so6669801pfn.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5LG988m59sM4vzMUSZJXhnMJeLVHHCu8o8BmdeD5lWs=;
        b=rMU2TPaVysDpruT8M+/RqolN8gXpBROGYJmozfEIx2mk3DeqRLL9MHJjd2jzAqSE7k
         lrsaMssj7eH2Gyqf1Nc2Hsl7Yu7KpKzqVxVoCY0c8rxEjdYCw+XScAUAH5U1KC1E71md
         RsCJVvNHjLrmFGZR5xiKJ38fLMD4cA9n6YFIPw5RO608E5zEavgeHk6PBTyxkRIXKpNA
         bOkNzGhuMam/4Cly/siXeX+L/+AKtofmaA7gfC61ZkL7WX7PTAj6Q659kXNPi+dDWphE
         wi8YM3VryP4D8icFPSb0HN2RFK+aDIVsp+RskYjQmmNt6daCDOuV5UTblumHioNUVPua
         uMmw==
X-Gm-Message-State: AOAM533hzFRoGeZjfZGHgLsj0CNKaXERFYzoBT8MXV66D8UbnWksSc4H
        xPiLkb2GIEn3ZxkJha1aEIXmkE8kDhDrHg==
X-Google-Smtp-Source: ABdhPJysCP7/kEdIAuUMTJNfg/mCADxq1VgpND462i2CYS2yhvFzyDF0rGat1Ql1Jfwd8S0xPPRPAg==
X-Received: by 2002:a63:f258:: with SMTP id d24mr14117647pgk.174.1618877394360;
        Mon, 19 Apr 2021 17:09:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 054/117] ibmvfc: Fix the documentation of the return value of ibmvfc_host_chkready()
Date:   Mon, 19 Apr 2021 17:07:42 -0700
Message-Id: <20210420000845.25873-55-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cc: Brian King <brking@linux.vnet.ibm.com>
Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 8f3b783ae08a..1d4bff0f561d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1841,7 +1841,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
  * @vhost:	 struct ibmvfc host
  *
  * Returns:
- *	1 if host can accept command / 0 if not
+ *	0 if host can accept command; a value != 0 if not
  **/
 static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
 {
