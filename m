Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184466;
	b=VEnvrRY5pWnUoChxrT7qRcMkV+Otf76qxSm2toYOufhwNFcpHS7alrJE0wc1h1claIyT
	 2CCEch0ICNVcfV2NGQ+xpCYquFzJGijJJUo7Okbu9ekPJm/OvpzDEzip0qPyXX8qm7cbK
	 RLCsR5KG25rtaDJz2n8KnieU0olOXi9Qs8uBwl27FjwBa0Pt2abkzFMrmv6Oqt7OULAOR
	 8MqlIpybzE3XxxTTuj+A2ar1UsQSh4XS1ue7f3YFgE0uNCeBiC7Xbw131sEwlDAeWcDir
	 HrHs1JvsLib0oCnNSo2mQv95P3O4a64AmeF6nzJ/ATqDcnn6YT0rGBTYA+YMLKf8FkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184466;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
	b=CAIr7sIfBAOvoJDpjVmxrm3p8E9OFxBKX5En0FTofJkIkMrI0Kx43pu+2ArWwb8td4u6
	 1ZGyfnqSLZ5jpUhQ+2Gfxy2vqyDuZYpjaIpSYcsMn7c0VYJ62efZ0RZ7OY2u7TeIwnsUw
	 HyQpb1A56RtfK40xZfAsNRQEyYlZLM89t5/bqg7ZVUeCxpoOTR16VdcZ0X2ejC47fPtyV
	 LGqedxnJv4fYijR+7FYUckz9lvQ9bFsMWlsnRUmwrAg4AHjnSd2b+cZ/6yo24OWTkckBk
	 BQFIbszcxPfkp1MQQQ3yMDRaj0IgM06Pq0+xznyFPzQskyTRkVnrAhxixQVrR0xNHsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qXTbJrRO;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C08606EEB2
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02C08606EEB2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qXTbJrRO
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4918c2d727fso134316f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184464; x=1794789264; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
        b=qXTbJrROM77jrmCM9vSlEIFFKfBcarGsiF17Y6oDUL7SOkdiBhgFQr0+YixFQkWEIf
         bYD8oFTkhS58HuFfPLn9H6mX4m0ZZAxM4XzrERkTjpzB3SJLNHOSvSsV8AC/tEppq8Bt
         MGZppWqXbepkL7pMczc33p3cmiQFuRy5MYtLQQte/3bTxKRjI831KG5f3FDqNUryqnyB
         eEKohYIZ4FVRnbdpdXsFLSKFtCHd8jPmqTgGo4qq2x89oY5DmmCjomsXCqHjt6mhmPGl
         Xat49iJQqtdDJ/TsXzGZbMNuKHaq5TRzEMhuqi9PKjPqnxRIxqbDKnE/ZWsFJw1NO6tJ
         UnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184464; x=1794789264;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
        b=bKPcn2NH+nTlcLYcbbGL3laPFXwVs64T8qOfY8M9V43kb5OebTIxor+iJPJEOQHSnY
         6I0grbwjCA7KdIQsdRw6EckhAwN+qyo7xZciteMcporWEQgLo2erEFR3AtFeq4ePCI6n
         ohCeLwMgW/WJKqa5YXvDf5Lp7wyO1rx108W4hhwkh/MGlNIJrYQXMbfQqVjQYRy2Sezt
         EYNxRta7lNJXb9RVDe4R8Gyji/EZfIFl+9r+GKsBsjLad81K4ExkHfYtdQZ/yK+QF1LV
         jwPvtlB2fjRoNXfutJtwnmwIF05UUZEeOBYNkSM4weuWMMlz91x72pGJyfREqsj2dLRL
         99zA==
X-Forwarded-Encrypted: i=1; AL+hErFnG90LknIVgV2pB28rVp1SknWCqrPNl/1b6Ccp0gOazFc+JQGWuoG8YVpAm7QJFgahU/acGzz/sZNy@vger.kernel.org
X-Gm-Message-State: APuU4Z/ocU6DNC2bIZSqDE4QV8fDXkw9sM2lKHBWMse4qSwznt6Jd6bM
	nbMUI1cfR+Ij+fVWSaroExmTbcuYeqczpDHQ3cgOfMZKSSI79Cs+tlMdyQ9oDLBiYB0=
X-Gm-Gg: AYBFou3lWh2WXB0+PYFGBVwIEI94ZhJOC7504RXYDEJriYtLsEnoTYvJgcYujxRPBA1
	sTFjevoghM/ZrSz2ZWIV8+yFk6G/787sMDuvWYCW7krKkmDV9oqVPkjbmvHG3Wp2a41CmfkJkpd
	Mz0IXcz0tM5j9i5UihG/3/oNhV/Ip/8/qgn90Zagrccs8epngQba/5uGau4B2nl3wPDIeA7hsiD
	4hf/iupjCFvTQyiykV4U0LTBL5LuhfnU5rTwxW+RsZaPzAnCfOoJj2XhjLzc5mQ74J8UAOb4VIQ
	Hr9mOzjP0YCH0EP/IECOOGi6vuxGPMS+Bx7RWVQVHFGdwnRN0z3cCWTPLHftceg3Z4xVTc/EZzb
	GrZlJ5cf5eG5Pl2zJQc1JhuNh8K0fAf1zKcZ6eVsroyQbt0+YnMXHzT12VSd2JuRxXErt8yclYg
	gOxuMVhOL/TbSUOQVNvgCgtkfZs9GIg1GhXVPFg3fXnFIXyskSZUja68wGzM5CoPjr+0I7Q5Y31
	GMD1MhcsjWyKYXM0PRwNaRzwRTbS+3fTRzQB8hmhvg28DXPYjvGI3WMIgaW2uc8il/MLve4/GdZ
	Qd/XxQZ/2ec4DnM5Wxr8IykzTT/eIriZbcOkWhMw
X-Received: by 2002:adf:e19e:0:b0:48e:44c7:bf0f with SMTP id ffacd0b85a97d-49588ce1818mr4774036f8f.25.1794184464442;
        Sun, 08 Nov 2026 16:34:24 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:23 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:23 +0000
Subject: [PATCH 11/17] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 Halliday
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
Message-Id: <20261109-halliday-dts-v1-11-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
In-Reply-To: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=921;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=LNBr+b73CKCaJq+Lcoy2dBwwEKE3EuPIoRzvD97HKJ8=;
 b=/dOrZ5kbZXiJ0bcfGwkBHl7a+YAKGn1bUTdYux1Y38RVDKws5L13g0SU1+8SFR4l0gLQgTvYS
 wprUB1wAKuOCKc4gs9aCLEB0eoMZXLaWUvR2Qma/3ofWIp9EDkckTFe
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Inline Crypto Engine on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..1512fd1d7471 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-inline-crypto-engine
+          - qcom,halliday-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,maili-inline-crypto-engine

-- 
2.55.0

