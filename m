Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4183B6379;
	Tue, 21 Apr 2026 10:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776769006; cv=none; b=V5J513kftZOA+wBC9tuqXxei8nY/OcJexs6C/8vGIrIZqtW1x6zdnhqg83llixkNIg/1AWnvMXvohcW2tlGnfnxNRv9ioS9e3rBbRrjZpqHCzhyPn5L9rwfsw808ow8fynOt6NpuvmIP113FWzVje5iazwWGXhAM5uG3vB6z0mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776769006; c=relaxed/simple;
	bh=JNq5LSGfrld3DEJuI4URirm0vMCAw/jebHEJJtkkbf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Va1kTzkLW+WN6k/ZjZ0UIFkGOc8oF3TmWdF/jo5cjxL/RGSEiADG29CaqoBL0GkuCXv/AWmFMuI3wfLkga6KZ98XrJ8fFpiyV/xY6CvTXdoZpHFSIr71IANwKQQMW4x0P8ljnPWtWdhg55YzdT29P1aN9CA2qAiLxVeTzkTjwJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGBKKAHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGBKKAHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC5DC2BCB7;
	Tue, 21 Apr 2026 10:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776769006;
	bh=JNq5LSGfrld3DEJuI4URirm0vMCAw/jebHEJJtkkbf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UGBKKAHtR2vSum8y+IVVeI5QyEw3n+Agavyl3HJ7M4XRqG9nH9ppL6ds8jFe4UAO6
	 mPvE8p2esYJSUDKXeMqfftwLki1ofj1vj9kdJRM2fbFPdt46mRqeRvXJsHqAZ2WT/l
	 wP2H582BeKY4d0NeyGqeaGt3kfo1M9e6ipzFYZl+iCcMR/32uGSl8+80h2b5tao5Fz
	 VfSuEbD2p2PbAA4FemSqXfM02dtHNzrhuSFdFTL2UxY6vczT3yQQ2Qc2+SPOgYMgnQ
	 un/Q3wLYSgKtY+bWuAtFNUTnFRGKnBrd+KAwL/k691cA7TXoyM6Qyh6GtJw25hXsyE
	 8pLjnZpiKL4/Q==
Date: Tue, 21 Apr 2026 16:26:32 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Dmitry Baryshkov <lumag@kernel.org>, Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: dt-bindings: Add compatible for SA8797P
 UFS Host Controller
Message-ID: <5vxfua3jj6t4rtf6uexta2qqvog7ss3qmcyzydf5xqplzstitp@hanez2rwjcmw>
References: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
 <20260420100416.1252983-3-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260420100416.1252983-3-shengchao.guo@oss.qualcomm.com>

On Mon, Apr 20, 2026 at 06:04:16PM +0800, Shawn Guo wrote:
> From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> 
> SA8797P is the automotive variant of the Nord SoC.  Like SA8255P, its
> platform firmware implements an SCMI server that manages UFS resources
> such as the PHY, clocks, regulators and resets via the SCMI power
> protocol. As a result, the OS-visible DT only describes the controller's
> MMIO, interrupt, IOMMU and power-domain interfaces, making SA8255P the
> appropriate fallback compatible.
> 
> Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml        | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> index 75fae9f1eba7..f2f3bfc73216 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> @@ -11,8 +11,11 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: qcom,sa8255p-ufshc
> -
> +    oneOf:
> +      - const: qcom,sa8255p-ufshc
> +      - items:
> +          - const: qcom,sa8797p-ufshc
> +          - const: qcom,sa8255p-ufshc
>    reg:
>      maxItems: 1
>  
> -- 
> 2.43.0
> 

-- 
மணிவண்ணன் சதாசிவம்
