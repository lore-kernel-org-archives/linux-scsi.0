Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578223;
	b=sfSIhacos/Hii6loIYC8Hy5WHUreuoU4WMBR1BISHtXL4TCoEHMRyd5ZCcV8hBRjj7dC
	 cLAn4YAKOFJeZ/fBeEe0ZwuCtUe8UVPuGwDn7EkCmay4IJGRz7cpgqZyxpAbJLn5L+6H7
	 w7ic8Xj/yE51UJwKpXKelt9Sk/na3Ts97tqJFwUOpygSgmfpCSDOysxBUO0zW40cswfAG
	 9oEoYtQgADjTdNCy3s6fVNHFHvGF6UhQte5SGfqsKYzRAO1OnnOduqXk8z/nIJSD60+v4
	 e4+etWT7iuSWflb+Vg67e3XAkEOHt8B50qcsNhn9ONQhIrjiPOW4Z2h/XMql2o3PMbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
	b=yF3iMCkR9YeJnZqr8HFoXq6zfGU/drc2Q2IDIWAen3kM4J6Xpp4pTPNxX2HgkqyxU4/f
	 bETJ5w1eT7G9FotlSblAYHC6dkgiilg9o6/A3gLQvBy5/IQ2eIzdqGo1mRu2WBh/0OKOR
	 +0EQ45HkOEg6eG9e4UZHUs/Y6+ZVvCTXQAVcFc52UyZVEZkUIgznb1l8O/s4Qw/BoQAuv
	 ZCAIPuxME7UJLpbf6bIq+PRD7QT+gdoayjU3spB1wx2XO/gOR3B22Ie44yAeszBUr5LQm
	 XPS34W13vhEY7XK446AVPMNSolpVgfqZwx2QjL98jwDzba8kxP8rbyNfCpe0oUAvavA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0gL35YaP;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CA7606A32C
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50CA7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0gL35YaP
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so54506025e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578221; x=1796183021; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
        b=0gL35YaP581fK3jcOJPups+fF9Bbf8JIZtZt5mMf57n60XTFjn4kYofnxX068yiYH5
         FuQ0yvkMTBi4fEdB55IabfGWqM2T63H29uww7lNh8DHLTv1kOBJPGaeo3AMOqMSSU+X6
         3LdUBD9U4cj47O/R2+eBKO3iISBcpxscvMpW/pqZcRplromX81Z3/RuRNnC5/EG5rPmk
         BQKfdN7YeHa+gsvJFgUsSAByJJs5MW9Pda01hnPON69QF8pF0jxAMkykIR7oUfizwaCg
         kbnLzik97Yu5Gv5WsFhSEW86b5D4gcno5s7wlSNmKItRT/jR3gKoc8KIJ8tUtaqOPD+Q
         iaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578221; x=1796183021;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
        b=eEfAS4pkFWEjgZApweUFvNZw/eYSLgO1WgEw1G/yOM5bYP3FzdSzvQXwDJdyp0S3l2
         BnjPy1TrVTcZLslwfUqkPPpkGny8CGPzOXd/ir6kbjxwi0+ZBzJ2h4v3fDJvsZAhO2ZW
         lBkAuGlM73X711Db3E74OhhC4EnQXB4P3YJHcm3RAgoMSAOq7Jag2gkvmPAlFI7gVI+v
         dlCy/9X3UkBZLPMxR1J7TjqKUXM5mj/EJ0IRfDQKjOUGGQ0rvJ/jh96n0vmhKB3xkyak
         fqZ7CODSKyFyo5MuOTlwLHlcG+3kxLcpW+NN/am2LZ3Xfuwy5Id7/iH0cN+dvgp6RDDl
         aAsw==
X-Forwarded-Encrypted: i=1; AL+hErEIGQt6u7ePdLjm9Z98TrOW2dcaRfr9SzQQMQRiot6WM5bh3ZdOjUGUctfeAe8o+f9v+LTihaOKH5lD@vger.kernel.org
X-Gm-Message-State: APuU4Z9aNGJCOlUW4vQhRzBmF0Z2LZL+KhuJQ0Oe5EX+FzJOubnJNhQ2
	Rvo8LNiQmp7KhZSf15o7ZK7NaAf1edxao/4RWTRtlB01gSm6xUm8LN1F
X-Gm-Gg: AZFdTZcQ6UpEay/BVaLw+StrXWRInoInnJj3Ze0p0QgtyaSl22zuIue3ujqQLDHNayb
	ywHLbMFVHWw3nHhEp4ACLR6TXzG9plR8dnDKiooNmZTvzNwthFEZV0gvAFFkTyPxlnARJjzfVGr
	8Q0RzuFbuTeElYxmRHlMLmAO2TtoLl23x6sBjJOhSZZ9r85qJlZpyEeBcSLIkY5y741J5qs8JXO
	UswH37seRODPSQwY1C23qf/GfyZd8H4MhSulQ/7VBInWAqqZOlkjzj1S+l7z0cCiN4uZbqBK9YB
	uUu5PNaxtn2frRIK3rkxHhpyDg2W03XqtXeMR6YewlCpvnwUrJcXx/XSVfmLnc/rMsXhH2Gx2Az
	u1NgJjRZe3bweGXGPULhr4UkCvjAM/8WRFSpX0TDmSxQZLwXEaoE5gOKDjMk8fNH4deZJsrkkUK
	27fgRG++cJK5Q0gXsmMTT4seCa3bhwA+F9Zsl0cRGdxXu0ggVv5AqN6kqqibe74Bb7uqQ+tnmws
	+eDyQ2M9A/720XwOo84K8dMgrgQoMexZc23Sgj+iAhqqnMTz0IzEfrfpSsxvKS1/iRya1LWhe88
	KlR8eSyWARu3YKAnwkvAgXGbl23Av0WpefOC/A==
X-Received: by 2002:a05:600c:34d0:b0:4bb:6a5a:7839 with SMTP id 5b1f17b1804b1-4bb889428eamr328092505e9.34.1795578220699;
        Tue, 24 Nov 2026 19:43:40 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:40 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:42:58 +0000
Subject: [PATCH v3 02/14] dt-bindings: power: qcom,rpmpd: document the
 Halliday RPMh Power Domains
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
Message-Id: <20261125-halliday-dts-v3-2-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1076;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=2tteAd38AfHrvk8Awl3RAniXNSdGBzL0LwEwE8e7LoI=;
 b=5C7/JmmmJaij3ZDCjC7taKHJ7ftfQrXNJKeux4QbuaH+Zgcx8qkDlh+sISv0oWyhLHGJ/5oZb
 fvQPpset2HKAWFH7uV37/GtdVaAFBb3EKxSiKjnd+R0Yi73lf00uJQF
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the RPMh Power Domains on the Qualcomm Halliday SoC
(SXR2250P). Its command DB has the same power domains as SM8450
(CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
qcom,sm8450-rpmhpd as the fallback compatible.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 8ee1c25a7c9d..663baae9cc64 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -82,6 +82,10 @@ properties:
           - enum:
               - qcom,maili-rpmhpd
           - const: qcom,hawi-rpmhpd
+      - items:
+          - enum:
+              - qcom,halliday-rpmhpd
+          - const: qcom,sm8450-rpmhpd
 
   '#power-domain-cells':
     const: 1

-- 
2.55.0

