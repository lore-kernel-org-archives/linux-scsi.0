Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184454;
	b=GShNY3G2rkyVBP6IsMVerDV7Q8ZYS1h6HKfZXm2RMkmIG1PzP10pAItghc5aEkvAegp9
	 na0qPO2cClfeJIGMA6KpKIf3bbOfaD7pQ48DTE2DYt0o5xL4MwHIURKT28tXPEWF0sCMk
	 kLMWENKACt3Sqjbbbvvo8Mib2esxkNkctedReFWTDljncQxMFRc3d98UmFGmSQTRtlag0
	 0VFQzQCiVC/5wTvJeFr1b9ysh+GJSOxmCiq/cprBVx61oVCPvREj8nFEtycS/AM/Yu03P
	 F0gcprILhvYiDMIQteIpR6RWUR51U/ZyuHslw2W/BIWDQwCumF31A5TxmrCahkJbEww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184454;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
	b=RttIDshOXg70LzrRCSUU0jyJW/mKgDozjXGYU0VkfFPvMZFMIbMmHPr5nmKzAP17teOW
	 b/0ooNQGtWX8PgfR2bM6RD7uU8+g7se0gEA2YIRHh24ohxpyYQ9CMP34lZE8lOdtzjP3C
	 SW8LXsISoKYe6YBu3ivYCuDXJ7SNVx2pof5dYpzMbhUqaJIE2fKv53QXxyPY80XfMEZmq
	 ohYTgVQI8n2p3W3Tp5mfNlUXgTjIyfab4jT14LrdjrPg+faXcX3i0kpb8RNYZ63mLy2AJ
	 irSYa2fXHmx9Ih1KUYF//4r2ATbz0QVxtm2KUJAHbMIaT5+n9f0zEOe3yPu8lgF45Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=umF6j5At;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5054E606EE9B
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5054E606EE9B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=umF6j5At
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-492f563d1c6so63737f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184453; x=1794789253; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=umF6j5AttmWrzMlF/KQZyI0KXH1YwvPaczptCwrQT345yLijjcx6iSsqOlX5KCD1Mk
         81IVQcYSQByved1oLZtfvz31EEtFJl8JdhoQ65nRSPU0kQDnBOItbKbX1fUEejMPZy6p
         METpa5VGRkb7v9AxKCwn06Ti2a+76f2PAO1fYp6OK7f3YoHRXXgMtR6eIOyl0wZr1XR+
         Q+Q0b8evofiGdpmVDTQLjHcuU3ANrLntmTVs+p4/Be+4Iw0IjImFcnD8OEhWh+sz8qV3
         VCshHfU3qUyeCBVw7vIdWPRJVTwUI9OA/sBzhqc3Q3wO+TOkhOJYlKm5WwJwlbBly7NM
         zXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184453; x=1794789253;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=V2tRpvGoEh1zhhCltCH/FnFT/BgmjgEPIn6G16pnd6AwLtjMe+TONi0KnYzYet9DNU
         y6+5qX3OSRVQzaBwRQ+L4Ch7MOayanmeM1np8QzYH77Oet6bz+WFzVJxLowWwgBhZPDw
         xQUVjKqg9Ea12dGIZioBPsioqtvgMKZtlUZMUBudOx9vNyhif2BsIQHJqASu9sujJsV3
         wDxhQ2Dpp593p4lxsPowB+NsEbfMVHTSHK2YIFcphKwT5m+kvGidHQbW44JI3uIWVt/N
         9BagUmhmnIwkEbnef2Xk/w2Eb5MABo/3in4vs5vLrTzesqkb93PTBA8oWMEZnnifxXzH
         1UAQ==
X-Forwarded-Encrypted: i=1; AL+hErECBRrnsZ+ldv9yQmJVFMGMSj6BqRBYZviLW4FYoujZ+Fj9gZfp1251VSXXkSO5wXAQxldkjwSZDrJW@vger.kernel.org
X-Gm-Message-State: APuU4Z8S9WdVraEJN/K5uOvbgSsmWUdh0MDeiBxzmjDjsxNRBCmkEzQn
	59l12gbFsEisZ56ye+8bIDnTcBmofDjTyyb5D2OTIaT5AG8FFlgeVaE1q2YgczGgE6U=
X-Gm-Gg: AYBFou3fU+eXEVmjssMM0YA5hntgJYHfSZUgPkJeOlaeh+UV7eW+xiLVqE5RO0oH8JK
	yeuZMULdI41rxIjNEAPAgekXelqgyHNm4dkETRzzvc2X0NA9EaVkhC56RcsWJPE2XRVjp//+MyC
	1E0CKzyn1z9DHWuFkFfcYfqxEbPOHf6FkrG2FvNdUaLfilCYYvflImeg1t7pYHmAYbx5pNCHqnK
	wr1DF/rFAh+IEBf6J687QMjmyOPy0Srla2chfdHRQVXki5Qs7nm0IdXFwT7FcznHpDMPqYOaNCz
	GRZgBp+B6j1bS3giL7N99Gkod9GJVn6buL0SjbneyZ2LGYBrJFU5XyeeNQrjOs0f2TiVrJ14A0a
	cW8+Hpd/U49q47SjW0kfP1SPggy6tnQLCbVmxFrB50O6/LAXhUNiiasUSmDMiYcCRd/tEL8NT8r
	JYTEOjUWRozUeZQjzuHKRdDimCZaEDTaWPOOjUbWesR+wE3wMWRUc5QR74be0QI1d60rwvwigBX
	qSdtN4gUOxwUwfec+77l0AaZV9UtD1zonq5Lf3vB1W/nafUEg878qP1nQl6MTVJUuH1UeKuWH4C
	kBZQk2pywsawTL6x4A+Ic4e6XGrMETe3sEzSrxsp
X-Received: by 2002:a05:6000:40db:b0:48e:3d2:44b1 with SMTP id ffacd0b85a97d-49585ca3e5dmr5109174f8f.52.1794184452788;
        Sun, 08 Nov 2026 16:34:12 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:11 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:21 +0000
Subject: [PATCH 09/17] dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday
 UFS
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
Message-Id: <20261109-halliday-dts-v1-9-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1028;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=e5+pG0dDXEqC2bp77Ez+oDydvwUzWtL2BPwcLeGQJvE=;
 b=iWkySt37dA02PFmmfguFJEKrCwxdhGzWk24XOJRJESzAH3T4aPp1n4WJJawTbnHxhzVp2Ej2x
 6zP4CwoB/ABAxTrRpUZjqAEi2nTiW6DG09fAo8ednu84TwNnmQyJB1n
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the UFS host controller on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index 3c407426d697..5d1784baddd7 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,halliday-ufshc
           - qcom,milos-ufshc
           - qcom,msm8998-ufshc
           - qcom,qcs8300-ufshc
@@ -40,6 +41,7 @@ properties:
           - const: qcom,ufshc
       - items:
           - enum:
+              - qcom,halliday-ufshc
               - qcom,milos-ufshc
               - qcom,msm8998-ufshc
               - qcom,qcs8300-ufshc

-- 
2.55.0

