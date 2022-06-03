Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5492C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240024AbiFCRrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345337AbiFCRqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B137532F5
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:43 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c196so7695812pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=idlBu1mfySjHQkC45ii5O5/kmS1k0uPA+pzZ1dL1QC8=;
        b=gV+ydNpSBCe5iwuosfFxfHT+T5xOG3sTAo7MwxAICencapsC3xooBZsfDfP0VOMW69
         aoe0mcTWnp4GVCyd76u3wKs/66cxv5izlXwmXP+3uGrvqBpyAzB9gkwK71dVA7ZhrIz9
         5SQD2m82dYzrRykC91xb2nZUMZyxsibxNXEMSqvvp4uJRxC/shb17Xwo0ZkZdklOL5HP
         BsVtOW1PUEFXG5RIW1MEuspO3e8IZCPjwQW9FLb96/30QhlURxP0FiLzPMm30u/g0MjC
         Ad6Fe090ITnMcEZqixRfppjcmXbOLIxPWsXPk3la1g1W+7VLEGQieGylqXOGbb9a9wNp
         4LpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idlBu1mfySjHQkC45ii5O5/kmS1k0uPA+pzZ1dL1QC8=;
        b=fkpCxjbgyNUvYiZYj4gGfRunTaZoJk53/Dt+RolWwO5MAvkti7vJfRgqHLJ/xd3E9g
         PU360T3brNtHwTxxk1S62z6snAUZ7U6D2Fmjbq2uQvigZPFyVuq1Wj/EuYqVPP7cGrYp
         eSceY4lowDJ1VypQib3IlWC9Ods4HrIR6kbbfUjJH/z2TotJlHdlAjEX5X6lXKT0RAeG
         yS9s0StbRJ+itj57Pt2z8WslSuSGIIQIGHNA2StOCI0pfkFDZwMHWJ2pmVA5P64uqNPm
         ELz5xDmGm0gw6cQtphnXmKlUimE1G2pHE3c89c6qyX3tD65eR+G8N4K/6eKTIdn/ehu0
         vdYQ==
X-Gm-Message-State: AOAM531h2W4S3OMaJoly4SCjZJNr3I+xIlxwEENmZ1faq5wnXmoc/wcv
        wZ6M3v5IsM9DT5jYAb4H0DJoEjqbyZU=
X-Google-Smtp-Source: ABdhPJwnIU/5K1lYeOQVN2Kq2uJjTDjRjeLxSJfPSyBORUYbcTQ033EuRPmldQ5wp+awB7YAtLWt+A==
X-Received: by 2002:a63:524a:0:b0:3fc:7f18:685d with SMTP id s10-20020a63524a000000b003fc7f18685dmr9994167pgl.387.1654278222874;
        Fri, 03 Jun 2022 10:43:42 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:42 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 9/9] lpfc: Update lpfc version to 14.2.0.4
Date:   Fri,  3 Jun 2022 10:43:29 -0700
Message-Id: <20220603174329.63777-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.4

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 4fab79ed58ed..2ab6f7db64d8 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.3"
+#define LPFC_DRIVER_VERSION "14.2.0.4"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

