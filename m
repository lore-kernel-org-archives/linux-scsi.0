Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF6B11721;
	Sun,  4 Feb 2024 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049899; cv=none; b=HqVK/tHDJSh4DuThvyut2021AblBs+ibS7lEpDLkiPUrQk/J6XwEoCvJGCXKoalT1TjJ0MQfbK1YC5gSpsL1MztwxEcuYUsyQnd4qNGC/BnKUposmR0mI7U1F1aaF59AEuXRFQuO9dlR4OgR7yXj6Qle9QyohatVV+Y8wA91R5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049899; c=relaxed/simple;
	bh=BViBL0n//DZwAZwsWKT0knJ1kyZTJzz3k4JOV2TPiCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WeDlHJHXFt1xU8pUONQLiVxx3ELRcze0t2PH1Vh1vOVb9PliHwXo4QoXtad9UfeNUEkfoquFJS/0+6gq3UKwNtxAZHWFIcGbI1I4rS6zpakmltPrlj9cW93OOSc7Eqi1ty0RKM3aQZbnUAI//ybBysBz1wnS3D86GxNIlHdTb+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ddAZ9eGh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BeqxLSZI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ddAZ9eGh; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=BeqxLSZI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ddAZ9eGh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BeqxLSZI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ddAZ9eGh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="BeqxLSZI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 382BA1F80C;
	Sun,  4 Feb 2024 12:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8aQJMwR9Z5GsK1IJPnlrbjrvibaz7ixCYFZBd+IcSQ=;
	b=ddAZ9eGhwd/FkErPz+0npVnLluer4Z3I207siS+Jc/ivmGm7TklvLy1Pb6LB5CapOlqnbE
	38B6EM8eajDDWj7PK1uyRvTajMnVbD4N6C+nKQ9ccvz+fIKzAS5fKUAkSBkqDp3OY8C5qS
	U1ggmVYzhrxXiN2Et7pUP9uhOD3bil0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8aQJMwR9Z5GsK1IJPnlrbjrvibaz7ixCYFZBd+IcSQ=;
	b=BeqxLSZInN9uRJyQSsfeS+T2Dg3t2breezBXCIHWB2BT7kfA0s5b+UhOYb8By9ZZsPDc8C
	/wwjYVPzvRrbayAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8aQJMwR9Z5GsK1IJPnlrbjrvibaz7ixCYFZBd+IcSQ=;
	b=ddAZ9eGhwd/FkErPz+0npVnLluer4Z3I207siS+Jc/ivmGm7TklvLy1Pb6LB5CapOlqnbE
	38B6EM8eajDDWj7PK1uyRvTajMnVbD4N6C+nKQ9ccvz+fIKzAS5fKUAkSBkqDp3OY8C5qS
	U1ggmVYzhrxXiN2Et7pUP9uhOD3bil0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8aQJMwR9Z5GsK1IJPnlrbjrvibaz7ixCYFZBd+IcSQ=;
	b=BeqxLSZInN9uRJyQSsfeS+T2Dg3t2breezBXCIHWB2BT7kfA0s5b+UhOYb8By9ZZsPDc8C
	/wwjYVPzvRrbayAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D289132DD;
	Sun,  4 Feb 2024 12:31:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iEMCKKSDv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:31:32 +0000
Message-ID: <7df50ccc-a93f-46e8-9609-f706e7c8dc7e@suse.de>
Date: Sun, 4 Feb 2024 20:31:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/26] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE
 elevator feature
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-14-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-14-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ddAZ9eGh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BeqxLSZI
X-Spamd-Result: default: False [-2.07 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.77)[93.62%];
	 MIME_GOOD(-0.10)[text/plain];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 382BA1F80C
X-Spam-Level: 
X-Spam-Score: -2.07
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> With zone write plugging enabled at the block layer level, any zone
> device can only ever see at most a single write operation per zone.
> There is thus no need to request a block scheduler with strick per-zone
> sequential write ordering control through the ELEVATOR_F_ZBD_SEQ_WRITE
> feature. Removing this allows using a zoned null_blk device with any
> scheduler, including "none".
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/null_blk/zoned.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index 6f5e0994862e..f2cb6da0dd0d 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -161,7 +161,6 @@ int null_register_zoned_dev(struct nullb *nullb)
>   
>   	disk_set_zoned(nullb->disk);
>   	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> -	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
>   	blk_queue_chunk_sectors(q, dev->zone_size_sects);
>   	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
>   	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

