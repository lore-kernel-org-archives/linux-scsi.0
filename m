Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975077;
	b=qheQyv/bGz/FEytlblDVndkXqeWqStutAezNW7D94/A/7E45AucUTLj32VZyAIDOGd+6
	 sYBi1gKiqtfLZdo3hxq55gu4FDuLIpVof3M5wBRj4UoO2OJfapoF9Lc5FfmECzCcueIop
	 1Sd39cnKQ4w22mFrl25M8jT0FO7JzohHKk7YnEx4tPHRAEiH8WXf94zUI7v2SFXUL33vT
	 aY27sawt6UYNbczGq8ZZ2SQ3bCMtWvYWiCdzbu6YolWVSsjFEGxV+tMnostP6UNobb7ZK
	 S6u5OIjQyoDAjPnNzLAEY02/NK+e5VU2fATbVi1OcqFLmGH75HXAguqzQN6H+Dys9Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975077;
	h=DMARC-Filter:Received:Received:DKIM-Signature:X-ME-Sender:
	 X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=IL1uP3TWx2sdq9EHxnID+hoVQzxeT6JCCziC5GCVic0=;
	b=ZahqPHTVVHnaeYQtvBJIhK/X2qcdRMU/HhsAZwitvf7TnLth8/6ozpoGoiRCxzuMkXZZ
	 16R+j8DKmHYjjzQ4ZAAnGogAY9YOoqmF1BNWTbKp8X0wGJMFEa8nxij6axsl0/L4NMRHK
	 6oa0Wp/PEJNnrTTsRVwh+uUbvGQEB+HunpOIkOYoH+E5QDo7j9Ga6o5X/7h9m9aa43jwV
	 pyvDdu30VbrRMGY8CkJOErOh58FQWmMScgpri8aSuE/WqStww/+gGGXDzU9neCrVaCg9r
	 deBm6/T2oqJKkyL1fgSlCDvvsBcOgJpsVvOkEnIFX+lrPosKu8t7rkj9KeOJiAViZUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=linux-m68k.org;
	spf=none smtp.mailfrom=linux-m68k.org;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=OknC5iF5;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7E3606A31C;
	Wed, 18 Nov 2026 04:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD7E3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=OknC5iF5
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DCD667A027A;
	Tue, 17 Nov 2026 23:11:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 17 Nov 2026 23:11:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794975075; x=1795061475; bh=IL1uP3TWx2sdq9EHxnID+hoVQzxeT6JCCzi
	C5GCVic0=; b=OknC5iF5hdwju2lQaAxYxWDg8yVMDio4GBfslj75QJ/kf3KS0nM
	s48oD1wRgTkrqCJc4GJxkZDHnLmMZp/fp++iZbNgJ1enpu1D+aaufTAug4/ezU9d
	8F/UV1Rd54YslhT+rUVee8xYGDF0r64sxWHmqVP9DjviSxXNSS7pYxud28VKwwXO
	IzEQpDIRYhgBmO6G/Paf6i8+fmOL9NUXK4n8Wq7wWL6vb2viN4xnTV7cqZBaqbGM
	3PstnTO3eKyoESefbjCIZC/Yl7GArg8jq5zgG8nOQaNMAIx5LUAXYBXOs3Tw0aMl
	96bGkp8uAWK/k8+LSw0aM1N6tLfvF1TIY+g==
X-ME-Sender: <xms:YyX9ap2X74tGVv50NiwIHVLa25dGLTXLiO9mqVPGp8b0CdcaUfuFpA>
    <xme:YyX9ahnGl0d-AldqoQWHFZy1eWZ-h7S5dvNpWQd-UZex-RoLLZoH7gnd_UxQKXZhY
    rsS5rU4HnStN_iwBqGM3mH_fyX6S8OMxt3LAflMx4yICSEbgymgM4I>
