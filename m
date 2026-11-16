Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865224;
	b=j7tPNSfTEH/NN4DnLG2If+oAuWTKeaZbnzRMlK5gvuhPAd0uMqx1m3uLGV7co2zwvne1
	 XsQWrfLRGn+6RvhskKla3ZymCIFYXMeVJfg+VWL5JhnBSuL6jbLxRxL1akTalb000pFgB
	 Mf6ywn+LVbP6HU1B4AjWVJihiTactVC63/ECFSe8CsPWJUBx5IaBrkKXAeYsqkpPaJeT5
	 mGnKiJIJ1MTM3sDvCNYEvtqxXOhWF+vjnXG7pwJCYfKgt+k3OHge+Sk1vs1r/lLDcz7L7
	 y3l2VVTeEV5xDDmmIBVgH3SrEcwMrX2fBIHU5gk4YnSOSmVl/8z0V1T29na3ujiPtag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865224;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4RYV0U5y2gEEfaOBMXxvhBpKDkAMS/N8y4I/IouMi+s=;
	b=ggX1tJpTmY8ZSURH2C+yjojOuEd3xBSK8L+wBfVIJxn4Pvk0Aw0IXqX6XoUDBaezrzFp
	 tEH0pFcHCquKsiUpR/uUlLa+OjDegIgGAQTVHPCPhZfKSjEmFwPxSyc7l4sSNOrQxfqq6
	 agYh+Q1YOHBEpUgu+BUcmtgpC7vukOyecFifiZ+RCEFbmJ00dP4f+GV0wLcb2ixJ6pK++
	 jXwsYihjp97xtqexht1UM8pEEPmi6WlCHitm1Lm4EVfI7vYdUSWDUFvxAu+xDBhZO0aWG
	 xv59J9vh0Nt1p8sMSOhjuaf35dORIiYS40lhnoZ/cCSXWN/2vrCriALR3gb3U1O+fLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOdOeyel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173D0606A31C;
	Mon, 16 Nov 2026 21:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aOdOeyel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C421F000C4;
	Mon, 16 Nov 2026 21:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865223;
	bh=4RYV0U5y2gEEfaOBMXxvhBpKDkAMS/N8y4I/IouMi+s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aOdOeyelYAfPwz2W+YstEJYH+kSp4WUrsFnukZQ75OlIR6peWJ3YdH4ZCgRnxv1mC
	 La3GGIy6SB7RGI8/qaFXt+vhn+gBonqG1uHAbQuOKcg2IsHxrsHS7geYYw5na3piMb
	 QJksPmKozqTMGe3mFH7+x8/IY/4e63gqvmsX8DeAkdl2GJtdyTjVQowshrYdup0ypp
	 /r815KDInYrHPcvWf+g4rTJrE8yHhlQvienYjc9Ul0M/6GLZHl0PJXn2wmyUPL/Hdh
	 WkdwDzP90OXI4N5N/qH+txNrie5XbDgwGBipJ7hYOd7zaAzQV2XcFli80gZnOfVINi
	 HsVRlTxzpEhBg==
Message-ID: <sashiko-outbox-217738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/16] arm64: dts: qcom: Add Samsung Galaxy XR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanislav Aleksandrov" <lightofmysoul@gmail.com>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Robert Marko" <robimarko@gmail.com>, "Guru
 Das Srinagesh" <linux@gurudas.dev>, "Thomas Gleixner" <tglx@kernel.org>, "Radu
 Rendec" <radu@rendec.net>, "Lee Jones" <lee@kernel.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, =?utf-8?b?Sm9lcmcgUm9lZGVsIChBTUQp?= <joro@8bytes.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Wesley Cheng" <wesley.cheng@oss.qualcomm.com>, "Vinod
 Koul" <vkoul@kernel.org>, "Neil Armstrong" <neil.armstrong@linaro.org>, "Manivannan
 Sadhasivam" <mani@kernel.org>, "Alim Akhtar" <alim.akhtar@samsung.com>, "Bart
 Van Assche" <bvanassche@acm.org>, "Bean Huo" <beanhuo@micron.com>, "Stanley
 Jhu" <stanleyjhu@google.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Rafael J. Wysocki" <rafael@kernel.org>, "Viresh
 Kumar" <viresh.kumar@linaro.org>, "Amit Kucheria" <amitk@kernel.org>, "Thara
 Gopinath" <thara.gopinath@gmail.com>, "Daniel Lezcano" <daniel.lezcano@kernel.org>, "Zhang
 Rui" <rui.zhang@intel.com>, "Lukasz Luba" <lukasz.luba@arm.com>, "Georgi
 Djakov" <djakov@kernel.org>, "Sibi Sankar" <sibi.sankar@oss.qualcomm.com>, "Ulf
 Hansson" <ulfh@kernel.org>
Cc: devicetree@vger.kernel.org, mfd@lists.linux.dev, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, olteanv@gmail.com
In-Reply-To: <20261116-halliday-dts-v2-16-2c92438c6c46@gmail.com>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-16-2c92438c6c46@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 21:40:21 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] arm64: dts: qcom: halliday-samsung-xrvst2: invalid chassis-type
  value headset
--

commit a88ca65d1f6d17d4cfe0ce907c523f8698e465a8
Author: Stanislav Aleksandrov <lightofmysoul@gmail.com>

arm64: dts: qcom: Add Samsung Galaxy XR

This commit adds the device tree for the Qualcomm Halliday-based Samsung
Galaxy XR headset, with initial support for PMICs, keys, USB peripheral mod=
e,
and UFS storage.

> diff --git a/arch/arm64/boot/dts/qcom/halliday-samsung-xrvst2.dts b/arch/=
arm64/boot/dts/qcom/halliday-samsung-xrvst2.dts
> new file mode 100644
> index 0000000000000..6fcc1aaafd59c
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/halliday-samsung-xrvst2.dts
> @@ -0,0 +1,218 @@

[ ... ]

> +/ {
> +	model =3D "Samsung Galaxy XR";
> +	compatible =3D "samsung,xrvst2", "qcom,halliday";
> +	chassis-type =3D "headset";

[Severity: Low]
Does chassis-type =3D "headset" fail dtbs_check validation?

The Devicetree Specification and dtschema (schemas/root-node.yaml) restrict
chassis-type to desktop, laptop, convertible, server, tablet, handset, watc=
h,
embedded, television, and all-in-one.  Other Qualcomm headset device trees
either omit chassis-type (sm8650-valve-deckard.dts) or use "embedded"
(sar2130p-qar2130p.dts).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-halliday-d=
ts-v2-0-2c92438c6c46@gmail.com?part=3D16
