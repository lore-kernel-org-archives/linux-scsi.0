Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435594;
	b=fSiML7YRvZP4YeQnA/cAHk7sm4i5HUmnAsf5SJNG2h6fqH8m3gC9+EATtfKzpCy0LB5e
	 HSg4FUdau0eJ5t39ToEJtwRCBpLEPWNonBWT758wMIbu0sZaa2KCyZdgPLHBxjjHuKjDz
	 XtlTJ4hXpcy2ZpNuRpm/zy3tATehD204Jt9Pu84o9onDYvRmgQjwE8C0Eyiko06EPT4fu
	 KvCeAkLQm2iY4cUCcmRvIYPsRp0yVbY9VnaRu7NxU8KNXcqUMmElcrlpTu+SPEvxKowx0
	 mb0SE6MdVgJao1S+QivxeRw4byLqSXERKxdwXQzp0VDNZ6Tk2Oh1nUJNFDcT6+yX+Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435594;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fU0qgGX6rvDQa6Hs2GlCa9ePVhgC0MKqV7droMC1ftE=;
	b=hZKfc/32o3hm7cNfit/jGXVSAPW701h4rQuHA9iHBlEoedZqlIb6jgvk7HCYA8aWnGJM
	 bygmsOK1XBf3/eawAUvMqrWOgyu3GFZAQN9fkPr/sfGm0SeNxUhzMSXDKklgauWHNEjDT
	 qx4hqAaq0WgqQT96Tx0KEaMRncibuteS64wEUxHGB5aMd2dlS3P4qt/KJ358VO2CKhvbr
	 fHWHwPHugsodc6fBR0ac6+pUcWwREHI9q9k/XYpMi3Kzw+C3LvskWAXIdiowRiKSGduID
	 mFUvyXII0BZuLujKvUcSjRcLv9HWz0amXQtrgDMIOkPSSgYFAtOaO8SSdn3eQ03231w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvkOvvVL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568CE606A31A;
	Mon, 23 Nov 2026 12:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvkOvvVL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45951F000C0;
	Mon, 23 Nov 2026 12:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435594;
	bh=fU0qgGX6rvDQa6Hs2GlCa9ePVhgC0MKqV7droMC1ftE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jvkOvvVLjNnnARXxCGjXocJep2IHYAS5xr97CekeRfZqkxcyNIittO7p7o5Z2Po2U
	 j+W0OBWU7/+D1HwZtwzqRhsIc/N0TpXgsv2yRQuf+hid+1mROTjg9REZV7h7UOsCIK
	 kmTlgo1HhVKzON+bjQ3wy6EuB4QXwfvW5fYM7ZDIDOHXknOGQjn7dF09n8n+3wLUYj
	 sICuXcCKEaXfQDx9zAg5yrYMDkRg/O/6K9TP26Ac384R5KJ+oTWJuBZ3mtBrDIxU5D
	 COJ6Jbn5nvsnLGN1eMWRar3a/+FPn2E7T2qBtgLdVWZ8TlKdm7L0/Ltpa+TlaThTy/
	 8HSdscy6zICEw==
Date: Mon, 23 Nov 2026 13:06:30 +0100
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
Subject: Re: [PATCH v2 05/16] dt-bindings: usb: qcom,snps-dwc3: Add Halliday
Message-ID: <20261123-uptight-zealous-tench-ccfb03@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-5-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-5-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:21PM +0000, Stanislav Aleksandrov wrote:
> Document the DWC3 USB controller on the Qualcomm Halliday SoC.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

