Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184427;
	b=BnzNFeTxoL0KNB1Uo325pap6kjPQfTaoy8ZOzGSNNGmFYyez/HCQwccjNxvL3I8eHHsV
	 9y5kitSdi9BZVbrluiIJB+DA/rYZGH9Tt+r1mKuFiY84uBd81XKKxrNlyYkK8EieoBmA4
	 9/VdiRd+hyPweSbShMm7EyHIx2DdH31DsC8dZNbqfp6hUHC8lVbax70f3/914clfobCH0
	 o8FsqnUDabEbVXVpRt/TTPrgQicAGK7bGwKI1p7yF72mw+UzKhBRjkRoyUWS4Le1M8wGf
	 O13p+sqexh0ygaKmPdL8xmb092IESDXJ1NS+fvznEr2wWBD/0yOKrpToiI9t5t6gZsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184427;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=PkFPVfDx+55MAHBA3oCOcT0HjrgdVU03z1VGaEKFF3w=;
	b=LqrO/lXxZID0xZWooIQJmaHoZ1NIg+kBOs69DPz+eoFR7KoQwtYkH/18WIM66nKmykY9
	 OrRxPPXMxlYXB8jKjZ7kPJXIGFvMDNYfrje2roZGEpXOwa7pZoivdg2P+BW7HYEsnTO6t
	 cQmr+enwOcU1kePPCrqO15Ti/K16zTw7JXyS2KeAk/m/XgrK1GCP0rga6cZkhPmPf5jmX
	 RquCFnQDtLvAEPXT/beHT6xQUMFjvjwdswn/TVA9H/Sa6CW0ZOdEKEBHsLej3xFJutLQx
	 M7ZTSX185b0W7KbxmRrkYV29w0wjS/0R6gl+DdelZFiGKktM+hWgfbYfvU+H94LeuUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FyDzKlyt;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47047606D80A
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47047606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FyDzKlyt
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso2456225e9.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184426; x=1794789226; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PkFPVfDx+55MAHBA3oCOcT0HjrgdVU03z1VGaEKFF3w=;
        b=FyDzKlytNlxAxLxC2gOdtwF1+dCkfYwbnWO6d6oPLIvthh1fBT5kqIqv3qhAxjwF+S
         PFR8nekUaUaUbx6CeF7ug3qsqKHwR/kTO9V1T4Gh8dASycorY7RcdrnLPeG1D5Txou55
         xgDbR4iPItBw5wvy3bOWz0Iyu/+OIfpLVhUWEPhctXpoFJ8gpgnVrNIaGCrAUOL0ZPyt
         NxOLj8n/xATQtJPIEPyzFjU842UmMjHxhCBNhBfhWuqVNq1zEGFr9t43gIXHmKQ8IbKc
         HMtuRXvOTX5bhQuwRu6FbfL0UoFdw7t7IXKyKMYwATRvVboP24aPvmrx5uB0BcbSe3Hm
         TZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184426; x=1794789226;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PkFPVfDx+55MAHBA3oCOcT0HjrgdVU03z1VGaEKFF3w=;
        b=gcHdJWHbcbnaIKM42UZKOENH93dZaiIlzb7vCwZUy+mvugEHV0brL39Szdb6Y8dDBw
         EMOg+ywZyGTGejj/VS8w0HQaghoUOrkxc48yAg/i5RLxLfUFyNAufV3mtw6jWYKj2C3/
         J5dX0FD+5rHjxYlfMYvtAmtPmIz2EZztesLDZiMKoneNjwVEzlZvgLYZFBInReAfS7/4
         ruJuFwiqbyFi6z3ALbhgsN7+Q8dCqmoDf8YGEdZJ3ItT2ssftSz4PDG5Vx23Tou15EWe
         MKkDpUf0Xx1jM4w+d5fILk4Sr1r5tVOu+FXj6xEk1uYZZw+w//qh1wgnHA8G2uxtbYlK
         v5bw==
X-Forwarded-Encrypted: i=1; AL+hErFtUkBVrjvd2rGJ0UFRk+QxpGl6y3XULOtbKMgfUmZZMu3/BQKlSUyS0p2ksWExR1ArE+4CaHlV18X3@vger.kernel.org
X-Gm-Message-State: APuU4Z+7Jp677rDAyrdQzsytusIljRfDnHeqB1bSR0gjpDmODX1NTk+V
	AyYAitCD2GuPYnzMLweENLyKlopOqJ5g2+BmB6zq8KINB7RwD1ZvwroYG0DjwTTq6Xg=
X-Gm-Gg: AYBFou2CTf1GH6H0W/CYOjVWSQTj6GVMT/7rRaHFfTUZ9G2Lg0kxqe0pDVLzpf4Hu2Y
	VxhHBgc6Z1apE1cG//5sUUrb/rt0hlM6obcEMZep54jdU/DM/OcLYx50+Jw4nQlaDL+ZCzQDGZX
	TXrmfBouLJWCDaN3PShIPQ/SVWptZ/S2Mk27LwraISOn8tJgJ/JuRlY5fjtP+ECm54ULA0NQoPZ
	1zwqDT2Y+e+4sb0S66ScAO5K95RBD2F5Ro1EO3CzzMG4ONTiaiS5SWliN0LneGEq87p6EcPVQCc
	p+Kcatjjqkk8A0uT8sc2g1W6uagDKacl+Sj7ExOlcgRHQcMnSej3krHqVuesy/IcgxUzts3pRmu
	Jj/keOqmQgLdYxqHjGTsdewbQoC8kAHsL0twQgmiR8NN95kSJnO2o3JajfVmWfH8hKKn2JZcai6
	ywLrAaE75BXgtdwNy2IWqMV2rF9KdWUxxzpVYpcd768X43A9zdZqP844JtDfqI+NMFCDfILMbUz
	BS+9LGhcvl/11dzkSugJ0tYDdB0fQNhV3tdRZm9tDL3KE2R1YHb4eTwFupYIVsEZ53t7s6IdCL4
	zwASRsSkOZEis4RNOWO80Dvht8TL3eNT2cQKiJ3g
X-Received: by 2002:a05:600c:3e88:b0:4b0:bc65:b9b5 with SMTP id 5b1f17b1804b1-4b963c8809emr43372595e9.35.1794184425700;
        Sun, 08 Nov 2026 16:33:45 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:45 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:16 +0000
Subject: [PATCH 04/17] dt-bindings: power: qcom,rpmpd: document the
 Halliday RPMh Power Domains
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
Message-Id: <20261109-halliday-dts-v1-4-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1003;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=el/mD1li+25cayhCgWCSoEmU7xbrdbDdv2bm0vKCgf0=;
 b=AAbKZuaWziyLaKTlH3TAQLDLLUPJbQQuUGnW2/exeZlWjcPjeJvTUQ3Mzs5Xy0Jsi923+4Jy6
 HYpQrlT+Y7QBXM0fnEs6fk3DZfReSJNsf74HPnCiwzI9V/RMLtbXEW8
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the RPMh Power Domains on the Qualcomm Halliday SoC
(SXR2250P). Its command DB has the same power domains as SM8450
(CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
qcom,sm8450-rpmhpd as the fallback compatible.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 8ee1c25a7c9d..663baae9cc64 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -82,6 +82,10 @@ properties:
           - enum:
               - qcom,maili-rpmhpd
           - const: qcom,hawi-rpmhpd
+      - items:
+          - enum:
+              - qcom,halliday-rpmhpd
+          - const: qcom,sm8450-rpmhpd
 
   '#power-domain-cells':
     const: 1

-- 
2.55.0

