Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864458;
	b=Xy+EzwqXnXzJrpYsCVMzPDvTw7wFUUnfL6r4yi7VfJQzPVmZ0/RUTX1tfFHQQ6eDLEL5
	 QL6r8wpnkZYoj3qXWMLtYEbVDgM4Yn9SXTkEMDB2vhyycgBJ6E8C4/eZvKgKPPCeKsaH4
	 kUa1b1NVoKDRE6ophhD5lMESakKwQ6+9+U7Ny/1g4MmQSUu0lnd5O6Xm2RMxKTVYTCEX3
	 F2m4LlQpCmubQONfr8f6ozkywE/xpG4REKEm3ya+yEv3etoudLuM67YVhW7KwXqnoLo2a
	 0iFeG0M+8g6ngPZpadn9KYrzT51gMUvWLlz8gE/33CvXg5wh73yU46Owrt6wep9r9Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864458;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
	b=IBfGLX/9CFd4LJXWDTlq03u73VEpoob1Cuaq7/1RJGQH2RZt77dWTz+JH4PGmRNM4kdK
	 ZPYuCER+rkaw5Rw942PdvXnue8RUdvm3c0+bb2sLQxxKSSDfy/HAVqZOje3M4zdcoCZ/4
	 /MkTzjZh1V9HS05959qAw7v/YsWLoVx467bjegLh1v46IYbQPsITyLjqc2/7wsK3Z8odC
	 5eQewvMjl+VW0HgMqqt3cSRMvgsWueRoqqhu17ydvReFYAKrQMRa11gEO2bkMuxUu24nY
	 FEOPlwPzUOWrX0NtgGBaLP01TVjNzxNA82Z7kcoMFNoUPO1uaQf8RM6AkM6BvOJl8PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aEwrHomr;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76002606A333
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76002606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aEwrHomr
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso4246279f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864456; x=1795469256; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=aEwrHomrXoLkAiILddo3V8DFgxCuIXh9nv9z9CGp99Mvv9q7rqS8WWfJjEVZyPKHzl
         BJcrzkqstHqVy4gz1/y4oTWYkRx+2g14yun07x+dBnVAXWbxJ6Pi8XR06lfkxtBvqCY9
         iLfFme7fheT+0AavzMAdfuk0LNIbBb4A/fuWyckPSLx8IQoPwrMmA2E7Ut++Patm8fWZ
         5Z3yyawCVkfdeHckJNnYoaWNHRgUbs68NL4nZXkxamHwG2zmOimO4uoTqxyi0KJ8H74v
         KgRMh5LPcsoko2D3/7aPeGtRlw0wksD9UiL+6PyQMe8GGRsHDiMrNoZmXU6ZdSAHjYHb
         hHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864456; x=1795469256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=2qRaLW3MoWRgpF49b82u0/pkTwIXZjZ2rreXgQ8nyC4sATLo7de0uQX8JNUIlW/wtr
         JX526KiIqUYTZmghNnHqACCS7X7cLSoqANagHd+EfpAB/b3sYBo608ASZQGhHstQGNim
         p83VgLLIv/IPSLlCBMXvkSusg/h0bEST8QxQZjUvqe7QFJ7N5zHDtfd8fN9v6yejyIV+
         cdTd6iOvOsuqNzi6QUeAV16cduKHov5HdyvwbFbjL6LlpdU1SfnetxzYPAGE5O3nT9Co
         nY97U7DTAQsI2d6+dKHUQJ2B5dsl7Q7fP1AcZNWkYFKlKwbEvfVcBGGsXw79VgN5bHp5
         XdzQ==
X-Forwarded-Encrypted: i=1; AL+hErFflIzLyJahfhN6Z8GMrntKE5JLBsr8Wdxf3uJuFbOchMcmfKMiBcFKi/BFg8qfhn5IMp5236s/BqRK@vger.kernel.org
X-Gm-Message-State: APuU4Z8ly4ezwBz+2dlC+27sVxeseobmS1bZMYPfozrz+d/1mmUetgQp
	/KU0Ydyts5BK22MFEkc61iJViw21qtE52JOiNaLW2G0cBpJf/LSOA8Od
X-Gm-Gg: AZFdTZdXemJ+YBaNt+YoAhFhl1kt5lm1aHoWaKtY/KVXqA2ifzJ0NbjIBE7/7AYi6KF
	0SlzygY7VLsMfmj3ZB8vW1yXTy3ivJYHX9MYiz38wa4yYtKt1sN/9wko6k3a6Qxe8EnhNu+9SR2
	6O+AIz9o0SqZMq7TdqGbNzlEqDI4gXP4Q4vHOOS9d/SZYcZfWWjCeRJi1SnGnvPCxxY87G3G6jr
	bUXBJhDnQsslssAZ7/Ypz7oxmQ2scqb1R8O4nRhNdKqe1x1PlbRhPYIXZxITSIBLwbPevqlAQTv
	MgTbJDCNgSAmL7NWVq5Vcg13o7vDLP1J/cF5GmiJs5FmqTe4rPEh9GdGu/2PUZmaoZSVBDB77kx
	sRNZ1JqRVsdjHM5eS4IDsw/J/DYj2SmHSdDpSycMBB/y+kBntlSPPQW2uPvxe3HM/9Tba+CQpkw
	NrcHOX054HJ3/gD46n1GRnbxDmP78EfH1DlEYosMAYtxC4v5eYoGgIeOynUqRCyQUkgNRA4pS9s
	02uw/8SGiJU7cTWozqeicMSN+Fk3JDivcZK2KNykwxRSh8VP/WkmKXxd3WCFXiRefmRpuWg+nvb
	hR6NH/fWgYyeSyvOg9X+3GKphKVvdL4Jkwo2I8wR
X-Received: by 2002:a05:6000:25ee:b0:490:b23b:802d with SMTP id ffacd0b85a97d-49c71d475ddmr22315194f8f.37.1794864455894;
        Mon, 16 Nov 2026 13:27:35 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:26 +0000
Subject: [PATCH v2 10/16] dt-bindings: thermal: qcom-tsens: Document the
 Halliday Temperature Sensor
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
Message-Id: <20261116-halliday-dts-v2-10-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=829;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=QaX1Uqhi9JFBTyniSmrOqgkrx65fb+cn/pSnBpltl3Q=;
 b=9cBm/5Mi8IeF1ejOwJZWQD4SfyJ7BWDjVcE5y5kBsTodKh6u91I9h5To2Rc8ArYF4KPYJAO96
 griT0U/fTv6BDQooM53jxYIwB3vuzMj024ajCLGGuHNM9Pf4WE6Noed
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Temperature Sensor (TSENS) on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index c78074fbcecf..3b440f395fe8 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -57,6 +57,7 @@ properties:
           - enum:
               - qcom,eliza-tsens
               - qcom,glymur-tsens
+              - qcom,halliday-tsens
               - qcom,hawi-tsens
               - qcom,kaanapali-tsens
               - qcom,maili-tsens

-- 
2.55.0

