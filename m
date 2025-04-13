Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C4CEC4;
	Sun, 13 Apr 2025 18:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744567370; cv=none; b=a/Tsm1Ml4ui+X+AOMblsHnH+gqrFoeVGViw1TJn5iRh6/EfhCuPV1AhFkmhUBtV6bCHMaEUpJHOuFeODySA00PQmaPShDuXCbu8dNslBQMuP5GSV2hn2f2rXRJtn1yL1AqRsZOfQjOY0XwvxVn/NcHuB0Y0prbTLyS5dikw/wr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744567370; c=relaxed/simple;
	bh=qo9Xk4ysQBUC66seaPO18axTR54cTNx3OAqCD0UiS3M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sxn8ajujjGOAU/Mbjl5SxAMW2uwJvod54H5DhinaPpZFUe34Ir7TcI94kF0fzNaiIlNqM/VgKPIvrfSbNmT8MUnC0kOCIReQsBF6kLM2x64Xtv7mpLFq5vChCqGtwqMXajKSAJrxznaGdNHgzw5Z3gT/UK/7OwaJ6J9ig1JUE4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFgUwgAc; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFgUwgAc"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso37797995e9.1;
        Sun, 13 Apr 2025 11:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744567367; x=1745172167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erGj3PFoA4vOPhXfNNzZpH7MlehLUD6YVpNUM/wB/mM=;
        b=WFgUwgAca/u+iVeFuYO7KwbeEpUQTyztKQsFrXIJHUYINA9DYpv+ef6gZ9IyElF/dB
         IWPd46BmHYBQacF2sX+/h28zCMY/uAGM9c78rDIbE8WeAm6/6r3h6j16dGhmGpL08I78
         MYCtpcubAVHavnE641AdIGgmAB7lw0oFwSgDaXtrfiY+/yIXFvX1eB0yVeivVsDzW7D+
         tjpj1l6Za3sF2dh7n3UhKO/HBFVcum/dN6w6SOa21BRzQlPSXpYeRDPd32xrzvw5Tikp
         QKQ1Iv3gkIihRSqVSa6yBOqAlDA2f1mtYUyZovKZNpjqNaJQ4PI4cbBWtre0QlVZvk6j
         SQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744567367; x=1745172167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=erGj3PFoA4vOPhXfNNzZpH7MlehLUD6YVpNUM/wB/mM=;
        b=eKfLAhRqgjGrEwToHRpx+pw98yebO8XPkKHvDSdOQqD8niJAYUKSmW2iF9v2PVFAxx
         YpSOW3MjC5XxBTX/0WK71CCaq9qCYPa9hCAeMAqbC/8Lj/IjHnGVkiEp7E8EpXsSbqdo
         fsj/N+30fyAy1NtLEAyvOjucvxXbOFIUeM5JChcsdsSMtdE4vr+/9vbgjHlX7gQTpZCJ
         T3HvxvXCj/51t7/PUkB5hYt+0RAeHPw9egb4azh7wzla4DgxO8J5PfhjfhtB0QYIkwAb
         AtJvhmF6biPKGRUh8YfY1J82R4SoRLChuCALA3vHxw1Af/yHqZFbSGdDsY9DVuFQJDZL
         Xhtw==
X-Forwarded-Encrypted: i=1; AJvYcCUhp/8OOJXAOHN1MAEQ/jzEoJdQdrqvoW5u+0WNxPnGZqtEbJQiHdROmjqSQbpAytDezo1bTkSR++aqn/g=@vger.kernel.org, AJvYcCUqC4tLTcgxWFwvzC9MIeqy2pm+4KXsapA67o++eoDPDgYx8hV0yN+OjTl5h3TFnGCSLwCvF+Wt+Dfo3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzecBdx6dTcy7VY4Cs84kP42Sor2kWreW6iupqvBlyr+dl+h/Wm
	3pBRf8FRD57+eOTTLx85X3QMcjVCkoaatEA0puwvE12YTFzZlZZs
X-Gm-Gg: ASbGncvw7szJSOwK2ZYyu3eQL8U03pjanv0BeOCOsnMa5I/om6O/a6rF0ZNC4BR1AP3
	uqctNDhtUBHnJx+/K66LROLgZNzgIL7jIH4trbo+kh7J4InBvTRr3CjLt51KCS9t0yxzXDZZtsB
	nTsgO7pRdTdC2h9KD7SWmNf86T826Wpy3GO5KhD4gHr9ZFaHWuQ9YAHxLVnGCCnlmYTUAnXA83W
	zdvnM8l0AeP9ZnIrDS36v12P+pT3OmHmG1uN+H7EZAnGZGjfwKndR1wJ6b59U8Rn/OFfy8aKEsY
	wMIQLxmGfqSfmmDYfMKCUZ0eSgfph/t+tGoRiJpMTXOxHfQO8XCRF9giY2e6dYEKM7T4isDi0gL
	uBQk=
X-Google-Smtp-Source: AGHT+IEUqvKPr3XsDz0Qe9lrQLQYb4cT2YFIpXkECUZXBJi0GDieo+9ZayZyWIEdWvstS2ydWn8eBg==
X-Received: by 2002:a05:6000:2907:b0:391:38a5:efa with SMTP id ffacd0b85a97d-39ea5201ea1mr8077035f8f.23.1744567366341;
        Sun, 13 Apr 2025 11:02:46 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f23572c43sm155115235e9.25.2025.04.13.11.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Apr 2025 11:02:45 -0700 (PDT)
Date: Sun, 13 Apr 2025 19:02:38 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy
 <dick.kennedy@broadcom.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lpfc: use memcpy for bios version
Message-ID: <20250413190238.2cb8ec64@pumpkin>
In-Reply-To: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
References: <20250409-fix-lpfc-bios-str-v1-1-05dac9e51e13@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 09 Apr 2025 13:34:22 +0200
Daniel Wagner <wagi@kernel.org> wrote:

> The strlcat with FORTIFY support is triggering a panic because it thinks
> the target buffer will overflow although the correct target buffer
> size is passed in.
> 
> Anyway, instead memset with 0 followed by a strlcat, just use memcpy and
> ensure that the resulting buffer is NULL terminated.
> 
> BIOSVersion is only used for the lpfc_printf_log which expects a
> properly terminated string.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 6574f9e744766d49e245bd648667cc3ffc45289e..a335d34070d3c5fa4778bb1cb0eef797c7194f3b 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6003,9 +6003,9 @@ lpfc_sli4_get_ctl_attr(struct lpfc_hba *phba)
>  	phba->sli4_hba.flash_id = bf_get(lpfc_cntl_attr_flash_id, cntl_attr);
>  	phba->sli4_hba.asic_rev = bf_get(lpfc_cntl_attr_asic_rev, cntl_attr);
>  
> -	memset(phba->BIOSVersion, 0, sizeof(phba->BIOSVersion));
> -	strlcat(phba->BIOSVersion, (char *)cntl_attr->bios_ver_str,
> +	memcpy(phba->BIOSVersion, cntl_attr->bios_ver_str,
>  		sizeof(phba->BIOSVersion));
> +	phba->BIOSVersion[sizeof(phba->BIOSVersion) - 1] = '\0';

Isn't that just strscpy() ?

	David

>  
>  	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
>  			"3086 lnk_type:%d, lnk_numb:%d, bios_ver:%s, "
> 
> ---
> base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
> change-id: 20250409-fix-lpfc-bios-str-330f6a9d892f
> 
> Best regards,

