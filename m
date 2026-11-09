Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794185826;
	b=SKfUbROtKzwiB5s/96Hf/47lxvNGh/pEUtpnEKKOfCtmxegs+tbTdSXbFJtXnQgRzR9m
	 zaR/l9rWb8TEGXx8FWacL9lVRXN4qpe9hPB6mLBSNGXKTehip7pLZLhkRg06/qx51ESM2
	 f5Do5xwomRrI+R+Wv7285j0H2ZqVKfnY8DkGKmxynrJ8eI0CDcUKmRmde7hQDHpn32AEo
	 qjrCduojldnrooBt+CcauUKCoec66WNLEhE/tbGEhtlR7baeLeSeNiJnbKo5np2jD1k4V
	 f8NGt0duX3AJ+GkmsSrMaIqp7zz66/UiJY13L3J0Nk7DJhLq+yihU7uuxySGzBKHNEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794185826;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UgV8KA7Cu5ZAaXYWYDbHu7HAyaZ/X9DN4CiRecqVryU=;
	b=aLdUk17uPBWBXdS5sEQp3J9GLCyz9+6sjdNfqpAkFFURhSLZxyLM7rMzdMqGV8qQOIqS
	 cklxu2j8Pe7lJFugibXVWH/DzeYW8hWQpoUlO8nZaYpF+Jp3YTDgwi12iJchTvBZXIYdY
	 XTRS/W8eQ3ZRcpUA8n885zM+ty6g/Y8PC0TO+LoJhpL6AKICwCqASxtTLrT3Wf9lKtARX
	 83Pxrg07Ikix4fyBW/MJyCiLyoWlcFhJric5rhYsiF66Q4PCn8MBW/9TInr9FiwLAXoyy
	 UlmEWCEghMFmVKbzaNBNt0rbWhtleY0a8DG6SXk9Z8isd27IksogEK4QUtYBullHR5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aCLHo9/6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F38606A320;
	Mon,  9 Nov 2026 00:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aCLHo9/6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0461F008A6;
	Mon,  9 Nov 2026 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794185825;
	bh=UgV8KA7Cu5ZAaXYWYDbHu7HAyaZ/X9DN4CiRecqVryU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aCLHo9/66kPxeQ3IlSV3ZYw9X11Y8ElsAX6H6zq2gRhS8i5w9QzUtaTRIqcLj2c50
	 wNcZ4HApf8c6WjEaVg23WQXbHYNl8X46GGcsTFdfb6z8xL0XwRFd0J+psV6dMO79/O
	 29Pfb3DCr22DF0WYm5d5fSq1p2OfWoH/5R2VwlwCchRLYS3qrMsut9/Ly1LALQRaE/
	 ZT7EdN53KZ7DzAn7nuB0As9a6t9BGPo4vMoa44LJhlNwRTzQ5Bgu3qZhDQFXAM0PFd
	 /bFuGsUALoDM0/f5WnN/BWYUh+vnJF4STVtD2OLic8D//ycbHylWRDxUpBqWSSME/W
	 t3ai4PjYZ5fWg==
Message-ID: <sashiko-outbox-204265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/17] arm64: dts: qcom: Add Samsung Galaxy XR
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
 Djakov" <djakov@kernel.org>, "Sibi Sankar" <sibi.sankar@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, mfd@lists.linux.dev, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, olteanv@gmail.com
In-Reply-To: <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 00:57:03 +0000
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
- [Low] arm64: dts: qcom: invalid chassis-type value in
  halliday-samsung-xrvst2.dts
--

commit d2d9cbc7744fd9c3d95a63b1d3df85d5cbe99afb
Author: Stanislav Aleksandrov <lightofmysoul@gmail.com>

arm64: dts: qcom: Add Samsung Galaxy XR

This commit adds the device tree for the Samsung Galaxy XR headset based
on the Qualcomm Halliday SoC (SXR2250P).

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
Is "headset" a valid value for chassis-type in the root node?  The
Devicetree Specification and dtschema (schemas/root-node.yaml) only permit
desktop, laptop, convertible, server, tablet, handset, watch, embedded,
television, and all-in-one, so dtbs_check fails on this DTB unless a
standard value (such as "embedded") is used or chassis-type is omitted.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-halliday-d=
ts-v1-0-289114ab8197@gmail.com?part=3D17
