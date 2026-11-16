Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848727;
	b=SxbPVhkmzkdmT39HUWJQgMcFkEfjSnMn9uicNExt10zKnQR8M6FQzQfkyXWD/muQSqB2
	 iD2JMKPjdAbgEDYEWqP7sEylOZS5PqXc/8msm8z68YVrmGNrMrpZHqrgP9FneUntBprxu
	 4H3q+kMjWNsx3xxstcLUexmrtipWnAcl6laxdTBB4QSHcRsVBZcDIp/7KS5qc4FyGktwr
	 AHi/9EZkR0PQkphi81doNZK46fSmlWh9pJze7bc6VAuEbGj7J4iLIZbzKTPH+c6rAAdpu
	 gL+FaSBvsAdwDGSDWqoBazYCebmkTTb5fczfCw33y33+robrYp0Dmj1wis1pcga+zGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848727;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=QIZ4XsgODrWcH8dTzvu/9qtSI703Qb2F/6/UXN9OBdo=;
	b=O4TktfbU1g6yM41ijq0MdNPEAGXjNZdOWf7WEvKctl/jV+JQvJlKv8RgVVDbWyg+IfdY
	 VGlXCbrEQQEwbaZt5/NF5x0Jj55rGttjXzKQBWa0xQkEFJK1QMe1M5wYDkBaw7hcRkpqm
	 fC0oKjAC0/6SF57WP/xBOuv50kbGCOyYuocgs/0I33cAyiRHQEBTg0X/V4w/ftGZonDEb
	 SQx5t54qVOdV3FNVoltV7NSSaCYdzdwl/g1L5+0g8G2zXY1L0bO7mgxIgUF5jMZSGSWgm
	 uXGXY2ITucy2+MAe15fnda0eT4BJt3COAomhkmprb6bbc+WgwB9XVChe4aKWCUufYFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KfskU73V;
	arc=none smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13E4606A33E
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 17:05:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A13E4606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KfskU73V
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1a2af4c8d00so7533858c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 09:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794848726; x=1795453526; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QIZ4XsgODrWcH8dTzvu/9qtSI703Qb2F/6/UXN9OBdo=;
        b=KfskU73V2nqL3XU7CsfJ+22H4pvOTCx6d/AP1PPNdOkEj1TRKCwdwBm40jV8fb0CWk
         /oa2bk1ZQzCet0Tia5pGeVWntYRU5P8uLywYuwwkp6VcJo9yA8/0D5b1AUSF5rkQ0gU1
         TozlZOAjI+JNjbNjsnWoWBA3Hq2MfKcvKKZ+LaiH7imLxbGxQEm9s5eqZjJmhftJFBOR
         Zxcg6Xh5yWqDRsJ4SYoQFhBgoUv1jf/DN1Sm2NYypwqIyZCaElsGNv/rQmXOqtINh8rD
         tBefkurKbbt0haBhwp+Rk7ccFJLlIlR2tAtHLKngWptdUzuOkgEtRtuAGRknK9HEP6tW
         YqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794848726; x=1795453526;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIZ4XsgODrWcH8dTzvu/9qtSI703Qb2F/6/UXN9OBdo=;
        b=yx4J4mhfi2mt7r5sGh0eHc/Qy/ESUh8z5YyET8iZ5cwXgAbApIFz+JiBojMQI9Npkb
         OXVZ7XXcdxUQYfHSU88UYSS2b9AclDcRdEE31yYNnldw2/1Nz86t4FSl2oX5GbPDGZzf
         ZxgmDhR417F0qcyL6XGFkNnL1qt5V6gGQvu469RCtmsohfzMSyoJonMpg+w+McxOoltQ
         DlsWyWehSP+DmFLxGs8hP26mcWXTspBX2aFeUt3h7zEr2zBrozw19dGR7APiOI8W9nz3
         PqXH5urSy48iK2RYHtTt5M5Dps0RN9P6jU06eRPGUubSuoCP1xB0RUez4xU7Jn138X5y
         8l4A==
X-Forwarded-Encrypted: i=1; AL+hErFGyhrepN2ziWetrHk+pq8qgnINBLL0FYjVXLidIVd0GnjHEGf/VU7woHai8O3/JDCh3zxwyBMhNXSY@vger.kernel.org
X-Gm-Message-State: APuU4Z9bSnHulgpKmkL+lqi/210pZBB5L8mrCsJIQRYpGtiBWcaIy4/X
	e2o6e/UxnTYylBbxR8q1gO7igU8YxZBL7PsqcBrNh5UgkK73PWFj5tpl+E9BA6zneDc=
