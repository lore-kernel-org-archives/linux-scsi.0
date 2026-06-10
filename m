Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510BA2FE056;
	Wed, 10 Jun 2026 16:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108356; cv=none; b=af5KJtWGSJAkhJrXLXLU8jXotNxIiedVGnFCazq9wkFQ8UkWzjEOsMEOT/bPm3WEoUhkL90BBIqPHuIcm4XYCfh0sRuCxS95+bJdlDL4MxeFfVHBFjDVOCvkntlO65B3e4WnJVDqbZHqqbkzjjrNegYW7+pq30Ud3J35jay5cGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108356; c=relaxed/simple;
	bh=5+iSWpXr2CnR85Fhrd14dIO7ZwkH4DoPjLCETONjDhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K8TB1I9bRCw/dDlyzqOwSac6LCYO+9VuGIAas7I7bplXFKboUtufOTEfaaoRGt0CMQT7sxRnQb1vKlzwNUiaiWdbr7S78lvM5rgH3biqZ5FNELt+1nDjKYejF9MO/7OI/UGP6zJ+rMZ7Q3wKFRWZaV7C1FV7fNtkQOmhAhjHcv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W5lGVwD4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W5lGVwD4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gb9vk5yHDz1XLyhV;
	Wed, 10 Jun 2026 16:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781108350; x=1783700351; bh=xfHa9RuC2nGVQeuWNKXTunXF
	zBkwGqnU+KCmJdSTHR4=; b=W5lGVwD4eJR9E3h/dqFI4fFevnrEqeetxMs8rbwB
	KnkCOMpNG9VJSNJrWjo/AUKkpA/iiXt+bcJsZO7CapnlnLXQvAF7bbA+2oLnHPpF
	BJbVDz5+7qi9JcLZMbnjQIzDmtwFhT5rI9F0jA8lg4hlyfVLt1tiwbBRbKr+yDaP
	YHtaxfbYaY6GhZpQcOn9vXzgNbTg9vZPcvztfV6LagGWaS10ztQnXXec5K5CRfFs
	b5iuUBPVPudCmsOPUJhVBg+FGhmV2X+AbgOxOaZX69gyXEJiYqwIrEM1fLJinqFk
	TElG4GhbyK+7GqO3ITwJaPLh2p5JR87zTu6Rs28VYuSDVA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id naQvPif2iLkO; Wed, 10 Jun 2026 16:19:10 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gb9vd0Rfyz1XLyhS;
	Wed, 10 Jun 2026 16:19:08 +0000 (UTC)
Message-ID: <8a07bac5-7083-4cf2-966a-2d5281e52a2a@acm.org>
Date: Wed, 10 Jun 2026 09:19:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: Improve style of pnp_device_id array terminator
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Finn Thain <fthain@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/10/26 7:36 AM, Uwe Kleine-K=C3=B6nig (The Capable Hub) wrote:
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index fd766282d4a4..93dab19c1cb9 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -1083,7 +1083,7 @@ static int isa_registered;
>   #ifdef CONFIG_PNP
>   static const struct pnp_device_id aha1542_pnp_ids[] =3D {
>   	{ .id =3D "ADP1542" },
> -	{ .id =3D "" }
> +	{ }
>   };
>   MODULE_DEVICE_TABLE(pnp, aha1542_pnp_ids);
>  =20
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 270eae7ac427..41731a7304dd 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -739,7 +739,7 @@ static struct isa_driver generic_NCR5380_isa_driver=
 =3D {
>   #ifdef CONFIG_PNP
>   static const struct pnp_device_id generic_NCR5380_pnp_ids[] =3D {
>   	{ .id =3D "DTC436e", .driver_data =3D BOARD_DTC3181E },
> -	{ .id =3D "" }
> +	{ }
>   };
>   MODULE_DEVICE_TABLE(pnp, generic_NCR5380_pnp_ids);

Although in general I'm not a fan of code cleanups for legacy drivers, I
like this change. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

