Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472C5C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 19:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJMTqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Oct 2022 15:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJMTqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2022 15:46:17 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C618B49D;
        Thu, 13 Oct 2022 12:46:10 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29DJk36L041837;
        Thu, 13 Oct 2022 14:46:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1665690363;
        bh=GhIvSPMwfeAQY83CKUcyeJ66XyQ471sMxcqg2xYdHKA=;
        h=From:To:CC:Subject:Date;
        b=Yk62bC9u/aJQymIjtJLM5yUag9rOZzTMPfUo4pTGycoWbUO/lI/Zc20+rsgJi8bH8
         k80cEZP1mDrQPxfRAt0h8esCt07QpfrDb6rIvZJmcGl2aS6D570lCWdA3tREIawZRl
         MkDruAeAxkipe9u/qN+b3BxYq4zpQksoOkobTk4s=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29DJk3fp010259
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Oct 2022 14:46:03 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 13
 Oct 2022 14:46:03 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 13 Oct 2022 14:46:03 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29DJk1UH110251;
        Thu, 13 Oct 2022 14:46:02 -0500
From:   Matt Ranostay <mranostay@ti.com>
To:     <vigneshr@ti.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Matt Ranostay <mranostay@ti.com>
Subject: [PATCH] dt-bindings: ufs: cdns,ufshc: add missing dma-coherent field
Date:   Thu, 13 Oct 2022 12:45:59 -0700
Message-ID: <20221013194559.128643-1-mranostay@ti.com>
X-Mailer: git-send-email 2.38.0.rc0.52.gdda7228a83
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missing dma-coherent property to schema which avoids the following warnings

ufs-wrapper@4e80000: ufs@4e84000: Unevaluated properties are not allowed ('dma-coherent' was unexpected)

Signed-off-by: Matt Ranostay <mranostay@ti.com>
---
 Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
index fb45f66d6454..835e17269d2d 100644
--- a/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/cdns,ufshc.yaml
@@ -49,6 +49,8 @@ properties:
   reg:
     maxItems: 1
 
+  dma-coherent: true
+
 required:
   - compatible
   - clocks
-- 
2.38.0.rc0.52.gdda7228a83