X-ME-Received: <xmr:YyX9ap-Lu1nxGbdPYNF2mf85rPESC55l7qkl_-fFYor5aa9j_oCCElWuDi7o>
X-ME-Proxy-Cause: dmFkZTEGcbklFMPuvNp3yEESMShtPrCjiVijO2JNLjxVkU8dk4WjSZ3g1bmbNcSS8Pj/b/
    xbHvEEF5M2CEgOPtWJGGQnAnH347CYaUPwoZ9d6KJKZy5mUp22qRUooj6bRMZ+i0IUJjsZ
    /hm2rR098w0LUvDZxuKVbe9gZnRiT/rQas+yYZxxpNbaxPSkKxtISXAuwYQ51EbhmIR8fp
    GZDO3eVQbMPZ5G6jit9/5rEnMLp+MCafBpdtjTlPQWedwgPMexxL6PBTHnr8HfcBBveQgS
    /UO5R6x1pmG4azbIse/1f2pC+5tf+PjNgGCzL/Uhd609b0kMF45n5N2MCCyYUqOoejURZd
    SS/IRz52WKS6ON+UK2V/GTlVWrOyV1xP51siT+QaKbR+jJxJBqCiwtOSwoyFCiFdT0SXwp
    4ALYHq4Uc0P4UvETjpv0sCgUUk2d9h3Xvycw4eHad+VfsCTsKQ7pXG/aCCDe9W5huIKzzT
    Sg2zL6Fm8koZMnp6UFxeNSel6908P5XkGEhrUx7gvh9IcoqhJWlFAkmxgcX6f6HONJl3Ls
    7QHRW7qxJUZjGoMhrrXWM8d+ihG/DRb9Q5pbaGy309N572mhpYozWGi1ItmcSxCqpqIUqz
    GDyPWwuQn9yd/fy+gNXddxHZty5j5mEv2D0tlOrCiFecFruXp5ejyGcQHpBg
X-ME-Proxy: <xmx:YyX9amqm21B5VnP0z8gPHINIDrMFtTUYgFdODwy-Myz7fY4wev6Pcg>
    <xmx:YyX9ailf-nA-x7rgHFFMts4MKNljHrFi-MQ1lDkqHXRAIOTEWdUTnQ>
    <xmx:YyX9atibVkusm0x4Pr0JafFNHQea8ejnV1fDRm38tk1YozWLrfqfjQ>
    <xmx:YyX9aqfFxye6vduuLtnNyCZ7orVo83oCoMiLKFTur2EOnQTNNcNJlg>
    <xmx:YyX9ahDsRaMuNTEEHoxdDiVY6mvIt9OjKq_Ft_lbg5vezsXKmzL-t-_a>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 23:11:12 -0500 (EST)
Date: Wed, 18 Nov 2026 15:11:02 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Tim Douglas <me@timdoug.com>
cc: mkp@kernel.org, James.Bottomley@HansenPartnership.com, 
    linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: esp_scsi: report the residual byte count
In-Reply-To: <20261118003746.61659-1-me@timdoug.com>
Message-ID: <ee193416-6116-7656-e984-5a556490997e@linux-m68k.org>
References: <20261118003746.61659-1-me@timdoug.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Tue, 17 Nov 2026, Tim Douglas wrote:

> The ESP core tracks the number of bytes left to transfer in tot_residue
> but does not report that count to the SCSI midlayer. As a result, SG_IO
> returns a residual of zero even when a target transfers fewer bytes than
> requested, as can happen with INQUIRY and MODE SENSE.
> 
> Report tot_residue with scsi_set_resid() when a command with a data
> buffer completes with DID_OK. Initialize the scatterlist DMA length
> on the identity-mapped PIO/pseudo-DMA path so the residual starts
> from the buffer length on architectures with a separate DMA length.
> 
> On a Performa 6200CD with an out-of-tree ESP front end, an SG_IO
> INQUIRY with an allocation length of 255 returns 36 bytes from the
> internal CD-ROM drive. The residual is 219 with the fix and 0 before it.
> 
> AI assistance was used to investigate ESP transfer accounting and draft
> the fix.
> 
> Signed-off-by: Tim Douglas <me@timdoug.com>

Tested-by: Finn Thain <fthain@linux-m68k.org>

Regarding that front-end for the esp_scsi driver, do you think it can 
replace the mac53c94 driver? Has your driver been published yet?

> ---
>  drivers/scsi/esp_scsi.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 9993b0ae9..162f8fe14 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -388,6 +388,7 @@ static void esp_map_dma(struct esp *esp, struct scsi_cmnd *cmd)
>  
>  		scsi_for_each_sg(cmd, s, spriv->num_sg, i) {
>  			s->dma_address = (uintptr_t)sg_virt(s);
> +			sg_dma_len(s) = s->length;
>  			total += sg_dma_len(s);
>  		}
>  	} else {
> @@ -907,8 +908,11 @@ static void esp_cmd_is_done(struct esp *esp, struct esp_cmd_entry *ent,
>  	esp_free_lun_tag(ent, dev->hostdata);
>  	cmd->result = 0;
>  	set_host_byte(cmd, host_byte);
> -	if (host_byte == DID_OK)
> +	if (host_byte == DID_OK) {
>  		set_status_byte(cmd, ent->status);
> +		if (cmd->sc_data_direction != DMA_NONE)
> +			scsi_set_resid(cmd, ESP_CMD_PRIV(cmd)->tot_residue);
> +	}
>  
>  	if (ent->eh_done) {
>  		complete(ent->eh_done);
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
> 
