Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864446;
	b=LpTComCrk6FEhHfM8lr3TBQNfbJCeA0DAh7zN8ZAqlHjXkLuAJ51W96fxFnt3SE2wXrS
	 d2t4l9dBxS7cPDaDswtHVn/HIvOzTwuNr81e8ksAJQGtvN5TmVM8uhFexpbst5SEgTyir
	 Oe9wVnFRuzaB4ypotdpvsIFGrHPV4Fyrn2LT4H7gga44AMl1odXKZ+5JCrgCVA3dhuhF5
	 jPJKRF4tayFgls1Qwhg4lZe1Lk1Tbe055jt3kyMr5pBwKTPX5u6rj4SrAfl1LFnEW4dac
	 r0JfQe5lv4PSt0okz+bkmlBN6aXo9fO3zyAcKPXe3bLDkNB8aT0zRfoYSAL9/YLwXlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
	b=2WGqzb/R7jkenRfAfwBwrP+n3qyXLs2qZYYg4JQRMiONBZcTY37cA2BXBfQk4y8Deipa
	 RDLgdKLVbcV+HlxprbqbTHUCpmOxuMJbmUczhvVhmSd/YiBACPLJYfJUmBXZmmS4AqHE1
	 Dew27mrqc30knnRjq/nejPHv6j1hTlHup3lCRTi8DljPunOVVtZ4G0H5XIhURWaXkuIHj
	 iUpunBQDcPK67/ARdnC29J7XXdLQ4EAT71eO/xyHZKHn9rbDqWdOq8tfqzT3imdvpWH+r
	 4wKIjUQUHwhjDo1QnyHoKwLHtrFQX++NqHY6G3B7auMtA+Sj90vBgq+Qrh+SEquIiBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iWmpHX9v;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B73606A881
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73B73606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iWmpHX9v
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so43365045e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864445; x=1795469245; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=iWmpHX9vy8zy4+SpuLwYiHLB3ln3/7sZipWq17iQxZemFskLqrf+5u0LQFERvFgOg0
         YGm75sawrb5dvvPHQL1E3tnBDx/3Lj9iGKAvXpNm6bZ7XZPo570BE2i9caMiY5IKS48b
         yiBmD1KuJl1DrDWRRsqVTXAG16CMeW5eB5GXQT6VgA4c1+z5l6oZ5HSKUqabtHjZShkT
         48NHibHjglieodvDk4cQu2TecbGkn+qDMwsDpIC4OxFmZTkuOj8+6GxuMUQCtCSsIVCD
         HuGkdrxWUd2eVnv/PV05xdTNl8Q6L1L49LNERTuDgEIO5Ltu94W6gpd+G19oZ0m2OntX
         /SZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864445; x=1795469245;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=QTNE6gdLGdPp2eg+BrW6oyEk+mjeI8f7fV4+Uju+lV15HNWqXl3nhf9Rao6g6qh+jD
         JNSFJmjohbcLYqMV4/L+yRYrwcPXEJFcOGu2P5dUnvFWvO+TERT+Ois9ige5vsyza/CE
         L4LLMxHjJsSDLE2CVZsc8g6hwmBH9xVOAeTg93XCxGZVxKs1xr2dw3cZIUSVSMbJ31az
         m2q7hxanbiNVuRF7wGiuV6NR/jngplSSMaenylE7oEthn0TEJ1+C/djcvzd66ILI0WQd
         Gu+sGpB/TzrhlOcuf3Z9NMB6i4c/GaPyVLiHEWE9aWhU2aFD4yIC7+JnEQ5h4unFqkui
         dNnQ==
X-Forwarded-Encrypted: i=1; AL+hErGaQciLWl92jCVBs16/+4GWSDg9cra92ZpO6V/g++3rKpKmyvYfYxIl5DL+c3Jd1cf98LqpEh1nr1yn@vger.kernel.org
X-Gm-Message-State: APuU4Z8ZPwGottiWH7GTo6Bp79N7FWGoAjKWsDvYOUhfmhhAXGckpm3j
	RtDSd+Rl/Q4NzsKMxdAlb0SVPMabDSXFdi49qDRkIy9TfhoH/OASCDvz
X-Gm-Gg: AYBFou1vIotGgYPT4e6E1ePkQbM5BYfu7HKBacN5AtZIkEB4Ouvx6og7/uugxLSotMt
	CY0OoYGGVVoM/klItnD1G6MO2+EBDKFvNtvaFslfMfF+B2aJeb38fA7MrKRcq1jap9T2dKBmmYJ
	NsMIZWoeqNrDwCkNEyXua1suhv4B50gmT9R1h9yY+r9X90rhLihyHvZzdVwtp9P7/OcOJDWYSoN
	8U48nsDmdwH6EChPIV4dvQjv1GvdNxn8Om74m2LrCV2Ai7BljhBIMBy3NWo+ZIptzX3qqJED2Q3
	Trx92CUf2J5pcSgheDEzS/MbGs7X7ZUbs7YgElw5aRzSt9MLYdTb47qudXQMckHZV25Zv939Flx
	qkPvWa3fwCygB2HonfZeh2Kv4Hh2NuM1ic5wMeGjROHoKdJKvsVxtixLkIgRC1pZxbtYpO2iy6o
	up7796RhTz7seDTKuXDBbqBui/WUSm8o6F6izeLk6TUlmtQd4wZTHqdy+g8ljcG/ATCWn9yc5Im
	RosxK9CmW+tGHQCqBZXTiumOm08m/SQnNIVwUA1mhnv0P2u51JbH4OQ3DKJMH22SQ2SdvKXpUYw
	yXB/Y6bLRRAYW2SuHTb83/Y8S0hd3Slgg9czlNlD
X-Received: by 2002:a05:600c:6548:b0:4b0:c1ae:829 with SMTP id 5b1f17b1804b1-4bb55a8d621mr184234605e9.30.1794864444941;
        Mon, 16 Nov 2026 13:27:24 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:24 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:24 +0000
Subject: [PATCH v2 08/16] dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday
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
Message-Id: <20261116-halliday-dts-v2-8-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=1028;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=e5+pG0dDXEqC2bp77Ez+oDydvwUzWtL2BPwcLeGQJvE=;
 b=gD8xOm5xZ9FtfmXv7b9AItlwRATNEZobnHQBfav0fJLpw18USQbXaJrBNVYJ8htSmcNjmMoiY
 oIwuZK62UjeA39gKapnqrq7NNerfrM+Hz5ecpQBWUPf7UaNqv3Q7sGR
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

