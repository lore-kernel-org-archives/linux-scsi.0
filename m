Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833883;
	b=Rg3LFUQ/qkczEN0TAvOVcfiGIbB3VaKqP9T329VKkzlH9rTmzp/wKEzFuFQXn1laX5Yj
	 w1+aS4g4ORADc+I+ZFKgRxyitKeGdZW5znMgVBvUlxc8EHpV5MU6vQMiOp/ccbCkkhDgA
	 dvOt8LjVtHuh9TfL2YgQEIM8OWpxVKN6nfDUNgVCO5jlbHFAcYA09bZzlH6zS7tduq8ug
	 ARuulJhelVAx2WmQiCGfuJzD5myw0IhTncO+xg+NBDcQVdEjhOjdxEK5wHkWV3iegbhA6
	 +Ocq8zqX50m3Foi32VqfgvrW7DtbezjtiTh4nVmUx5cIT0CguzJHYGJUSpkMH0IPa+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833883;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=qal8UuunRgkosSIU49gXoj+H7xf2mzwRvMG542u7h+k=;
	b=H4vI1lnKvtIlvVBzg8FclgkrS4xacerSYejpEal1xpKljCZf1AacKBarjFUY+IMBluh1
	 lIk+5boyumdrm/0UfbLkn/sbpk/zRQlVFYg+S0efE7toGZ9Y23OLao6X0pSE6GoHQwPca
	 Go+rjjlHq97gIL5IyjjsIradv+y6gNm6xwViU1QQIkjeUIo9O9rRig5ie3OcPRDeWLKPp
	 DpnjZ833w+t2RyRI//Ek9nzMqKGwQbidyeoufo3BeUmCsHOo2EA++PBxu3BTDfMkRkRAA
	 kRBVEAsZ5wHmoEtaxOIYjezNyCFkf2x0i7ZNkX26mDvMmb4dUdAGXYEbNxr9AOvZkRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="hm/tdR/p";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eYnRihck;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="hm/tdR/p";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eYnRihck;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988A6606A323;
	Mon, 16 Nov 2026 12:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 988A6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hm/tdR/p;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eYnRihck;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hm/tdR/p;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=eYnRihck
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BFCA01F7D2;
	Mon, 16 Nov 2026 12:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794833880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qal8UuunRgkosSIU49gXoj+H7xf2mzwRvMG542u7h+k=;
	b=hm/tdR/pxSi7ozoTZHYSm+6R2Tsd9dyLycpgGsi7aM4mo2UGRYW+qsXSvRYD0Y9xpqVZ8u
	op8RcZBXQz21J6Froyf8xSE7q4Ky7b7z2qM4WdNsi8LogpMMxDA7bQWYacnPLSzK3NTN4F
	8lFtJxVxK7jM/UpnC7rdLgOy4pa1enI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794833880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qal8UuunRgkosSIU49gXoj+H7xf2mzwRvMG542u7h+k=;
	b=eYnRihckPW+X4sTOpLpjH9oZzfWb5xXIAt3qGRdQPx8fI824NUIgHEd6EEiwv1jibGakli
	QqTzReKSeVq2FtDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hm/tdR/p";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eYnRihck
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794833880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qal8UuunRgkosSIU49gXoj+H7xf2mzwRvMG542u7h+k=;
	b=hm/tdR/pxSi7ozoTZHYSm+6R2Tsd9dyLycpgGsi7aM4mo2UGRYW+qsXSvRYD0Y9xpqVZ8u
	op8RcZBXQz21J6Froyf8xSE7q4Ky7b7z2qM4WdNsi8LogpMMxDA7bQWYacnPLSzK3NTN4F
	8lFtJxVxK7jM/UpnC7rdLgOy4pa1enI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794833880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qal8UuunRgkosSIU49gXoj+H7xf2mzwRvMG542u7h+k=;
	b=eYnRihckPW+X4sTOpLpjH9oZzfWb5xXIAt3qGRdQPx8fI824NUIgHEd6EEiwv1jibGakli
	QqTzReKSeVq2FtDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E2E91334C;
	Mon, 16 Nov 2026 12:58:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WvJRFtj9+mrPBwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 16 Nov 2026 12:58:00 +0000
Message-ID: <b80b824f-944b-4375-b8f4-535a7e8a8a6c@suse.de>
Date: Mon, 16 Nov 2026 13:58:00 +0100
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
Subject: Re: [PATCH v9 07/13] zloop: fix zone reporting consistency
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261115145015.938426-1-dlemoal@kernel.org>
 <20261115145015.938426-8-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261115145015.938426-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.de:email,suse.de:dkim];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: BFCA01F7D2

On 11/15/26 3:50 PM, Damien Le Moal wrote:
> In zloop_report_zones(), filling the write pointer and condition of a zone
> descriptor separately outside of the zone wp_lock can lead to an
> inconsistent zone report with a write pointer potentially not being
> consistent with the condition being reported. Avoid such inconsistency by
> filling both fields while holding the zone wp_lock.
> 
> Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Hannes Reinecke <hare@kernel.org>
> ---
>   drivers/block/zloop.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 7d98be66a3a8..a13937f3bf6b 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1001,8 +1001,8 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
>   		blkz.len = zlo->zone_size;
>   		spin_lock(&zone->wp_lock);
>   		blkz.wp = zone->wp;
> -		spin_unlock(&zone->wp_lock);
>   		blkz.cond = zone->cond;
> +		spin_unlock(&zone->wp_lock);
>   		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
>   			blkz.type = BLK_ZONE_TYPE_CONVENTIONAL;
>   			blkz.capacity = zlo->zone_size;
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
