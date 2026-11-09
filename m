Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184455;
	b=ZHxJOog3UAGZbQzjlGehCui6Na5zRcm7rVB+4HbBCcAj2XDNdcheHMn5+Cjr7MjjFLv6
	 Pyc/AvFEnNfiMLcxCuSjJQWUOEBdgrlc7ziO9qTJLE3hTBh4cKHgLM4gLaF9KYgysW1MS
	 QwGM/amTwC3COBAUxrVAiyH6hqSSyoY7kl2dmYM3xHioPMWsbsJaHp3JnBB4FYzVzh7us
	 6sSfhusmRi9/jH15992sug36TfNqPX/Z+F2zclRIByRxXJ550HoIq3f3jcochJGGPGVsJ
	 kugyFlOLhcM9lO+NUpZP2emkvd0P9uhY034zA2wzw5c+F/kSLD8qoDMA1ZluQrKj1Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=b3VvGqgW7w89m51V5OtlQCJq1vHDswwHimQMB9pEHTM=;
	b=4GvzxkzDYx5szTbFtHbG4yrED22Qtla2AD/xeePBoYvg8UAQxgrF+3FbYxPXUXX56h3K
	 Q16GbzlIR3hfV1I4Fl2QpmVaUa8okafnfFawFLJbQzxZ5msGVFC2iLDYl/5qaGQ3Y8lmd
	 tcx4U4tFFW/y4RVqTQ/TGOpBJm6nBIzVwjozVyxEVj18Q79PRU6WsNn+5GjJrZBvU6ZAh
	 DKdbXnhq5dAd6BMjrNRL+NGI2X6J421QCvFGY/ZavYGdrbSt0ePFC4dbH7Chrx7vxyy6e
	 8Z3p3NMOrpBrE9TJ2yaCylkcs1oijhFEpvEK/5+JErEbl3GVl/xkPYbbQjuhPaGycmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjJzEiWq;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0676082BDF
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A0676082BDF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjJzEiWq
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-490a0e72588so164360f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184434; x=1794789234; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b3VvGqgW7w89m51V5OtlQCJq1vHDswwHimQMB9pEHTM=;
        b=EjJzEiWqX7bP8p2RpKx0A8Mw4VIgcyhMxrNGNGYks9jT5K7ErZactzYCM9t6cwd4kq
         HaawBIqhzJIoLY4VKt7M7axDUH3ltzAQECL2DA4uwdXfdrRmzhjFbqCwUEKRsgMmA3OT
         yUx4/q4gfrM7qxWKUVkUiMy+1fv7O8bhhnA2B0BUCSLouXNRGcMKyshx7XYeRBPj5cMQ
         wqd9SPL1tAWpz/KhUuAGxUxS4NdfwwA1C8dkrWO405Sx1TUg/iTb9/AsEtLF0Uiqhn/2
         2FoNSTstnuusd6jY9eQoW6qa0bQaccSOIzfX/PXknfF9DEqb996bbOcC6TQtKxYLJM+a
         m8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184434; x=1794789234;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b3VvGqgW7w89m51V5OtlQCJq1vHDswwHimQMB9pEHTM=;
        b=soTeyhUdeVqJCX5Ta+axY9K+yRytqjnXqosY+dyU+iiu+l2HUqt1qwKyMi8UHrbAOG
         IdVhhExCei8wRkeVdn+zjUz27JHGaqDph1jKFsbz6LFguF4pFlVwBhWmiIXPVJEpxPvf
         MFmP4BCu5JuHfs376Sd6kYXv7Ln6mfa8BZhQkBLI80cdwQ+HmiWAdn15s6lc5hVZKw+8
         sfUYsgwx5PanWP6IfaF5HK1RuSxTkQ+/p0Md1THWFefkiscbaLgj9aOL1OAcFVV9gg66
         4Old766L8lYCtiTjyOucgb32M+01G5D3ovTs35IRMCLioUdbU8XLCuovTcOqzMHo2hrX
         8E+A==
