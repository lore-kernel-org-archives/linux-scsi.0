Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576031;
	b=WyNXzhhoktXct0gTQOoSbGwiLpD9yCciEYM+qCf6R3lA9ShClHWgndSyouv6c/teiUqB
	 ypsTQeo6/m90XFKLzeabfEzZ4NYmJal491SiD0zMJlXKj3PcZV5gc96iOshj/ET1lCRp4
	 U9b0kGAQweKC5T4IRXQJ3Tw47uAuW7N98I34mxVa08uOqVOioYOwTcfYnQMEW+g8BZHPx
	 DB1578CiGdJFD/bld8oabYyDBK3lK+CJgW0K63vryfyZiUpixn+WZ5MU8aCOy/cllGTZP
	 EkLfrXOTnLiKVBUIQAcEGrrYqQb7P4yEtQ4AGOE/ZzQdRZc0pQbLB7YG/wB1uHKFw5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576031;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Action:X-Spam-Score:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Level:X-Rspamd-Queue-Id:
	 X-Rspamd-Server;
	bh=yxQ4UvTKeEA6JoFtoYNb79QjuedRIh+eoodb4ZtCYNY=;
	b=E36K5Ji34Bb5YF7ny+seuF64cdTzOYw7Az2cxPvNDwdZi5ksgoqmpCBOqwI+hMofYxKh
	 /2N83zgmpWEiwJ5x9d9wUgW8DQugABX98iHRIe6wGepb3Z0CrAArTKtw2z3tam3CE3WNm
	 /7roCn6QcPpk//jk1omPyiDxLDFIgF4zsieEn/Vu1EPabNI50f+h5Y3APbI8spPYoHQpg
	 GBi7J+hLw5Xnxios6dgOYeS7Lz3eeSDTZtWGx5zxdY1N2kp+mEjTBHtwJZYv8PMB4cXEm
	 14zJo+vh9aP6Aq45jvUciF3JwWP40rK6dSXH/DDAi8BZDMpiHJ5OWvcRtCdpXBIY+SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wJSRaLJ7;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4i+DwX2C;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wJSRaLJ7;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4i+DwX2C;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63EF606A319;
	Wed, 21 Oct 2026 09:47:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D63EF606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wJSRaLJ7;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4i+DwX2C;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wJSRaLJ7;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4i+DwX2C
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B0D021DCD;
	Wed, 21 Oct 2026 09:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yxQ4UvTKeEA6JoFtoYNb79QjuedRIh+eoodb4ZtCYNY=;
	b=wJSRaLJ7lfk3tJbvElCsDu/2gRrzlci3nt5r+wY5pXQPKnfD8yznfjlSVSgQKy0McCI8l8
	ZZ3WhaWla1CIhqxf+CNeOdvzv/fmTJjp+hSuzRSJqk0wdfq6RX7lGBNfjhBycjvt+9UlBi
	OpmLI3YgREwNc8An8qR3NaC5Yx9FtD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yxQ4UvTKeEA6JoFtoYNb79QjuedRIh+eoodb4ZtCYNY=;
	b=4i+DwX2CZaYcONQvv6MrvwJYjPXumdhO1INE03k37KxEaGyyGxsoFSy41H0Elouw/zpZ6U
	2xefnY/SuHynIJCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wJSRaLJ7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4i+DwX2C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yxQ4UvTKeEA6JoFtoYNb79QjuedRIh+eoodb4ZtCYNY=;
	b=wJSRaLJ7lfk3tJbvElCsDu/2gRrzlci3nt5r+wY5pXQPKnfD8yznfjlSVSgQKy0McCI8l8
	ZZ3WhaWla1CIhqxf+CNeOdvzv/fmTJjp+hSuzRSJqk0wdfq6RX7lGBNfjhBycjvt+9UlBi
	OpmLI3YgREwNc8An8qR3NaC5Yx9FtD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yxQ4UvTKeEA6JoFtoYNb79QjuedRIh+eoodb4ZtCYNY=;
	b=4i+DwX2CZaYcONQvv6MrvwJYjPXumdhO1INE03k37KxEaGyyGxsoFSy41H0Elouw/zpZ6U
	2xefnY/SuHynIJCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6016134FD;
	Wed, 21 Oct 2026 09:47:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nyW9LRyK2GrqJwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:47:08 +0000
Message-ID: <d602572f-354f-4789-a69a-f939a263cea8@suse.de>
Date: Wed, 21 Oct 2026 11:47:07 +0200
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
Subject: Re: [PATCH v6 06/10] zloop: add storage element emulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -4.50
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 2B0D021DCD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On 10/13/26 2:27 PM, Damien Le Moal wrote:
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
>   .../admin-guide/blockdev/zoned_loop.rst       |  10 +-
>   drivers/block/zloop.c                         | 690 ++++++++++++++++--
>   2 files changed, 656 insertions(+), 44 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
