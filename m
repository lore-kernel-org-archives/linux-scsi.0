Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435173;
	b=QqrisjWTNEt0gT56PhoISAoxFkHXN9RkzgdP2Ck7e7zKjm4/QbDW4S4p5obRGCu7ssaF
	 Q5dgiDpP//SwnxKHLaffPr9mtH1guOr7oOVVqhwBPUchwPhIHNFhRtexLPnY+DXeOGeZ2
	 8DOrlSmOz8YovtmuYhsOiLyD6yfKlEU5vZ2cgR1UsBCu/AKLFZDSVDDZ7lYFmI41gYB4K
	 3Rb06JrjSazp3vhvGBs1tR08QF6XDSnyK+RkexxtawuLQyA5xyhcYmpyLcY9HtaMjNX7K
	 GH+MRrnB0JemBaqFvKpDRoWOITKXPd8lhNaCFfUYs4Gvsn+NtVwZk/uv8/MRBFp1rRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435173;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WMhEUhdeAFlSicfRRTfApEYeOqXkH8+a1r/iO3xzqW8=;
	b=uzu1YWQxOoaee+ImEKMVxcz120ThxTGjgiWxH7erjaHkzn3qs4zPj54+xI0/+4L8/GVD
	 yp5XPb0zdLGKp9REuxHH/bfCu93RgmhqkF91TWvmerPxp9k1/Fhm5+zc8WM1uFpgg8rn1
	 OpZ5z/fOb4REEabRE3dsm+FJkCl+QYW91MRGWsfMizdffg+t+ospR+mrTrp5+jzHByUHh
	 Ut1z+PPSMP+aF2D7jzah9rOwHv/1l0wFoV47T5S2OZh4sb8SFVJJOWJljQcFvQTaZg+uU
	 19ZkmPC2elcxAmdKJ+b5KFT76r679EVSDb6vtHg5letPLqcf/c11NHfJtwCqKyKBFEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DS83tKDB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D3C606A331;
	Mon, 23 Nov 2026 11:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DS83tKDB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079911F0093C;
	Mon, 23 Nov 2026 11:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435172;
	bh=WMhEUhdeAFlSicfRRTfApEYeOqXkH8+a1r/iO3xzqW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DS83tKDBJxjSPlL2eC8e6Zvjmxbn/amPwEVsuRuoWVGcAj/+EuTDbKwA3bOW2fK70
	 qBqGCvahuU92TARH+7Yl74So5W6LpyDqWxpOwWFjNdWqbZ0RZ6J8Xqhn+6fVP/fDdg
	 HscngvhevobAt7D0L9U7FFGLfA7n2PvtC6zVqFGCYIZH5WLtvF9Uva9U/GqwZaqfcS
	 FohksPgsAGr9DldrpFnzXVYBEpDHRxYQW6OZGv6tRoxN7iCOcJClOu9MzOjqDEiEPh
	 XfFBcD1/Xa9k5mj8H/iGCbri3PqqTuWE1vCNN4+Yo540uCtM67NeFpj2/NDUr0nFCE
	 GT33q2RHgqNTA==
Date: Mon, 23 Nov 2026 12:59:30 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Robert Marko <robimarko@gmail.com>, Guru Das Srinagesh <linux@gurudas.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>, 
	Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
	Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 03/16] dt-bindings: mfd: qcom,tcsr: Add Halliday TCSR
Message-ID: <20261123-bald-sparkling-vicugna-cde8af@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-3-2c92438c6c46@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116-halliday-dts-v2-3-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:19PM +0000, Stanislav Aleksandrov wrote:
> Document the TCSR block on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

