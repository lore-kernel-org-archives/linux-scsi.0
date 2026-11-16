Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864435;
	b=ZdU4QFLiukwx+116kwGkRXWoXSQAFtrdOh0dky9Rxlxxd33SZfq2RNznc5ljLNb+XReK
	 HEzL67SkZPXT7pQGZjlEa0r4RbuqZoc7xAyvV2XpbknE8qHl529zALZLaVt2vVSb6MGuX
	 gSmt1t2ed3aKg/SC+vYmq9B/vtSWURFqSH1sNx0O9Ixb1CPGxtX2Jq08nPAvET/CaFi0V
	 xOfgz1tLAiOxSti5jjJHEcGMQBRaS3Smkv77ydObPSaZ4OLoh6eJf+MSyqNZTXm1g8IEq
	 vcu/TiD1f0s2sE7nNDr31BuqEo/6nE0E64lsic75RalfvXd1q/dhrKPAh3N7fTdI1Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864435;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
	b=Gz2nPZ0K0J3si7iKolTIvteFhlAxUZP3N3rbHSfjCQ50wSrbZJcKVnI5gPU8AMcUYZZz
	 O9QP4egENT+sJvWPBVCRA0QDZdPk9cgiSIi3Af+bJ9wvYW9gh8bPmJ6A2fMqqfBO/KgFv
	 T9tsRTy/3CZPqxxDS3uZa1FSLqaixn63fXHRo0pMvWK8S9mhuqk71g6H9ZcigC2jg/+JH
	 /FZ5EOV73mRY4RM76xzDxfKW8fnfri3mDne2aK1zE5RZ+HEiAGqaj6n65QsMpjpRgTfwK
	 hy0wr7zGaiCzgY3g9toDQG1n/0xKJH5Y0e8FblgjoR6M1EEVbBjy9MDVGAeAz+LWj+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P16DvILv;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E9606A32C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 21:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E5E9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P16DvILv
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4a357b1c649so215183f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864433; x=1795469233; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=P16DvILvAkJjX6pET/OY1y6yCbL6KHNvFmQ8Vc5ms2Nh4pBtOsH5swOYSMdfoItM4b
         t5MUV5RS8EsfFWLaJSSS5E70h3/UCARtpvqtPXICi2MnbVDPa95XtCUmcFtAYjMi3iD9
         sCZvL8DZRUZv/G7eI4SHBKPuYPPoNAExEKI30EQbOIauyxIQR0kIV/+D532rj4kB4ZjR
         LbaVAAYCUUzAIoRJt6nlQejAo2Qj82puHxbZwDW1Fa8tRWYcjQNNMrBV4t0c64r9Bq5k
         XxoBse3bOdVc5KRCAVJVYP/0nrxUtbAZayRyyja7hKGad0rPdK7UrkQNvPW9f3BimHA9
         xUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864433; x=1795469233;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=BbH+2Rg2rQLkUeZ0oupfpMOV3WTaEOwNbNI5VfK5N+1qXXTERJQKQwNSu7kQpInD+M
         2KvhzQGU6CPf9sygjjLQ2NJv8LB9xVfhTBRFrkYixwZrop0eDppqFDAe2Hv4t9deVeFf
         af6Dp4FrW42cprQHube4/l6M+CFmyQIa0otMctahmUuiwCNPJ4UFsLgMyS0AZBjMeOFe
         vPzPlsScNwAT3pTYXSir5aRfte++JOlMqusyllDiQcTymPUdW6XOrp6g/5FmDcAKUnPZ
         HNu6SGMOOuAMgYadIbMbG8zs0FrBXBHg6q09FjtJLFkVo10WRvnRDuVURUgMluMCDYRM
         oVMQ==
X-Forwarded-Encrypted: i=1; AL+hErHRNW8M1SrqAqcnRvSsdY7mZ2wJIeYVOvZFULuHBb7ibGnxM37ZQpO/cKRt8bgtyLjESAw4QeCLATSA@vger.kernel.org
X-Gm-Message-State: APuU4Z9mDDZfvGgzKJC34H5ll1E80FA78uOiDsiFFkrhM/o4c5lQDPc4
	p66jtl2xwVpOqvsg+6llfRW/O9vq98kghRZB7du5z8BELYejYi4n7+QH
X-Gm-Gg: AZFdTZfqghC1xtEHLcMN4EpkDgKCK17nt8WJ2Da8AtqYonsnihjWHGlHRKidYp1gGmY
	hbzLkTwInVdGv518fBzcJd5qAyTKesf802qKg5kUHN2aoNYLZcXwEnGyzUVxRHVrvve3nzPT4Dw
	67XgSyHGxUBo/vrxpdu1J68Aazyd6TsQJNsZ0cCe8xEr2vff4CeMekCYqBBvb0F0GucRSUajkLY
	SGysRR5Q7cFWlgGLSlUMRIDEXiSVWms2TOds8ArdA0zyUHyePSoor24Kn1uFg3K8gkErP7f+OH7
	V1s8GUoL1Lggldxg+yPbBPN5XJ5X1BoIyqtz2YBuj8rWC3FMGqsmFyS5Rt2kqIAx4JewB6Qu5XK
	fMWdcbAO+RTSpTJuHLywERkpLMopDdl6PWpqfI9lDA8hTsl2KaXMMtgUK3ofI70kVIB5Jh5ygoS
	X60d0k9Mzor4sLn6zYL7K17Y2VsgTnyI231A9P63sN7bc1ZYBxbZkLtwsGsVmGLTt1TJLixyhhY
	ZcpGhymd1ZAZMQafa5L4c/55SgihoYTnk85ZwCtGpBadoyTtPuIgX0Ona3opsnK30zBH+xmajLm
	6/K7AHsFqdCXjRHXDxP8Itjg+PtXB5W95lQZ3AHm
X-Received: by 2002:a05:6000:610:b0:495:5c83:51b9 with SMTP id ffacd0b85a97d-49c7467a893mr27328310f8f.50.1794864433590;
        Mon, 16 Nov 2026 13:27:13 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:13 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:22 +0000
Subject: [PATCH v2 06/16] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
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
Message-Id: <20261116-halliday-dts-v2-6-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=891;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iomST/Qr961He4Ne7crBcxin7EtHuKLr8auNEsY1c6w=;
 b=XlBnHuuXKSsmwBoy79zd7CM/aQS0V4vz73O5I/ykrhOgY3nFJG4rnY0qnm4zfFTA5sK35VFT6
 GeLVT3WztE2DdDA/hh0iSPFr/rHt5tVJ5B9S1do1YbNU2FqHh/CJpdT
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

