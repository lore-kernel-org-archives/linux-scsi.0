Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578272;
	b=a0jUnxOITYuSiQrGgExNAdvr7A3OK/O/JOXJwNHWKdMTGkULNU90EmDqKlkP8dEsUuLk
	 zbWx3y0yRMCEsWBVLSPFBz/hB4MY+HhIH2dcBHCwZyZIAnyK6Sj1usJQvRAMSXoaehFj4
	 Ub+yC3JcIjKdR+oSOyCMwO+nEy9Dw4c6NismlucpifrQsaTr9DQ902n46e8e3qIu4RXft
	 Uj32p0l1bm4KuhzEeTUi/uiCSLzlniJFpx9aSgFVlytPEbtZ01nlKknbB0AhuQloiRW3M
	 KWn1hh0LISHlv3GqGdDNzE5GX1McplbDAuMX0ZFEuMuHqnUk+8umej9+xpeMuG9ujkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578272;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=MoC1SgO2w8DUrhMh2AG+uVa1qSo1fqq7KKacDb9Yle0=;
	b=k5aWKmPqyQLQiDHhPHJIuLxWRmliadIUN0VEdiwzC5JxLvo/xJSYWGER5Vf3IDFshRCH
	 Q42nflQM9KognAnodFh0wc8y6mR6riwqGcz8hZr6hXplNIbJCF/RnLJOXap4OBeP5mH3M
	 JXx0FVZiGUXTCiYFVuqPVS9AiCZ+uRIQhgzJPJcv6ln/ctNiQDqbEBHWc5RePSLFVz1g5
	 NSRpUyQA0v5IGkIYyDUeJ8U+ZZ1tpPFEXwS5EUnDXy77lzsUYNpgfnazbFbS3quTZ1hcF
	 B55oklHW1LUKgJ4jKRQ06BzVQNSPGVWVQ+Am12fi3L8e3DM2VfE+/pH6OYFxr9QvIFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="cd/CwUIr";
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54C1606A333
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E54C1606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cd/CwUIr
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so51569075e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578270; x=1796183070; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MoC1SgO2w8DUrhMh2AG+uVa1qSo1fqq7KKacDb9Yle0=;
        b=cd/CwUIrjbcOE1jcXgRaYEIJDQYsFOTCJ5iMNwUDr+K/29VkIZmyHTaJpvjyoplwUt
         opHj+vOiMs4TceBGSSSXLJKXZ1kG/6/jRyut2IruE/5mr1cSY2NcKw8Jvv5l2hE3jtvg
         /SaanOhh4Bs57LI5zBeU+S0ijGpmAA5qhzuFVDanm14lBFNKgrbjTtOOQjIF44Crw928
         iippPScspNB6PFL3psxMHXTiJBBL+rnUbRzqvW1LfJkTHxqFrtexgvScZv3F80oBetbs
         uYQhg+uMXBE+sTplkymU+bfIBxVEGZbnnmeuMfGBLK/BTUKwkKbKbFK/tBjJ6JR+/jmW
         XyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578270; x=1796183070;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MoC1SgO2w8DUrhMh2AG+uVa1qSo1fqq7KKacDb9Yle0=;
        b=fvPem8PFV3CuSmsegF98qjdX67TBaCUJ1Qtssn+lYQASZ0uSRpOtreiTZt8gg5Y65s
         qRrTaSXu7hu7xP+SqQyl1X1UbemknXAC7oQwAcHW97fCFMQGcq9zzyV5MIAJJtYgkLot
         b1Wa8/EqM89aDByN6It2/AIs/YTyFW1SyVA2Gj0yVIF/LfrM+2P/9XcCYHB25Frb8qoI
         WQNcLlMsxLCpQK9qsbbA/JvLc2VxbrRvnRZF6dZDHbyyfLx98Kh0Zuj7Ugn0g76TonVP
         M7sQs0W/9IbWhCyabSd3Vm6rVGX3I1FwlBgFprEgX5il2X60hPN55tT6jdWhcxHN0vkm
         aDFg==
X-Forwarded-Encrypted: i=1; AL+hErGg52SLhmLgg9t2MPZV59o/bNf7fPLNEW17PPQyZGYVVBD36UnSsRoSraYyTmxEqgqmJ9Tuk/vZsidn@vger.kernel.org
X-Gm-Message-State: APuU4Z+JNJ4eR6rTnMmPOl7ouELsJWnAfaVhTm/PiL3RlvloHLDEx14K
	KNOZDreOelEaGBJuPPx9wYVfYsd2M099q27HroEsBZTvsMT0OHceZpKu
