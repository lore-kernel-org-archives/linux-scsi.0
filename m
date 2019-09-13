Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E55C4CEC5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57C2206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dLR7VSJs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbfIMNFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46997 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id q5so18029615pfg.13
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ktbcZeLlBRjAw6x6Msq4A4si1KxqnAXIHUrMZiQtUvg=;
        b=dLR7VSJsL/rTQfa7rE5qXzXkE0IcmR8pH8dCMIwh4Y2zmmMsXIPDnApZnHvFZUH+nQ
         WOCEcDjG6hGYyRWF6fJJCum8BkeOb9lKSaMDWId/UcpgOIECaXiZWVgk/hdeL9C8jYH1
         eyGHFsK9Osj8vszpM6KbhpbJQM/PYicw0gsg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ktbcZeLlBRjAw6x6Msq4A4si1KxqnAXIHUrMZiQtUvg=;
        b=ObYAnHM1U/myc9ttHkEUDMfh+lu+4trMUvPsZvtxADsBQIg3gLmXpQLp0ndzN0AjLj
         11alqSu0yFtgtwgjMkgAa5u3naBbQLEs/8C0ZwLgMRn9/DmM9+HO6a8fyNbzGhaT5Gnv
         gLEpFwMeDiT4POpo6mktmoW42exGIwCMABj7C71+EqxRB38JXqXyyjvPiwK+GtPDfXN0
         Mep3y3mle0eihxMohPByMS6QpvSJ033j8GFSIobumN/n5Iv4bDMPNXHkzRSG33wU9rTF
         0K3KuyOCkdaYqN39quEeqarGoLD889D7TsdcOajh7jIvwqTaOwIJPJ452pVcE9qNRjep
         KW5w==
X-Gm-Message-State: APjAAAWr4GNRqPzxMKOcZeaygw4n5q+fsJ2yRplxryc201vm4WLxY/dx
        y9EEI1MtFd+Hg3Bf0nwvGhGGEw==
X-Google-Smtp-Source: APXvYqxvi5Diy+YFgOGpf0L8xlS/myCe1845ahpYofOGRfBNB17mBB1Xby3qIeJmufEsRGmSEVLbjg==
X-Received: by 2002:a17:90a:360b:: with SMTP id s11mr5136710pjb.30.1568379929581;
        Fri, 13 Sep 2019 06:05:29 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:29 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 13/13] mpt3sas: Bump mpt3sas driver version to 32.100.00.00
Date:   Fri, 13 Sep 2019 09:04:50 -0400
Message-Id: <1568379890-18347-14-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bump mpt3sas driver version to 32.100.00.00

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 91f6636..4ebf81e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -76,8 +76,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"31.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		31
+#define MPT3SAS_DRIVER_VERSION		"32.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		32
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
1.8.3.1

