Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795579127;
	b=tco4BGIRsm9hhglLHuiEx8jnLtlYnn7PfiTT1V0OAN/ObkLSnwsbfab9X4RVjw1mXqVl
	 DwJ9M6Y3P0vVi8LaxKwlq7In74OYivAr6020nmUr1YgtKslfLrUTCpIBZvV5MTrDMf3kB
	 WgqlJC4BVGFd2nuWybE2z1uTGWJICUGdLyvMbj6azB2fqYvkbIuu/E+sg3h3aWxPKHGUG
	 LdvyW89FJbK2ul0umHsJqe0WGPMcFcvQEkmavG9YH0UlQrx5gcLlkRVxjV3QqbZSg6V0z
	 Cqh2pfpoCH/PVzX7e9B4uH+J8eQ2HJsB60VD6rNvBcGEDYbsqEnsbFyz8nMVt8BKCsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795579127;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rUSncYOFDalKV12+0CuOreGIfe6/pyEZf5JX4JuwEJM=;
	b=G3dqYqaKUz7fjRIbc5pV/Lss5eFC1lfHDjNrIXZt0nGTTJqePawtfoTRsyYySItZI1XQ
	 U+LUNXA4We3kNt9wlMiqWC134XkG9yqf4FGlI1hdM0r37zdjjtv15ebe/2e6x1O520PvN
	 HmKpcrwTZbTlQO/gFCLi/LI/wudRt0khNckh5fYe80mXlMCmVTk/HPGEoECMuLrdwITIr
	 CJH7F1sqW9D7ib9sbQwef9Pwg90EFLwHWPcMLGr0btXWHwBV8st1sSfXV6YCQiMCVfWBS
	 2s048N1z7QXq63EhkOC1jNRXVGitWpjA+wXFCC+Ixxz2xfKXgEbH1iHDoZnpH8zSZUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=isBXPg8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79945606A31E;
	Wed, 25 Nov 2026 03:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=isBXPg8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0257A1F000C0;
	Wed, 25 Nov 2026 03:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795579126;
	bh=rUSncYOFDalKV12+0CuOreGIfe6/pyEZf5JX4JuwEJM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=isBXPg8VYtB1N39rM3LjkhQAjwIdftUqOM3mYyT/1J4w36E4lbXGN8M0k5O8w0J8q
	 W5HXT7bibsuZj1hoTMHZsUAo+92Ai8nY+FfnTNWSAg1O5Kdc9QuXq0xWkfOGikKr9P
	 qKF2YsKfKpIkrWCv4JIqIhp2xOBajEf6e5a6dJqvqEa+AY5TOaN5us7EcKp/RC36xG
	 NPSqoHNxoWaCMSPKwtmHhPji8riPNJc3AzPbR/pWvGcGU9ywHVNz+MjQTX+mcjcQRi
	 qxpxlujdz8CkewasHRPPioB3/PpqvZejVvR+M1Fku2vQO7OLLqaRFd6tiAv4MbIA0C
	 wEREpbzXfMHxw==
Message-ID: <sashiko-outbox-232541@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/14] arm64: dts: qcom: Add initial Halliday dtsi
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanislav Aleksandrov" <lightofmysoul@gmail.com>, "Bjorn Andersson" <andersson@kernel.org>, "Konrad
 Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor
 Dooley" <conor+dt@kernel.org>, "Robert Marko" <robimarko@gmail.com>, "Guru
 Das Srinagesh" <linux@gurudas.dev>, "Thomas Gleixner" <tglx@kernel.org>, "Radu
 Rendec" <radu@rendec.net>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>,
 =?utf-8?b?Sm9lcmcgUm9lZGVsIChBTUQp?= <joro@8bytes.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Wesley
 Cheng" <wesley.cheng@oss.qualcomm.com>, "Vinod Koul" <vkoul@kernel.org>, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Manivannan Sadhasivam" <mani@kernel.org>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, "Bart Van Assche" <bvanassche@acm.org>, "Bean
 Huo" <beanhuo@micron.com>, "Stanley Jhu" <stanleyjhu@google.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Viresh Kumar" <viresh.kumar@linaro.org>, "Amit
 Kucheria" <amitk@kernel.org>, "Thara Gopinath" <thara.gopinath@gmail.com>, "Daniel
 Lezcano" <daniel.lezcano@kernel.org>, "Zhang Rui" <rui.zhang@intel.com>, "Lukasz
 Luba" <lukasz.luba@arm.com>, "Georgi Djakov" <djakov@kernel.org>, "Sibi
 Sankar" <sibi.sankar@oss.qualcomm.com>, "Ulf Hansson" <ulfh@kernel.org>
Cc: devicetree@vger.kernel.org, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, olteanv@gmail.com
In-Reply-To: <20261125-halliday-dts-v3-13-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
 <20261125-halliday-dts-v3-13-5c8311c0b70b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 03:58:44 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] arm64: dts: qcom: undocumented qcom,halliday-cpufreq-epss
  compatible
- [Low] arm64: dts: qcom: undocumented qcom,halliday-tcsr compatible in
  tcsr node
--

commit 86c1934f0d5f1fa3256ca9a1cc6c46f37f79e659
Author: Stanislav Aleksandrov <lightofmysoul@gmail.com>

arm64: dts: qcom: Add initial Halliday dtsi

This commit adds the initial devicetree source for the Qualcomm Halliday
SoC (SXR2250P / Snapdragon XR2+ Gen 2).

> diff --git a/arch/arm64/boot/dts/qcom/halliday.dtsi b/arch/arm64/boot/dts=
/qcom/halliday.dtsi
> new file mode 100644
> index 0000000000000..a3207c0c8d4b2
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/halliday.dtsi
> @@ -0,0 +1,1871 @@

[ ... ]

> +		tcsr: syscon@1fc0000 {
> +			compatible =3D "qcom,halliday-tcsr", "syscon";
> +			reg =3D <0x0 0x01fc0000 0x0 0x30000>;
> +		};

[Severity: Low]
Should "qcom,halliday-tcsr" be documented in
Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml?  Without it, running
dtbs_check on any board DTB that includes halliday.dtsi fails schema
validation on syscon@1fc0000.

[ ... ]

> +		cpufreq_hw: cpufreq@17d91000 {
> +			compatible =3D "qcom,halliday-cpufreq-epss", "qcom,cpufreq-epss";
> +			reg =3D <0x0 0x17d91000 0x0 0x1000>,
> +			      <0x0 0x17d92000 0x0 0x1000>;
> +			reg-names =3D "freq-domain0",
> +				    "freq-domain1";

[Severity: Low]
Should "qcom,halliday-cpufreq-epss" be added to the v2 EPSS compatible
enum and two-domain constraint in
Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml so that
dtbs_check passes on cpufreq@17d91000?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-halliday-d=
ts-v3-0-5c8311c0b70b@gmail.com?part=3D13
