Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8294FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 03:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiCQD3l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiCQD3c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 23:29:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550DC2459F
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:09 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id t2so5735890pfj.10
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iCHyUsk0ZznoID/NdRfLq/nAsK4oYMYrFSCQKyku1/0=;
        b=BxqA0rthWP/bxNRz2x9m9CWLaHKynu87dQBrMQiN+HSF9p5elxAo5pbhbaj4t8R7Pd
         hrbA6AnS1X8QQxzuQ2mrK/2oYYkvK1EriFxCljpOgIrTuta7f66ax/sS9VoTAyGu7eDa
         VT8CQ+SLPLl3vSjfbfYEaHu77PasR7GOOC9D+OTugGSbM/1joTLb2nVuWnrdyQuxTrTU
         wR4m4x2VZpEu3zohTKsOy0b52t9jDHmx43e9KmoX+qJqd5r8oFC43jy+4Gowd84vXWt6
         3MnuobFoG9RLZAZM/6Zd5GmtNR5TyYf2yxKJ1SOVw/Ogc+Xj3x1ZGCu2/lZ+umGWhf6p
         hkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCHyUsk0ZznoID/NdRfLq/nAsK4oYMYrFSCQKyku1/0=;
        b=06nqC7qJS/rKXEbQtdRxiA6lgrn4uh0aSzmnuT8asMDb/t75TSuIP30r5SYMFJXVVQ
         z3ELLi88WARwbhVYYgQvT3cQiyUfgSPCW3grjcDf3G9IlelcuQ2ZQyaab4dN3OxXylls
         PuQLNp1RMi5/GFNHbmkfhuiWZDCgufC843Ej8J0/VEZ7riJXZ0wBlPVgGm5CDtVtvJfH
         DCP7AnUynTI7PnzYQnBTlBQo8OQk/AK88/0HN1XTcZgJwMHRydrNFzCqJHA7qmr2nJSJ
         LI2mo80hdmNXmSTi1Tsbz9VrksSpc6EKXjfTtodJO38EHmJTCBUg8XQFi3ncbyVCxISD
         6tVQ==
X-Gm-Message-State: AOAM533WmCc6Kprt6EDVzwE0lgafXwdnATKhN8QdjX8TEx5utyT0SyJi
        kVTtOAxrrASiQd1T+7DgN+5hLFO2Eok=
X-Google-Smtp-Source: ABdhPJwKsecya+AOWhZZ+MdTK7NI19HTOYbMmt4l3Ha5YZlPGYeblPUR0xLDkKyhQFb6Dm7bOWpW7A==
X-Received: by 2002:a63:cf09:0:b0:372:d564:8024 with SMTP id j9-20020a63cf09000000b00372d5648024mr2079076pgg.251.1647487671689;
        Wed, 16 Mar 2022 20:27:51 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm5017511pfc.190.2022.03.16.20.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:27:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/4] lpfc: Update lpfc version to 14.2.0.1
Date:   Wed, 16 Mar 2022 20:27:37 -0700
Message-Id: <20220317032737.45308-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220317032737.45308-1-jsmart2021@gmail.com>
References: <20220317032737.45308-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.1

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index e52f37e5d896..a4d3259b8c52 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.0"
+#define LPFC_DRIVER_VERSION "14.2.0.1"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

