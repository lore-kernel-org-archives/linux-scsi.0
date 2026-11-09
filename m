Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184452;
	b=1EO8iAiWtc8jwuzx6YBG3/22MeT1h/yWT/VFHCYlc6r+3cr5s9wp8RKVBj8q2RBp0xJL
	 +VRts/Uom6shQm1ybPyw2vUfO7+Sq5LUGKXN+KNgYk1aV/ixE93R/Mwyk/lTLQDDqylYJ
	 TkNGPjlUQzYWEUc5mBUdXaz8dsArJgNvzoVQgL1MmEfCV5UeyAU7IPRAyrUhhqkxHv0ea
	 Ev62fUzgHJHkbDt9/Kfsp1w7Z7dCiNrxwzViiel/PIR7It0XqU3QRNS/jKD7bLds2QUor
	 m4DQfccf5nNPOwHPLmMhO/IpMd/kbEp2ig+VC+qoQVruZHXawqtlsE/73q7zFwz+axA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
	b=HBmm1Vp6WJFRY+yRh3izKvrIrUcS/xvHZetP+nodC0a7Eb8O+F30dAWQuGmxnQ06oIRy
	 +4trlBO2o+EE06cbEbF1eybxeJkBRxbzmNIxqhLqjdXAxaQ0OEZZfLAjTFx7R0OGbMqcy
	 z9a31XDTYhHnizZigua7SxDnfqqRTKWcTjSYWXXbdWtpsl/y3EyfTIleFRGkEl2qfMdcv
	 Kr0qmdADicRrYIqX9yydoD7nRyIfsKFZxvRW0gjcod+OFkyi13EhYHn7GeOXPOWT7dsu4
	 1hShkrTDRy3APsiYYhrbW1YhL0UL21ISUEQG3nmzmtFAHPSYchaeypApUnSkwRpMelw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULEuYnxb;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4263B606EE86
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4263B606EE86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULEuYnxb
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so187544f8f.2
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184439; x=1794789239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
        b=ULEuYnxb9uEPYMVwaCZFAhBSr3XRRf7x47G6eugQCaMON9WlvKKlg8odFviJChKVQz
         L5ivnacejg1JFvAECb3CXO3G4CGlkXkRUf5nvRqM76uVba7f3AbCgFEyfN//93jXlobk
         RRpUD1wxP334PPruCEBCm7XnO4U67yem2Q++cYePF+tA6Ll3cXA7KHUYpVW7bHGXPv3W
         01KWH5s+I/rChWyEAC4I/nugfLSJhWg9sy7NvKigj0oOHHQWEH6RZ1gw31QBj3pWz3YO
         YoqU83BPVVunbYylhg8fGTfC+v6UuQYbRsQ69PfH+mnbpLdKnjMRZknNIjNiF3iaLp2o
         JADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184439; x=1794789239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
        b=x3rWbIMDHnNS9z5L63h1nhJ5s658SCQCYZse1n8yPuYQLJekdxvi860rpT9b0Q0oe4
         7oO4PM9zgQLQtwD1VQ+m8Jl5RpeJoPGqBO/JH6AnOdws49fnLzDbcIOlSXHusfQj9HvY
         nUFhZvi3moJrWSg7XcO/xW2+MSiggS6VM16jXVgNyhaT5OoakgNb6gURi8NNOqYA0w4P
         l+hR9xq7XqCcyVAKcLqDE5SXISxeepmIG4W0mZ/poA2kQmKKpbBfyDfd8fLY5j31Avtq
         Dt0Y/EOsFZu0qij+ZG5O6yxGpJEXZ256uyAonE7zqgtGRwVCnX481mwcwsRsUCikNwPd
         dU+Q==