X-Gm-Gg: AZFdTZeaQCZ9z4IKNy1v28jqvF+pMEw/FYMKIDUTgzr6m6O+qW3dydWSvCakeZF1yW/
	J7nZkF+ucwhmtGPynX6rV07dOkAmO3HdkQ5zOMnALtZ8ALlM8+j7YADVjUKQr8XylaeqMnVsn+I
	43AcRWwON6g0pPKNiQ5n2Xz6xxSZdUUz0IfvlD0gWMzTYvl9ezS27kx+WOz4Fup2EEVIOlU39dp
	m4LLQNVokJMzuZm8NKd5eBI47CanuCpC3M/Nf+e9lwK7LbjW+F+dmfV6GiIgUCFyjStEjnoaWoF
	gsRunBBXWZxX0Tqmz1SqaE8FXCMNe9g8nD/VJ/HqyGVn9WzAuFcty/m/eOouPHIRZGc8Gqn55Bo
	9damrcK/n+zH8D/UMaFBKFSFt/HVrFuncLxMLd0JjFNlGj+WDdLQMOXoNpLemOUekRf58q77hnP
	mwoWIp8I3FdK4DywtCeqx2fXEIp9hVIK5PcPK1Ui1svejSaZPP3uITGScMR6EQG6rE9rLXKoXV0
	zBw1L4NEPWNBDvihfS5yg1Ddtz2/AczvB5pVifZF1cjCU8DKS1XLWCtIEP365q5OJLnMcb6msn3
	4eMYOo5enXRsDnn4YLIPXEDd6B6eGpDTSWkHKg==
X-Received: by 2002:a05:600c:a085:b0:49f:e8bf:8f9b with SMTP id 5b1f17b1804b1-4bb887ca0dfmr355855285e9.4.1795578270210;
        Tue, 24 Nov 2026 19:44:30 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:07 +0000
Subject: [PATCH v3 11/14] dt-bindings: arm: qcom: Add Samsung Galaxy XR
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-halliday-dts-v3-11-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=2338;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=sc7hCO/9FV03CpZVdvB2YU0dNTyFNg8IPFIk+Pz2HvA=;
 b=SvON30lBvsLRrioVjQpTeOXmqm/qci7ViucRjmCDuG3VaQjW0xP9BFS6pOQsd/zJ4swyXRt58
 s7+MR2lL/c8C4SsgOWqG1Sju1syf3BxGFRuDPua+ActSxncjvLjBfNQ
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Samsung Galaxy XR headset, which is based on the Qualcomm
Halliday SoC (SXR2250P), and register the "halliday" codename in the
SoC naming convention schema.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/arm/qcom-soc.yaml | 4 ++--
 Documentation/devicetree/bindings/arm/qcom.yaml     | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/qcom-soc.yaml b/Documentation/devicetree/bindings/arm/qcom-soc.yaml
index 179aadc86a9f..9d392329d437 100644
--- a/Documentation/devicetree/bindings/arm/qcom-soc.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom-soc.yaml
@@ -30,7 +30,7 @@ select:
       contains:
         oneOf:
           - pattern: "^qcom,.*(apq|ipq|mdm|msm|qcm|qcs|q[dr]u|sa|sar|sc|sd[amx]|sm|x1[ep])[0-9]+.*$"
-          - pattern: "^qcom,.*(eliza|kaanapali|kuno|glymur|hawi|mahua|maili|milos|nord|shikra).*$"
+          - pattern: "^qcom,.*(eliza|kaanapali|kuno|glymur|halliday|hawi|mahua|maili|milos|nord|shikra).*$"
   required:
     - compatible
 
@@ -42,7 +42,7 @@ properties:
         - pattern: "^qcom,(apq|ipq|mdm|msm|qcm|qcs|q[dr]u|sa|sc|sd[amx]|sm|x1[ep])[0-9]+(pro)?-.*$"
         - pattern: "^qcom,sar[0-9]+[a-z]?-.*$"
         - pattern: "^qcom,(sa|sc)8[0-9]+[a-z][a-z]?-.*$"
-        - pattern: "^qcom,(eliza|kaanapali|kuno|glymur|hawi|mahua|maili|milos|nord|shikra)-.+$"
+        - pattern: "^qcom,(eliza|kaanapali|kuno|glymur|halliday|hawi|mahua|maili|milos|nord|shikra)-.+$"
 
         # Legacy namings - variations of existing patterns/compatibles are OK,
         # but do not add completely new entries to these:
diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index a7157795870c..4d5e335ce065 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -107,6 +107,11 @@ properties:
               - qcom,glymur-sip-crd
           - const: qcom,glymur
 
+      - items:
+          - enum:
+              - samsung,xrvst2
+          - const: qcom,halliday
+
       - items:
           - enum:
               - 8dev,jalapeno

-- 
2.55.0

