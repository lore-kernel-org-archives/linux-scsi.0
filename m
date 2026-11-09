Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794222979;
	b=pj2dHAC2dumKc+Vl+gk2kYgcfO2hk2sgzIJh7bYAX2JwkUJfmAKfuV0jcxa1Ydq8rWb7
	 GpbTHox+1itkoXNdymlK+Lf+dsFZ5vc8xOyqm8KMVyoQXOPgiFHGsTbMHnLIj7YCTU2Jw
	 2HQfetIGZFEJcu+0qvrpwhSF6YZYnxhBDjq6eGV6uM51UA1GxkTYURITOUqmL1J6duToM
	 soKE54i01jJHl0jXREpo8rLgjqhnDgh9lLMAXFPA5zCjPobir2JApbsmnE1h0GGCbITtw
	 obrCHaIoIa5nc01CHu+iIm61uotsxdYlQMP0YRmZMS6Q0VEeRvAvBNx0CNxZx7bBYSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794222979;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=ASo2dT3qHjo4Tx+1a41SSOxUTIBVkNxhd30sptd/Q8A=;
	b=W9qyh/vvgCzoLKWpNSDjLV/44lPoj08hUBH9fit+b2ZVAtkN34hDwjYfSOgZ+OeAnzHL
	 3hd7rtNcwCgOSQRIKblkfwlEhJFvhNY/FaNYAFAYdlJcPvrRcG6Dm2iYktyDQP51UnzYM
	 eXCJKb4MO8ez8kucb4VS3n1OFKvpTq2KDqmzLJ2yfUMb08/GI54ABqzUWNwqHQyp6E93x
	 Zr9cLFAbAavMyTgd5sWECwsKH7zdRXd7w7Rs/Z3DN2/cGv0fc+xNxgUAeO1RIglTYihjo
	 CLrt7BbwRJf2uVbXTQDoORu2AEClYstGf3FnLjyeYnv01BLBc2xfO/R8INk/sSqN7/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UeQSMQu9;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=npXPVuU1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UeQSMQu9;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=npXPVuU1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF69606A321;
	Mon,  9 Nov 2026 11:16:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF69606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UeQSMQu9;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=npXPVuU1;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=UeQSMQu9;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=npXPVuU1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 449B321EE1;
	Mon,  9 Nov 2026 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASo2dT3qHjo4Tx+1a41SSOxUTIBVkNxhd30sptd/Q8A=;
	b=UeQSMQu9l4I9NFGXFC08JspVYqgbZL0qRcgtUyHK5YkptcSv4v4b15Sjo3zKo69En5ooNV
	kD95fJwgqb2XJjgmKzPW/eZP3yRBJa2vTz3IsvbxTz/akS8WIVECl+ha3HNJmY+tSVklah
	YUE6unJVse1xym6uriKZYXiGoEIRgT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASo2dT3qHjo4Tx+1a41SSOxUTIBVkNxhd30sptd/Q8A=;
	b=npXPVuU1TfAYhJtguaORzluB/pWjVSeU9St9XLRaRRgIK82eBKOTnmMDfey44Fx0bwEFUd
	1BgCUm/xQyHpi5Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UeQSMQu9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=npXPVuU1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASo2dT3qHjo4Tx+1a41SSOxUTIBVkNxhd30sptd/Q8A=;
	b=UeQSMQu9l4I9NFGXFC08JspVYqgbZL0qRcgtUyHK5YkptcSv4v4b15Sjo3zKo69En5ooNV
	kD95fJwgqb2XJjgmKzPW/eZP3yRBJa2vTz3IsvbxTz/akS8WIVECl+ha3HNJmY+tSVklah
	YUE6unJVse1xym6uriKZYXiGoEIRgT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASo2dT3qHjo4Tx+1a41SSOxUTIBVkNxhd30sptd/Q8A=;
	b=npXPVuU1TfAYhJtguaORzluB/pWjVSeU9St9XLRaRRgIK82eBKOTnmMDfey44Fx0bwEFUd
	1BgCUm/xQyHpi5Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15C2413319;
	Mon,  9 Nov 2026 11:16:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EVgQOICr8Wp/GwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:16:17 +0000
Message-ID: <235e9b84-4bfe-488c-aacf-b31d30d7fb8d@suse.de>
Date: Mon, 9 Nov 2026 12:16:16 +0100
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
Subject: Re: [PATCH v8 06/12] zloop: fix zone reporting consistency
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-7-dlemoal@kernel.org>
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
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: 449B321EE1

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> In zloop_report_zones(), filling the write pointer and condition of a zone
> descriptor separately outside of the zone wp_lock can lead to an
> inconsistent zone report with a write pointer potentially not being
> consistent with the condition being reported. Avoid such inconsistency by
> filling both fields while holding the zone wp_lock.
> 
> Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/zloop.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 96666742523b..844a9f5db6a4 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -992,8 +992,8 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
>   		blkz.len = zlo->zone_size;
>   		spin_lock(&zone->wp_lock);
>   		blkz.wp = zone->wp;
> -		spin_unlock(&zone->wp_lock);
>   		blkz.cond = zone->cond;
> +		spin_unlock(&zone->wp_lock);
>   		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
>   			blkz.type = BLK_ZONE_TYPE_CONVENTIONAL;
>   			blkz.capacity = zlo->zone_size;

Reviewed=by: Hannes REinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
