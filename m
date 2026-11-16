Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864401;
	b=CFdk5koixhWGDLnigITiJ5Qtovwa5BjJAOy+u4xn+E8Vhyf6Q78naBuHhPU6qYPD5dZh
	 kvkrheI6ircDkF8bf7335CEOJhhZ7FP/oKAOZLR1s4e/PxclS4MFw9rbhrTadbPyEfZHL
	 6Uhk1JJV6bJB9UBuTyNpP/CF4RsWL6N/440JditJwiCrJzH8/PghSmEfkXvQHgikGHodB
	 sdJMuBCezmlauV6gBb8cpx7KU/CJd6Cuu4P6UW910uXzQcBfbVJAManp0eCzUsBwHUMhq
	 MXF4H7VYS73oM+qmkiM8NWRCUk/6f805SjpRT9caqPFjSAQTMAkHYxfpIhB1qGrcEYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
	b=1KdpNKWNn9my/zuj+xuea2RwZ6IULWJzIBzvTnPDV6aURIiHa4Gjg242zYftF5HRvnOb
	 +d3/2fOTpOm2TcX/Hyi63p5frVfG/p6gjiwajunKqt540Sh3jBlzxY1LhXYfVr+9TUV8C
	 pHd4BGB28KdSJ2PqPcKm1o1yornRnVJQC9JIKWTFKuP4pmy0EgnsPl+Hs8uiVRRWixc9V
	 TRpzFQV8syVfuFWYM7FVwVuZFxx+JtK5AELSYTIf0prrLo5ZLBiQE5+LaAyYOf3fj9nBL
	 oqie7SUGPwGWSDAHudXofUErZRoUSkZFm2TkuYMQFneHwmwlKWUB/0/Um79ilxRCb0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3jIIAKb;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04CF606A336
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A04CF606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3jIIAKb
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb61185057so16924885e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864399; x=1795469199; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=y3jIIAKbbbSqQMJBSkJHyd7OrigIp9VoXLj5TrsVjC1P5SJK1+6GfH/CwfjSUDChdp
         aSUwKzVMSzcpqSu+dYj881QSy5uTr/mR1OuilOAa2PvT9ykPWZFupXWFXDJUWg+Evv7+
         YMfIN375w4C+9j10ZwuEeWRYPJesN+qvcukrs197w5O55lUuxshj1qTYZTKsY4pTkB8q
         AmWVhst/9ZLMgOWXi9rzj5DYH6Nkhc6djSlUphB9PtYcVDNyHJItRCJ/2xhCROn2FZJc
         u07Cqgc9tSSpuyxqc+gXNYk6FMS5PVUI7wsv9LBks2s6FQbonvj25Ul9GhnE9u2M+hED
         rhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864399; x=1795469199;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=110hARU+zfnQ0fygP15hJoAt+YF+II0F9mrkxi7LQNFxKkxzjpiLwhFHgDg5DfjlXY
         ZEsE9AraaP+BDubUTSxbeP7Ozt2ZzbMbILAZVGscvR+RvFHHa7nsaNddJjuhO/Gm/PeJ
         HIXx6S96qSZo6UilDIOtTyAwOnR1vzkbFgfHe0+JRLw35zCPTe/ZvWqA7x6xGy9encYV
         0zcOVZtn+dq8SSxyVZqkHdEqs1pxCIlldOQnOJCjFvgU4KHJ/WPdx85GHNKYjOqdGBGo
         3ut5Q5LiyIvRjiAurLciRf4bNDZNEU2iR2IOvBV8BhmobQbBlttwyHv9jT2mh2b1DWWP
         9OCQ==
X-Forwarded-Encrypted: i=1; AL+hErGqKmQXBhqmxljrl4yia57hpyRRZVm1yi8/lhCHAVJJ+wsdp0ATmavaQSn7fnZoIuw4rCZb+mPGncXs@vger.kernel.org
X-Gm-Message-State: APuU4Z88khObvqjWry6lbl860vvCsStoW+5aN75Lk9cdJ3vUy9FGhIvD
	N4SARjryxLgNK/Xj0B+KVGsj+CkBrTL/wjdGdM+jYOM6hy5mh51IyNEp
X-Gm-Gg: AYBFou1VM7sMtXyPxg3kWjonRyF5GzjuQl+uTckjgiNzUeoK/Rk5k/u0vrFNTxzo405
	q26WNzEg3Ed+uaCj9WxSH+FQ7pNUiwa9cPVl8kKIiI4YYgt2rvnPnyTd7UHuxDn4vI2rPtqzLws
	hU9h7KVofxrfjWtrqjZTSODAc9bLEbQVaICVUkdaOH3sS0V8IPFz3ih8e7joGZq2IjpvHrVqXtk
	tEQzk4cGXfJe0JBmfNfvsSLQs+t9EWSEtwrrO+0e54cdV/13uNBk11tOXZJM6GZebyOqknJFKxI
	E8o+KhWBBX8EchCO9UOsGD5tbGo0NOtKpeaTvlOqaspXGRSidQBd52m5Y0XCBnesBTMlHyns+sl
	QvG9fJUWnteLSR5Usinr2fsYqlUSAcKx5hijorx2qdPg35VU1iV1R9KJrVKBpzwe5abKiKkxw/B
	H7bpkUEe/WLUD6v4VezBkkGRHV9glgSoMn4ev2hyMDSrPGCL1vmihSvHaVV8qyfuGshkZRTfgAz
	+oErRZrXPRxOXrx2cLpEOM11ues5xNU3shKZr/a2Gs3GCusg4n8ZqYBxDMmpVdbzYoUbbYN4GXZ
	QC8Sbz1soTD3L9WL+wZk3opuVNi4HbBLu2L+LFDx
X-Received: by 2002:a05:600c:3509:b0:4b4:262b:88a2 with SMTP id 5b1f17b1804b1-4bb559f3633mr229913355e9.1.1794864399079;
        Mon, 16 Nov 2026 13:26:39 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:26:38 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:17 +0000
Subject: [PATCH v2 01/16] dt-bindings: interrupt-controller: qcom,pdc:
 Document Halliday PDC
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
Message-Id: <20261116-halliday-dts-v2-1-2c92438c6c46@gmail.com>
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
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=910;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=TIEe9N/cyAzKgpuoZBtDZhrBfZnBIMsVZBId/jMf7sU=;
 b=dpF7p0w+OJpIxiGvX34+YlsXwN/di/jZgfYFaXfY2LGvx7anrS9naa9DX6XaW0R3KAm0CLz0p
 0yoxibSkrgQC5/lkQjgDmvTXyvnDrKaMbIZimtpZ/81OcVIj7o3EQjp
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Power Domain Controller on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index 8401d3b48e0f..cf20041e86c8 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -28,6 +28,7 @@ properties:
       - enum:
           - qcom,eliza-pdc
           - qcom,glymur-pdc
+          - qcom,halliday-pdc
           - qcom,hawi-pdc
           - qcom,kaanapali-pdc
           - qcom,kuno-pdc

-- 
2.55.0

