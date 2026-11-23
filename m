Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435603;
	b=J5fGYflUNZOYgjZt5X7UuofJnThMX8TEUky6Bgm53lTkvy+ip7xr9iaAao9nn7G4XPm8
	 JzkC25Yon6DXzyiTJ+11HtusG52UFZB4e0ncxGn0EyW/XMn/brJdml1JESU0R4QvNI3K3
	 WMyFWDinhSyBi7GhE1dPFBjAh8ztqqy660OhwBL4JZvFGuNt4wUelFTCcvMrWBDOz3tDY
	 khTJ7e2dKsKpy0a3rxqMg+SAJM7AFyh9CTJ3Mc/tOwpJ/cCdqnnBhG9Pd1eLmGVoINCqY
	 +Gktchi2M6G3Be1FqEhwwfbLfdlSLGIbcbFaKOos4bl0AikEeHtmnGrPDtqlit2BdCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435603;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YcMb+PLs/AWZj6CMeHYvkaPehmudD/DmEHA3ZbplGK4=;
	b=TyUMIrcVF98PErYP0gtg35n+uR1oS8juxX4xi6YmmiJ+G78tboUQrP9g2Dz2cytb0T7C
	 yriW5eHjLN27aI1V+/2/8ITCvG4wReFgmynXSEkzPSIQZ4pal0fuE72Ngb0wYAbLisz7i
	 i/Wv/2uqYiGLGPdTzEAmLyDX6+BJVETTvCUHQBfj8GIwOfXhLMVo28yfG4HalgdxJ7Xci
	 xWwbHcje13XXfeoPIqQZqyQV8gR6OaQRgl+fHmvbbs6FoskPudeuwuupcZcBirOYOy6lK
	 uR7bR4tvEZkULYhnlvR2Mcv7QMA4SFOvvoqlwoP65jw7dy5f+dSEESYqnN88qAX4SgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScqeuJIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3651606A327;
	Mon, 23 Nov 2026 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScqeuJIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE861F000D0;
	Mon, 23 Nov 2026 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435603;
	bh=YcMb+PLs/AWZj6CMeHYvkaPehmudD/DmEHA3ZbplGK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ScqeuJICiSa3yA0PGnXYuPrVQpQGvFiqYra0ZrcRbjqbchIMnB2YmFxs4mOzXVt7L
	 yY4P7wQAFA23kn7IQc5LBKacbRLjf/QsGRqCOdSTtaYlPhzAQZaxZ/MoqXGBRTqE63
	 zQzwaIYPHLy7kt1cxhJuZvBfEK1WvWs/i2O5kZj7i347L4qlH6rZqXudyRE4N1jHUe
	 yjudaXrmmJ1jAI52px/2ikKpC+qc/AUTaJN7t0Ag7TXUrHdFSJzTh8y74J+B+ebX0P
	 G+eMQk0g44ctWuJOKzNAtU68QrzbujZN5/KyWR0h10mxKH8fC3xgoB5mt5nzHtcJIQ
	 B75cTRP3G+ZWw==
Date: Mon, 23 Nov 2026 13:06:40 +0100
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
Subject: Re: [PATCH v2 06/16] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
 Halliday HS PHY
Message-ID: <20261123-azure-wolf-of-whirlwind-43caef@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-6-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-6-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:22PM +0000, Stanislav Aleksandrov wrote:
> Document the Synopsys femto USB high-speed PHY on the Qualcomm Halliday
> SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

