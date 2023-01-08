Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00ACAC54EBD
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 19:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjAHTzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 14:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbjAHTym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 14:54:42 -0500
Received: from amity.mint.lgbt (vmi888983.contaboserver.net [149.102.157.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD6DF7E
        for <linux-scsi@vger.kernel.org>; Sun,  8 Jan 2023 11:54:36 -0800 (PST)
Received: from amity.mint.lgbt (mx.mint.lgbt [127.0.0.1])
        by amity.mint.lgbt (Postfix) with ESMTP id 4Nqnpf669Lz1S5FV
        for <linux-scsi@vger.kernel.org>; Sun,  8 Jan 2023 14:54:34 -0500 (EST)
Authentication-Results: amity.mint.lgbt (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mint.lgbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mint.lgbt; h=
        content-transfer-encoding:mime-version:references:in-reply-to
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1673207674;
         x=1674071675; bh=c9nSCJYScyOro/xinJ2YenD7cEvhmRGGKbJnrYkvv/s=; b=
        y9WbH04/l1m0GmjahpAvh4aeC4VTODycgrzMOG3Wxc1r4Iy7VZSm0/kxBD64L+xV
        n9su0ZDN8bRHhcSx13g2/4IW563+7mANsjVKAE5bnYfnnQElMf8n/+QVG+gnVIQq
        KK8xUHCiXg+/XITvKdQhv4Fhdn4vEVMVeDkkGy97JJ6fEuZ/YwtE1mwmQQGtDh0u
        kqqM5VqTLKDQyAlZIRfLC+oIyLPWnxVJdj4WXLxqaj99FSTFXAETWc+yWlaql+3u
        u4jApqLSzkB/kC67He1jdfsd/tZbWQIS74JnOhJn4unxNMJafSRW+KADvKCZa1nO
        boToB8qw4r4cBpIE4LB9Cg==
X-Virus-Scanned: amavisd-new at amity.mint.lgbt
Received: from amity.mint.lgbt ([127.0.0.1])
        by amity.mint.lgbt (amity.mint.lgbt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XzH4gxPrwkSz for <linux-scsi@vger.kernel.org>;
        Sun,  8 Jan 2023 14:54:34 -0500 (EST)
Received: from dorothy.. (unknown [186.105.5.197])
        by amity.mint.lgbt (Postfix) with ESMTPSA id 4NqnpT2ghtz1S56d;
        Sun,  8 Jan 2023 14:54:25 -0500 (EST)
From:   Lux Aliaga <they@mint.lgbt>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, kishon@kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, keescook@chromium.org,
        tony.luck@intel.com, gpiccoli@igalia.com
Cc:     ~postmarketos/upstreaming@lists.sr.ht,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
        phone-devel@vger.kernel.org, martin.botka@somainline.org,
        marijn.suijten@somainline.org, Lux Aliaga <they@mint.lgbt>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v6 5/6] dt-bindings: arm: qcom: Document xiaomi,laurel-sprout board
Date:   Sun,  8 Jan 2023 16:53:35 -0300
Message-Id: <20230108195336.388349-6-they@mint.lgbt>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230108195336.388349-1-they@mint.lgbt>
References: <20230108195336.388349-1-they@mint.lgbt>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Document the Xiaomi Mi A3 (xiaomi-laurel-sprout) smartphone which is
based on the Snapdragon 665 SoC.

Signed-off-by: Lux Aliaga <they@mint.lgbt>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentat=
ion/devicetree/bindings/arm/qcom.yaml
index 27063a045bd0..4923dafb5d7a 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -793,6 +793,7 @@ properties:
       - items:
           - enum:
               - sony,pdx201
+              - xiaomi,laurel-sprout
           - const: qcom,sm6125
=20
       - items:
--=20
2.39.0

