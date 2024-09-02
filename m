Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70492032A;
	Mon,  2 Sep 2024 23:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725319201; cv=none; b=hp9MP+JJAmuxihUmSadnahHIKadb3xBzPITfbQk/HwQDfAXYWKtw/Xv88Pyqe2CBryyvqLd86vT71W6JLdLgUWm7Yi6vaDtNlN8Io3fn67Kae/Nwvt0eOKCXANQgPJ2DQeP9uXNll9hGdTTAJn8YP2lH2HGHAklr6GgARrthKZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725319201; c=relaxed/simple;
	bh=YAGrIzusnyTr0rxXlKRJ2lrCnH+Sp4JMoe5jlxXvGHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiCFTIUomDUprvscH9lsUfqw76wEcqcaqJhin10eJDEOmpuuuXFvoG8ZlCr2xZVdZin5a9ZkTuvheNvkepOBsEodBfocxhbe20RK4kpJIKmSd8/Kr4G7Y9S3cPpBfyFXtjQuA8lcc8Ib3agbulWTDrUbYsAeA8wudrZMV52wzhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=D6w6EoT2; arc=none smtp.client-ip=80.12.242.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="D6w6EoT2"
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id lAd3stLcybNNslAd3sOnCp; Mon, 02 Sep 2024 19:14:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1725297254;
	bh=dsK29Y8mrgSSPkIHZ+2Q9mnnt52c5HZqPwvsqeoeFw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=D6w6EoT2JPD2gA2xOUrhWPJnv4/1h2HHHrOYD0eP5I1o1kfiOZN5U/8t+jFlscxro
	 tJkNAP2neZSPL64zcnebyKF0ha3eAJHOmX5GliFcdZP4NZnQQ4R8ELAt+hYr8RGr80
	 AJuGd+rr/SgvPVoR89744yLAgfqUPloAm0zSEJupJRZVOMJyEFLdBV2PUIC1i6oOA0
	 EEE43NopSS3q9AfA8tgqIUlmEZpDQeJQkVckDflx6Q3mgLrncEsGhYkXcXSf0USDkk
	 zkpoP0iD5mMz25yGBZeg5grU1rr7bZexJ332hRkgrg2ZfKwlbsPOyMkrbJoFjijOu0
	 piIc6snyHarEw==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Mon, 02 Sep 2024 19:14:14 +0200
X-ME-IP: 90.11.132.44
Message-ID: <0729c1a1-3d3c-4734-8e1a-6fd722b73e02@wanadoo.fr>
Date: Mon, 2 Sep 2024 19:14:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: mpt3sas: Remove trailing space after \n
 newline
To: Colin Ian King <colin.i.king@gmail.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240902143645.309537-1-colin.i.king@gmail.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20240902143645.309537-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 02/09/2024 à 16:36, Colin Ian King a écrit :
> There is a extraneous space after a newline in an ioc_info message.
> Remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 9a24f7776d64..ebe4cbbc16e4 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -8899,8 +8899,8 @@ _base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
>   		if (!device_remove_in_progress) {
>   			ioc_info(ioc,
>   			    "Unable to allocate the memory for "
> -			    "device_remove_in_progress of sz: %d\n "
> -			    , pd_handles_sz);
> +			    "device_remove_in_progress of sz: %d\n",

Hi,

I think that the 2 parts of the string should be put on the same line.

Another call just a few lines above is already written like that.

CJ

> +			    pd_handles_sz);
>   			return -ENOMEM;
>   		}
>   		memset(device_remove_in_progress +

