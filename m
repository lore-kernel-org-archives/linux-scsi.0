Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A0815666B;
	Mon, 19 Aug 2024 12:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724069342; cv=none; b=E7Xqr1vsyOHCbet20QhgJQEkXVp1iJzoXfBYx0S2TM/ecHvVIypcxtsJwci3Ehh4qoaGG7OPTLWKrDu31331drW+bifXro3OGN0/o1W3wf2zXW5tPZ7ei87mPS5xWzqinNcrzihI70bel0Y90VAMNel6OxRjfKBBCoS1UvqbMXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724069342; c=relaxed/simple;
	bh=PKUgctShUuF5smxVxpXr/elfbiHpvj5MZhJ0BzZoYNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNHw8muKYLlix3NKWOtPPb4s8JNYztSRcFrOgwQIQAHowI1VIdJf05YOifHayCBdsawscaAZam9w+i0Y4HcYGTf+wB8yIBnQo3ju8OSFfEjMkPZFdj7U5MdaeXLXbNAwLiOPVyDzvHM5y/mdXqHlW4ycGIsck9NFkmcxboy8uF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XySd1RRj; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XySd1RRj"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-710bdddb95cso2374273b3a.3;
        Mon, 19 Aug 2024 05:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724069340; x=1724674140; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pt6QHwBAmFKSEnRFwX3SHcnEffqlGCVeUH83wmSq7vw=;
        b=XySd1RRjD+v01Etd9TasJ9tt4zcYVjRPpV91UN04wZjNgJY9bFIGdd+Lwl4kR+9x92
         EPW4h+cQj3zTD0dCpzt/jVc/ApxnMXXIoCMAPz4VnDpRicPxyu0vuroMgZCnzr3QwznS
         FmB6Z2MeckwAxntqVeOwPd04J2dsHC8L9vhdrojY1JF8OZHSvkXxdy2CpB7W9I9satSM
         C+nueb3XNbvnWyL02QNFSkZAtk/7wOvwzyZFjvI7Svv2T/UZ4HgW5rnXZdHjAP3T8klq
         3Ox8nH0vj2WeRxO945YrcDcPMAzel0WZ9wX8ArU6DUNN1vxk0VWPnvkNNZCfanVi+fjV
         MQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724069340; x=1724674140;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pt6QHwBAmFKSEnRFwX3SHcnEffqlGCVeUH83wmSq7vw=;
        b=ZFUQT0dGkRcAETgvcpSzIf7vJtEz8nmgc5MqMFbQ4gz48DVDEtnL6+Gz5i4kAZEWkR
         xW6flU6WowRoXI3PyaIHsfB7M8RIXejxvPAIMzUWUFxV05X4WJGjs1A+w1WozCq62LgS
         B+xOcgU4OCaFYB61Um0RLyVlwtRPLLQqBdMPe3s7gqpu+stGkFqm2TMThoc/EF/L+ISi
         TC9ZFSO1PP0CJrc9X9MOi/EfrK8eECkulTc8iTn9309/ECjAoeoZNxgl3UjsmQDzUHG7
         PcpD3/bv08K9cUdFlROcWFvg4Pc+camMzaV8x4C5SN47YC6qgyGr07SpSfrM7vuN0Kfv
         DKmw==
X-Forwarded-Encrypted: i=1; AJvYcCWkzDyRkAX/VIWWE9h6HvbeuAjN1YWrCyXTI02d+QydYdo5aNDaj869WF8t2kybfE86mLny8kM0LVbHfCd2LK+LDreC+MH5vuYahA==
X-Gm-Message-State: AOJu0YynWF7wbQVftfLP77il4yS9I089dOi/+08bBkJZUWYpPwbvw6BR
	yeF9+mZGiLEWr4RX9zPdy8F6uSVSN1vdVBUtKVZhXqpmBjzay0Tp
X-Google-Smtp-Source: AGHT+IGuUzJlxNFYojz7oNc/kOovo0osmwFt37B0ghd4icWTleq7T+Rpk4VrXL/Ocep2C2cxCK5CfQ==
X-Received: by 2002:a05:6a20:9c99:b0:1c2:8949:5ba1 with SMTP id adf61e73a8af0-1c905059d72mr10180241637.53.1724069339770;
        Mon, 19 Aug 2024 05:08:59 -0700 (PDT)
Received: from thinkpad ([120.60.128.138])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add43dcsm6490526b3a.28.2024.08.19.05.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 05:08:59 -0700 (PDT)
Date: Mon, 19 Aug 2024 17:38:52 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Mary Guillemard <mary@mary.zone>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH 1/1] scsi: ufs-mediatek: Add UFSHCD_QUIRK_BROKEN_LSDBS_CAP
Message-ID: <20240819120852.tdxlebj7pjcxjbou@thinkpad>
References: <20240818222442.44990-2-mary@mary.zone>
 <20240818222442.44990-3-mary@mary.zone>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240818222442.44990-3-mary@mary.zone>

On Mon, Aug 19, 2024 at 12:24:42AM +0200, Mary Guillemard wrote:
> MT8183 supports UFSHCI 2.1 spec, but report a bogus value of 1 in the
> reserved part for the Legacy Single Doorbell Support (LSDBS) capability.
> 

Wow... I never thought that this quirk will be used outside of Qcom SoCs...

> This set UFSHCD_QUIRK_BROKEN_LSDBS_CAP when MCQ support is explicitly
> disabled, allowing the device to be properly registered.
> 
> Signed-off-by: Mary Guillemard <mary@mary.zone>
> ---
>  drivers/ufs/host/ufs-mediatek.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 02c9064284e1..9a5919434c4e 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1026,6 +1026,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>  	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
>  		hba->caps |= UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
>  
> +	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)

How can this be the deciding factor? You said above that the issue is with
MT8183 SoC. So why not just use the quirk only for that platform?

- Mani

> +		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
> +
>  	ufs_mtk_init_clocks(hba);
>  
>  	/*
> -- 
> 2.46.0
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
