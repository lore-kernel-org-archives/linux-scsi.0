Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352F0C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiGAVPY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiGAVPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:16 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9593DA7E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:15 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id z16so2715500qkj.7
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yJcTuQnaY98PeloDz0ngQg3I0jGELz1/KssalQyTDM0=;
        b=EBap5BPjSXDvtFdQjTMDjMJI0yM8ydWSU+LR4pc4TofTCwzh0rtScVEbvTC1aL038L
         c+XBVemVs/+cUKubaNKQNHEOhsdVo6DjQRO2anSRMF/UPm1iXqCfS3aIjHT9ARAWvjAT
         P0KtR1dofwvvQG/DtFq87ThqjWj/Vt7DRsCuP25jOc30ECCHoYm/52s19tKB7lL9Pb78
         5TT8Bw0LH8Y+Bs+uD7Yv0fDCzW9bJPGxrAJmWG0xUAugsBU4sYvVWr+RiZTYJeOgBpGt
         X14lR+rqYdneYk7dvYdyzhxEsOxmIZc8Oer3imC3PAAmHvhZ+pSTKjdLz89e/ilmHnzv
         zL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yJcTuQnaY98PeloDz0ngQg3I0jGELz1/KssalQyTDM0=;
        b=5ZRR38nLIxs5aJ28UHaZYoi6wwY6a13yCdxtT8qQtrcfMlmIJiXyr94vGbeP9bzVG6
         s4fykOAu/72CiNEDLg8HSrc1rqOAUXtAUWLRhFmEsU469LpKjuUKCSHJ1vBaxhB8c2Tv
         8JgPujckiVmz4xp3X7l4/WpxX1BfFr5FcSJE4sgwKQoknahhpd7jqCjlzf4eMtGdIftN
         D7EHJwBTCgPfdoQbq6Ay/CqUqPUHnE0adjj3lO8UFdVi3x14jOWCMHi48ZA9yx3/NQlQ
         axJ9WQIUElU2yK2vUKx4p5bSn4FzpSjuEsGaNgx6tDxfpLzilxkKJK9Kie7iZ4xGpq2m
         U3hQ==
X-Gm-Message-State: AJIora8bCUbOIO+ZpGqi8GPG+04zMR3qCiWG/U4npqUaep08JDeVEkz2
        PCEUCIfZA/lZzHhd2aebaj21zNu0OFQ=
X-Google-Smtp-Source: AGRyM1s/u74ldPMY2wpglGYEU4JYPqXmuHvj9RTz2K7bUZIVuoHmmSFLKGE9AOPtqqU59X0fYQiplg==
X-Received: by 2002:ae9:eb0e:0:b0:6af:266a:38d5 with SMTP id b14-20020ae9eb0e000000b006af266a38d5mr12274760qkg.664.1656710114755;
        Fri, 01 Jul 2022 14:15:14 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/12] lpfc: Update lpfc version to 14.2.0.5
Date:   Fri,  1 Jul 2022 14:14:24 -0700
Message-Id: <20220701211425.2708-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.5

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 2ab6f7db64d8..63eba9928e4b 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.4"
+#define LPFC_DRIVER_VERSION "14.2.0.5"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

