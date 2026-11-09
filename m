Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184411;
	b=P0LVxlk4+v+TkCnar2PN9Sq6cc3q3LvoISHuHHAg0kOraj6Xvz0QxgzSQIT020hLxgSK
	 J+HoZBxYjcrSlJSA7+DQGQB30LZmclDmT/76+NQnrpTv+6AVVO0QSIMKcJLQh3Ym/RYR6
	 WQyFgag/464+T6rhW3yv3kaia25wGsdZPpKJoYlz9kaTu7FoQr5gpIH6YsyObkTcIZjUr
	 5bqCkVR+4t9PQqUomd+R14rB1HtR5g2b2NMX38xNKzIX9sr+Or1+HPqT4LLp5+Bn7Ma1w
	 aI/j1Z9yhmtfGOLoa5+40mxrTtY6YMcfuPygvXuYWLToebCkEwZtnYu1NQXuaHgUc4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=YFKLW8KNYAJNpwdl3pS8AB+PKg8ma9J8S7TqNdUzcMs=;
	b=ZhAUHp+Fq20HEm8GnCIOfAcX79zz46mSTPCuBSNiUoZXMBGh2pkQSpJGaYSNUmV8fWyg
	 y6FA9q4I2Sy20ZJ28Xg9VaEq1/Ho4Qc2a+BcFVLqYirH9Unk/VCjO0nPNSV5rR4nDsZoF
	 P8UO2+do6UKbKIdte2jBGoyY/sLexr+Os6s2bvBtKidvW8VgGENxZ7PKKAStxCiWvEicb
	 Bh23LQ0uCWeCpzGHglS00Ox37P063zejbnyeBVF5pmqWbZn+h2cUxAoQw1d62raP/6Evp
	 z2XzeFfHbAPr1bUqin1ejakf2KQXyhfrg73r6E72881ZiNWb2KZ3ZrotnrB/L8+LTZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lNZuGQVz;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA56606A33E
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 00:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DA56606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lNZuGQVz
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so228843f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 08 Nov 2026 16:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184409; x=1794789209; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YFKLW8KNYAJNpwdl3pS8AB+PKg8ma9J8S7TqNdUzcMs=;
        b=lNZuGQVzEHPj9v4icTTmtvLBfDYlz/M/Sso0f+SFCtPs2KLbjb7e5aWrWAAHlDGn5V
         SGl3pdyTe0lGYBspYgkiVZzMC9UMLvyqiThBXMz3ffInz2Og5B7p8DZZaCvSWi+9Zg59
         cXkTjnqyhcqHyZtPG68KQsJzc2N+h5/9KnHv/vXFMEzjkOcm7CJsLLed4NN76bwhSGrr
         NeAzNq3xQZI3yrF+NPzJK9DyDwjSrTfV/z+rhp5egW/KfqzqhsnCZMa8gNl9ktHPW9xY
         1l652jbB01osQ7vZJv25jdjL4zOEJSAhBOu1srktMxungIeE/pPGjRUqrb8Pjjq2CmXe
         dBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184409; x=1794789209;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YFKLW8KNYAJNpwdl3pS8AB+PKg8ma9J8S7TqNdUzcMs=;
        b=vYJNuRohbnKRnLO1h+1eo6Pn4CO7T9wucIx8dIbnlW3iX0RjhV7rheFR8V8Q+X5cT3
         mh2GuYOuzZE1y9u0mkvBBJh2Rd2q9rD9+zx1bdzhhysHhXuPfNxrrZeifHI0amGritcS
         x12pGmXq3kZ8GgBzpWMScm0CrZxdyNQhfq5OLrROIAKRHZthlM/7dJV0lmURJocfkgMK
         ONUbqRRsDWI33aJVz88wjSWsubtaqXE8aQdHbbhN4SVbCypC/+R3phAjN1SStsw86tnU
         532GgIpJ1kEmSNRBybn6SUmvKBomy8tTupq4J0n6P0dMeVbMKCR0G3e8CuS2BA+N1I6B
         i/KA==
X-Forwarded-Encrypted: i=1; AL+hErGNjoBSJ4oatMkwJL4k/wHH7dRTeoMgBhf6gOn8R6JNQqiFzjh7kn9TjytgVkQk6ImUtv4+MuBWp3Rr@vger.kernel.org
X-Gm-Message-State: APuU4Z+eVYFEsCgH4+fNJ1mwnV49BBy+vk5gy6tHT0p5arFtWX1IrfL8
	X5njNMBYyprez7gmvejGRJU0CdBMgU6bK8IjU/5zwqOj1G7yVHL/4yJuBozGcV9gcvw=
