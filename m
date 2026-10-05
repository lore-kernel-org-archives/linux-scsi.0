Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9B1C5D72;
	Mon,  5 Oct 2026 11:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791198881; cv=none; b=RVt+N8PEqRBINQn8I11rQb4VYdrLG6D7jIp3tqFf/aTzPiHo4ufgrXs62ZW+0+fZqNanEV166YSjVWdF2M1B21IoTMeK1ve96pgxGR7qBqwjqusptsiFv0ZYnxwGfqZRfrgNsFtvL6TgCdXGklhlxx7fN3ANRZl0Wsi0kANn0nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791198881; c=relaxed/simple;
	bh=cHk0MW4dB5AVjfBjimXZLZY5V6n0ldrVPIpmP5uI2uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HpOX9/xt89IIlfMQ61pk6OYlcemdEp7wm4QcV6cXF2my/NGkNpNjfM9DRkWnBm/a3pVyS8HVgGWnXRNksf1rXHAxI6nAl7c7EVxuCymMfsrusQ8OWFfFjEVxBiQE4sUKq5B3fZAytpVXOmLSY7RZXrB1AWBGuSuvWZBPPvbIKuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1d0mUtP7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yv4Ub1yI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WJEBqa9P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/bGmdH2p; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1d0mUtP7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yv4Ub1yI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WJEBqa9P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/bGmdH2p"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4136C1F7AF;
	Mon,  5 Oct 2026 11:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791198874; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LQuVkelhplC5ln1sVH8T3GvwFBI0FlaqhViY7Qpnt/8=;
	b=1d0mUtP7t2F1qZpCWUh2lItoi7k2D4x3crIx7yJfKLMuMnNseIjKbDtsoshsDKauJuZp4G
	zTXUSipvXaLuf8hoJSIr1BG+oC8NsCL9UCANzdzPlmI2xbkW2PvdHuOX0FGKTKmn4MCOW0
	WEGEutDwxE9Q0yYqLpK1XPZaIWTkQyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791198874;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LQuVkelhplC5ln1sVH8T3GvwFBI0FlaqhViY7Qpnt/8=;
	b=yv4Ub1yI5Pnmlnos5AIO5wssAp4lyyq59VYSqZONQTOhZvKmW1dno/Oj2u0mJ2X9hl9PEG
	LkqLmZTDPbVM5FCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791198870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LQuVkelhplC5ln1sVH8T3GvwFBI0FlaqhViY7Qpnt/8=;
	b=WJEBqa9P+TYOaTpIM9g2Fxm9mVrujpDm+JowgnaoaQOqy27CD/hXfZ/Bo6mpQ1OJfzRi5K
	iMm9LaqGVX/28QkssVs8dLxV4fSZioMI793CObKoaW7ouPocAFrw1AymF9xPe8XPCKBakT
	q9yCpL1RNfTLdRF50X4AJY62vviXwqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791198870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LQuVkelhplC5ln1sVH8T3GvwFBI0FlaqhViY7Qpnt/8=;
	b=/bGmdH2pPmjMRi89R+D97gsonzaLvGzverWz3YzF1i2DNdehnUaJlRciZcbqbV7zo37P00
	XrbTDnuqdA/eitDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F022132D3;
	Mon,  5 Oct 2026 11:14:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o109OJWGw2rEVwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 11:14:30 +0000
Message-ID: <e0822b7b-e516-434d-acbf-3a235bf1eec6@suse.de>
Date: Mon, 5 Oct 2026 13:14:29 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] zloop: add storage element emulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
 <20261005094632.580753-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.979];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> Emulate the storage element depopulation feature of SMR disks in the
> zloop driver. This emulation is controlled using the new stor_elements
> option.
> 
> This option can take several values:
>   - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
>   - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
>     (e.g.  read+write heads)
>   - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
>     elements (e.g. pairs of read and write heads)
> 
> If enabled with the value 1 or 2, the number of storage elements, or of
> pairs of fractional access storage elements, is automatically calculated
> based on the number of zones of the device so that we have at least 2 and
> at most 32 storage elements (or 2 pairs of fractional access storage
> elements).
> 
> The mapping of zones to storage elements is defined simply as the modulo
> of a zone number and a storage element ID. E.g, removing a storage
> element from a set of 4 storage elements will offline 1 zone every 4
> zones.
> 
> The storage element management operations are specified with the
> zloop_se_ops (struct blk_storage_elements_ops).
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   .../admin-guide/blockdev/zoned_loop.rst       |   8 +-
>   drivers/block/zloop.c                         | 510 +++++++++++++++++-
>   2 files changed, 490 insertions(+), 28 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
