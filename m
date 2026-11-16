Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864441;
	b=n75P1wEZHuztJlcBUAm5SLfmichmhILx4PwuCbpx1TNOXS8lUxG6VXSuIaKHHGVfqLd0
	 Tws1aTnj7cquaUyqN9Q0jP1iF/5t2x4C0GEfwbVm1JhPIHRSPVP4r17vvrhVLGrmrWe7b
	 f2nnQh4ToqJSAkWomjfxOJtGphIQcb6hlmDfFuGNDSUIf453ixE2IGnsrpDgEsL9UW6GP
	 QYGHGYu25k8NUQEoIvSR+LHIgD8r0Pbu1DWkSrz01XRQsEQ++o9wVj1hts7Ub64vQ1+3u
	 X++b+E8In+jsMcrtwHU1hThrZwMhV0vnSXNStFAVJXVw/YdI1birP18p2IN84Yr7LtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864441;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
	b=1qkOY8jFqmqUjbKiWOJ8rKl3gZi3b0baFAa6ahTVuZWcOpgBe81mVZ0VUKBT0SW9KPdi
	 LTpOBNrpnAKhA8HjfyVysB5kDazKc0uGjU1hOAOyhRo4idNZE7Ee1b02dz5h4wFhI20P9
	 QohBrJYRwa5u2YasTHdmiGdoM2E+S02CeEHKPo0YwBULxHo9lYwguZb83OqpYiNbb8XrH
	 4LiOhEFGB1upU5t2PH3t9I7IDsTBXWhb4AxSItDE3GYqEkyIPsg3AWNYkm5D950JBMwjR
	 gKlTXdSdf9yB5oWt/D6ZzdUM5fMeESP7AhjwR4hIrUiGPhvtNqyfP7Ogsrvxp81OnXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AG9pfL7W;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0663606A332
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0663606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AG9pfL7W
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso27635735e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864439; x=1795469239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
        b=AG9pfL7Wd/r6/98cIDo+nVLfIVZ9Px+zjsXE5kwL5C5mXq0vvRxtAzXqCOjP57c76/
         QDAdB73QojRTusWajXwvXLflOajjTrRtPUzzN2iBmylVD9h5CuWtCva4RFTGQ3WAXdqj
         QUPHfhV8R3R6+D57fWZz5PoRdD7Zh4aEwbeRy6IRy5hp3spzPFQuezFUatlivFZZIhX7
         UvyPXGEihmkcLMT0slqp/7SwQoAyDHmifQcdngvOwon8ytHUPr4DHYsG+dXREzWIOZZf
         o6twMtZmZHhO517aRhzfH+NpS/QusUvv1lm6Ilz7LGycETpzHg6Fbdmdyo/hrzPzp1uj
         QbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864439; x=1795469239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
        b=XBXSwkF45bl9+0tfl1WzpwEWfWc4Zk6Ve4sHgC7lfqawq3YLOwBHmXPnGrhw3UF5gl
         +IJzIdjWMha+YGeqkiVA0YGa2upDMxNdzIgUcDF+MIHzhFiCRXvp5vw9SKnmx4VgUX55
         f+1YoF/a9vhyJZCwjiLIGHVh5hDFhBIgIv/R4iyjpRZpIZlgaob5xIsrI0QX7GSmsPwZ
         RffrZml2eDC/hdpr4Vm740Zmvekcy6t0oCWt/QMh2ikav613+0Xb2f4MyF+io9PS52oB
         s7Ck8hNkaXXj0tgNcfTVAHnQTVwLzf4NDLtDC6RWI9b66ccACIpC0bhxh7SzrP5kExME
         2BLg==
X-Forwarded-Encrypted: i=1; AL+hErGNRX4eARfLhuLWAgMpBRrO+YUJkicR0CUNSL1JlGZ5rocw3k3y/fNN9mckS9H3EtxhRXYIS0y/mR0E@vger.kernel.org
X-Gm-Message-State: APuU4Z9xrUog+2r7sSVzZ1SF4AISp0Td54tD1EmZyC6+e9mcOaClpigO
	92V8xUqtVyJYE+atZBKaI03UGMFhn1tJcmU7E+DE37C9DPhUV2j3lrPj
X-Gm-Gg: AYBFou2aIZE58XK3utlSofykjcSP55lCryVyZ9oIuOTswzr724wfDp1WzD1zCX2lJx0
	v8VZfSKp0mGRq0EKU1nTeXgpvFfStUg7M3kWxDMve5v7vjZoK3C1oSNnB6cUzZ6p8/6kHUGWvhS
	GA/AsJ7ZK0mPazYiEhLbAIoZTaO/jRghatpTSPk38MM9tNAh7CiEH9o8hFuSkAMNBMgHbk/L8LH
	SgyHbo2LahvyCBJi5JuxPOwlbrFJjuxYPOKnsgksKY4+brUQYrzlTU27FKxsXYpntiNchYhbuzM
	ZjAPYtNAt2JkUYzketB9agxC/v2hl7dBu7nqqnXc+v3XyyeCD7DNmes3liJu4S5k68cebF8lD5p
	2FMUxFj4f4+8EOqFz7EgunY0GXXGPYM1yXcJJiy8+8E3O9WVksZBiHBFf2T0HGyTazg5IpgTBT2
	ocT0QDuuQfPh7CoCyKOI2mdMs3lFpPmHtNr6/W+mqwweOxHt4Y4ELPYXXJ+/RvPtdJzTK+bpery
	T1ApsQhriTbuwGTINFaB6rp9VB7RyD57yKnbk7KhrI+tND0yhbJ065YWMwZ3uPO1b/hXZTbENS/
	rjjFWK94MT32XyoOYD2bXW9skvk/kNFTFy2oEKbh
X-Received: by 2002:a05:600c:3487:b0:4a2:526b:d410 with SMTP id 5b1f17b1804b1-4bb55a4f1b4mr255653315e9.13.1794864439353;
        Mon, 16 Nov 2026 13:27:19 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:18 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:23 +0000
Subject: [PATCH v2 07/16] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
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
Message-Id: <20261116-halliday-dts-v2-7-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=993;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=Os3dtyGi4Umq8bQ7AEz34h0NK9e+Ws6GY42XJz6qujA=;
 b=JAnPagjMpge0X10XiR/LbxFcl9vIwvXlY8rdMR3b7TnG2zjS5Ef/3pOUFBSYZcopY2HJ+t+/s
 qtEtnXV/IW3BvhWLgk5yEo8YJikc5cpwNQrDqesXNsRHoPh2k6l5Th3
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the QMP UFS PHY on the Qualcomm Halliday SoC, which is
compatible with the SM8450 one.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 10435a0b5230..a42bba9b550d 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -28,6 +28,10 @@ properties:
           - enum:
               - qcom,qcs615-qmp-ufs-phy
           - const: qcom,sm6115-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,halliday-qmp-ufs-phy
+          - const: qcom,sm8450-qmp-ufs-phy
       - items:
           - enum:
               - qcom,x1e80100-qmp-ufs-phy

-- 
2.55.0

