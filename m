Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184486;
	b=nfeLzM6v6hBa3D3tJcule6yyhDb9n0BUIcaFQwbyPE3b/0wCwBV3H+9K/C500itKCcqk
	 vSlKXvD3627U63RejxtV3mMsTdUqzih1Ekj3R6m2sc2jSccHLsW9IaXPGdlqzYodEwESS
	 2wVKpYHzVM8LbB/fwMVJVYBZ8o+JAV7zjueaTPrbXFEohKIy5WBfwuzejYWpandD+nUfW
	 SOp+KDc5/R99zu48LIgIWNNsBtlflP9edS3FA9QBQbSnQXL4FtA+XHQ/IAugeSLaEczHY
	 DXAmbPtBC9bFYzTndo6e+6quVJ0YHnDLRmtx+EXOcDNYUZrQuuhHja5Wj0H+i/IIeqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=RVY15LYwgm0Qc/TTM/+0NaikfZtjUT6nkNDgccuwjcg=;
	b=z5E2AkSAYBezgRVwc4st+CGcFixTQwq4of9OujuB4Qug7ahU6DPx5XOtj10wv6T7w3MJ
	 cRU/GHYun+pPw6r/k8TeERsUa/IRQPxNu+qvg6GHYRBZnGRLhdwNJxzkYvGP1XCv9zQds
	 cBC00jdHAC5O1EgPZedhoqnEOaZwT0nYCPrvShilbZxEK3SlSAHZ51BXZ7Lan1BdjxUQa
	 iZUOiPnaCvzIVFHVh74aftxTLbNM2N9SAyGCLRfGlL37fai4UOwPq1PrCfAYZAICyaF5m
	 6yZvBCWuUwxKeYKuY9nPH63Z9nVP1QSCwvUiFf/ipdFamAes7Jg+sHQJCkTg9bO/WBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ar0o+lOa;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D2760A2626
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81D2760A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ar0o+lOa
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-491aaed7565so189485f8f.2
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184485; x=1794789285; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RVY15LYwgm0Qc/TTM/+0NaikfZtjUT6nkNDgccuwjcg=;
        b=Ar0o+lOaLQ36hMaSQhz240QICDkzMHtmQDPTHSSCzgvKoRRu6+3NEyf5r8UGihmdVO
         YbL8kGYlIwYFzt0m+P3LcvsNsXWFp1DnoXb2XeAAeHKjD0e3mSdbFDeNhE2C064eHQKn
         FBw+L6yYJJRGThN5FTZYemlT04n3GfqgGq87rIHUjOJoGNcaF4/DfTtKARyZDeZ/xjrR
         b2ektKO2o/QtZcCAYpaDtUDybpL+f8B/n0nKzY3lo3ZuY+C94fC/nTZn1362e+1nZpVD
         khlpFRfxsUKvqLFNzImO1bvZjdT7ysUCEMcuRxy31zGl1OqROACCKC3fKd/G1KVQ4t4X
         QYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184485; x=1794789285;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RVY15LYwgm0Qc/TTM/+0NaikfZtjUT6nkNDgccuwjcg=;
        b=kwNKhckEost2+0nPivMx3Dpyfk0DyP5rZDjbX4g3TGKUvEV8LX7XALE5/JminNQEyp
         5zwTy1kZwB89W/TWIgLapfDdC7+XDflE3tLBkhBIM2VCDf2H7vrmYLcIipVfXPZunquq
         +pwWwdX9nnjHOStg7XJJz5QtaugSBeMf20hZZsFwa6Vg1nEljiOavpl4PWMkuzpoZUNR
         uCoy29fNOySUfB2/oNcJXbLWLmAubD2oKVh47aOe8vpeAhsnSwso6dMTIO+bwzQHLExG
         pjQMU+KBighZ6Le1K+ZrnOe9NYhyHkdIWvmAs978gWm0X60rkEUVAjHlZZl8RWel3pTH
         jFUg==
X-Forwarded-Encrypted: i=1; AL+hErGf1f92wA1/BN4ONrznXRZRcHuWw9qUKypQCnLfE3HbT206cZL/aeadZYwr8QI2JwVdFrlltUHSJo3Y@vger.kernel.org
X-Gm-Message-State: APuU4Z8w8ehBedQnFDueCPTfln6wUo12xdaql08h7+/lKPBU4X749xPm
	WVrnuRKvGYu9xbqiaHdi0OSQ9uveSSbcqwiP42pvN6B7+/TaMmxjdkB9PwIZwo9xvQA=
X-Gm-Gg: AYBFou1E5QBDAWEJrMEmwaBynorZukf0K3kYpAhK4xf4SW0a/w+VwWwn9zwsaYF5HBO
	e1CSpiSRRBUAS9z2LW8XLa7n2rZ4bGe2NEEY7Etthlgmaiv+V8CMoc/Gykxp8pivS/lZjI31CjO
	FNtet9AHz3k4IlN1m532okDFF/GvgPIyShOCvNWdKJS2V7oiEBAG+T7J+390GO3gRV8r7K8UOMR
	wh5hsqeWl2Lso8m1bEE4n/SzrAJR7J38ZWBaQ+bYsAuV9v4X1WbvYAohYDdj2x/FvL7Pt8PF5Ah
	QeAJjnxRSme3edw+Jmaon0dj8B888RqUJ+NaW8SJ5zN2o7fbNwvKljKeNjNZgZj+8y02/24s3Vx
	xnDYUQ+2qpRNoAS2q2NZ6j1qnZqnMWcsrsNVshZ13mzScMtsNcrrPVVUu+7ROWAFb5ZKRwZtRrB
	JkzFy6R6GMosEHjTZR8zLpck9EFMAq/GNyMJ7NKZXAfGbDlvbH6tv3m8+aE2lqsjXhArh91qjq+
	gJIRzyVizUjA00CobA6cVVTRTJmPfYzlPADT56WCpCKwnLOyyRtVPrI2b4DRfz+KoAz2wfv7VOu
	bLp7eZc73KpxyD1mBBW74pnTXK26Hl79BmUoSgjr
X-Received: by 2002:a05:6000:481a:b0:48e:62a9:1a65 with SMTP id ffacd0b85a97d-49584690551mr4596063f8f.49.1794184484831;
        Sun, 08 Nov 2026 16:34:44 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:43 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:26 +0000
Subject: [PATCH 14/17] dt-bindings: interconnect: OSM L3: Add Halliday EPSS
 L3 compatible
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
Message-Id: <20261109-halliday-dts-v1-14-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=844;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=gWRtexQl3K6zrJ8s8OX25X6Fe6c5gXvBp3k5tSGU4UU=;
 b=pnbK9TbDaJw63lMsp+XBx3cpAT1m6LlRO8M5pm7At3undTaYtmQjFmjLHcmBIU0XLq40cIoX8
 jdWhe4OxgWuCqPNlp+TJGp7ld3LSdzNJFNkDbr6brDzv5M8VXRxZg8B
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the EPSS L3 interconnect on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml b/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml
index cd6685683bab..6c3475005a35 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml
@@ -31,6 +31,7 @@ properties:
       - items:
           - enum:
               - qcom,eliza-epss-l3
+              - qcom,halliday-epss-l3
               - qcom,milos-epss-l3
               - qcom,sa8775p-epss-l3
               - qcom,sc7280-epss-l3

-- 
2.55.0

