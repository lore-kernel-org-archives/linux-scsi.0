Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5486CC5DF60
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB3321882
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 05:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKGFWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 00:22:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40042 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKGFWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 00:22:08 -0500
Received: by mail-pg1-f196.google.com with SMTP id 15so1135279pgt.7
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2019 21:22:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BDTBKgmm8HovqDIbiBo5BiT+3zEk9acYa2+SMAqjsug=;
        b=Qnz0wCxB8zveD3IhFrYJPBW1KKwIE+mZqHvRwlBDzUdISMaUyKQaGKXZwaWhKsRb8/
         tDF5/5zEgszOoHZiiRHM+FqxUQjFwEJx1qrqKSF3gU8sAJWeD9UcqICMYYN9qJkWHoUT
         n1T2Wl+CGovpe+eVJU0XF47HAi7jxqtiZThhEHU60payxwPPVoZ6LzsHI3wjkA0VoU3F
         rWpni+KLijWyOP9pFMsLGibGH7HJTCYJ3xFZVezJgPu08PEfnjMvn/Dp8orq0P2PCixk
         aU9k/tSS8mRmBJOEm2KVdGTFlgsx7cY4jY4KzauJUpNEihJHgtCAgvo+1siIntOxyf1K
         aWSQ==
X-Gm-Message-State: APjAAAV2KcblSwQAXstpE1s2AcTHAQqLGHQde9dFgJRjNxvEZCEX5UlJ
        tEoB8H4OO9IWVRnPWsIyOXs=
X-Google-Smtp-Source: APXvYqwLGzSQnkQlCHCIvGV1tfVJFAMWI7d5NImVYNgzOR6kKPG9ZbVtSqLM/tnjA5pR8uXN3+NTag==
X-Received: by 2002:a17:90a:bf16:: with SMTP id c22mr2374028pjs.83.1573104127768;
        Wed, 06 Nov 2019 21:22:07 -0800 (PST)
Received: from localhost.net ([2601:647:4000:1075:7917:b099:7983:671c])
        by smtp.gmail.com with ESMTPSA id m13sm719961pga.70.2019.11.06.21.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 21:22:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Three lpfc fixes
Date:   Wed,  6 Nov 2019 21:21:53 -0800
Message-Id: <20191107052158.25788-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The three patches in this series fix recently introduced issues in the lpfc
driver. Please consider these patches for inclusion in the upstream kernel.

Thanks,

Bart.

Bart Van Assche (3):
  lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()
  lpfc: Fix a kernel warning triggered by lpfc_sli4_enable_intr()
  lpfc: Fix lpfc_cpumask_of_node_init()

 drivers/scsi/lpfc/lpfc_init.c | 17 ++++-------------
 drivers/scsi/lpfc/lpfc_sli.c  |  4 ++--
 2 files changed, 6 insertions(+), 15 deletions(-)

-- 
2.23.0

