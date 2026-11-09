Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184415;
	b=yCaeGMvHm2ROaLI4HZv+XVThUc6meEXxJkihy++vPvw6wXohesaeTHMsIHxLK1wa6Vfx
	 AOgHWD/TnUutFx4XgC/Y/vISKFk+JLJgbEtqdARAasFSsPJAN7o5MN7TKJIZn4/LJ82uk
	 x4MxDlCPBE6PNCH3L6R2c+7ONYCRDYn7KhdMu4FM0snrn1AoJVIxHokYDn/kAlcgnKJIo
	 R5S7D3Arwz2GmNmE1h2P/9f+p0i1je1iWLWF5o4JeQrVcB0oelDmhITFCoR+pbtbKIxXC
	 jltozl+s7iZ6luE/X7uTXPGWhsEdZ3OywSmBZbGnqi4Nzq3WDhza23hJqinGxhrezUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184415;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=x3Zvaf/6knxBP4r88bzQVxogNYmuURJ/Z9N4FNNEXXM=;
	b=YzJSEZpKD9vuZTE2HAzLvpK6+16p8Milhb3vwf6GImg+0OGMniBYswLm6CvfLPYr+T2C
	 0rp2lXpcOtudxabGyhpKFXGMv7YYdoakqn0eCvLvELvUnUmVAFdZh+zCjNKCWYG9iUr2o
	 znNoUskI0nJ1UF0I63ByKfhI+iDy3Qcrmc9aLLfQRpeoZ8MvzoQir3JQjwURNA2oetpGw
	 8rVrEOkvirQR+RAvBjhRu4ZKITCMzxBZLMYfGZNQ5byQTlwlvHOq8drLQJZRfcbcbf7Iz
	 VhJYHQKz7OMCcuaDqFpcCgOKyGkSWV5H+9L3n/HvT8Stl2Zihj4OW8qWoCH4uqFUTBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="DVeB/ILu";
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700C2606D822
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 700C2606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DVeB/ILu
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so2792015e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184414; x=1794789214; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x3Zvaf/6knxBP4r88bzQVxogNYmuURJ/Z9N4FNNEXXM=;
        b=DVeB/ILumBTLtGhAnK9SThmzeGROX65vDDXvaMLZaeOoYlcOfAZJzCyt6um5mYfHDv
         Y3VcmUpi6VTDyzOrubE+TKxzkEzeV7DSAlF0WPPNZOCE3moVlSnmkE+1qezIdsBohAmP
         a/93IAhud+Xk1IuhtXMMbD/9JTprYk8GiRs8RDQKDOz2ajUzeKy1jt8xEeKQ03ZHTNjl
         KWqIgDs77rGbxNx92twtTmLWRqapsVjV3jMP0O+gf6wVsaSd0oWYgtJXqPstZO6rnlkr
         fdQkYrgvqlA/v1Pb5mWvu8AR3xbxLkneLZ+FWfx+DKb2+C192KWMt4IWysE3CQA4Jrx3
         3R5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184414; x=1794789214;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3Zvaf/6knxBP4r88bzQVxogNYmuURJ/Z9N4FNNEXXM=;
        b=HeSBqFWxKy0IN9TviFMBOfKsesJ0+WGA/1ygxGP4w9wcdrpKL7hCFR7klYFN0cS4en
         V/EypVbZcR16Z3SsbECpMgzVD4nBv99/2LHogsQ32dzRFvKpEsLsJzeDyOkAXrMoAIo5
         G7RrWnNcQgZ+BD+TIrUAeJTNawyFtKmL5U0EE/ok0/E0z4e5hC5D5Ewqc5bTfVHtHkWq
         TXuzRe6GQY7Y3toQHjujsKqlRWqIKTqO5OWhGtQUZdPf4QTNoLnKwaGfO67qLqUan8Dn
         RdjV23oQu78Afme3CD/A8a2QJw7cyKhmu8E5f7hHks/9iFqpbKcpsViALs+Igbd7YdR+
         lJAg==
