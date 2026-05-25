Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38D0DDA9;
	Mon, 25 May 2026 05:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779688027; cv=none; b=JTF0s9vGstg1WqCwYksVvhKNgc8ieQecaGD8VvSEShNmJOxHMXzAtQLLA3gPaY1JfO+wYvSHPEKGUhJtjFGAOVBBmUezDxZkr/E2hihpPXaTtlx66v2hRw7MxQk0m1OHZM/u0MgCWfnKxfrJbdAfcwmHfCf9ugoqCDIAQnBr12U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779688027; c=relaxed/simple;
	bh=hUhn990K+yC60vlhBq7qP0RNjsocPuYPF55KnHiHLgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbixYAJ4NEzpvgfMpcS8LULPV30hbKFgM2MdWJXFjB9k8jJzJCPkXclQKAHORjlVblQD+5bQ3qPq9Ma0BRbNpehncM4Oh9xShEaQj5e+LW46y20bSqiy5NFkhIbwWF/5v/XP78Bpms8D0t9MvSH5dN6yZrDM0BlpN5pxrhE8uLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFi05KAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFi05KAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4891F000E9;
	Mon, 25 May 2026 05:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779688025;
	bh=xqK7fgXWi45nvz9VHQgpE+zTyFdNw8eXTSX1sXRWDqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fFi05KANGvHZG+ZXRYaTwP8xnSV/QaeUuftp9d+x1q9O0pDEueKxFX7y06aPP67VJ
	 ySf/ygotzeQPE3NJDCnnqEjLafP1KXgGJ1EHCbXO8l0jUVKtk/iMAG78CTuXeLgrpT
	 Zif1rZjwZhx22qhuWSXnRkEtyEp+7I5iMpzuk81heaKm2THWFk/bUPqwiavgHyINl6
	 T9t5XoqDaf2S6swT1/tN+8nAy5BscvKJRjgrIzrKk1z7pj2p9dP01OAKKQd92vd/ok
	 Fkv0HuBC0qPWTagRnxtIyDycwEIBLE9MOUIxDqkLT36LDnYpPXd9iXlZKd3JssBri6
	 TeMiEE8JLFTGA==
Date: Mon, 25 May 2026 11:16:56 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: palash.kambar@oss.qualcomm.com
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, alim.akhtar@samsung.com, bvanassche@acm.org, 
	andersson@kernel.org, dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com, 
	luca.weiss@fairphone.com, linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 2/3] scsi: ufs: qcom :dt-bindings: Document the Hawi
 UFS controller
Message-ID: <ynxf6e2wiatgi2ogxywgwqlrtot2cfnkzg2l4n6tvj274uscm6@rz6fydc4gxfi>
References: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
 <20260522172716.820490-3-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260522172716.820490-3-palash.kambar@oss.qualcomm.com>

On Fri, May 22, 2026 at 10:57:15PM +0530, palash.kambar@oss.qualcomm.com wrote:
> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
> 
> Document the UFS Controller on the Hawi Platform.
> 
> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> index f28641c6e68f..3de00affa4c6 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> @@ -16,6 +16,7 @@ select:
>        contains:
>          enum:
>            - qcom,eliza-ufshc
> +          - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
> @@ -27,6 +28,7 @@ properties:
>      items:
>        - enum:
>            - qcom,eliza-ufshc
> +          - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
