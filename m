Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245938;
	b=1sfnKRg0pJwFTJ792oYYQzhY0LWT7vmG2fhoqhKyh7j9USAjoqmdwpZP8Msq3JuYGV69
	 Fp15G9RBgc0XozsjgjEnl+Dx+BWHXxbb1cRQKg9nvtFB9v4wDcHEjNKFbW0NfHYuOPxyG
	 AfyM4mfsZ/XQHUYn4mcIegM7V2qnwPYaSq9RswpyZpWlh4qh/5zX0CQd5uS9OFVDJ1Jb2
	 /3urQOQMAMA+ztD2BkLb1Bd7xHhyL+ESb5D/0vOp3olN+0gcpZEuhg9nUWDWik7RKbffI
	 0IghQglsarofRiRyNDiduOIMdwJgS/dLv1IyIjuGzm6V9LQEJ6LawjZ+1CzWZdPVMAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245938;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VSgAu1YCz0/TBDQtz025D2yh3sRQq8BFfiF0sq3qrAw=;
	b=GZceK54vRzmcuZJak4RpPkP5wLlDoU3Op9REwBEhtSLzAIOfz5bXtRgFUWT0WncYrWhr
	 xpJI/0Q+v/XvHuO8DemLHs0RU2Hss5Wx30QqYT3JFAvL8yEWPSwMK/YxQ5MRL+igK1Vyp
	 y7EvDM7gD6KRQKCJH19EabZmPkLRpQmF+PwA7+1WyHMNmUluVCiNqdMbRBT0QSKAbrJm1
	 vtizScIyGAf+qpe4TWG3TmKTf3qanSM+3l44Wiw4nwbBoW+Q0y1Q7j3f84Iqp/+1k6L2c
	 2WzfpoaBn36cPoYsp4hNa1Ct9AsjNCH7a03M1hrFjuCeOfhrmphjLLfghlIK3Q1z5jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ET4UmX4l;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26904606A330
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 17:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26904606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ET4UmX4l
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so9893095e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 09:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794245936; x=1794850736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VSgAu1YCz0/TBDQtz025D2yh3sRQq8BFfiF0sq3qrAw=;
        b=ET4UmX4lnrqCC21B5oGoVYsMQvX/uO5ZDK9wo7RPCXLUSHAzor2KKP7C7D4g9dOSKl
         T9tIynx1iZ7nScEbu/rROoW0ihwiLqJhnnQ61YL9jqzvok+DK3S1a+gguxLlBKC8w5O1
         moTFTURhfavgIUyQOJfzNwN7KB0x4LD4UGwaMonewXo+m5sWjx57U6MMJmglEzxfuxMO
         LmUAzY4EtqQeiNxES10G3nMFPkiJj/jPtOOkesOWKBy7x6Ryd1/Cph6kqfXQpWmPijOY
         8IbZFuODa/za16J/GDh0DmEFHyP77cWRenI/CjjMSrzXFx4Mn5aU+7EARh+lKdHOYquD
         rC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794245936; x=1794850736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VSgAu1YCz0/TBDQtz025D2yh3sRQq8BFfiF0sq3qrAw=;
        b=MQQ0OxSw0HdUbVfh4iv3KYqe7mHQfEVAjDiNZirvW6MNMAE3qamkJNlRSf4wAOCBgz
         8GCi0nxsg6GXtqF5J5oRzPn1apswz62PxexbyMz8EiNefWZe8IFDVgZTLWHSTmITSyQC
         SSyv397tleeNvg5NwHZHBlxQ5FJofPUsVu3bBm9QRir2IW0c55VqLpHj1vO+z03CFQZp
         bCjAoR5LqWqugnnkWtLTrV/xdy0bo3DNQ6vK+C8crbjylAnhHVTmAQo+Ea7BU6y/3HY1
         mj1ln4ekDfvlD0QIenJLjrLrWzFE2dZUiABiUFqB43qmexNjYta6eeRlj+HBSl/i1v4f
         gFPg==
X-Forwarded-Encrypted: i=1; AL+hErHzdDFJjGbmpUOTcRE4SwPeZCFFablmTebx51zxzKSEMlmN8JfQTxe6Hk2uOjK9lInnuT8uSguxDev4@vger.kernel.org
X-Gm-Message-State: APuU4Z/hwN3g1Dwgd1hwsrleSnLd6RgL5+dC++SJWP5yjQiS3CJ+v8/5
	clhuVMW1ZLjGOjJ3JxQ1jpoc1HfCuAr11dyoJt77RXQgX/t7og6Stitu
X-Gm-Gg: AYBFou1fSxDjFHlxxD3Edt2ohFEyHoC8l7YSHEL/GFEXLjmwsH4A+npQEGcpfd87+uu
	S3OtG1u3mbdG7Sx+0QgrSmyHDv+rnrtgOXbOkR1qmB7NqW6DEfHx4TBCAIjjNdAne4a0k/EUkn7
	KAH9c3TgIxqrNnYZ4i2AEydLC4uKGBOzl8ifQyqChoseNfPESdnQrRiWfacB1jsoTOUm/Ub87Fv
	KFbquBWG530rURe+Phr157Xr9SEL0gBKf4bm0glgV3Cjve+rZpaGTp1hN3OLeasxofLxmxf1EeV
	I2qPcKERLnMmCT7nSdEff3GpqGQ1EHq5OHV+uufAzYh4cxLtPVF6mzTstOXCML4ZAyZxNW6svh5
	w5gwviZFAwJrzARtolj5p+cczNr6UaZPLb7U23+mRm4wCp5FpVIlqJVTOAwRr73ys3VD/OaFpnP
	QjAgmm8DLqvgEsJHnQgNcXq15+ETOgFIvj9oF/gn3ZUDBOAeqw0pWsn99W8Ufmnfo58TBmAfzJW
	GLLbJGSYC6yaCBwokUEBVP30jqUiUWHNI2u33STUL7CUpdSQYLteAg4aQQc3lttxdwgK3jPTg3O
	QoSDFP5Tcf92l8YVuVg+y6tFL3Y=
X-Received: by 2002:a05:600c:608a:b0:4a0:1b14:e283 with SMTP id 5b1f17b1804b1-4b94d76329cmr92154365e9.1.1794245936334;
        Mon, 09 Nov 2026 09:38:56 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba0157b707sm2522005e9.0.2026.11.09.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:38:54 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Lee Jones <lee@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 01/17] dt-bindings: arm: qcom-soc: Add Halliday
Date: Mon,  9 Nov 2026 17:38:37 +0000
Message-ID: <20261109173837.2084788-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <78a88d4d-11af-40c1-b063-b6a4d4298ecd@kernel.org>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-1-289114ab8197@gmail.com> <78a88d4d-11af-40c1-b063-b6a4d4298ecd@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 09/11/2026 09:25, Krzysztof Kozlowski wrote:
> This should be squashed with patch #15. Also, there is no benefit in
> organizing patches within patchset where patches to the SAME subsystem
> are split all over. #1 and #2 targets SoC, then there is a break and
> again we are at SoC at #15.

Thanks, I'll squash it into #15 and keep the SoC patches together in v2.

Stanislav
