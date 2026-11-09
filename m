Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184447;
	b=QbaITh1oEebjhHjN7BLaTj+qk9sc8gxzDKBOCj9HDe4KQYEGni3buhlUUXsUp9sIuu6a
	 hyqu418P3ihWikFavOGNBRiHC3QQvAPiRa7wPqL73PqdzxdCG5zrScR+EmBpMKQrgXBU/
	 LzEm73LyD8kKKyy7zoHOxLjBfkShcBm+WTQmGU/H2q3pSHJo23tw/7Fju/VZ68f/rvUqG
	 0cboIZq1SueI/soKZzqHwQAFb4r1u7UkdjyCD1quwAKt9xSEsC1um62Pfh1rsgcq2h/Ie
	 y8F1wBvbXUaf1YZv3ASIBjMk85/gHYKVyu0I9m2i7ClmX3nuUAOmIeFv5Z1GgfZIHcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184447;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
	b=LbHnZ8FnBjaO3oLqOjuTyC+YPl3l02FgDiqcyO/MEK3YWhE5/HsJPNoENTRwRiqxSjk8
	 kE9eOp0M0ZbYllVMqny+21jd4AxeKWPPg6qVLRSZaJ+dyucjixw95BljUB1SgJ81FzR2E
	 iwm/C+5RURJF2ivsf7QL6k2BQukRchuI83QRxNvpka4tkqVx7LDuNcnNcS15Q4QsN7YfW
	 cYL14T/3tI/GYcxih4WKAHRs/bPFSpBiVMphzCirW32Bwu97JgTsVp4fQsOHojkoENiSJ
	 WdJc5boTsWrJ34g0zfUM8WoHy24b5lwf4sXNNUelHxMufjDUXPl0xSdePp1WSwi1f6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qSlqzKjX;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2FA606D811
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B2FA606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qSlqzKjX
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so2506125e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184446; x=1794789246; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=qSlqzKjX/7sPDCZRvmng2Fd7M44NFkTn1QnTKlon15ILFRt36QNjsrqLJYYai8FaJT
         xqdBUzCmut3CjikZFdWRXcM18asXALumcNCoDZ8wkDUy/vLNU2Yu18uXCs9ENs9OPJGu
         nTOZcCyszK4wAzAPo3RgIbwzygxedCHuazWjHdx+F6NUU18zcCBMt/igNH+VXF7b6oYH
         qlTinMkSbUjNgaZL5pqDSb6HsOSqrLuMpY53PyfJXRmWyJcmK2xZiyNp6qhlx0aMWWyk
         XD5wvPWvs0D8+P9xSygLy6qITW/i8jKmud5s6HzgGS2nR4vlHSyW1pd61/CmzpTA+ZFX
         bwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184446; x=1794789246;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=frQZeNFL8YPDvLHxkab/TqicMtW4b47mURasU06B5phWUlJix/Yw4EaK2hIyhDw5kv
         lNn4nQMx5K8r6k4zXbmiYxhAWiS6IJKdSRA2aWQBlxohbN8ABOLX8d0qGBOxwUIPTOoU
         djr0jOAAznlRRbmRAnOYfqyJCCeMQPBsLnEUXm9or2gQMVYAsvE5haLvlquVlLLX2/hl
         RC7e/m5sSG/TjwzjWpThL8cNYtvn1lfkqxqtxafhfuCedudkNHDMv1CEolc1txeK0c/t
         yyVSe7VR3dNtQ/FaozwJSWfYYwBCxNG/L+r/M2ViKK3rHqcoou4ZNWe8mg5OlKcqFMHa
         r13Q==
X-Forwarded-Encrypted: i=1; AL+hErHNrpk7XC928d3Sgs0ix27Wa+GhnawherN0d7aHIlLeIDfVbSGxv70kLEX44WHBYP3h7vAfSlOE8f+A@vger.kernel.org
X-Gm-Message-State: APuU4Z/N1xMgE5s1X+pTOqdDpAbPDxb26a6uCX5bu+o/kdofrPVkv/I6
	5FRbNs7qvXirQFpfhEzRxXWNBm5Xu4G8m3ewFOJ6l/+JGeQOCObVphHTURO1tXfdU+0=
X-Gm-Gg: AYBFou3FnE1v5MEHEbQgA3AOTrQTky03a5jDDKhMz921+dz5TRcpgm2UrCtjvW9V3Hy
	i1BD9qyjNv9NZJprQt4fgnaUwND4GWOOLIm4/FPhH4U8pgnMvCa4KdEhapN8GheLuKKUjun6n5Z
	I2+hi67XRlPDFbknvI+BJzwJB5qM7Hhadz58lgAB+MBosIAUhAuGGMN6J5pJcYEjOdM2bezFAsG
	5lWIet4pK0li8Ocqn3ND7A5H+xVEiGwUZ4Bkfzj/Q898dq0JXfRf82EkkKjDrxdauhGcY7O6192
	88pukMu1QWaXVlGdd5oZw2xIuPvHsB0Z2ooPxgVAi+vwHLOvQRdI9rCVayKiEcaU/MtI9C25El2
	m3sj6XvD1oVAtufx9P4Z6mywf14ZRidj4nfwAWrSNxWmBRuvCYyiV9ddUTfMt8p95nrnO8v1EEJ
	WV+5vPAjzGlflqjkFery8xr/5FVN1MZSGIZGel0yBBKtdT9ev3B0Vq3tXzCgGwkqrNd+Gd2QwY5
	62aObxYOv4QZN8hHTGzslxXCNdBPv6PP/yAArgvuDyW6k6iO36ZdmhjtqaQiNJiQiWjHeEJWqYE
	U2MHBzAWI8X30es/M9VISgvDRcX+XyxrJ1tDmJTQ
X-Received: by 2002:a05:600c:a010:b0:4a1:c5eb:b445 with SMTP id 5b1f17b1804b1-4b963ca3a7cmr51069905e9.35.1794184445733;
        Sun, 08 Nov 2026 16:34:05 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:04 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:20 +0000
Subject: [PATCH 08/17] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
 Halliday HS PHY
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
Message-Id: <20261109-halliday-dts-v1-8-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=891;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iomST/Qr961He4Ne7crBcxin7EtHuKLr8auNEsY1c6w=;
 b=4DxRuDlo3Sv6o3VM377FCKNLzrNNMHf6FsM5TYa93t66FIlBhCp/mgcC4QeOncc3ZgmuRzx3Y
 hjxDAxOeJv2BA5u50QEvvg0b3XgcZ1hYXm30qFoJ+yx+NwOICn4vuuC
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Synopsys femto USB high-speed PHY on the Qualcomm Halliday
SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 661759b25064..8ff1db4a1d79 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -22,6 +22,7 @@ properties:
           - const: qcom,usb-snps-hs-5nm-phy
       - items:
           - enum:
+              - qcom,halliday-usb-hs-phy
               - qcom,qcs8300-usb-hs-phy
               - qcom,qdu1000-usb-hs-phy
               - qcom,sc7280-usb-hs-phy

-- 
2.55.0

