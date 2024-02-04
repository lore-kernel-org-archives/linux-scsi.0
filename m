Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442D32231F;
	Sun,  4 Feb 2024 12:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049940; cv=none; b=JqmqvX9bwhrkEIlJI10tUrLbGq+7pRz+DAl1/+G+n3C0fT9chmAljpNJqyrb/e7/8wyjXwT8rMY/a+2g06/0m7MIs6eAeymDn8ygfcx1CpSsF7ibZjsapMb5t/NONKwarqkioW8AxTZbV3rJy24JHeGw9/ySbb6Wxy3nJJ1Rlwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049940; c=relaxed/simple;
	bh=WKWvtrmXy/h0zNo/H1i5/co7BGQviJ73nq0b15zbwBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnM+HWk6bBQ+ovPp7xAyTPYOD3tCdLqIkUOc1fKS7KwJyhUmreyxe6HZkJE/rCjsyFZLJPNnY3pHC+P0WACvYFENgXtRkTDaYnkPNu6ICgjD9MSAhtB8ili0HpiobU9JUwlbVexUvu8T2EbNR2zxqxjgR5eF5rUZe/gVl0WPuCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AV3smeEt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dnJ9Jd+n; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AV3smeEt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dnJ9Jd+n; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AV3smeEt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dnJ9Jd+n";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AV3smeEt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dnJ9Jd+n"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7264F1F80C;
	Sun,  4 Feb 2024 12:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLSAOPETBgDWLK1JVvygZfruBNGi9kz5Qw7QBC9gyQg=;
	b=AV3smeEtJ8q0Ezv062Ao0mGxRQhP759hWd9QTr4+wCEQflJINNVLgFQX+pBwrVILpYAjZV
	ubTMfg69Wqbe7M/CRFngPRvddYBLA+hPfGTOoMqxmIHKMUolPPe0qU3A3pamBRPVlTgvm1
	InJquDLQ4C05c1AVTh8JhJAOH9nxxE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLSAOPETBgDWLK1JVvygZfruBNGi9kz5Qw7QBC9gyQg=;
	b=dnJ9Jd+nUV0NVQ/UVHOhjItPuaCV8W6xY2VbFncrB2VhCVxy9X1KUCn9QhWYGaGOOweQ4b
	jO14mVGR3GfIzjCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049936; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLSAOPETBgDWLK1JVvygZfruBNGi9kz5Qw7QBC9gyQg=;
	b=AV3smeEtJ8q0Ezv062Ao0mGxRQhP759hWd9QTr4+wCEQflJINNVLgFQX+pBwrVILpYAjZV
	ubTMfg69Wqbe7M/CRFngPRvddYBLA+hPfGTOoMqxmIHKMUolPPe0qU3A3pamBRPVlTgvm1
	InJquDLQ4C05c1AVTh8JhJAOH9nxxE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049936;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QLSAOPETBgDWLK1JVvygZfruBNGi9kz5Qw7QBC9gyQg=;
	b=dnJ9Jd+nUV0NVQ/UVHOhjItPuaCV8W6xY2VbFncrB2VhCVxy9X1KUCn9QhWYGaGOOweQ4b
	jO14mVGR3GfIzjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EC4B132DD;
	Sun,  4 Feb 2024 12:32:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6OhdOsyDv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:32:12 +0000
Message-ID: <6ca5864a-7737-4b2f-961f-af3d85feee8c@suse.de>
Date: Sun, 4 Feb 2024 20:32:12 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/26] null_blk: Introduce zone_append_max_sectors
 attribute
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-15-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-1.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.01)[87.29%];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.10

On 2/2/24 15:30, Damien Le Moal wrote:
> Add the zone_append_max_sectors configfs attribute and module parameter
> to allow configuring the maximum number of 512B sectors of zone append
> operations. This attribute is meaningful only for zoned null block
> devices.
> 
> If not specified, the default is unchanged and the zoned device max
> append sectors limit is set to the device max sectors limit.
> If a non 0 value is used for this attribute, which is the default,
> then native support for zone append operations is enabled.
> Setting a 0 value disables native zone append operations support to
> instead use the block layer emulation.
> 
> null_submit_bio() is modified to use blk_zone_write_plug_bio() to
> handle zone append emulation if that is enabled.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/null_blk/main.c     | 40 +++++++++++++++++++++----------
>   drivers/block/null_blk/null_blk.h |  1 +
>   drivers/block/null_blk/zoned.c    | 31 ++++++++++++++++++------
>   3 files changed, 52 insertions(+), 20 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

