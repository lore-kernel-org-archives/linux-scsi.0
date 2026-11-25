Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578254;
	b=zYUd18eg+6Aw1RU4M4AKd/MAcTWqnDv+/0iTiFDNwki84P3FDTF82IYB1MGhqFAuCHvb
	 17DEoffjlCUptvxwFbDdSCA/eZ7A+oBFzeUIdowLEVp3T1fo0bPeJq8S6gKkMPY+E9S+i
	 bAWS/r/YjmHmAakWUU+JA7u2K9daj7Zo4VWxmsnT+xATlqbOD3sOqTooaraYsCv7MBYvK
	 cIWJ3YvVnee7lBb7RyMRCKlIUkru2u+ASh/JjT7h87eZiqJDWQC+Jd6Xzs/ZtbSQSC6hB
	 C+33XJOn3GnXLEcSp/sHcwzEwMhjG1prTi9g9ofkCz4q5RM/YWKY3AKqCYnzXoQBOVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=0gMkbbLOot3bX7ZvRSJsql+Zsoh4W/ttXNIHMpReErE=;
	b=gIJIOCzbDfYqC2osArQqJZ/TcbpcEbNFyQB8+YRuxsBx4Jl8Q8vx+GZ1w7RA3YGlT/eR
	 OQETonA8ghu6bnuw1q6TcKFOj22+R9MLUCI7QsNs2mSniJPmg7cqS5G/7ICQqJ+nFFTGD
	 0Ct+5h1FQyPVeAORodK3br/GPfCYsMew3vFpLE21H44Pl/KpFhwMAjM2E4JEPtgDWUupX
	 2Ond2TBBqN0g98A5rI8JwIDBFJGC035vZ4nF8LmC4UVOssajkNXlt+7igPJuwAQGjpSe0
	 aBxNOOXiz5yuti4ivLk/Pm7fu+up9A61E0Y1o5GqRJ2DupDNbiXhb9RU0zTriPsP+bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lEdBuKcF;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB864606A33A
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB864606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lEdBuKcF
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so51567435e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578252; x=1796183052; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0gMkbbLOot3bX7ZvRSJsql+Zsoh4W/ttXNIHMpReErE=;
        b=lEdBuKcF0JncIpcutUemWRCVLwcBptVk45nftYoXdUPaaPEMjOXhRvlDgUBMqszRSi
         GjVW7ES9OlK67a/2KLB5I65GkIV14Ylzo/LfhicqUla0tHCcqXUHFVnVhyXZGsWk1GYi
         30KWFrA88HI/8R90LcNab9RdDuPnarcq6aW8IuA8Dbg3UasrVz81iXsAmAz52FFpSxkl
         kwCNrdjoDvsHBIUIV7L7pGx49IZu2fqgEP7oIu858HUHqjSUGsKRfpJS4Xm/DgASvkCY
         ohconOG9BXS7zsTTxG601/wjTYdl90IpxPDLaEEQRmhw8dfhpInmpWHAFkRnignmsUL1
         jNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578252; x=1796183052;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0gMkbbLOot3bX7ZvRSJsql+Zsoh4W/ttXNIHMpReErE=;
        b=h/8UnT8ctS+kvpBcxUa7ik3jVjN5FTS+ivGS0w1Rs6+jM2MfCFGY2sC3h33gnW4tDT
         xMXxOnY7e95UfHe1rk7zjDFWa/t30MDXf+AwE6TGlF52C4im/GCA33CGS5v/htEcZwGU
         loDy9bnkNJwtnD6UfzoR1/m8Si+aw7uZjsndbOaLaJB01SpeTAY9O6y4J5uRQH/G4nXs
         X9qsJDekdlSp8eiChc+z5x/mmBc9fRY7HDLScpuphCmbUEv/JlaoqDMzsyKF1SnxZGXs
         nqP03ygds/j08KppPR/5OQOrYTIARTyQCkx+TacE7nWuY8D5YwkYwitIywieCz3COr8H
         u0qw==
X-Forwarded-Encrypted: i=1; AL+hErGaMaKGpNWHbmwD//gvzm9D5xl4eP3nqu41lrIzh0Dc/sIbff7J1ixueuLnummE0H39SWvkDiWjWZSL@vger.kernel.org
X-Gm-Message-State: APuU4Z9MVfFRkBWluptYwqQHG9DG6dVdW81E+zewovEI2ayKuuy/zJDe
	svvet9QV90yayHu6KNlAO/4kXlp7IOPGXxdf0UPLMwDhtefc1JORjM/5
X-Gm-Gg: AZFdTZcCg6T/I7MbI+XQz6xBCC9LLiNEjTLugM6hK8fg9+YHIWqguCcOTJ/E9qxRuwe
	4ODBpaqpVbqkE6ZJC6KGYpvhCuFHklgCZjt52T3W+lBv4c/b43pgKg1mBMQ9ezE5Rh+7cZJV5ri
	Yr9D05SBBCZxYg9mQto6L9TPlO6uSATfeU/doJgquEezjIg3KLS+UtXGeF9e9LExeug0GAuqT3p
	BBg6neM0VGRe71NX8Ne5xlgHf9uGBoJObNAzAy/8DiF1jRhc3VPbltx168EEkBIKf6e/lBrZ+KI
	oti9xeB6Ta0XmQeSecWHyZyHwOq2vmsZsh1fdwP1EigcnoraDdhKQshyY2DnlhWINDs0YDHP4jV
	Vw61PI+lOtsM/rz/KGjWEiF+Ub9IPJFoDpVf5jfBV3rVEepY+9wSNXVRR/f7kaJYL2C8k2jPqDS
	Wt72R9H2SXpKbeFdrOJRbTEVDSToFi0Bl5J7Wnj52KIQN3jdrLZ0eREDYdlFqnahTfPOAxmJ8Bs
	XLFq3Bv+Qd8qZMYk32E4NEC76+FIIRzdXozA/8ni53JSQZdfCVngT9SYPsa3KM3SuJqjuojHa42
	NPfRYnt85r/S8CqfhFvR7xHQwnR5XS6tdEaaYA7iuBV+VNmZa58Nsnv3SJw=
X-Received: by 2002:a05:600c:3b84:b0:4bb:6f45:2a6d with SMTP id 5b1f17b1804b1-4bb888074bbmr399963545e9.12.1795578252392;
        Tue, 24 Nov 2026 19:44:12 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:10 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:04 +0000
Subject: [PATCH v3 08/14] dt-bindings: crypto: qcom,inline-crypto-engine:
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
Message-Id: <20261125-halliday-dts-v3-8-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=991;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iODhhsd3yfvGtcciUvxgx8qkDXgsEtkBlczLh6ZRfrQ=;
 b=lvcDevXHoUjfOVIKmGcAADmxVZULBy9zMoHqx2H32a0E3wUM2ikLAFlGNM8+8Y16B1yXdXwzE
 0y99BcDJDu0At3F9ibFbmmvIZEbRo82dQ3K+iKDoR8DVQfXtRsOln6S
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Inline Crypto Engine on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
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

