Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184492;
	b=RoFK2UGh/2/zSnP267q/wDfQz9JTXHkcwZWIihpgvYrK6FzL/n41F3pithMV5V3Pxhfn
	 183HVurVptBkpIud9E7o6klo3VL1qFpifAn/g59VLAsVxq8SsNvArxibJYCakNpfSX4Jh
	 txyNBF8Ku616/q4iLd5ONC/q/JSXmfz/Y5EiWcAbq/JutfU6r8rySnh5r7H3KMkQ2oUJX
	 ue6lGJiBMuFLQgKWK69YPRAwYf4JfrfgVNo1r3i6eHx0vfEQh5ZON73qLiJINA9CfRQai
	 zARpf0tRbt6j3MOnAIWF2+OO4NV5GjjxnxW+1rbiUkIV+VA1cHJEdEW7sX4w+Zy6vNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184492;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=bqalaJtZ5/g9y9/6SBPqjpN1E4M1h8fqL8PuTjv/KSk=;
	b=nkHpqX+iqwn6al0hNodJz51M1Bjl6mD/6rVPOyB8/+DCKiGYNel2XoxZJxzI/E8mMWiN
	 c9lcs/RApZVUab1B3/j61GLkoDW9AP2CWZIK2OGMVGDJJbKeV/aSovssBs6OLRdkn51pS
	 bVwA07vi7IRFdC6ZT2kwrvoai5Nuly7S1HCbzPWE1eIUUA+WYY+F/LXMKjL0IXlGHEbj+
	 t4LLKlBArSKq6ovCxCUPAypoN7/4a6SsvcKBxSOxeTcD/ETu4eRb6n9PdKW1nfazsDYrQ
	 4X/OjOCOPsTCl5sqS+QUOj/4dOyJOnX/hPzA+To0MmR498Z2cBzRALDmtTJrTzIfhmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E4mD95aN;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBA160A3801
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEBA160A3801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E4mD95aN
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so3481975e9.1
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184490; x=1794789290; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bqalaJtZ5/g9y9/6SBPqjpN1E4M1h8fqL8PuTjv/KSk=;
        b=E4mD95aN6utgtguVmche9wruQufBYUmPr7se0FjMNh58DsSqVSMujoYr0keBmRpW8v
         uWQWheuyiSWXxKez1vN9DHsvkz3dIxygT3PejUT5UR97F27EKdO7WTr8MwR/DYX5j7If
         J5n5+NU+o62GTMTKrKJF4U0oIX+yriKVSodOXqH3bAcyiqaL4rHDO9eNXyjje0tgioF3
         kJjFsybCFmRigW6JjznYVc4hYOd89F4ZaDco6gDgRFm/z6xDqoQPjP4mGVKFK2BAHaN1
         NUR9o08rR/2JzDfKTWO51s5/9EiaI8Jvltmy1OQJ6WmNNyfpZkFqT0xbMVSgVs34YbYY
         WCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184490; x=1794789290;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqalaJtZ5/g9y9/6SBPqjpN1E4M1h8fqL8PuTjv/KSk=;
        b=MDa/O/QzXQFFYJmNEqwHHwoHftGPAHcIBWlXOdRPnSVGivJowX0SreQw15vlS+9NsL
         kz+6X90kRQsCfrhrWxI2+6Vu1gDfPg0LyUv7Q6YRvsxZdVHOZ47bSI7EiPdBZnU/LkZu
         s2aUJuaxwFgomDCsPDpjJqxXxAHFW6qCf8FqvzwEXC0APOQLGc7aKMETETVoUp1lGiFT
         9Jz5ecsGM90ZL6YT9b2ZXgIQ+Zvi0YtWVjx3NX1+THYZ+e0bvBHpOAaUBiQFcLSSg5ls
         vPU67Vk2Pfiu9MO5hTabvek8Clp1Q1I9tHNPOVzRaTyv/IgwS6j4X2tGwahEOqMddnJv
         6ZPA==
X-Forwarded-Encrypted: i=1; AL+hErH5MeVkRikY+rD2QV6KN28bjKLfFSycEF6OaqCtAwSDLGT9QDR7MU7Be/VMGHged3/4b4YGD9UIyYY2@vger.kernel.org
X-Gm-Message-State: APuU4Z/tUW+/ACoOZkMiWsjszNphQMrnnz2wh4BcP6eibAYgRcE/AkaM
	Bpd6PAbLUcYcDZ4wkVHvP6ny05PkDOWItmpFGSrD+Pk4yvIvrPSIAry56+APNpyZihc=
X-Gm-Gg: AYBFou2JwVdu4qqSv/uJbOPmklsYarDp3yp1mIGhHbib/WzwVJXLzRxrRPdC7itTRvL
	E+/r/1Cp1D5RDByFsjBkE+tMZVwC2gfVrWfaPatls+iTEhxbYRQDtBm+8u1e2jqy3+5FwZzwy4b
	oAG1q0GmmwA6R664gxgDai23DP4CECMP8zkfBIq5Ytc4E1mqMiSgmMviC8Wxn6VSs6mPKwYrqou
	UDzJwba5JWTGWEK4tj8Y7ls3SFYv3tk068d9+YM6nyhqGoz0rweHPGHYWnpZZQ7OY8XLBUgj7Bo
	R0UcaBuWrjwoAOBQdUkADpoZAz3XPL4T3B3dXm7pFZgVAULgFma+9qN5jcAqQvJaJqiWNFBbnpZ
	Rd1OJToPzwgGdFGMUuP6UKHEJIcJotouGVDtQBQ6lu/rSl02MgebkJi0Y5HDafDybooC03aEXNz
	teBAr4jx1N+K0d0RtVDiJXk38qnLl3cu1XJ1dWiH2UUnRcOFZCw1A+ry92xiMOrGDOkrCb9aUBb
	rv5V6cyvDCmFK+Auoo4ccdhZ7J8cbBReV4wCoyUY3QdOy0aVjUWu+qFUrzWafCOWOe2tcKpKam9
	WVw78Aejlf6c1ensGMIj4fKsaaLHyugyEQiCxUMj
X-Received: by 2002:a05:600c:6218:b0:4a2:1002:223e with SMTP id 5b1f17b1804b1-4b8205955e1mr111833455e9.7.1794184490117;
        Sun, 08 Nov 2026 16:34:50 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:49 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:27 +0000
Subject: [PATCH 15/17] dt-bindings: arm: qcom: Add Samsung Galaxy XR
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
Message-Id: <20261109-halliday-dts-v1-15-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=822;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=GR/L35KkjRTQHIwoej6N0ZVQiPJDeokJdA0dH1/xcVk=;
 b=+pMC0hU92qIlScFgbvyLG0yeciXJR70jYMcQsgbMkAruvtq441EcqoAR24w8+H8PddfDvxdW7
 NeEMu0FiaHdAmbbpArcsFtCmr29OynUnIXhIC1Struq0XQSLzW/yMcu
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Samsung Galaxy XR headset, which is based on the Qualcomm
Halliday SoC (SXR2250P).

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 121ca557ce1e..b96ee339956d 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -94,6 +94,11 @@ properties:
               - qcom,glymur-qcb
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

