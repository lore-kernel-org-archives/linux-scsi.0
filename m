Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235F035A387;
	Wed, 29 Apr 2026 07:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777447006; cv=none; b=IEIlSDN+VKG9j5jEIPKqkOH7+F09AxT5JnsUSmNp2dX1UZZefXw8HFURpYiCLA+HgOrmTXPxazKBdtZoL+l7SpDd/yWfcqnLKG1WzksGXyeLACLdgYnfUG/MVn9VNyvIuDDR0Sjn/qDKWKITuMd/LuEYLKBmGV9/7zkcuPHhqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777447006; c=relaxed/simple;
	bh=FTpgnX6lm7HSkuC/tj0uDIaESnQjfNt5WRUd5INg0Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXpw2oYiK9nzFnoKFR1MS5xiLRCWIi009qABpTxwEuT38aYHsjw3357b/ZSMT45SiMLD3riMBE3tGmeVm1jG3ItIgpgb4McO4lx2v7vT7doNu0U5ayOzar4JpFuHSgzs+MJwuu/0dQsrWUrkWqmDAtfG01Uh+6Snzcx8xY/Vr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GI+N9ifQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI+N9ifQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE35C19425;
	Wed, 29 Apr 2026 07:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777447005;
	bh=FTpgnX6lm7HSkuC/tj0uDIaESnQjfNt5WRUd5INg0Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GI+N9ifQt2chGRQFu+5CG6JFU4Ochio+SV3l7PK/Rn/lHNoc5HLECEPVePVq/GHeD
	 Xh2mj/uDJYUmns9n0B8OziVM0+RsFM0Ywy7lgt7OUWQ5tZkf6DQjjdticd8/nK1F+4
	 cHPLJGJSrFOpV21uN84FDAtGuu/MnMR8MuGIiY1xXAfP9EIPJ6IO1mUzDfbf1iz/gd
	 I0hmAf2h8oC8gy6j/XSESoDEi2KMivAsZb5GA5H0RH7Qn7wiN8TUhzlnwTpFaBy1TZ
	 DqeH3pKwvxyWSjJi2HtC7saUYbWzkEAw2U7Es4GHFfyXo4d93FypsVNQpbI/8ERUS8
	 AETOYHlhCrsMg==
Date: Wed, 29 Apr 2026 09:16:43 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Dmitry Baryshkov <lumag@kernel.org>, 
	Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>, Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: dt-bindings: Add compatible for
 SA8797P UFS Host Controller
Message-ID: <20260429-amphibian-bullfrog-of-awe-70a928@quoll>
References: <20260427013115.231731-1-shengchao.guo@oss.qualcomm.com>
 <20260427013115.231731-3-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260427013115.231731-3-shengchao.guo@oss.qualcomm.com>

On Mon, Apr 27, 2026 at 09:31:15AM +0800, Shawn Guo wrote:
> From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> 
> SA8797P is the automotive variant of the Nord SoC. Like SA8255P, its
> platform firmware implements an SCMI server that manages UFS resources
> such as the PHY, clocks, regulators and resets via the SCMI power
> protocol. As a result, the OS-visible DT only describes the controller's
> MMIO, interrupt, IOMMU and power-domain interfaces, making SA8255P the
> appropriate fallback compatible.
> 
> Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> ---
>  .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml         | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Best regards,
Krzysztof

