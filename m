Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184481;
	b=tp12AYyW0sp1ToYz+yv6giWaYmiBQk+wJ2uh70Kh+I0DuH+0oTWvyTQ8AIUTyvGNDj1D
	 cTwqZD6NoMYuRlR0C2A+c6Up8WLjY+vey9zEKv5cSsqf8qIQi2f/NZ7m9UU2mYfHZ5E64
	 SHFVJUU5D2SUmA63RhjkNU3C8jjYX9kW+bgRSD4w7QSTyz48t1WAwNl1rmY1yBdh95xsd
	 +smavbiooFwMWQnNLOJwmEIfoJEOvHm84XEmEXIYFIwtfgJ36PzpfLHy00pIfaxweVyTm
	 cDeuo2JyOfYhU/vFmS46QJaqInF+Gh9CXhoGDjK1AG7VKLpOs35FJXUbBEF3hNGeIPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
	b=Mv4Ld4t5E9zcxVHhWyqmqh19nhH2SZRXIFDrBF0VO9u9UOrT9jGC/2UhuQ4BpFs1M3aP
	 jqzaSP6hl5ZFFvPtkPM41KexDkcu40fBugTfjGHH5HgjdRMD+nCXH/tYQmB+lEhFqQlLR
	 6Bn2+M2fc4c/FjwsHdNxFLCTHg3BtcK8VxCrkjIwupjzOAj4eJH/t+Jtn4Rz2BH2CG2Xp
	 gVKQ/ncJ+4SfPWLiTjoK1PfxXslVIx3FwB3kTVEm/OubAkmOx28rzGfCnfxbEWTirpMyE
	 uNOEIPrf/C1fq6Vhj70pVG+mdSCHTUK7W5qWY7IoqG17K9vvB2lHFS/Ix2UtwKHN82A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IVXS0Dfp;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0455606D822
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0455606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IVXS0Dfp
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-49465892f7bso241839f8f.1
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184479; x=1794789279; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=IVXS0DfpUIsNMmmlCVLQc/sr3m1dEoc2PxYn9Q1ZBDZgge7WUtw+jdTyqhCup5beuX
         p5UkKtqsdQor407ZN5+sThyv2nEYmcDa0uUa+CnKgMYC7zlI6qui62evwV2DL9VYinBy
         BarYqmMFrc3QEZTIlC8ssJP3XT4AbNHEFJZW9AzKMaUXkbZAhWMFSvOd7SRW3KD8cBll
         drhaytrMXaHy1ToVY72wpbCvSuNZPazRJo4cICaGRiht28G8IVeEueDOvEoNfrZLf8pw
         YGCplgziHwLWFFjwnfizo2aTCI9Yr266yhB2sLiV1K7bPAt2DOuj7ztQV7B0vgLaulZy
         apqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184479; x=1794789279;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=w9FUBBkqTWuzTDD2ZYdoxxI00eoFxxza02rFM1BGyNufkdsvPLCmzuvJtrhFJxYO3X
         I6+/7dCM0U+ofQUomACqtnqHqdrhzSdwwzQtyCalgquhHRmQ/m1hGRVgV+DO0+nxaram
         JCSrMCHPyKjmr16zRIVJB/CiaKTB1UqsW9sXElf2rEhq2bpi0H2Lx4SSJwJ5BNjEGEUM
         kaNfaggAibFT+VwnlQQlHoGW3ucA1lFAeL4Yu+blC52z3yP0l/KQkbvnMu0sY3ib5ndM
         FYKWCMhBTTTVyYHcjBwbwkSmO9DshGaOaOH0vI/Xxxi+V8Z+XV4zo3ifttRDkOsw35ym
         7J6g==
X-Forwarded-Encrypted: i=1; AL+hErHFhrFgRdhz5ZYyPYhHG668DEPzk4TDxgepFTiLnLfp3ukN/8OkWcObP5fanxrjGZnOL/zd24+depPD@vger.kernel.org
X-Gm-Message-State: APuU4Z8Fbtczq9jviHyeOZpawqr9VHauI2Q//XA6+El9rcziJzV1uGCp
	0q072l9ohVPO1Gnd9tljgu4I4Ud4S/tZ3IAr5nfQGozs1GRl7u5q49PTI+dREWrjnik=
X-Gm-Gg: AYBFou214RGi68iBEZl9GFZXhUEo/epVcRLYIiNf7hkuf+7740ujfJn/CTb4Qu+HLUb
	teRv3XpUTkOiAkewANC4S5eaFBjaWktTERDIXOsAy4zpP+ddVkq4ATO4LqIP578b0hTl8GE5h85
	RLq+7ZxeRaPt60g0wuWAuiO9bTHiT2XNH1bgLr+PjhOPkhkXrn/1/ub0LWNPBnnmKpZKf1Qo6ny
	4pxqD/CB1122HGt0p+xwjMSoQEaCNtSM83JRVBDV4dR9uINXEeHDojutK74Kk83tHCH4Ogsy6ti
	KNU/zBNSpKujq2nvgJSM7ak6qsuhJskSX4urc88Xh6lkutykArQUH3ZxdzAvtp/1Tg1Y4vmLjZP
	zBv+1KqB/zSC+8M/dk3wjD3nnVehAzd+ZT/le+5eKOFv75Jbyfb2sKKYa910X6u+DORhyxPIFOS
	fl3Z1X+Gsiv/cnB/RpVdzJDmqjgIW3hlQC4goHeVK7RbYjKgA8aYbMSHOWJnugxWkI9t2qlEIcO
	uWkFOL+z+pl8KaZX97fja1dOlziAXxMKXY+lW06hi9jZu1VzjbJBRBLayCl1Nne2mCCcNpWLj+9
	QImhyOU58CEfq1VFapWylRTBsFUKZpWsVeKgiNTK
X-Received: by 2002:a5d:6f0f:0:b0:48e:679a:4aeb with SMTP id ffacd0b85a97d-49586a3c015mr4911501f8f.3.1794184479389;
        Sun, 08 Nov 2026 16:34:39 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:25 +0000
Subject: [PATCH 13/17] dt-bindings: thermal: qcom-tsens: Document the
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
Message-Id: <20261109-halliday-dts-v1-13-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=829;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=QaX1Uqhi9JFBTyniSmrOqgkrx65fb+cn/pSnBpltl3Q=;
 b=Nal1T+ROAiQwIycyxEfKMIQ4y4aGW1L0uJ4HewmCRmGIZfSJuQVD6Fg2qPRcOrHnEpA/WiD2I
 u4aa5TB+J3JDBwhP4O82nlPD61zqIxNlRPMGwQQVcuKGnMJPv1tp6Q6
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

