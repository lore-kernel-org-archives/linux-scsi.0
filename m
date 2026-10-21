Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575412;
	b=e4Eju6awAjlJ3FAZBCPKt5ecWDR+8F+UtLtJN8x9TqFw9adPGGKwHnsU4GTv4HwJaBTo
	 AidE4IMojugz3vYnWNDUKC3DN8oPsNdIzzepWXgx6t7tYDGQWuuHkqsqAUDJbbD7wq5X+
	 fCpxmRsWyZEjucxvJ3DPnoF2Myfjl2yLHd2KAK+cCuPun/ME1vxGSxXxJqWjHATrb6cZg
	 mjQdkgMhTO6SWMhYNFovrq4MhAZNcICKqNb8iIeaa5VLDYIEuDC2Qu1gE5RrkTfGaIzqr
	 d+a+GWF30UhiVyCM3sFiGt6QlgTv5a301Tm7MY/S7zpFHBsJFuw9vUq9pclqHfYUd/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575412;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Action:X-Spam-Score:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Level:X-Rspamd-Queue-Id:
	 X-Rspamd-Server;
	bh=0xKHBxgviBMY6RMZZZlVcmxSTz6Tc6DMhX3WPNXMYzM=;
	b=kih5LCneoZA5gqvtzBDqUrbCFo1drbRmBcbuQLojHrppySWcMKjAxg6opyB3xHpSifJf
	 j7zguUeDXue085Qc0ypirn3LFQUzo2C6NZltSZB8cjJXIkcmQ2JD6UnljAnRlSdmYMIhJ
	 rqxqyCAkMupXhitO9YKHs3nCYkTqXDprFenX43jpRGNUSBNgVDhbM31R+xWCGV0loq5Tp
	 2v20Svc15EvEnrbjAhhu5/Hzm1OL7O9dc9FhK5pekTsjncQBZF2XL2HbCd54jEY8Z8j6Z
	 /qF8vNXP56x7/1dwVE9CapjZZh7++WuoEHcgj2NFn+HXDA4jdUafTa0bScvaYBWDAtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kisJ3RAi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zStD+jgX;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=klzqhM2L;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=X6Zw3AzB;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B5B606A319;
	Wed, 21 Oct 2026 09:36:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99B5B606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=kisJ3RAi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zStD+jgX;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=klzqhM2L;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=X6Zw3AzB
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D23AF1F7BB;
	Wed, 21 Oct 2026 09:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xKHBxgviBMY6RMZZZlVcmxSTz6Tc6DMhX3WPNXMYzM=;
	b=kisJ3RAiWDLqTgq2FKf5C2r5alLjq1rTUhGGE9Dt0mkDquxfOKf5xAcfevNQKpHUQAZxZ+
	2R50PcRQ4DLYQ3SQf0BQX2KJSuyQGYU1s3MWDbl/Xmy5auth7sybAeWYt4KJcgQvfrcWBu
	7Fov94Exn5j72hBaqgqVXMMw/O8UIgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xKHBxgviBMY6RMZZZlVcmxSTz6Tc6DMhX3WPNXMYzM=;
	b=zStD+jgXOts5mwoQpJxSplGlGx9M8yJwYVUFbA+EwyNbIN3oukWBjxxmBYFLdtCTs2rJ1K
	BgDWFl+6BvkNreDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=klzqhM2L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X6Zw3AzB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xKHBxgviBMY6RMZZZlVcmxSTz6Tc6DMhX3WPNXMYzM=;
	b=klzqhM2LYnglM1/R959L98i24vz36Q3KKCoQRk5oPLYOYCw6Mum5fSxapOmJ4weGEnSbqx
	sek3Xxklfl/mv7bK2b4bdyIaY8WykmJuguhtbzPcPfhpez2zSMCtXreBR6lvVyQxtn+ZhM
	OyRGQJaGd6kCYcHjDIRXDgHxBlT1Qf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xKHBxgviBMY6RMZZZlVcmxSTz6Tc6DMhX3WPNXMYzM=;
	b=X6Zw3AzBQC7/jhH587y+LkTWFuV5mH8Fm7P23R3UyfIv1KZ6zW0DuZ01lBLkAt0FAI6Y+p
	5th/qltvrFRgRYAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EB7B13518;
	Wed, 21 Oct 2026 09:36:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id waeMF7GH2Go6HQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:36:49 +0000
Message-ID: <05a7b220-9795-4d7c-8e63-033e59143c78@suse.de>
Date: Wed, 21 Oct 2026 11:36:49 +0200
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
Subject: Re: [PATCH v6 01/10] block: introduce disk_zone_is_offline()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -4.50
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: D23AF1F7BB
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Introduce the helper function disk_zone_is_offline() for testing if a zone
> of a gendisk has the offline condition. The zone to test is identified
> using a sector number that must belong to the target zone to check.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-zoned.c      | 16 ++++++++++++++++
>   include/linux/blkdev.h |  9 +++++++++
>   2 files changed, 25 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
