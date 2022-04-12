Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5350C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiDLXgn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiDLXcz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:55 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61149C625E
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bg24so86257pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0CEat0N0/R6SpxVpu8NEB/Z4a3LQwD5uK6RNHyPWSEs=;
        b=A+nHjxr38x215teA7qQNGMxwXZNNGCDS839ljTh5k2EBmgtvW3QC/IKE55FKH6HFLa
         FHTTFISr7BpMTY23C5dL1tBAIPzoBmPeuT3QRu0h3Ey/o25OCytRHCJUJp9X4mwvdR/2
         42UPiZ4aghZFm13WZ5nKu9qj+WvBTyePBXJmkFbC/gfTG8Q5EcfmyQEE2xoPkPY44aYz
         O+UwtWKGJtBtYJWS+33oaU+tZcG1xCiRUlyDC+5NVsStahVzuq2nOyJ0mSmYXcfJ71A6
         fze9/icBj71KIzDZqvzVKh6m4WDKEgPV0lCA/HwsGbjTAhOjWVQAEn7BLmJEbQn2c5BK
         8bGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0CEat0N0/R6SpxVpu8NEB/Z4a3LQwD5uK6RNHyPWSEs=;
        b=CodhEO3HAAES4iMSO1ijtqvoGbaM6U74qnAx0QLdvuFjN3kAT6xk26udln+i3m8X4U
         J/rI5mzSE4zlCMOpV1apAvQ/fpGxlSOjYilBMLuzB2o8C/asogi7m8LSdJG8Mz009Q5O
         ZrCkZEEEpuZfT3eFy8A1mPz/D09px/gex5aLMAmHQqaFRWp2K80RpmsmRdVj8FOic7Mg
         Li8Ux8G+qasNdjKbhsht6bAsAHZKB3KOzfdzLPBzUy/5j5UpvFwvRei1cAp8Wn0zH4C8
         RO9AgQj/72Wcs6LwCPWkfPj1yUWrXVyNGFty8vnAGaLHWdouIsLxgNDXbzbpA/RlvBxE
         xdxA==
X-Gm-Message-State: AOAM530FWpwf4eRYGEjPZqy7arsi163IUfwMsi8py/XCCucg2tVvMug6
        P2ys+9DMbjp+aTrPqT8mvQy2ryN166Q=
X-Google-Smtp-Source: ABdhPJz+ysWdG573GFH+C+e0APeX24qgrPZHfF3qzW1K+RPG9+iMr5roCbCjqZY2kUfbR4IioRbYWw==
X-Received: by 2002:a17:90b:4c45:b0:1cd:4fa3:6ee4 with SMTP id np5-20020a17090b4c4500b001cd4fa36ee4mr232829pjb.96.1649802034835;
        Tue, 12 Apr 2022 15:20:34 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 25/26] lpfc: Update lpfc version to 14.2.0.2
Date:   Tue, 12 Apr 2022 15:20:07 -0700
Message-Id: <20220412222008.126521-26-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc version to 14.2.0.2

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index a4d3259b8c52..a615011c282d 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.2.0.1"
+#define LPFC_DRIVER_VERSION "14.2.0.2"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.26.2

