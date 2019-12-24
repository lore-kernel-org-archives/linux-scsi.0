Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB72C2D0C3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BABA206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfLXWC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 17:02:57 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34363 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXWC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 17:02:56 -0500
Received: by mail-pl1-f195.google.com with SMTP id x17so8889045pln.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 14:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tj0z/8+PCiyDDhgq9c2kQvefDFenJNN/RRk86VSEi0c=;
        b=jFZWk+j/b4HylPkF1MTvVvZa7xH096LvffcEpzASuTPml+MRnta1k4C5RsZZQYO/JN
         8Bk0+QMTUSO45jT6naVitk6bbvzrCIZAoUAhg6JuWTnt8YTqJClkaqzccKhSK6YjZQd8
         MJvySWT6UW8I8g+C9pj084GtlOb87ejYG8mNiYTeGkynMtOUNoXBiLTSYxTB/uIjB+zs
         +Q/PrBSVMTvyQFsf8fQ+c4yOzaxPdESvYyXmZpitJw1RvyBHXg9BNlVsEoyIT/ivUIgJ
         xfz5GovmOD1ecxV8LUCXMPO8qiWd+GvBLhFH49GbfZLFuSrJShVB8Qg09fhp8pJj8ctE
         qPBQ==
X-Gm-Message-State: APjAAAWDd/XzyeJJNSKC662KbzmVy5wHQVGH+SG9nYgMiQCmZwiH4v9r
        7KXw+zKiad5okLJnc5/a+EzAxbf+
X-Google-Smtp-Source: APXvYqxepxPH0X8i4JVUOhC4aFXohZCj9A0Al6ntNPKTFFCxHme2cqWjfZvdwodzvLhdlu7yzxfeOQ==
X-Received: by 2002:a17:90a:cb16:: with SMTP id z22mr8572105pjt.122.1577224976028;
        Tue, 24 Dec 2019 14:02:56 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:1206:80fd:a97:a7d:f0c8])
        by smtp.gmail.com with ESMTPSA id m15sm26839779pgi.91.2019.12.24.14.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 14:02:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/6] Six UFS patches
Date:   Tue, 24 Dec 2019 14:02:42 -0800
Message-Id: <20191224220248.30138-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes patches that clean up the UFS driver code somewhat.
Please consider these patches for kernel v5.6.

Thanks,

Bart.

Bart Van Assche (6):
  ufs: Fix indentation in ufshcd_query_attr_retry()
  ufs: Make ufshcd_add_command_trace() easier to read
  ufs: Make ufshcd_prepare_utp_scsi_cmd_upiu() easier to read
  ufs: Fix a race condition in the tracing code
  ufs: Remove superfluous memory barriers
  ufs: Remove the SCSI timeout handler

 drivers/scsi/ufs/ufshcd.c | 64 ++++++++-------------------------------
 1 file changed, 12 insertions(+), 52 deletions(-)

