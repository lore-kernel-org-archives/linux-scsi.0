Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D537C419304;
	Mon, 20 Jul 2026 12:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784550909; cv=none; b=JciOSJR0GjggqyYOGRaAdHdEy8zIM1sS9j5dpqMXP7zhgVXcGcmulxU0bn4GnGPaL2xS/GyYBqj4qw90MBi9fdF0lM53p4/Z9fOMOAr0yHuGYEPfCRtKNkAhu6sf+nIrDxaFA0CpftLbcbveOcYeQ8oNYCJfplzKIIIKB/1C+iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784550909; c=relaxed/simple;
	bh=GmOq1MCKVpSESpAwyGcFeWIUVGHzHs55MNJ5RgVrEwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/ed8hT7XDsglVUm5JOcxA024m/tuf6VO8aWHhPhyEOIvxknisAw9txdIkP0+tpZGMAa8lbzpDvQskxzdHEMVI5BDdT7x9PWhKjnXVo/JE/54qL7SiI0jyB9/vKWkEaO63VqG9s6pdyOiFZ8dCJp0QiXOPdVmz/OfNNJBv2yZ/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPi5rUA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPi5rUA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3DF1F00A3A;
	Mon, 20 Jul 2026 12:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784550908;
	bh=iKpWP8hoVh5cB7VCKfRlbJw7AuCrEYVuIfoP/u54i6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mPi5rUA0YT/hFR+2Ub9ZxBJZiFeldqvmz0OHhbD7jC/w9lYjnVv36gevX92whq7o/
	 sSk0ulb0Q9OcP2ixIy098Yz9a7C+GwS4uy5nJ4JaBxB+Z4+81RkeZlVJzkSwIYXLjv
	 9qqOv2Q8LHgXyA49upmh1lg2gT3sUgqWjO+fBqqSkgEpGMlhK2kegLsrTtQQWl3S2j
	 y0PdLOnW0W2Kz2sroXxTyQBGP/PwKud0C6wxuCl1LIrcdIlcj2v9RSJ0LwG3piIESW
	 Voe5SqWMRZUtRKpFZKsdb8kKBbRcfX5TbBEiRrD785g45ANgAabJTYz9R5TS9Cjsp9
	 0wuzPnHUhZq0g==
Date: Mon, 20 Jul 2026 14:35:01 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, 
	alim.akhtar@samsung.com, bvanassche@acm.org, avri.altman@wdc.com, conor+dt@kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: dt-bindings: Document the Maili UFS
 Controller
Message-ID: <qzgxnt7pnybd5l3rgro67g5kkevctst4lnfn37jbe4hhnva2yo@azmngirwv26d>
References: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>

On Mon, Jul 20, 2026 at 01:28:33AM +0530, Nitin Rawat wrote:
> Document the UFS Controller on Maili SoC.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
> Change from v1:
> 1. Addressed Krzysztof's comment to update 'qcom,maili-ufshc'
>    to the allOf condition required for MCQ targets.
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> index b441f0d26081..d03295806657 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> @@ -18,6 +18,7 @@ select:
>            - qcom,eliza-ufshc
>            - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
> +          - qcom,maili-ufshc
>            - qcom,nord-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
> @@ -31,6 +32,7 @@ properties:
>            - qcom,eliza-ufshc
>            - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
> +          - qcom,maili-ufshc
>            - qcom,nord-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
> @@ -78,6 +80,7 @@ allOf:
>            contains:
>              enum:
>                - qcom,eliza-ufshc
> +              - qcom,maili-ufshc
>                - qcom,nord-ufshc
>      then:
>        properties:
> --
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
