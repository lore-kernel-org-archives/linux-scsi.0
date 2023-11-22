Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zWD4RCs5"
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A8DA3
	for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 12:03:53 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-507adc3381cso113678e87.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 12:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700683432; x=1701288232; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Io/gjQ08AuDbFAY0fMf9d/V1TR/FZrGyaBoM54Wv8Dg=;
        b=zWD4RCs5NskLi+UE+EVMUMu5jlQmQP6K7m3XpDfIQRP9NeqpUhu6viK9B+ISp5I+tU
         Qa1WQeqaUAW7jUnw0MF2UtFseCh7VuYGVg1aRtRCth91d89TMmBFqk5KpLbkI150Vhaj
         Dp2uTS8UTXKcbXboZTj76d0rlpKT9qwQEp4VNNJHhpQOHSBN2yjqiJQQu+6DEg+pCPdb
         gfGKJTX+a/FugNyewoqDHBmORDQVT0El7r2ESZg3e5LaEFHPRnS4lsarmXRNlQDFWFA/
         n68REdwg91HJ7lZl+xNtnSBe0+9Pis5CUan4qyiKUOy2TsdHnrEzA7Am/zsPP5SxihmL
         7O0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700683432; x=1701288232;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Io/gjQ08AuDbFAY0fMf9d/V1TR/FZrGyaBoM54Wv8Dg=;
        b=fDHEwt5qepwAw1kCikOfjVk7Z+vzH0XvgUb0/h940SkXw70ShmVGhvvO/jP87JXwV7
         QuN9Eogr3dgC26hypOPBfBL2BLnVmiS2t7H2bhPvtwwoWk72QUprSq5myK56adMBYouI
         3ezf720FqPiSrE7JDT5tSoHtiQgS58rhMrIAYoJWATwCACOQ6TkNDZY1EfiUCcNnGn4j
         AQjVnfXIRcT5u1HOMKFi/W6FkW+IpvyOZ0HklIWWacQBHvYkKdTKfewSRkwnACTQVHsK
         8djkdZZ2Paj24lmtURcFnpl8y1pYP4EH+K+r3Idz4kRFF9mOAoW8G8vUetf0jsl+7RNp
         NF8g==
X-Gm-Message-State: AOJu0Yy5djdOIDjWV+vhUMw45IrRlZSi12scdrCtVQeOtDP+/Jukspmh
	QqIPBRBvFTD1CkbytdnFBJEVAQ==
X-Google-Smtp-Source: AGHT+IHz/4Br/9+seo/Lrak4kInlCaTk0gNCYlhXMZj9w9gtMMfU7nZufobL54nVG+7FpfSZWSIVJg==
X-Received: by 2002:a19:c511:0:b0:509:e5a4:2af2 with SMTP id w17-20020a19c511000000b00509e5a42af2mr2294279lfe.49.1700683431515;
        Wed, 22 Nov 2023 12:03:51 -0800 (PST)
Received: from [172.30.204.74] (UNUSED.212-182-62-129.lubman.net.pl. [212.182.62.129])
        by smtp.gmail.com with ESMTPSA id z15-20020ac2418f000000b005079ff02b36sm1932808lfh.131.2023.11.22.12.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 12:03:51 -0800 (PST)
Message-ID: <1bb81371-e829-4e02-a234-02f84433f4bf@linaro.org>
Date: Wed, 22 Nov 2023 21:03:47 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] phy: qcom: qmp-ufs: Add SC7180 support
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
 <20231117201720.298422-6-davidwronek@gmail.com>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20231117201720.298422-6-davidwronek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: *



On 11/17/23 21:08, David Wronek wrote:
> The SC7180 UFS PHY is identical to the one found on SM7150. Add a
> compatible for it.
> 
> Signed-off-by: David Wronek <davidwronek@gmail.com>
> ---
Should it not reuse the 7150 compatible as a fallback then?

Konrad
