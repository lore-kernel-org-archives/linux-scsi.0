Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073090;
	b=ufU7tU/xJNQrWLujrCvEN9rmyvhxy745EmT42iBHfzLfgn9nfd7NVsrzgxf4/IepNtZD
	 dNgg9AaLvQh6WKFJvsF1w1j9Gd60kFS01KiaN1YpHPvxaj56dpPuZRxR6ceOuI+t24H8l
	 u+uVtct+kEult44EY3m2LuvGCU9ycKb1JpWIns1wlk4HqY6yNyJxT0ArZwALLN7bQ36WS
	 ceh6j9ub2KQWPzvgh1Adt1HD3MlsMV1cB+j/UOaztg6lddN1nXt5bi2g3P1YOwRQhqGk8
	 oIbD5mw8NGKIN6fajb9fNrwO1C712UXhRjQDmo/sDYiCGXnydh6DXozrbpL+T8yDiPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073090;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=Z2CU09g/rx7JNyFGOoWlNZJxHrWJRck4HYEfS/GMMig=;
	b=PiOSTwmGzKDqewAz9732MEM99fy8lgxjZwjfdvkSFizrRxGo5QZgxSafLI9TEy+aegyP
	 Ocinsmr3FbBp2rWadPep7d9JgYZQSj1qOVGwYf0WAwTEAUbb912xt+8j8T5JsIc6HZWxY
	 NYXwZX2FED9yozZve1lYUuhSIFYmEdrFWCXfNRCXkoSQn5pE8AZY7udOVQ4S/QECiuA+d
	 2fVJ900WCuUtjcwoY+TshhG9F1mWDK4YkqinTIaopPSA8HwuVTLWa/aK9ZLqD3kmofi1h
	 s5wO2mFWQvcvF8T4yvCsX4mn4Tfmk7yFAkDrXzHD1Al0Ec0kqV7rYiuCyrDbgY6B2aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1FQYXKbK;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sLiT6gSz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="vZt8/KwU";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=46LvWbMC;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A81606A325;
	Thu, 19 Nov 2026 07:24:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84A81606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1FQYXKbK;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sLiT6gSz;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vZt8/KwU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=46LvWbMC
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F6421F7A2;
	Thu, 19 Nov 2026 07:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795073087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2CU09g/rx7JNyFGOoWlNZJxHrWJRck4HYEfS/GMMig=;
	b=1FQYXKbK1mOAiZa/4uzTYibJ3qvHKx+l8lkql937bUyH/BXIRU0ISOGLfYOiQFrXi2xUW1
	vxajaLHYMY0AnluS6hoWIosOo8E6e3L4+RTR65mcgJN4n0wswFijPYFteWCYWcBGja6QdX
	VU+lwgeKsXh7JLHbWh7sOwlPOpGawNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795073087;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2CU09g/rx7JNyFGOoWlNZJxHrWJRck4HYEfS/GMMig=;
	b=sLiT6gSz34auHDKYDQCimHov0/j3YlxZNBf63byR5TnP+UOAe2/m5On74e8Vd5M9BT8a+A
	zWkxUIFrOjghf6CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795073086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2CU09g/rx7JNyFGOoWlNZJxHrWJRck4HYEfS/GMMig=;
	b=vZt8/KwU10e9lCqfMT4vlrt/0cv5WMi+2sIM223b99B6nlT1hOV89RKrU9x8+p8beV2MGk
	KUwwLc8XN6ljjxmq8VlNOXYy3j4TN/MTWIYJK0YPb3jB7l8nCLkCuwe7jfN1rQL8jk4xz5
	Vm+Fyvvs+A6+Gqfh6lYxWCfr1ehDdiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795073086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2CU09g/rx7JNyFGOoWlNZJxHrWJRck4HYEfS/GMMig=;
	b=46LvWbMC5GlHQZPsaY0nM6j/51uVY2+KG3ajEMSDynNcEk/G6nr4YTRXgNS6bota2FRWK2
	QzB+CneRbUI+zJCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 485641334C;
	Thu, 19 Nov 2026 07:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id glo7CD6k/mpoUgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 19 Nov 2026 07:24:46 +0000
Message-ID: <06b06739-33d9-4314-8080-ccf28fa77b94@suse.de>
Date: Thu, 19 Nov 2026 08:24:45 +0100
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
Subject: Re: [PATCH v11 12/13] scsi: sd_zbc: define storage element management
 operations
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-13-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261116213702.225970-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29
X-Spam-Level: 
X-Spam-Flag: NO

On 11/16/26 10:37 PM, Damien Le Moal wrote:
> Define the storage element management operations using struct blk_se_ops.
> These operations are valid only on SMR disks supporting the storage
> element depopulation featu, with support for the GET PHYSICAL ELEMENTS
> STATUS command being mandatory. The support for the modify_zones operation
> is already indicated by the depop_modify_zones_supported SCSI disk flag.
> sd_zbc_check_depop_supported() is modified to add detection for the
> command RESTORE ELEMENTS AND REBUILD, which is indicated with the new
> SCSI disk flag depop_restore_supported.
> 
> Both the remove_element and restore_elements operations will block
> until the operation completes or an error is detected.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c     |   3 +
>   drivers/scsi/sd.h     |   3 +
>   drivers/scsi/sd_zbc.c | 489 +++++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 494 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
