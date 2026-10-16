Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4AB37C91E;
	Fri, 16 Oct 2026 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792144491; cv=none; b=Q2oy+dF0Qqq4PqwbRGx3CDOju79/MFpJRxdIXhYu6m7zJOU2KjLbOUbhF5X4BMiOmZ+NcLxH6DOznt2LtSaoRkSWJTisGOz7EJ8i5KQBLhDdpVF8hnxSHTscGpqSoJhES8lxpQ02KRVkbd+fZ8qfHjqJ+e/tLCK9ON37K1az4Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792144491; c=relaxed/simple;
	bh=xT2LBJqH0V2cIi0o5HP5JsWOT+cHaNnlyZRVk11zIdw=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=hftAzYwmBmETJrLrLXOolR1lcVajN5+rv2muq5+Y48c7vUBijxacJ5WM2KUrqwHyJjQYFXoJyaD5KqkJi/8O1KRO0vzsfdFZ39FSFokC4M1xHXh8qrSCgyEMy/6KgFNpEBgG0jLSbJRQq3G8j125EhyqJpJfx68sRPYs2H7fQNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6pKM2AR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6pKM2AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FC11F000C4;
	Fri, 16 Oct 2026 09:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792144490;
	bh=1LYuAnwQxjThq0bcnWdxYRswFEC5pOuk5XOjSf0KelA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Z6pKM2ARhe2PmJlQQA4GjGMeEkOqi4VEg+DLSe1QyAAM1a4JO3Azw+VW5Ye7eeOM4
	 D7guIf9gdBqFO6looMpN3jDW+KtQFD3RHXMGvAs1ZIx04Vhadn7qfBQr5mssOR7EXf
	 /2zHkDpWl91mSTZAoTN4k/I0iFgzrw1HfUDRCiibZ3uPIsPOnk/wOPpLtTKJ8LakJt
	 1Rc9DChinNBIs2dGjYIzEdyx2xZEbH6aFezfLRtDMvGxHxtFiEQNO6/kJqE4+zTf64
	 hbhOSjBXZ5TzraKk9gxQRaTwu7bvRIOzukX3UhZmX8OhAnV79N4oJsgf0ela7DotNx
	 fRvNvpVdMYLig==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur
 UFS controller
From: Manivannan Sadhasivam <mani@kernel.org>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
 gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>, Abel Vesa <abelvesa@kernel.org>, 
 linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com, 
 sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-2-9a6ce83195b7@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
 <20261009-glymur_ufs_qcb_enablement-v4-2-9a6ce83195b7@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 15:24:36 +0530
Message-Id: <179214447679.106618.13395726363064166351.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1673; i=mani@kernel.org;
 h=from:subject:message-id; bh=xT2LBJqH0V2cIi0o5HP5JsWOT+cHaNnlyZRVk11zIdw=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq0fRfFuzHOmJ1zEbRe2NvhNARv7jbUwiBdCiyq
 YuCvgBsK7OJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCatH0XwAKCRBVnxHm/pHO
 9cHwB/0QDxC9RpCl15j1TBsqxmClzMTtsGJfD+kWTU9TRNlMH/0c/Y1N3j6QM6dB/3aU5ACLqFW
 ElRIvVFM6Mj5oD89A2FsaVulMM0UEN7Rv+6nzmLFalEwXF1QRA8tzYyO2COE9p/n7ixKgIHPHVk
 SFZnqz7gp66mntkSCferg3fnXe3eCBOWkw3B8sWEZcVmX84YocwTOjAs++99Go+9jKFV5Kdccho
 pqoAxP4ZE8uUy0PzZ5qj8fhjyNPEPFWL/p7CnYvqfEOYxTWDBe5m37ogZbRdsr3t2WKTyFHswG9
 DaIvTdUlco01MxI6IcTI6Slr3Ch3/Cws/w72ZvUpxs3Tpkv+
X-Developer-Key: i=mani@kernel.org; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008

On 2026-10-09 16:05 +0530, Pradeep P V K wrote:
> Document UFS Host Controller on Glymur SoC. Glymur UFSHC has a
> multi-queue command (MCQ) register range in addition to the standard
> one. So, both reg entries are required.
> 
> Acked-by: Martin K. Petersen <mkp@kernel.org>
> Acked-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

- Mani


> ---
>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> index d03295806657..f132b1a9ebc2 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
> @@ -16,6 +16,7 @@ select:
>        contains:
>          enum:
>            - qcom,eliza-ufshc
> +          - qcom,glymur-ufshc
>            - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
>            - qcom,maili-ufshc
> @@ -30,6 +31,7 @@ properties:
>      items:
>        - enum:
>            - qcom,eliza-ufshc
> +          - qcom,glymur-ufshc
>            - qcom,hawi-ufshc
>            - qcom,kaanapali-ufshc
>            - qcom,maili-ufshc
> @@ -80,6 +82,7 @@ allOf:
>            contains:
>              enum:
>                - qcom,eliza-ufshc
> +              - qcom,glymur-ufshc
>                - qcom,maili-ufshc
>                - qcom,nord-ufshc
>      then:
> 
> -- 
> 2.34.1
> 
> 


