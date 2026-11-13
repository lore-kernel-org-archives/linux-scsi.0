Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794542903;
	b=puH4C1yq5oyr2Sagn+hG9ky3Tzvpuq+DoATwlmffiovBaeR+VNWgVxJiNGcBmWQ1zD17
	 xg2o8qQd2a2kUvNZnMabovjOBnY5ESNrOrrNDOMfyrXUf1m/b9HTqz1ditojSdTxZiERx
	 JBtBdJy3KlqzV8tWLHwnShIYt+cmaRsyzmlA+gu0hdfect88UikGxeQt6eSwo1JgPSGfj
	 jJb3A3G9A23f3pYTtsL8ygoHPZpRvr6UC6OM2spO9n2PmVLfQ90ELqUJ4es9jwrsL0ntI
	 1axToPiIVE7wTy9BQpZx5LLlZOGnmZ/GpzpmzsF4fQU7mbL+YJrwnyN0sdFB3LQ3MgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794542903;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8YARFsfshi83KcJAZu11qEFspbOUXOBNNkYtX280ZF4=;
	b=ml04ySx3lp3gX6TkhY1YCnoWEald4wsy1iuIE2EAyaGJE6iiO0F9Ropr6Repl+a+3nat
	 zH7yjaGIT1COatpg3rlKPHxbqW40Z8eaFG3OCaTd6LoqRS0StP5e3HGJZZQhosCKRlRS6
	 wsLZNwaLX29Z8guCw3aujGCnqNOsLJZaqA0hFCylXyJf7ECkkPSekWSGdBvOzf/F7XGHT
	 jhq32z5Nh0HEEGsy88ZLOoWXk4FVWP+JEohFdVknYE3fPh7rJMl26exye/CXPdiSc0Xoj
	 JuU1tsQRMc5MtJNdn4BJdUS9QuFZ6Es204Wfj37cmFYFacFtYdp2wAZnYKgdq6R5BYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iNlulHIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D1F606A323;
	Fri, 13 Nov 2026 04:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iNlulHIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318871F000C4;
	Fri, 13 Nov 2026 04:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794542902;
	bh=8YARFsfshi83KcJAZu11qEFspbOUXOBNNkYtX280ZF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iNlulHIL2SCc/Ua0Dc/VeDfAjB02OCQvHD+MzXAmOhhxh+bZgS+UL96+x2DCtz1op
	 264qXfZCs2EyN2TtlyLiDMruuz4hw2cNgl8y5RjXdjSy6kSGCM5C3R8Y6/jeBgjvlX
	 hu5wQXOZ3CUF8bK7vd82ZaaDeBaI2Tr58/pnBQndI8uKpIvywufrXxRY2N9ykpFy9u
	 MUWrdwXqo8TYz5kR6h8Q825vzr9LcUVa9oJlTsUajpP+rFujxdAMxV3XM3AW3NJ+BD
	 1jyDoUy90T4f1LMR7Bhgmzref1+wEOAT6c2nTMqKC3NnCJx0d/FLlWMSe9Ftk4gTVS
	 4seotPE5TqjcA==
Date: Thu, 12 Nov 2026 20:08:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>, linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ufs: ufs-qcom: Enable ICE before enabling crypto
 support
Message-ID: <20261113040820.GE1742@sol>
References: <20261112-qcom_ice_pm_enable-v2-0-177e454d6f22@oss.qualcomm.com>
 <20261112-qcom_ice_pm_enable-v2-2-177e454d6f22@oss.qualcomm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-qcom_ice_pm_enable-v2-2-177e454d6f22@oss.qualcomm.com>

On Thu, Nov 12, 2026 at 06:48:18PM +0530, Kuldeep Singh wrote:
> ufs-qcom currently exposes UFS crypto profile and sets UFSHCD_CAP_CRYPTO
> before enabling ICE. This leaves a window where blk-crypto can issue
> keyslot programming calls before ufs-qcom has explicitly enabled ICE.

Please be more specific about what actually goes wrong, and why.  During
probe, the crypto profile hasn't actually been registered with the block
layer yet.  So the above seems inaccurate.  Likewise in the MMC patch.

>  static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>  {
> @@ -188,6 +190,12 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>  
>  	host->ice = ice;
>  
> +	err = qcom_ice_enable(host->ice);

Use the 'ice' local variable.

> @@ -636,12 +645,15 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
>  		 * is initialized.
>  		 */
>  		err = ufs_qcom_enable_lane_clks(host);
> +		if (err)
> +			return err;
> +
> +		err = ufs_qcom_ice_enable(host);
>  		break;
>  	case POST_CHANGE:
>  		/* check if UFS PHY moved from DISABLED to HIBERN8 */
>  		err = ufs_qcom_check_hibern8(hba);
>  		ufs_qcom_enable_hw_clk_gating(hba);
> -		ufs_qcom_ice_enable(host);
>  		ufs_qcom_config_ice_allocator(host);
>  		break;

Needs an explanation for why ufs_qcom_config_ice_allocator() and
ufs_qcom_ice_enable() need to be called at different times.

- Eric
