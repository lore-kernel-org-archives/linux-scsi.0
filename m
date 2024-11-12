Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12181209F4A;
	Tue, 12 Nov 2024 07:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731398023; cv=none; b=CNszVTxCfuOI0eYsY/CZk1onVdXoHomV0dEfpE18hOqYMu97glFTIst3eDzvnWE3XLHW/J1zM0FZuCtiEg88zS6sKbWkQ07xxjOuGDxHHUxS/kd+XNWWJ+fG+FeslJV9CmemHJf4tyUrTdSthdqS8zGthGtLlkVffCpAYlGf8Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731398023; c=relaxed/simple;
	bh=aNauZ/Ih/QkT/dVs7qqIjV3TANMpfFtHW7+Wmb08jek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cR0ZTeuJliB+4KJTOEtT+gTxFxlmTApTq8qih/ZTYg66gburRexOlN1GIYnWkVaQovCkDHBUKDN4VgYs/x5xmLvl5JPZFsn3tGnoAz+wYkc5/yJ6406tXKlFglxAqO+d5Ber4ifbvFn2BKSNPlwEhbCI5K98fYgZUvAznrfY9Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5StVuah; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5StVuah"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7242f559a9fso2506800b3a.1;
        Mon, 11 Nov 2024 23:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731398020; x=1732002820; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bUgoxxvXrdhSJUKoJyf/O9v+5uKNcqCPwgTAuJ4BG7s=;
        b=k5StVuahyiiO7KN2syrqVzoiJQoNBGi4VDfp5PzeOIB6lETijR+QTD5k5yf/nVXNIX
         U7B1y/koPL8VYtiQqWmec7lRSnBVnG5MlTG/R8zMdhzRAeRNtGEMxMhwKQSg3t2NcHJO
         cjUCbctYZtVGDXGK89L9zWbZaaFYDYFbt2WbGoDWE6z/2aUuYJ1CyXNZSBxGk96VxHSw
         +9UYtAMFJ8PSsvqv3VcywndHOxMooQdpdZ+yefYeCgYwJb00AZd0fZINvYqEqr3CEZys
         6yVdu1ND7YxjuBTCkQW2Hn8+xkJokakL/Fvw0UeJsqRJXPwGizGl6bhsux4lmuosZgnG
         ksMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731398020; x=1732002820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bUgoxxvXrdhSJUKoJyf/O9v+5uKNcqCPwgTAuJ4BG7s=;
        b=sqth2KThKTm5bwSjy3YWsfIV9mVKN+1vNQqHWoTr7ONjBVM3Ng+LRmbpqsHkF390uB
         jE2qe40F+J9uZRws8GNULOCd3ONJh/c2JUnVBPyDHnwTt3+aTo7Fu2/jUuwet6HTq8RG
         NsPiHyvHaHeSvfZxIkfhiedwj9Xai/v1BmYC1rYJ8o5BzliiA8gDumZ0sQ8rvB27ZjIk
         c9i9cIroCnPfAEVOklhjhVlu2oHfJboTMrKXesXnyk6d+e5qAZkiXxQ3FYkqu5MbR4QM
         iJ2jkCVrmXG+xTsVCo5gJZxnxVKcOjdZBBjI6cZKdmCSHiz/6FYxpePKc5NvgqaTKtrS
         2y3A==
X-Forwarded-Encrypted: i=1; AJvYcCWNCf9seypxgpVWSBWEEFYHyRj4VNYDlLlNmx4/m8LXV3ToBrHlZjAmlP//92NqskFZGDHtcJavOosbg+E=@vger.kernel.org, AJvYcCX+azBmUDVftd3Ff6ZXG/fCYrhKSVJZgkbrN3QIIAqTxhYAIJzIGODfat+lbB5cvtVyMGD3DCs+jxOE4Cdgr/+M2ys=@vger.kernel.org, AJvYcCXxgnQBGFdJh5EfasuZvrWSUS7Tzc9r+vXglW5Xn6RkZ3InZWeRbK4uWaMevdNJs7fUqWqXSoezstka4g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlym+J4AvRTn10gtV3GheKiS4z4TmwSlkiwzy8Kh04lPcZmwa0
	WkmSK3M+B+lvrGTIswtn3VoeBbvZsKcFq2ECyd+VaKeL84mJJwV8
X-Google-Smtp-Source: AGHT+IH4s7RgAlk5NeJXz45kGRRPxv9SbFPlQhFQl+z6UduWSSD31KYzEVYWdy1FjRFjXJxIydK7jg==
X-Received: by 2002:a05:6a00:b56:b0:71e:5a1d:ecdc with SMTP id d2e1a72fcca58-7241334a09dmr21966921b3a.17.1731398020189;
        Mon, 11 Nov 2024 23:53:40 -0800 (PST)
Received: from thinkpad ([117.213.103.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7240799bb78sm10424749b3a.95.2024.11.11.23.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 23:53:39 -0800 (PST)
Date: Tue, 12 Nov 2024 13:23:32 +0530
From: Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: alim.akhtar@samsung.com, James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com, krzk@kernel.org,
	linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	andre.draszik@linaro.org, kernel-team@android.com,
	willmcvicker@google.com
Subject: Re: [PATCH 2/2] scsi: ufs: exynos: remove superfluous function
 parameter
Message-ID: <20241112075332.lhssmh44a77uyvit@thinkpad>
References: <20241030102715.3312308-1-tudor.ambarus@linaro.org>
 <20241030102715.3312308-2-tudor.ambarus@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241030102715.3312308-2-tudor.ambarus@linaro.org>

On Wed, Oct 30, 2024 at 10:27:15AM +0000, Tudor Ambarus wrote:
> The pointer to device can be obtained from ufs->hba->dev,
> remove superfluous function parameter.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/host/ufs-exynos.c | 4 ++--
>  drivers/ufs/host/ufs-exynos.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index db89ebe48bcd..7e381ab1011d 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -198,7 +198,7 @@ static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
>  	exynos_ufs_ctrl_clkstop(ufs, false);
>  }
>  
> -static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
> +static int exynosauto_ufs_drv_init(struct exynos_ufs *ufs)
>  {
>  	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
>  
> @@ -1424,7 +1424,7 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>  	exynos_ufs_fmp_init(hba, ufs);
>  
>  	if (ufs->drv_data->drv_init) {
> -		ret = ufs->drv_data->drv_init(dev, ufs);
> +		ret = ufs->drv_data->drv_init(ufs);
>  		if (ret) {
>  			dev_err(dev, "failed to init drv-data\n");
>  			goto out;
> diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
> index 1646c4a9bb08..9670dc138d1e 100644
> --- a/drivers/ufs/host/ufs-exynos.h
> +++ b/drivers/ufs/host/ufs-exynos.h
> @@ -182,7 +182,7 @@ struct exynos_ufs_drv_data {
>  	unsigned int quirks;
>  	unsigned int opts;
>  	/* SoC's specific operations */
> -	int (*drv_init)(struct device *dev, struct exynos_ufs *ufs);
> +	int (*drv_init)(struct exynos_ufs *ufs);
>  	int (*pre_link)(struct exynos_ufs *ufs);
>  	int (*post_link)(struct exynos_ufs *ufs);
>  	int (*pre_pwr_change)(struct exynos_ufs *ufs,
> -- 
> 2.47.0.199.ga7371fff76-goog
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
