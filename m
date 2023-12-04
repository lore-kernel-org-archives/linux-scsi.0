Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="PHkKXXB/"
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685B31A6
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 02:24:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-54bf9a54fe3so5474768a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Dec 2023 02:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1701685454; x=1702290254; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k136HpPBxB75fbT2utHLBa5irmSPTM0KT5lmOjawCwk=;
        b=PHkKXXB/Cjl7s7uuNf8mhum+qVOUjIs/PUMyma3JTrq82yn3y8JYxo9Kn0MBxcBEqZ
         ggZR1A1A0D9/uRAgKIp9cVrrAtZyNdAbkUtq2TtJerp4RycjwRnzEEChrBowhZA/tO/J
         iC+VN/vSnsQ16SPjKzSUB/CqOGlZIGyF15zR/0g4SiU5UNN4GOPFbHxxPL8fC9nTjLcV
         IslMY1tFkMX1m8EYr1X521mx7cCTrDwy5saxN9FV9IDhcN9B7SR3wGdbNWjUnndNNzBi
         nfGhu2zs8jflge/DrNRNJBzUWHnvtwkZZAVL8eKWc3NzkMQd3lEClzHbl61ilGDJLVX2
         aGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701685454; x=1702290254;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k136HpPBxB75fbT2utHLBa5irmSPTM0KT5lmOjawCwk=;
        b=C26nwGh/VQdFG79UhIGG8XGE3wtec0RN8J8hk4JlSK+BRefuehHyYWg15C+6PKx/oT
         TfwoJGjPCMo9k/+Qz3SpJI7qossogNvslT+kdvBGqdtOix53q4TwqDUckmlRg2eQrdu0
         Dc6+62IMgpfvHphFAb/gYCARrtguGeggQ+WNjXVRL1v47RCpOlr3EuA7mQiXvjZoFwrW
         HQqiKHY6wTcvgcQcD0lZQDD+AlJw7fGIU4B7dXDf2OeA+tmEalZd6hmJeyGLLoadvEDe
         POT4QpyxA/6XoJQnlkOX8wVb+Gl84cfRSArjHRkCliozj/8GlXlY/ukg5i2ZqOKck0Zm
         Sx2g==
X-Gm-Message-State: AOJu0YyGeOyZaqSeqW6mqvJ24znCEjUPaPcaejvJqXmlTjlainyPW2Op
	+Cq6COV++oRQo1pEveXdA7/jvg==
X-Google-Smtp-Source: AGHT+IEtBdauiFo6/m4vFmjOtJmPLwVCJAjhwy5Vn7o4sKAbfmoX/inEUuC/g5QqQdMeJ7XxRTEVqA==
X-Received: by 2002:a17:906:8b:b0:a19:a1ba:8cf5 with SMTP id 11-20020a170906008b00b00a19a1ba8cf5mr3325610ejc.147.1701685453779;
        Mon, 04 Dec 2023 02:24:13 -0800 (PST)
Received: from otso.luca.vpn.lucaweiss.eu (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709066bcf00b00a0bdfab0f02sm5121551ejs.77.2023.12.04.02.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 02:24:12 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Mon, 04 Dec 2023 11:24:04 +0100
Subject: [PATCH v5 1/3] scsi: ufs: qcom: dt-bindings: Add SC7280 compatible
 string
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231204-sc7280-ufs-v5-1-926ceed550da@fairphone.com>
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
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.4

From: Nitin Rawat <quic_nitirawa@quicinc.com>

Document the compatible string for the UFS found on SC7280.

Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
index 2cf3d016db42..10c146424baa 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
@@ -27,6 +27,7 @@ properties:
           - qcom,msm8996-ufshc
           - qcom,msm8998-ufshc
           - qcom,sa8775p-ufshc
+          - qcom,sc7280-ufshc
           - qcom,sc8280xp-ufshc
           - qcom,sdm845-ufshc
           - qcom,sm6115-ufshc
@@ -118,6 +119,7 @@ allOf:
             enum:
               - qcom,msm8998-ufshc
               - qcom,sa8775p-ufshc
+              - qcom,sc7280-ufshc
               - qcom,sc8280xp-ufshc
               - qcom,sm8250-ufshc
               - qcom,sm8350-ufshc

-- 
2.43.0

