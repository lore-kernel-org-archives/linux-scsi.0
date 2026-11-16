Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864452;
	b=myV1fsI2unj2q5AlaKAF21T7uXn73jzRBL31Vkccpn9up+vhNoGcUcqBQK0HTCLeWsNY
	 wRFaU6k9wh/HrPmpsLfQX72rmx8AKzJ9j/E+t/m3vhlL3srwpzCGKvHi7w21dPfS5peY6
	 xyur2TXdub0qa6DIYLdsO9wKg134bvElhneEzep+Ni6q0cSIh/MPq3SfrdygjVLV4Xf9E
	 S3DlkmyWVYsOZuar0wVb1iAsUCP6hOHWZQQCPFcEHxYoYGcj3mSfK4ktVh0D6L9ytUaoT
	 dULMZx5Y1rmjNijyDufz2j6Ftk4bNmEy5mCZgcM4zK0PAW4nSplounFU7SOBd9Dw8sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
	b=FHYVW4gPGCdftKV9TvlIxMRqGnsrbx5pc2YlDZ30yDPsOnYMRU54k9DiFXv4pTcfgNHw
	 1/pyQCie47bQ4lUGGyiOaH6ifJdkPfbm7dQLQj3lKC9w8+5X+w17bMzQLERinaV3/ujB8
	 JaaBvY5WAP2C/He6en0jNioyHBUrFpjFVpCmAe/DYvQoUm60+e2ZGHnSsX7sgMJQCUYX0
	 P1rG77uZvBS1if+aDdo5nFLBU0tZde9LfXIE+N0cKgJ7kSH4WOp4xm7ulTHWTN6r09Cj4
	 ASs0AQST91Ni+CvLocTugLi63YRNt2Y1ftMz+iy9OXfth5mrYkBzOmVyxqt3f8KcdgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pe94GAJI;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E58606A32C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0E58606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pe94GAJI
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so21284715e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864450; x=1795469250; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
        b=Pe94GAJIWEr/y+mRBwb7Iog7Ajds3LL8wRIVBH/8xPQNrjbBDNlEcQCn+p1QOcbrOV
         bH70aW245d90T1wUfTfa0Sb1xipFO0e3BL/QPMT4jfWcMzOuboVOx66DzI97tdUkpVn8
         em63v1WpvLz1xDjpzkqtc09ikGmguqMkXF/iBCSCrH/7rvMJVikSjBvdeaH+nfm2b/iW
         Hjkp5FslDnjSyufprS3LahKBu44fJFSHmzAIkvAgbVTvZCwJLs5vDW8WjGCFxFP3mws8
         5H88Pj/ByqUxoJReDfmjknbzv2qH6Xj3kHe//wfRUbrzreMGjXoGLArpiGQAfFxpX0lR
         wpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864450; x=1795469250;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
        b=D6p5NET4e7HjB4Si3w2+kAjbYJyy0n2PKcFvebIhCXw64LvnfTvUbQoKFvqrON7p6r
         IerF1jqkJmuRtAp1lddVQQ9/m+DXTl8fd9GCtkrfbn/mcaZejUPcvUMQtLyKmegOJxsl
         IenpzG910nezyMX1NRXJrclcmsTU8KZ3kZK5XUKzXB6NSz9uDmr3G88DO5af+1tcWt/m
         wJqgBl82+FJ74i4uWuzU0n6fvk8ipIk4gM8OHluIota0yoepGGFxdkxUkfHGyTJY/KLy
         IWA1L/3OudmhN0LL/Vi7Pf9IGXYE1w9uGuH2182FlHqugwXjMSe0q7U3mGu9PkytVHeL
         aT2g==
X-Forwarded-Encrypted: i=1; AL+hErEzRELACMMRQUauKYdE0ngvSOEj4A7CqkHVl9pefn80VvUGL5gri6G3QIffPGoj8Ws1ScsaM/Z7JhAX@vger.kernel.org
X-Gm-Message-State: APuU4Z9J3NXS3kSUV3qWVqVXS27Z3xzycByAOAq8bvF8GuAOA/mttjIp
	6XOwYURYYJlUNsOD4/sZaOHUpGDpUU6hmL5xPECUSbSG3LWDu/LlzDTE
X-Gm-Gg: AZFdTZeNd98zsSkqC2LSMK8hXBBAY36LVweq/sEhAOBCFMHgDleCNFqh0Fre6sKrEX2
	dId95S2Eg/R9igOB9QBjzqxnghKb+JtxJgou1YhLn62tOwshKEMGXcBjbOqupU7CIO3XVd1grsk
	O2aS1IVSke34RoC1wFk+Rin6YVC66JNdfygiIbwFa3Evv1/YMiTFVdRgdtrSLnBLkbIreXSaZ9w
	LebhaOdXivJh8hRI90BusprGYlf2FckYgc9DQP+JvbaUpp4Cg1+wd9aj+eKWkdj0sqx2I1zv02I
	fGGxir3dDpsKnI2J0F1gWM3iTMXFxr6hB1a/7LtgXhKCJ4f/fpJMBk3cDkUjPHxFQt9AaLGBYYX
	L5fjNVPosCDxUUgQ6VcpgppfH4T2D9Px2xZeQ0LVyloHuc6t7yz2khrVQqjpPLJU3ZpoZpqPEAQ
	VtDcYRy6rdGDsLfFOnMQ2LDKjAguWBCn5jJUQkJqpmsfv6cLM62ENwGGwjV0io2EEzcwAbQfr4a
	1DR36971nnAi0HCvtVAf59/h6xg4JzVspuYr8jNq87UoFa/tHExxBxai2Pi63wzX04ltVaAyrxt
	tTVVL/uFFcc+ti9GTdVNxhkdVx+rGOlk8tgunQaJ
X-Received: by 2002:a05:6000:1a8f:b0:4a3:8b21:51c1 with SMTP id ffacd0b85a97d-4a38b2152c6mr1214677f8f.53.1794864450317;
        Mon, 16 Nov 2026 13:27:30 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:25 +0000
Subject: [PATCH v2 09/16] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add Halliday
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
Message-Id: <20261116-halliday-dts-v2-9-2c92438c6c46@gmail.com>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
In-Reply-To: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
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
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=921;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=LNBr+b73CKCaJq+Lcoy2dBwwEKE3EuPIoRzvD97HKJ8=;
 b=Oo5JC5eiOukaaqszf2JD96qfK1gjo4Z88L7lhFkJnmKZtf8EiRQqPApokWBgoFrRDRq84oEys
 dN0aV0Wol0LDOOw0PtPKsKDeYZp8RCTw6bkJAf6hQZCCV8VanxNS3ZJ
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