X-Forwarded-Encrypted: i=1; AL+hErGnbU1turIOT8gloZ/lHWtHa/0PmpBjSYkMSpfzbEGaR1RFwDQ41aaA1QkPy7yufxt/S61fi7alMxlI@vger.kernel.org
X-Gm-Message-State: APuU4Z/WQY0rAOi3vXzaQ9xNaHDZgIrCPX5xz7vXzVT/cfA6eJuLCXy5
	B2NHGAJ0kTnklA9vfA+1MMfrVBDyjzOtcb84pHdzynWBl2Iy4UHOgGK9hNDUWOzXyds=
X-Gm-Gg: AYBFou2NiAwxQy/jUQlnKazOM79sZxD1SW6qlGJ0tkr+VMfwhtRoT1SjvKJxEfBYQtx
	K0XpEfK06VmpDVAgPtH7UPCnNgMhsQ91cW/PnwMPmIpWkNXayycjLLe+JcXWYy7bJdVuQr+9yAz
	G96SdluxQw3H9JKjRY2vBxalhM3G/4B0stEeOVsZO6f1YgoSvtuanv+HjJrccdPFtS0apI2vLsx
	i6ELoDJB1zUBYErjbVXbxD2/mBsadO7DsxLMsUA4IgWmIrOnS6vmqvX6nhaQ4CX/SNxwXjA1D+a
	U6SWnBL2ntn7B5MHSJ8auhWdiFaG+HAOJi9OxaEyn4gmYdU6Jb0ViItf3ESsLCs9S6RD/Ta1EA2
	krxSEsQ5ffrWQ1J/0iJ1l8kAhirPVtoL3l0pgmJ1vX7TDhpQPy3LlPJxUmDqha6R6RwHtVDSMMB
	Sb/Hyr+wACndgg26w8b7s/gfQN1bZrj2p4rUZ9M/hKFIYqvEoTwD/nh/uazbyAd+H0g9S2jvtTl
	7nOaF0wJDxXy+cZl/yKcz8Q6Q6+g+6K3RWTXdCJ58slzq+3FUTlcTcOD2S34/T6mxIlehR1Y5iJ
	O9zSBw7aejDmF6AGPckBggG/LBmv8t1UxVAVPHkW
X-Received: by 2002:a05:600c:8506:b0:4a2:10f9:37db with SMTP id 5b1f17b1804b1-4b963c664fdmr50119595e9.7.1794184413846;
        Sun, 08 Nov 2026 16:33:33 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:32 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:14 +0000
Subject: [PATCH 02/17] dt-bindings: firmware: qcom,scm: Document Halliday
 SCM
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
Message-Id: <20261109-halliday-dts-v1-2-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1033;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=mntziyVI6wQ2kSkSteAmiaUttlX3LQ+YCHknAe0v+s4=;
 b=6KLs+gQMEgAdwwaI8XXKZHARhr4EIqJqXke9wpzWMnotth4jMEZlLGfBGwMvNoTpcE0tKCN8v
 aRJBBJI0d5iA+Opb629gN3RAQt1TeYIjZdEvW3ChlNmIbJyjVXak7Mn
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SCM on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/firmware/qcom,scm.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
index 40a267c54b00..fb3da66443ed 100644
--- a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
+++ b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
@@ -25,6 +25,7 @@ properties:
           - qcom,scm-apq8084
           - qcom,scm-eliza
           - qcom,scm-glymur
+          - qcom,scm-halliday
           - qcom,scm-hawi
           - qcom,scm-ipq4019
           - qcom,scm-ipq5018
@@ -225,6 +226,7 @@ allOf:
             contains:
               enum:
                 - qcom,scm-eliza
+                - qcom,scm-halliday
                 - qcom,scm-hawi
                 - qcom,scm-kaanapali
                 - qcom,scm-maili

-- 
2.55.0