X-Gm-Gg: AYBFou18kDGWyssDWIOlcKr86MJLSpHj9FQr33+zN44EDQLry/cTwOF4LGO+N1cd68l
	s0hzMa8Xt4KcdL38h2EhAagC9upUUb7m+goFcbPlBiFIzwhX5QJQnpkN885C8ycoxA2i/NDRbgH
	CYqdOrNrO3Ci14wQ01Vz53CZVk+zVX8YHjhk0YkGz+jgcfKMJ0YX9qLh+yiOyQmK5fYVz2agnhF
	x2Y9/BlsaMvlJES/a1oLxdczDTCMPwm2xkxqjUosIf6Ktb/JutXFUEiLzJvsheqLszo/VnwBWVE
	MYoNWhUO3e3PgySB9ivPrw75bQygBDVuZ4Cp3fUAWZRXhvgjhdwlZa1xC1nErrmAkwLd8T/hAE8
	ERNOJrQVA29S7DaZO1s/aqgIf/UXCGlEARt0hWsQMP2XQ7huzGtxCsclYWqPaFCRT1lzJmBKA2c
	9ALNtrISLL0ADrW5R/+I8m3daEPwmI7n72WcsuieNNYS4mKpgw3haD5+Kq6oSY9gOnGUYe5tFac
	1KVlN18L09BGr13fa/bgwB2Idq9fj3A5hMGSNAmDcs8Hs+4ijBY+grEjeSYIWB/aGjtrBhjIjtH
	EenrEHJxPDQ3a1yVXguuo/kD7OEqu+dX2ITA
X-Received: by 2002:a05:7022:29c:20b0:1b4:e533:ff50 with SMTP id a92af1059eb24-1b50313d871mr10447133c88.40.1794848725646;
        Mon, 16 Nov 2026 09:05:25 -0800 (PST)
Received: from [192.168.29.85] ([2405:201:8026:213e:e2c9:cd5e:3a2c:ae0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795591f4f8sm35331095eec.13.2026.11.16.09.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 09:05:25 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] scsi: be2iscsi: Fix NULL pointer dereference in memory
 cleanup
From: mdshahid03@gmail.com
To: mdshahid03@gmail.com
Cc: ketan.mukadam@broadcom.com, James.Bottomley@HansenPartnership.com, 
 mkp@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261107093611.42311-1-mdshahid03@gmail.com>
References: <20261107093611.42311-1-mdshahid03@gmail.com>
Date: Mon, 16 Nov 2026 22:35:09 +0530
Message-Id: <179484870918.18018.12288622784632288336.b4-reply@b4>
X-Mailer: b4 0.16.0

Hi ,

could you please review and give your feedback, when time permits.

Thanks
Shahid.

On 2026-11-07 15:06 +0530, mdshahid03@gmail.com wrote:
> From: Mohammad Shahid <mdshahid03@gmail.com>
> 
> During memory allocation ,DMA memory may be allocated successfully
> before the descriptor array allocation fails.
> 
> In this case ,mem_descr->mem_array is NULL,but cleanup path tries
> to access it.
> 
> Use mem_arr_orig to free the DMA allocation of the current
> descriptor and handle previously allocated descriptors separately.
> 
> Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 34 ++++++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index fd18d4d3d219..95706b5db7be 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2549,22 +2549,30 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>  	kfree(mem_arr_orig);
>  	return 0;
>  free_mem:
> -	mem_descr->num_elements = j;
> -	while ((i) || (j)) {
> +	/* Free DMA allocations of the current descriptor */
> +	for (; j > 0; j--) {
> +		dma_free_coherent(&phba->pcidev->dev,
> +			mem_arr_orig[j - 1].size,
> +			mem_arr_orig[j - 1].virtual_address,
> +			(unsigned long)
> +			mem_arr_orig[j - 1].bus_address.u.a64.address);
> +	}
> +
> +	/* Free previously completed descriptors */
> +	while (i > 0) {
> +		i--;
> +		mem_descr--;
> +
>  		for (j = mem_descr->num_elements; j > 0; j--) {
>  			dma_free_coherent(&phba->pcidev->dev,
> -					    mem_descr->mem_array[j - 1].size,
> -					    mem_descr->mem_array[j - 1].
> -					    virtual_address,
> -					    (unsigned long)mem_descr->
> -					    mem_array[j - 1].
> -					    bus_address.u.a64.address);
> -		}
> -		if (i) {
> -			i--;
> -			kfree(mem_descr->mem_array);
> -			mem_descr--;
> +				mem_descr->mem_array[j - 1].size,
> +				mem_descr->mem_array[j - 1].virtual_address,
> +				(unsigned long)
> +				mem_descr->mem_array[j - 1].bus_address.u.a64.address);
>  		}
> +
> +		kfree(mem_descr->mem_array);
> +
>  	}
>  	kfree(mem_arr_orig);
>  	kfree(phba->init_mem);
> -- 
> 2.43.0
> 
> 


