Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="j2ujXazv"
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CEA191
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 02:24:18 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c9eca5bbaeso22064581fa.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Dec 2023 02:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1701685456; x=1702290256; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+ofOOqwlUZnjaPwU1R/ES77wt7OX5hZOTqDiest6VM=;
        b=j2ujXazv/wUQHlX6L8k6yZjFkX7b+JLx6E7rsmF0HvSXzJVk/vgAgyUv8P/uHNfpQP
         LCWWv1SC/SJCFOA/JqPwDd8DEA8rFl9incD11jouhTn4TSilgqoF1cXhWuYDEaYRMCCX
         aVl7qIwlksXK12AuKAzpfMLvWvmaT0z5irvGkqr+UMF8Dh77GzZrkjd/JnSVHVwID1ri
         cRP6dTJ7lNRsZlamwAUoOmkh0fx6DFh1Q+ywHNA8NTbhiEpN42QcN7UvQ9IUitNIXbVw
         W+z8K7aercDlu3VQ2BGnbl/SMyVOmlF61BZ+j+4T7wwm+NZxixK1V6LYGsgwIZvIPOt6
         T1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701685456; x=1702290256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F+ofOOqwlUZnjaPwU1R/ES77wt7OX5hZOTqDiest6VM=;
        b=aLi8klB447RhyaC/45yXUGiGRXIAUuyJkXBcsaeAmRlTAJpPUkg3Hc9xi5+KsxCZ9H
         ugRs0sV5JJAqqsdd8u1S/8YJm3cg7WpPTFy5oXNcAfw0w5kTQRGGzQfB2HUIqDIrXg+/
         Abgi5vg351kKcMxsjbbzcSzaQR4h88bxEd9MaD1QwmwBHvIB0T5rvmtBdmvGyO7G22lZ
         msQScLQ1YKpALTI7rLR1fRY7QPyRWTsZ8Jchu08rLH9lRLnAefZA6ZG94ejs20IkyRWg
         heacvtQoq8hYUUJcVJQTMpNQphQQf+HjjL7KVXn2dQEHO4QwHnki5DSFMRqX7YPTvSfV
         j1mg==
X-Gm-Message-State: AOJu0YyfgN/XIAUIMXBzMr07VnMMew9HCkdAEf+vTn7LMCcx9D5BXFTi
	qJhtUB9anXizk2V3QfdN2+yvfw==
X-Google-Smtp-Source: AGHT+IGfZyiNNc0jMr4snd1gdmvFtqMZ3JH/kWXhhcJq6QF1u/8bMbIuMuKp40e7ciUb3tmmWiMGlQ==
X-Received: by 2002:a2e:2c01:0:b0:2c9:f776:e28f with SMTP id s1-20020a2e2c01000000b002c9f776e28fmr396256ljs.120.1701685456383;
        Mon, 04 Dec 2023 02:24:16 -0800 (PST)
Received: from otso.luca.vpn.lucaweiss.eu (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709066bcf00b00a0bdfab0f02sm5121551ejs.77.2023.12.04.02.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 02:24:15 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Mon, 04 Dec 2023 11:24:06 +0100
Subject: [PATCH v5 3/3] arm64: dts: qcom: sc7280: Add UFS nodes for sc7280
 IDP board
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231204-sc7280-ufs-v5-3-926ceed550da@fairphone.com>
References: <20231204-sc7280-ufs-v5-0-926ceed550da@fairphone.com>
In-Reply-To: <20231204-sc7280-ufs-v5-0-926ceed550da@fairphone.com>
To: Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh+dt@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Conor Dooley <conor+dt@kernel.org>, cros-qcom-dts-watchers@chromium.org
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Nitin Rawat <quic_nitirawa@quicinc.com>, 
 Luca Weiss <luca.weiss@fairphone.com>, 
 Manivannan Sadhasivam <mani@kernel.org>
X-Mailer: b4 0.12.4

From: Nitin Rawat <quic_nitirawa@quicinc.com>

Add UFS host controller and PHY nodes for sc7280 IDP board.

Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index 2ff549f4dc7a..a0059527d9e4 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -499,6 +499,25 @@ &uart5 {
 	status = "okay";
 };
 
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 175 GPIO_ACTIVE_LOW>;
+	vcc-supply = <&vreg_l7b_2p9>;
+	vcc-max-microamp = <800000>;
+	vccq-supply = <&vreg_l9b_1p2>;
+	vccq-max-microamp = <900000>;
+	vccq2-supply = <&vreg_l9b_1p2>;
+	vccq2-max-microamp = <900000>;
+
+	status = "okay";
+};
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l10c_0p8>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
+
+	status = "okay";
+};
+
 &usb_1 {
 	status = "okay";
 };

-- 
2.43.0

