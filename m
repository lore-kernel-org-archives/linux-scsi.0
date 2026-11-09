Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184431;
	b=cH9TGxWvAiNSchECd8aRHkuhAvq1qGrLBqioBQOSIC+QwRajEyoBy/S5QZTZG6OyI8DH
	 7MzGpkVuFTiOaKUhaR57FCwEKmmf7uO/LLYtCjCJn50ma7izSU/pVkjs+02A+2aQmTNFO
	 w78AOaSmxNXFL0PgnHi1g54iWZdNiCQwINpIfQOkuHmPYDy9vUgf/wAWGJeUL5lKtL6pR
	 Y0crsWpVQlq0/E5kxEV6Ml4yyrfQZoBqdt6RcAaY7bIxbWaY4r0t1LeWGSmAjiw3IeZsZ
	 xGg7mAIMt9/FU5YGjG/6zOrrRPhPJgXT/1VA05bVpsH8sNqB1bqnp5RAmv09UHmGLZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184431;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
	b=A0YOWqkO+zJJ1vU+xGux9n9JShxk08EayOpO/wCY3cRFCmQT1Vmvs0aQt+m+M7QAXJaE
	 XgosTbmLz+2Not5LRn8TXGcULLK5dZDY1gas+pY+yZvjuWUqreUKw1FxNPTaP4ZdAwV9i
	 MWfFeWhlJ2dWPyVVXp4rgwIIrnUS4UB85CZ7RG1Ld1JQTAnCctC/nvoZSECAlxGNXErRC
	 1HoT0RArPJiytpXrQkFHn/HWIgWz06Nt36prse5w7SYOCWWVHDKbxCxEqzdKXluZ5uNYc
	 RVAv4Prr8Tb70ljNMRHPfX4DKf77Q5htBeG8hElZlS4d0tY4RZefMgcdzmkX6g/aEtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mqATGSDg;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA9606D826
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88CA9606D826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mqATGSDg
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4910b863b84so218752f8f.0
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184430; x=1794789230; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
        b=mqATGSDgOcyspCGm0r88zz2LKvOBuTSrflTy4G3x+OmZ3/e6m92wx8lwDFbkWU/2r7
         wF4RvcborS48J1HQFsH7E7pQgiQNwsPdfK59/AT1PhF1G8mvFKr+CfuUUZqZjulYaEup
         ouJz/e8/k/DLsRowKga8BFqAZDnPgMt29Cmqfeh1kSkF5wRiiYm0/AlufG1QlkuycLwj
         rEpBeHEkXJziqZintgY94/c64b0LNVR31luc5/F2R95zuMihuSOw0tSRvV08J2itGF5Q
         e6yNkFjWR7cidQVwBnB5dheZp9Tw2HuJb8BECeTsjwwMmrbGM5Ib9dRsZdyiCb151RhX
         5M/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184430; x=1794789230;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
        b=0cXBW0hcF+M8iAVfkMRFZ0bVeKOONKeS0nzbaqNeMltxjCYSoTwBCEfkBhJWqrQAIl
         3ECpr0d/RqVMmZeHoBObYkuDVhfD2XH+bTodvUFJR2Dp5HjuS/VFVqOrRmC0/6cjysFH
         rr7cS50GDrH/CDMRmNnsZrf+Lhq/RvSVL7fqxjAEovGNOM+uzhYwKpSwZqOSmE5BLN0f
         Enp+D37zpDJkDCullButjtYAI92iL5q8vrMwnjvmuUsSQtCxipaEHvcDRQZuCK3dilNw
         EhTAvyWdoGk5pgY045JaiL0vUbLePBD00I7ONXtLeo7HDfyyL9OVVkXH3i6FpsQqYbBg
         P7pQ==
X-Forwarded-Encrypted: i=1; AL+hErFalqwts1/CswQl6ueldVK2EMg53ErToVkeaQFRW4BuF4sASdFS4Z3eEV6HFczQaGrF5I5YTICFM9VJ@vger.kernel.org
X-Gm-Message-State: APuU4Z8CVkkv/uJlMcbxdr6JSe3v+LsEJdQb7zD+lFHxx49knuydGsmE
	D7E/OzG9sAWhhDw8e/XKan73Bi6pixodAXz9PCWhhzqVBv3MGO9u2DrZB3LHF4lv7BI=
X-Gm-Gg: AYBFou0kV2zQMKS4EoSyvKUxxQaE71yQ3qbq9xB7UdqCFXzk0gLlduQRh3957vVCcDz
	HUu4vTL0/ZfYtW4lpIYEBhx9txR76Pqft7ba8FMCfhZ4cH+za3rRmmHBxGhFb9TujUdLCR7O3OT
	aTsMs+jA6bFa6gc7wlFZAmZUASHKPgWSLRUDpLZI+SGnAvI0D5Jo4zOmWbym2xen0cjUwbee7Vr
	50UC6dEbldloAUIhmGZwgHpi+XmlHJsjlKIIP7m1pccxh8yQwvK54M1jFNVh/5ZWdMFe6wDGEpO
	oIna0mvPxfp60tB+bAmJyBJusB4sPjxHBumLDq/QLjkEeTcmvJvzw8/pg1mJmSIH1+LRYHnslL5
	aQU5RZY/wz57aAOvuYOw24QIszVt5KajyaiRPlJOZornXBRUfGGAP5ViLgKSAEgGVJXiD8F+UT4
	6REuPnRxESKxN0+gaxXX7A7kwhLarTXmw2iZYLmBm9KxN8m9ve6EJtt/hDts81SDEqsd1hRpY+C
	0y1iWqX69YthzEirO4A5ixV6yPoRSk+WWHLIkk8IkOzVqxmb9EhqIkQAE7i38fyTlWkTQWkqruT
	Ra5WS8tEJu9L6HQV4z3PPBWJXgdec+b6lQocz7t2
X-Received: by 2002:a7b:c34c:0:b0:4a5:9224:fa10 with SMTP id 5b1f17b1804b1-4b8205a7b74mr74612065e9.18.1794184430004;
        Sun, 08 Nov 2026 16:33:50 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:49 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:17 +0000
Subject: [PATCH 05/17] dt-bindings: mfd: qcom,tcsr: Add Halliday TCSR
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
Message-Id: <20261109-halliday-dts-v1-5-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=720;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=sz0jgm6yJ2qfmdfMMgsqR7Wg9ExS4UZymLewfvVCvH0=;
 b=uUjeKsqz31kCcfPZSa8Z47M4B7r1CADYAoSad8joeZDRvAbLwLDkhf9ZDymLvxVoerAVE+UqI
 g/farVtv7C7AYkuFx6U6v9lz+2+4yx0RS/OmA8jjU0ljraJ4I1qJLhy
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the TCSR block on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml b/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
index a021e4dea486..e8a681b5e6ad 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
@@ -17,6 +17,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,halliday-tcsr
           - qcom,hawi-tcsr
           - qcom,maili-tcsr
           - qcom,msm8976-tcsr

-- 
2.55.0

