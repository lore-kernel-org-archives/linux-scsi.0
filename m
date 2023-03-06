Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E2DC64EC4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 17:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCFRWF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 12:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCFRWD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 12:22:03 -0500
Received: from amity.mint.lgbt (vmi888983.contaboserver.net [149.102.157.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE0A468C
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 09:21:30 -0800 (PST)
Received: from amity.mint.lgbt (mx.mint.lgbt [127.0.0.1])
        by amity.mint.lgbt (Postfix) with ESMTP id 4PVlRb5t6vz1S5KW
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 12:09:15 -0500 (EST)
Authentication-Results: amity.mint.lgbt (amavisd-new);
        dkim=pass (2048-bit key) reason="pass (just generated, assumed good)"
        header.d=mint.lgbt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mint.lgbt; h=
        content-transfer-encoding:mime-version:references:in-reply-to
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1678122555;
         x=1678986556; bh=VbzUDwgw8Wby0J9gvqa6EvdBS02V72CvMVhm/k21OKA=; b=
        x6F/uU+uvwTIM01PZkdVn6vBUfBjcMBctRu09dcaXIrGtSYjifsvM19STk4ewYPO
        rtxbUW2QOxebStOeR5FP2lDSTSLfGZgwkF3e6FD8nQPKpcK2i0KhbhcHMzZUItTl
        10+UEp5rLTJHGC1yogHdXNAmwk+wd42DUCC+Oqv7hlmgsv5ASleC9otIhY7mZX+G
        oKcJuZCAfU/kKwsjX8ROlFZTH23J9wheDjhycOvBkp8c7PJA9XQvkOA7RqtRZFX6
        6IBCNAgqBSI/I34Y+DOzZ3WMYfaTU0ARervgtH0hBSVUo7fJT5NH+Yo1pGlHwEHD
        3rRjZ4QlKUoKMkSMOFeiKA==
X-Virus-Scanned: amavisd-new at amity.mint.lgbt
Received: from amity.mint.lgbt ([127.0.0.1])
        by amity.mint.lgbt (amity.mint.lgbt [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UJCgtzBq8d9C for <linux-scsi@vger.kernel.org>;
        Mon,  6 Mar 2023 12:09:15 -0500 (EST)
Received: from dorothy.. (unknown [186.105.8.42])
        by amity.mint.lgbt (Postfix) with ESMTPSA id 4PVlRQ0bFjz1S5Jl;
        Mon,  6 Mar 2023 12:09:05 -0500 (EST)
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
Subject: [PATCH v7 5/6] dt-bindings: arm: qcom: Document xiaomi,laurel-sprout board
Date:   Mon,  6 Mar 2023 14:08:15 -0300
Message-Id: <20230306170817.3806-6-they@mint.lgbt>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306170817.3806-1-they@mint.lgbt>
References: <20230306170817.3806-1-they@mint.lgbt>
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
2.39.2

