Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CE734846D;
	Tue, 21 Apr 2026 10:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776769067; cv=none; b=aQTq9ojvRYgEdZvSrLgxkhxKAbPb9Bip0v7JU+eMaVID3PY/6lMEwFH91orQeRPKVt0QwGv+IVQDDEHUY4gLFT1BPmL/3TfVnPHBwbIjKgKSc/r+CyixkGmY+zG8p2o9q9VRQHp5Ul7ADom7CwuiCBhwxwutVeaAVbkbr/hiZV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776769067; c=relaxed/simple;
	bh=r2Uj/8n4b/vsksJenduleFOR6xxSb9vEn+mFG++z+5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzUvPbyqd9Lz+hb9L44QJPHS7sv0/7+lXfWvp/pN254RYZft1XIt0k7UzVEt1IyHYeK5DjV2tMtcs/qwKCvpYL90NkThQ9s0SN4fRjLYySQo8q3Wpvbc5MBR+J5AKDYlGgbvr95pPpRdE67lYporY2zfDV5O+aDLTKotmAvbny8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCKmixEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCKmixEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7C4C2BCB0;
	Tue, 21 Apr 2026 10:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776769067;
	bh=r2Uj/8n4b/vsksJenduleFOR6xxSb9vEn+mFG++z+5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vCKmixEQ1DKVwZ3pPj8ADkgBYwx5DfKUQ8zxFPbtNYCqlBM9flOTBrJlfSZj9SzdZ
	 /jzG0uJGkN0QWcNE46sKe9mgLVGMUwhqnUDLsJuvjHCiHUSYHsqDDOaccd078Av+V/
	 bGvNJCSnEnN0WPZGehCwkW0pfCYloKT2vjpD1fvIuEDiMWyUiVow3sn/QjZ+fSpCNe
	 ngfia/Vn2ptq1rp8J4dRqiR1iAquhyXUw7MBQ09Vkkqlnyaemux3FOawS9b8euZHEi
	 rthcMBso0qR3fmq7tyNjvRFf7sSuQ66dtKja1uDPh4ptxataE7WuqM2yJDBO8CYcnD
	 zM03coGkp283g==
Date: Tue, 21 Apr 2026 16:27:33 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Dmitry Baryshkov <lumag@kernel.org>, Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: ufs: dt-bindings: Add compatible for Nord UFS
 Host Controller
Message-ID: <kpe3dgilfpv6r6jkjwljdvacdb4alq5s7oz5fgndd2bk2jn2kw@by6eufl6n5v7>
References: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
 <20260420100416.1252983-2-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260420100416.1252983-2-shengchao.guo@oss.qualcomm.com>

On Mon, Apr 20, 2026 at 06:04:15PM +0800, Shawn Guo wrote:
> Document UFS Host Controller on Qualcomm Nord SoC.  Like the Eliza SoC,
> Nord has a multi-queue command (MCQ) register range in addition to
> the standard one, making both reg entries required.
> 
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> index f28641c6e68f..900d93b675cd 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> @@ -17,6 +17,7 @@ select:
>          enum:
>            - qcom,eliza-ufshc
>            - qcom,kaanapali-ufshc
> +          - qcom,nord-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
>    required:
> @@ -28,6 +29,7 @@ properties:
>        - enum:
>            - qcom,eliza-ufshc
>            - qcom,kaanapali-ufshc
> +          - qcom,nord-ufshc
>            - qcom,sm8650-ufshc
>            - qcom,sm8750-ufshc
>        - const: qcom,ufshc
> @@ -74,6 +76,7 @@ allOf:
>            contains:
>              enum:
>                - qcom,eliza-ufshc
> +              - qcom,nord-ufshc
>      then:
>        properties:
>          reg:
> -- 
> 2.43.0
> 

-- 
மணிவண்ணன் சதாசிவம்
