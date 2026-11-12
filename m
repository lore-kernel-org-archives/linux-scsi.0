Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794484368;
	b=FWhOcBH8gA/qLGc2/VtFjZs2Cl3FwseaT7iEMWGaz6JTH30fh5l8VFWecFKTGRBv7YkB
	 WJZemZNCl/rZhf5bx2/4ZQ9LKxesJRJNL4bAqGx2XWUTux1GGUd7OE5bEXcwzwhflypL/
	 48Q1W8D5sSBuVdWrVnmE9AHdiJCqCkPSXZerAJqOmcIO/23MpZz+xsjItCt5R4x/WH+5k
	 APm4kKREwDfysgAN2u0Buf6sJC6pe6Eqs6JlnJ+B+GmCa2dg7d2LoNvANgmiMeZzi03DE
	 RezU2J31VMQCFK7FiN13aDcA5podQ77joERcbzP20Qqjhs10fRwBWjJp2I6b0Ph8ovA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794484368;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ab65Y+/YS/ftn0XtRf+D21POuuZDeeWSaeiwjaGmWKM=;
	b=Dk1YwI5CFPnQpABSCxNcrJ9903L85NBkNO+r2arbu9XBA1zlNh0GLcZ1utBxpAyIFlPu
	 PrV7J7Oi+VGFzAgvPmBSbnqjzXEKKRKmkJeSYSuOKydUtAPEkjheaChb78+ZgaVR+ynPv
	 TpiCkKq9tIbZwd4Jqwp7LEnH/mU1yoOB96M/pwbgXqJQHu7EhxbvsGPTLHTc1lIe5nzRD
	 vfKJdMMdR9njaMvVSGltAvi8ywoppnGrqYJwv1avFhLcw84fnB4bGayI6tXEI6WW+6aDe
	 WlbUYfZpfIogeuvXjg+wS+wmbgUaL302sADJnmGd3FHVXFkRAwKZUWPfCLSqJN20bsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JciomXZa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06967606A321;
	Thu, 12 Nov 2026 11:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JciomXZa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF661F00A05;
	Thu, 12 Nov 2026 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484367;
	bh=ab65Y+/YS/ftn0XtRf+D21POuuZDeeWSaeiwjaGmWKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JciomXZaUjqGr0rn+i52tzTnVMKf61Ev/r6LPScfy3/DHjKOGHeScELqCPIMBBPlE
	 ctID8uzarSzJ+lo7upBGVmq2V8xtl5tnfs/cB+SqHYLHbajDMl3JXyuXoq6iIMGLaS
	 P/y1+WblHvuQml3Bi8eNhvWXoq1nttW3GnSWLFokZJcUeOM6yIoklaaYb3p4yq09r+
	 kwLPkSBfkFsF+Tiucs3ZfCvR/I4CEgOuCSjcFU0Xwm5gWwbn/fGHeHGO2k6DhfnfU7
	 DuXsXuV9XgADgIxMopbBrjiRn2Fm6wsL5HTd3PVU2pQnTVkJerK9EXIz1ZTrThwqaH
	 di4aUgCf/gR1w==
Date: Thu, 12 Nov 2026 12:52:44 +0100
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
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mfd@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	iommu@lists.linux.dev, linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 02/17] dt-bindings: firmware: qcom,scm: Document Halliday
 SCM
Message-ID: <20261112-fabulous-nautilus-of-joviality-dd8d5a@quoll>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-2-289114ab8197@gmail.com>
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
In-Reply-To: <20261109-halliday-dts-v1-2-289114ab8197@gmail.com>

On Mon, Nov 09, 2026 at 12:33:14AM +0000, Stanislav Aleksandrov wrote:
> Document the SCM on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/firmware/qcom,scm.yaml | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

