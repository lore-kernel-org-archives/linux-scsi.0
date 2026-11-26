Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660722;
	b=EBW67E2l7jlz0YyjEkxhdKTLq7XP6Ulxtg6ixI5M8R3m0dpCGfHrHQFtWmtOxX26O3Hw
	 1u5qrsMCxEGnLo1I012VqSH+YfYykylm8p7Qcn1qpx/K5KBd2dRWZFMU4wtb/Dzxvl6Mf
	 D89H5EXAr8VV+RNJKW/KybG3vjLD0FU5YX42CfM20DgeBCPsNcZoO+RMPbwlCe9Mxwu5k
	 il0nFRNFyqN6Qtj+Li6VZg/caGK2W954zQDPa9tsNq1ojy1F3dBPJHeozc6YkriiDU6om
	 p+tC0WJKElOJUIIPnmYOh8EsGn2eOWVv2n4mS6xRWJKEuhnYJFu2HnGAZoVRI8Y7LkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660722;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=FrsA9VM2RRDYw3dIWHPlcPU2Tzr0ACPscINTsZ3wYKU=;
	b=WWMIasQGqN79o41MA1tXSiyHnwKxIHRBBEJn4KeH6a/X6eZVTFauFEQKdCwFrw1+2ZDr
	 YSEf+Tf87qJs44tTna9Fpy8dAqpYmUuEFx8bWK7+4/JroIrJ3swNkrXDN+8zffwmiewNe
	 UIPkCtAacP2ctc15Jld8SN0DPdo2Q51RLBzJDIkniaGV+DBGokBnL662U4GSZFelRah1E
	 s0XO1Ufq65pN4bIwgYSAUY7Ockt3WqXVo/414cLtd9mfFMflIWrxHm5EDrWh57hmOA3TE
	 04ghyoFogXcsjJhhCwWzvAuVJvj2Cz0jQZwHout0TeNA0Z0jFjUwyVwnbHHeEECSAvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bQ0PGikm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5E2606A31E;
	Thu, 26 Nov 2026 02:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bQ0PGikm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E091F000C4;
	Thu, 26 Nov 2026 02:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795660721;
	bh=FrsA9VM2RRDYw3dIWHPlcPU2Tzr0ACPscINTsZ3wYKU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=bQ0PGikmMVpCXzr2+ogQGCzmWiJsDojV8YuLw94SOoEP+6af4SDkg1Hz05ayFBKaU
	 T2Kkn6ace5P/sBOVer3k6SEGH0Ev/B4bIxNUbkMzLaVWTX2m84EjwxigZ9zr7C5ta3
	 Io/6ySL6xk7/Wb0+RLCQabC0jimBgxFCnQtIxULviz7f7YZ0WX+nGUMUl+NqjmIh09
	 S4gN31qaEurmnHa5pYbcSItay35YwpXukelvdSK/KB8u3jxbJ51CUjMQpidqSu7hwC
	 vP12nZVTa+DWYWW3MwC5TGg10y40os0eK+YRpCmXvbizboj6O+CuHCfcEKzmPUCQZF
	 gIUMuxcOfUvVg==
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>,  Konrad Dybcio
 <konradybcio@kernel.org>,  Abel Vesa <abelvesa@kernel.org>,  Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Conor
 Dooley <conor+dt@kernel.org>,  Robert Marko <robimarko@gmail.com>,  Guru
 Das Srinagesh <linux@gurudas.dev>,  Thomas Gleixner <tglx@kernel.org>,
  Radu Rendec <radu@rendec.net>,  Will Deacon <will@kernel.org>,  Robin
 Murphy <robin.murphy@arm.com>,  "Joerg Roedel (AMD)" <joro@8bytes.org>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Wesley Cheng
 <wesley.cheng@oss.qualcomm.com>,  Vinod Koul <vkoul@kernel.org>,  Neil
 Armstrong <neil.armstrong@linaro.org>,  Manivannan Sadhasivam
 <mani@kernel.org>,  Alim Akhtar <alim.akhtar@samsung.com>,  Bart Van
 Assche <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>,  Stanley Jhu
 <stanleyjhu@google.com>,  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,  "Rafael J. Wysocki"
 <rafael@kernel.org>,  Viresh Kumar <viresh.kumar@linaro.org>,  Amit
 Kucheria <amitk@kernel.org>,  Thara Gopinath <thara.gopinath@gmail.com>,
  Daniel Lezcano <daniel.lezcano@kernel.org>,  Zhang Rui
 <rui.zhang@intel.com>,  Lukasz Luba <lukasz.luba@arm.com>,  Georgi Djakov
 <djakov@kernel.org>,  Sibi Sankar <sibi.sankar@oss.qualcomm.com>,  Ulf
 Hansson <ulfh@kernel.org>,  linux-arm-msm@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-arm-kernel@lists.infradead.org,  iommu@lists.linux.dev,
  linux-usb@vger.kernel.org,  linux-phy@lists.infradead.org,
  linux-scsi@vger.kernel.org,  linux-crypto@vger.kernel.org,
  linux-pm@vger.kernel.org,  Krzysztof Kozlowski
 <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v3 07/14] dt-bindings: ufs: qcom,sc7180-ufshc: Add
 Halliday UFS
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261125-halliday-dts-v3-7-5c8311c0b70b@gmail.com>
Message-ID: <yq1tsl4jp07.fsf@mail.kernel.org>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
	<20261125-halliday-dts-v3-7-5c8311c0b70b@gmail.com>
Date: Wed, 25 Nov 2026 21:38:40 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Stanislav,

> Document the UFS host controller on the Qualcomm Halliday SoC.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
