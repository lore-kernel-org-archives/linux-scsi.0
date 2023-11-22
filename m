Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uYBL+oLg"
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A081B9
	for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 12:04:33 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-5079f6efd64so121027e87.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 12:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700683471; x=1701288271; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vxoJ2WrN8KtuI3BxSCT4WLfqN6zRjmbcz4kxjayHe9s=;
        b=uYBL+oLg6Es7jNba2xDLLOHXFQS3VESv3vTJ6F1HxllKVyfsbaDlwPw1FGT88OJjky
         tgpw7gECq/m9b+bBP2vYWZcnPiNZMpEsHGY10NIjHnwsyX6auy4DI7T0lvCit9ofKKvG
         /9d/7vj1B8hpAPionCJV7eOPe2hg6Hde5qg/l3M5YLdYY6fBvSll1j2frNHm2PNGA+2J
         vJcfINUW2Kc6LeOcInS5CfvfDLnT8/vhgDHclHEiMmGND/7JIWWAxXWzOpGSpdXtD2Qv
         TMC5fhzfe6HPRaWfD6KYk+UErpr5wKlWgxaCW/7Od6AlyclugCwAiixtzXLXEGeeeJ5e
         vY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700683471; x=1701288271;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vxoJ2WrN8KtuI3BxSCT4WLfqN6zRjmbcz4kxjayHe9s=;
        b=ekl2gDihzPvKGS368eELPiIrnRB6bgOalgurfKdnNhOjWYR9hWd6/Ixj/Vqy7TcOHQ
         5QdpgXlD+jyv7SNX+J6gUIASRMySoZEs+GQ+U9VjwWLBNnM1YRZb1xWtX0sT6Su6Fpyd
         pZ62yC1zA6ht6dsFVF+hZhtZlIil38eVA/OxXdfG9EL62PF0QC9iRNts8Dx9bWKhQtLI
         7Ju8sYLSnGJlcXaS3SSI1DYilAN2DnxGyS3hv7RGLN4Plapa5XaFMakb6yFfERMMgmeC
         tmUDOHVH0YWQ2jPX9qeSQcQsy3XZ/zOUqSZtcNVDheDhYGB6+Xe6njg6O6oQUOopcj5x
         cPSA==
X-Gm-Message-State: AOJu0YwAyGwgPIBNWYZ36culneG+zRkRaJpR2HgDzOifOzpr0rAMDZrb
	e6alxAUInqIL1K3byu7LLoclYA==
X-Google-Smtp-Source: AGHT+IGHoVufOj4nZYvDHI80PACB0Odp4KmXAYiWrXeeS8aeTV8yPi2pgjfMuFu61pWjHALztnjZJw==
X-Received: by 2002:a19:7015:0:b0:50a:5df2:f322 with SMTP id h21-20020a197015000000b0050a5df2f322mr2391908lfc.13.1700683471420;
        Wed, 22 Nov 2023 12:04:31 -0800 (PST)
Received: from [172.30.204.74] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id z15-20020ac2418f000000b005079ff02b36sm1932808lfh.131.2023.11.22.12.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 12:04:31 -0800 (PST)
Message-ID: <4ebb0e95-933d-4c50-8220-b763698e0169@linaro.org>
Date: Wed, 22 Nov 2023 21:04:27 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] arm64: dts: qcom: sc7180: Add UFS nodes
Content-Language: en-US
To: David Wronek <davidwronek@gmail.com>, Andy Gross <agross@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I <kishon@kernel.org>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Joe Mason <buddyjojo06@outlook.com>,
 hexdump0815@googlemail.com
Cc: cros-qcom-dts-watchers@chromium.org, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-phy@lists.infradead.org,
 linux-scsi@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
 phone-devel@vger.kernel.org
References: <20231117201720.298422-1-davidwronek@gmail.com>
 <20231117201720.298422-7-davidwronek@gmail.com>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20231117201720.298422-7-davidwronek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: *



On 11/17/23 21:08, David Wronek wrote:
> Add the UFS, QMP PHY and ICE nodes for the Qualcomm SC7180 SoC.
> 
> Signed-off-by: David Wronek <davidwronek@gmail.com>
> ---
[...]

> +		ice: crypto@1d90000 {
> +			compatible = "qcom,sc7180-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0x0 0x01d90000 0x0 0x8000>;
0x0 -> 0 for consistency with other nodes

Konrad