X-Forwarded-Encrypted: i=1; AL+hErEIyJFdiTtixybphUpzuwTrwnqDDJEUKQEuT4577HjOVYdtbAhMH74Nq5L/XCGvMFa7+/jbT6AkiDzt@vger.kernel.org
X-Gm-Message-State: APuU4Z+OBjOO0v32FYgC2y+1hR+Jjp8+eZ82J+EsbqPJwfVzGdi6F9Hf
	ySSybcR0EQGa25n8k0WfwIFsR9snbHrDuM1o18tZRecXLAXK9tuM/S6nCewgneJW9mk=
X-Gm-Gg: AYBFou1sMbnvCWg2aanR7iyMQhQwLF07Qb26lDN3ttn0JCLnN7zDRpEusm/i/Q5Ue00
	kVdYDZdVmjAHlbRueSQY9ztiYPOqQqWOsT49sPv3NH9lD701PIrSi4QJVvb+R5vROMw7OgCt+yy
	z1nifdDX7V2Naf/HqYVq6f+9n2uWjiRFYNU39qwGjqmC3ddddsR6yCUzhDNhROGtBlmkCQ+MWU4
	dUhuzIfZk6vJ96+qio85l+jwX6umpx22VAcKg9nu6ZY2M+vMEguBZ22FkgD0HDXKrD4P3Jb88M2
	pPIcyhgg+pTKQN8wpOAd41i8bfnoX9zwwY9WgjED1nJsbr7snxeKlWux6l67sNT43ps0T6Lf8bp
	zZtsqDuHfpmRjp7pI6sPmnPBcDNvXbxmymRlNpB2TIj8qZn+k3gAFCW17jsEB8NksN1Vlk/zRvj
	EVa+jSGcNvblOWGIcYHbI7FdToTTpoPL8uA8VQZahh4BVcBUh69WdniICL6TXM9L0ahjruqAL3B
	dg7BdGHyynVdu1aZOx5R97PgPWiljB2YTmorZgmXqGTMJnfagMxDslKPgOvh6/taeCyLFP1PqJ0
	uRjDYt+Fbz5Uh9vYzJAKYilO/GqfmspxAX5jpBawxw==
X-Received: by 2002:a05:6000:186c:b0:493:2eb8:e7fb with SMTP id ffacd0b85a97d-495856e15f7mr5379354f8f.41.1794184434351;
        Sun, 08 Nov 2026 16:33:54 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:53 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:18 +0000
Subject: [PATCH 06/17] dt-bindings: arm-smmu: Add Halliday SMMU
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
Message-Id: <20261109-halliday-dts-v1-6-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1112;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=ePrzoruUVeLDRq3OCS+DiCl1d/Uk3kZuK6w1BATsFKY=;
 b=pH81WehGSEFzi7T7LS+ShwXYAfu5lsev7imaA1JaeNifItRSFvMkK3a/y3Fr2K8IwuXgQfeAv
 1F1xnpR5tNxDdiiDmSxt0TVIqWh9HxtwfbMTz8uhxpsozlK3LlCAs7D
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SMMU-500 on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/iommu/arm,smmu.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
index 6748351c7812..925afa8cca8d 100644
--- a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
+++ b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
@@ -37,6 +37,7 @@ properties:
           - enum:
               - qcom,eliza-smmu-500
               - qcom,glymur-smmu-500
+              - qcom,halliday-smmu-500
               - qcom,hawi-smmu-500
               - qcom,ipq9650-smmu-500
               - qcom,kaanapali-smmu-500
@@ -629,6 +630,7 @@ allOf:
             - enum:
                 - qcom,eliza-smmu-500
                 - qcom,glymur-smmu-500
+                - qcom,halliday-smmu-500
                 - qcom,hawi-smmu-500
                 - qcom,ipq9650-smmu-500
                 - qcom,kaanapali-smmu-500

-- 
2.55.0