X-Gm-Gg: AYBFou0DnrkSsPk+xpyJ/Gi6udrt8aEk7yRFChLNgFyM8MVJK8yh6xs9Uy92CWn4zAN
	dHXfY5D+IGWQ6hdL1XNXZIHr2TRgKD/FnxskRHxka4qgiF11Zo9mA7QFpz+j7e9sLCNo2Luvr1o
	jH6+y36SQu4FYIHDE/6PumAr6bGlPiu6JURLxtMMH9BW2whLm6UA/bc10jU/EA3aRy7u/A5+ngZ
	D7faKiRRH/RoqVCAmVS2PHYLxHgPfhVOt50k5O/K931cr6D9RUvf4wSDrZFq+g7LjodN5UGiZEm
	sHEMDXG+SmDBgnUOsCXk7OiGISFYRfF9B5XqFhCSwEEAzWlEWHicc/CPP5Detmupf7RxA9n1PUi
	/z2pYmfMbf20LIczBULYFUK+0f5B4eEqDVirj0Co8v1YTLpi6woUtZt/J/wIpj5rfVmNYbAgQUI
	/4nDLhh7nQbBx7bhSPlKlOwjptcYWO3hOE1cjv+cqByHRI3ZY3BG2aPYMP7AzK/KPT18AFa5Lha
	im1yqcVWMih9sKSh5j4hyVf/k7swzjxKNEgetEaknzthgIuGBWRIOSrZ1udQ1FLikJ1EdtsoQv5
	u7aHhqvsp/BvdK8MnXHsCaROOOe8WhJhWyYpzKv0
X-Received: by 2002:a05:6000:41de:b0:487:6f2:1a4c with SMTP id ffacd0b85a97d-4958363aef7mr5202460f8f.25.1794184408539;
        Sun, 08 Nov 2026 16:33:28 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:27 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:13 +0000
Subject: [PATCH 01/17] dt-bindings: arm: qcom-soc: Add Halliday
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
Message-Id: <20261109-halliday-dts-v1-1-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1550;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=tUWocDfAfCJsF3v3OtoKwfhNWUHIfuzBBTQPqmsMKT4=;
 b=6d7YwzTFYjop5p0/v6W6IN2CR4pGsNNDgYvAeTsTx60B++SOP4IVlql7QjUftzoP94efcMQBt
 9wyXGd+1Qj8DJV/y/ijna8Tz4UO7i/9OTJJYJc+5QBZZdn3iTw6kOCC
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add Halliday to the SoC codenames allowed in Qualcomm compatibles.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/arm/qcom-soc.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/qcom-soc.yaml b/Documentation/devicetree/bindings/arm/qcom-soc.yaml
index 179aadc86a9f..9d392329d437 100644
--- a/Documentation/devicetree/bindings/arm/qcom-soc.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom-soc.yaml
@@ -30,7 +30,7 @@ select:
       contains:
         oneOf:
           - pattern: "^qcom,.*(apq|ipq|mdm|msm|qcm|qcs|q[dr]u|sa|sar|sc|sd[amx]|sm|x1[ep])[0-9]+.*$"
-          - pattern: "^qcom,.*(eliza|kaanapali|kuno|glymur|hawi|mahua|maili|milos|nord|shikra).*$"
+          - pattern: "^qcom,.*(eliza|kaanapali|kuno|glymur|halliday|hawi|mahua|maili|milos|nord|shikra).*$"
   required:
     - compatible
 
@@ -42,7 +42,7 @@ properties:
         - pattern: "^qcom,(apq|ipq|mdm|msm|qcm|qcs|q[dr]u|sa|sc|sd[amx]|sm|x1[ep])[0-9]+(pro)?-.*$"
         - pattern: "^qcom,sar[0-9]+[a-z]?-.*$"
         - pattern: "^qcom,(sa|sc)8[0-9]+[a-z][a-z]?-.*$"
-        - pattern: "^qcom,(eliza|kaanapali|kuno|glymur|hawi|mahua|maili|milos|nord|shikra)-.+$"
+        - pattern: "^qcom,(eliza|kaanapali|kuno|glymur|halliday|hawi|mahua|maili|milos|nord|shikra)-.+$"
 
         # Legacy namings - variations of existing patterns/compatibles are OK,
         # but do not add completely new entries to these:

-- 
2.55.0

