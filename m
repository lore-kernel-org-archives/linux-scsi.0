Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795435770;
	b=XXhLloZaaJBAt9wcFOaSnDiNidoz9X2K1volD3gl8nzH9fgJ3ud3k9Kc9b9sRUCF5DrK
	 SRNqBoIHASJvLd592zw2yokq7b91toG5rbcgpc7XmhTpOdP2pplsrNjUgm4rtTwgqkfGx
	 TnfrGfS7ZZVQ87v9YukJcNTpYxzDNVH0Spp7qx9yXoKSbtCgQ6/Ol/4bqmJ8ysg6kWlwh
	 oc1LFUgoHNEbqyy9i4kUrCdKkqaHIwqgCyRdGXbpEl569oLbPp1t79+X4lM/aSoJmzBq3
	 naGIRQG8/0KrpPLrXDgbEhIgIhTTTSKPqeKN4SJDHybZ1S3LYlScdxmJISZCAAJ/VJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795435770;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EBAlgyArUaIDoaFWbczuSy+qeFGqGHKDwrHB/xbYHXM=;
	b=To38sXSAfvBcWj2zMr3YjT3s862vzv3l7NyaoaoyFcdux6p76hlN3Agjnx1IyA/sPS+4
	 gr8nEWpA8KGqbNR0YghKeSig+dIt6a8rvny/hE6KS+WuZFvSU5/BYU2Wh51RVfsu7zdcL
	 k1EwcKHBnx6esgLWnxG76073u7af6FYEzbC/nXdt6IivQWEqG/pHlJB0P+CpQWOvsUogf
	 GizDIQ4GqbREOYBNmtdatxH68MhT9WPE7KzOFcdmYKhP40gcp4nErylx/o6nfHJwpr7AU
	 mAB2OdeleyXEAjy9/aH+moQzLX6+TZAKUQG9klSaC4h6aiqoMT6bWUaVZtxcVcRxj6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E+6H/6oP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B7606A31A;
	Mon, 23 Nov 2026 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+6H/6oP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296FD1F000D3;
	Mon, 23 Nov 2026 12:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435770;
	bh=EBAlgyArUaIDoaFWbczuSy+qeFGqGHKDwrHB/xbYHXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E+6H/6oP8nLnOr4iihKZsT5mFLOzHyhwUMzMxmC6pmAe+pt5ais3/kGYPwi8oF5zr
	 GjAUPCdau77AfYr2a7Mpi/s9QIus/zoxYa14PAqfbidqxzxwPdaC4msn8xdwhGgYbY
	 nrWqf+M6Mn+OtAJyvAriYXzms38kkQbkOj2aCC5vFExcHvLJrAW61nRLiv+esgmheb
	 hmdZLQDBBvmHVNc3/BLfmVLqfolD+YZt5NvD63SBFtb0XhEPrhJcH4DKSycDVALgmF
	 Vepzp38JoPHLXSbuUbw56Yo0Q2S6VCXBAySB6aIOmtu9udEKeBIynyCXinbFCiTHjE
	 1yVG1ElUOlkmw==
Date: Mon, 23 Nov 2026 13:09:26 +0100
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
	linux-pm@vger.kernel.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2 13/16] dt-bindings: arm: qcom,ids: Add SoC ID for
 SXR2250P
Message-ID: <20261123-pastel-barracuda-of-rain-bce8ac@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
 <20261116-halliday-dts-v2-13-2c92438c6c46@gmail.com>
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
In-Reply-To: <20261116-halliday-dts-v2-13-2c92438c6c46@gmail.com>

On Mon, Nov 16, 2026 at 09:26:29PM +0000, Stanislav Aleksandrov wrote:
> Add the ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2) SoC.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---
>  include/dt-bindings/arm/qcom,ids.h | 1 +

This should be rebased on my patch removing the IDs.

Best regards,
Krzysztof

