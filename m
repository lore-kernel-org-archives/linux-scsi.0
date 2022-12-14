Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BEAC4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 09:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbiLNJhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 04:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237615AbiLNJhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 04:37:51 -0500
X-Greylist: delayed 395 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Dec 2022 01:37:50 PST
Received: from amity.mint.lgbt (vmi888983.contaboserver.net [149.102.157.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ACE6572
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 01:37:50 -0800 (PST)
Received: from amity.mint.lgbt (mx.mint.lgbt [127.0.0.1])
        by amity.mint.lgbt (Postfix) with ESMTP id 4NX98x57Chz1S5Cs
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 04:31:13 -0500 (EST)
Authentication-Results: amity.mint.lgbt (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mint.lgbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mint.lgbt; h=
        content-transfer-encoding:mime-version:x-mailer:message-id:date
        :subject:to:from; s=dkim; t=1671010272; x=1671874273; bh=Te4FoBB
        7d0qQIWej9mZZ8GF8WNlyMDQYAP3Nesnb9Uw=; b=rkbsc0vbIW2js+GmOt5opLa
        kt49RXAY3ZaJ1s15rhvzUCkPy+W83lUgTC9M65qjBdbs2CZe7b/TA43boF3/80lp
        F+1NOJtu8UN4evsn8SEQOSNFcKP+6LgrzHRBgfyOYFJ1BhnitCNHxvX30M2nRfWm
        0qLicSgQSWiGYJkpTO6pY5sqlQcYMTHJaKtA4FjRH+Wgxou7PfpDx6lii/DfrGv0
        4Qj8GORAu+lBoGlYajqTbQZ8fHu5is0RaHlpezW2klIW0ZGOkQ3flx1ozVwfdPHc
        vkNwvCez7W4v+kdDM4/qV90zK9kbpr50qA8LLDnMDoGMqHKZKWA6COrZnLd3A/w=
        =
X-Virus-Scanned: amavisd-new at amity.mint.lgbt
Received: from amity.mint.lgbt ([127.0.0.1])
        by amity.mint.lgbt (amity.mint.lgbt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OUqcW1f9xMud for <linux-scsi@vger.kernel.org>;
        Wed, 14 Dec 2022 04:31:12 -0500 (EST)
Received: from dorothy.. (unknown [190.196.92.66])
        by amity.mint.lgbt (Postfix) with ESMTPSA id 4NX98n3vJCz1S52g;
        Wed, 14 Dec 2022 04:31:04 -0500 (EST)
From:   Lux Aliaga <they@mint.lgbt>
Cc:     Lux Aliaga <they@mint.lgbt>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dt-bindings: ufs: qcom: Add SM6125 compatible string
Date:   Wed, 14 Dec 2022 06:30:52 -0300
Message-Id: <20221214093053.152713-1-they@mint.lgbt>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document the compatible for UFS found on the SM6125.

Signed-off-by: Lux Aliaga <they@mint.lgbt>
---
 .../devicetree/bindings/ufs/qcom,ufs.yaml     | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Docume=
ntation/devicetree/bindings/ufs/qcom,ufs.yaml
index f2d6298d926c..4d3cb12e4882 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -33,6 +33,7 @@ properties:
           - qcom,sm8250-ufshc
           - qcom,sm8350-ufshc
           - qcom,sm8450-ufshc
+          - qcom,sm6125-ufshc
       - const: qcom,ufshc
       - const: jedec,ufs-2.0
=20
@@ -178,6 +179,31 @@ allOf:
           minItems: 1
           maxItems: 1
=20
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sm6125-ufshc
+    then:
+      properties:
+        clocks:
+          minItems: 8
+          maxItems: 8
+        clock-names:
+          items:
+            - const: core_clk
+            - const: bus_aggr_clk
+            - const: iface_clk
+            - const: core_clk_unipro
+            - const: core_clk_ice
+            - const: ref_clk
+            - const: tx_lane0_sync_clk
+            - const: rx_lane0_sync_clk
+        reg:
+          minItems: 2
+          maxItems: 2
+
     # TODO: define clock bindings for qcom,msm8994-ufshc
=20
 unevaluatedProperties: false
--=20
2.38.1