X-Forwarded-Encrypted: i=1; AL+hErHJ+UBGXDhJ6FFDoS7a9iPSm5fJtSZtLb9FK7Kxl9crQ2bHSAh/1ZiwrwvWZha+v1oc1xVHEGJqh5No@vger.kernel.org
X-Gm-Message-State: APuU4Z8T0oG7vjYrkl79WOpOcbGqA5Lnhxcsc+VAvlKYI4sRdyoYh6s1
	4x4AD6tjLgbd/qfhGf98cwwx2T0k5OcH+RT6D2U4Sg2LKsrUa0VUwhT8SwZOA0Iefwg=
X-Gm-Gg: AYBFou1c9F6T7ZTm8B+exz/gQTtJAHkxC/BpejLZGG551X3zDWIFazAYbyboQow+S0i
	X+RvH/rp/OVNRnp1GT3F3p9Z4gbHwzMVAdrSczfhkoqBWdxHp89zY2oNK115W2yJ1K84LkwdU5S
	33voNiwZFjPwdwQ1ZmjUqpBHDfNsHagTFzJAuPAAIPZEykTJp/MUv3Nh2SG6Q6+VA2BykG9GO/z
	zd1yEaK9Ix5mlMrlAW1vLI+eJQIke050gCHuZAK8lSHqIzvepg/8AdvchZtfmS1/eGYSQZLkOyE
	NZi78SLHIxjs0AWbsvgrPLYzG6t+jpwHBMRzMLt7wTqWOnJsjoJu9gI70H2MfP0VaTkaVzLHPbw
	LezNLNJOWNpIYj9O6ekwwLNtGewV1Cvvqi3xG4evUa4ePeXw1z/64qsx2WtGJ5Btx53Q3ueI6Rk
	A1iO6riBfJrF0aQ6fIQFN2EgE/BKmQpffq4JjPq5d6E6U+jYnTiOfMyI0z/kEy/ourKQY/qlTWZ
	DuRxCksc9rri8dAQZ1gkkPzYWnPOU+8/J9UJweNV5C2FTHn1/wRxiktfSsu5WV43pghlWDlpGId
	ssLn2dQPNQRuJ/dMf+1AbY5wQwBd/MAVe+p69/pqrBrp0MDxYyRDzQAUZxY1Yw==
X-Received: by 2002:a05:6000:3c5:b0:493:2376:81b7 with SMTP id ffacd0b85a97d-49588ecc152mr4851434f8f.27.1794184439552;
        Sun, 08 Nov 2026 16:33:59 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:59 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:19 +0000
Subject: [PATCH 07/17] dt-bindings: usb: qcom,snps-dwc3: Add Halliday
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
Message-Id: <20261109-halliday-dts-v1-7-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1289;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=cCyX7eu7E67i1+mb+zFb+/V3MZ2Z8Bvs+BbDvfy8HQI=;
 b=HQwzvS1g9UbQKH8v0/XpwTYPPGyIcJ129Y8yti74NjNwgnbgo8LwZJmaOxKeuHMuvgkZ+EP/2
 IP5h1J7SLhzC0/e/TSquB9CwBZEDq02qBgUbIWpMHDatD8Y+sZaCkxU
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the DWC3 USB controller on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml b/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
index b77c02c64d45..7a8b72d2929d 100644
--- a/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
@@ -27,6 +27,7 @@ properties:
           - qcom,eliza-dwc3
           - qcom,glymur-dwc3
           - qcom,glymur-dwc3-mp
+          - qcom,halliday-dwc3
           - qcom,hawi-dwc3
           - qcom,ipq4019-dwc3
           - qcom,ipq5018-dwc3
@@ -209,6 +210,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,halliday-dwc3
               - qcom,hawi-dwc3
               - qcom,ipq5210-dwc3
               - qcom,ipq5424-dwc3
@@ -570,6 +572,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-dwc3
+              - qcom,halliday-dwc3
               - qcom,hawi-dwc3
               - qcom,ipq4019-dwc3
               - qcom,ipq8064-dwc3

-- 
2.55.0

