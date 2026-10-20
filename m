Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792515506;
	b=l7aO5PsMboVN1xSLIPl17MIMq4L+WKgybpCVND4Y0uXuErOt3YaTFSyVL2aHyRt0ls1D
	 +hTpCTSAUupEi096/CYKqbAeT4toA4YSOnk6xIX0j4ZjLJRS6joe34OFMhAGZ164CbGIb
	 3cwoB1UTb51wD7Iw8TkJ8QLhmQKWKWdQJw2tPurKsc4SnXVrnEbsCygBoEwgttMjWY0cb
	 TjbTGzhOtdCn8cHNVNBYOLivihr9ELCJsPZu8NkkoLzbzAZj05b/NPdYAGUAXIiGpoHyF
	 GhBivSJAcQQ9dioJMfCFulcTbRZ0oT4LJFK3PAH1c1xojq6emmjGG+xNx/78Ha2XU0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792515506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=u33Dm7JjbPZcT74XXr76WobWuAgvMPKW6Wg4WE97FmI=;
	b=FM57s4D1/kzuEZ31mexh2SPZNCE6nC/Zbt3i52Vb2KRRbG9J+yl6VMbQiq6YNGGEZZqq
	 1BmEkqDMGjmrikHR07kCxG/AkTP7p+UAJTWrUzshIaJHb7sp+wY/PbEwNHhFV4G9h3Vcv
	 b2Q5sb/Ilit87OioQQzZen5OGmf4dg380UMiXLaqMojfzq57cyHuUfnpypV8GZIMCZicW
	 cj+td8w/TflyZoeubYdEP+QhoHR4hGu1sQGGS7rWbl79qez1d6mhrnOYaa/vyppx3r/JY
	 h4Z1SMDY0iLuNVlUY6fItQjQEcXA66z2IlOWyhEKyw1iBWrS5y6/QbtgztAJZgCUQkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yTirvnd3;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A76606A31D;
	Tue, 20 Oct 2026 16:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56A76606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=yTirvnd3
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j8JX15qM7z1XM4Tn;
	Tue, 20 Oct 2026 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792515500; x=1795107501; bh=u33Dm7JjbPZcT74XXr76WobW
	uAgvMPKW6Wg4WE97FmI=; b=yTirvnd3iH8YEIMoSzHSJJT8FTMgDEoMnpO7xE8R
	xZa3x7p8XloMx1L6Wgmw7J0PuvP/ERBLE5Piz8CW/TUASW6SeY3UOGIqrncrx1A1
	+G/eY1/dKSWfmje5eLxTXPoKgXgcXTcvXmW7fnGm2IbloVo3JF+VxfEOsAQ81Qcx
	nF/bNlFU+Vy9BJ6UELtOTKCKYTmWd2b9H8oCaZPWFzLdzszfvmtPk82N9qBG3xsg
	yqIEE8Oybatzbse3Aj1kUvOb2tI5w7IPcd280TAM7ueEyCuFtf+4/zpkLeZ6stVs
	C7XavL9/LXYkHkiRoTFY5rig+xLZSIQ9oiVQu3yhs+vKOA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5ZGCu1zuONdp; Tue, 20 Oct 2026 16:58:20 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j8JWv36SWz1XM4Tl;
	Tue, 20 Oct 2026 16:58:19 +0000 (UTC)
Message-ID: <e6305f92-dbdc-4f3c-8702-4611014167b6@acm.org>
Date: Tue, 20 Oct 2026 09:58:18 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] scsi: ufs: core: Add a helper for clearing
 hba->outstanding_reqs
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261020082110.3511797-1-stanleyjhu@google.com>
 <20261020082110.3511797-3-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261020082110.3511797-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/26 1:21 AM, Stanley Jhu wrote:
> +static unsigned long __ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
> +						     unsigned long mask,
> +						     bool from_irq)
> +	__must_hold(&hba->outstanding_lock)
> +{
> +	unsigned long completed_reqs = mask & hba->outstanding_reqs;
> +
> +	if (from_irq) {
> +		/* Do not complete polled requests from interrupt context. */
> +		ufshcd_clear_polled(hba, &completed_reqs);
> +	}
> +	hba->outstanding_reqs &= ~completed_reqs;
> +
> +	return completed_reqs;
> +}
> +
> +static unsigned long ufshcd_clear_outstanding_reqs(struct ufs_hba *hba,
> +						   unsigned long mask)
> +{
> +	guard(spinlock_irqsave)(&hba->outstanding_lock);
> +	return __ufshcd_clear_outstanding_reqs(hba, mask, false);
> +}

Please add a short comment above the above two functions that explains 
the meaning of the return value.

>   /*
>    * Return: > 0 if one or more commands have been completed or 0 if no
>    * requests have been completed.
> @@ -6071,12 +6094,9 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
>   
>   	spin_lock_irqsave(&hba->outstanding_lock, flags);
>   	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
> -	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
> -		/* Do not complete polled requests from interrupt context. */
> -		ufshcd_clear_polled(hba, &completed_reqs);
> -	}
> -	hba->outstanding_reqs &= ~completed_reqs;
> +	completed_reqs =
> +		__ufshcd_clear_outstanding_reqs(hba, ~tr_doorbell,
> +						queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);

The above line is about 98 columns wide. That's too much - all other
code in this driver is 80 columns wide. One way to address this is by
introducing a local "from_irq" boolean variable:

+	from_irq = queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT;
+	completed_reqs = __ufshcd_clear_outstanding_reqs(hba, ~tr_doorbell,
+							 from_irq);

Otherwise this patch looks good to me.

Bart.
