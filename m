Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6541D225CC;
	Sun,  4 Feb 2024 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050006; cv=none; b=oAy87bJGhUH209InSchSpRuFcpC/I5c63o6+hckcqgBvu0ln3IGsGDGj56VkpfKwoJLFGhdmxAo4U1pizAqrNY8Hijaay9P0wUWsIkc6I1652HPCx4V0cP4Gu7TpQyYe2IB/mdQ/IwWL1s2wOExpnsRng/1hy/0WR0dDk4B6mhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050006; c=relaxed/simple;
	bh=S+iTlgL6eaUhB14pKb5yifskASY9yRgyHUMSdpsQx3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OnzjG4S+iYVdUsmGZOSPxHpyce1MZr2lBf+0HOqqS2Hj5nWigi7Ex8e2V3HqJLy5cAjRrjA68ZAyYxGzIhfkPQhlx9fRLan6o9+5/de2Wlvo95Myeq7qrOYdCE68s4aZM4+MMWFThasOBvvyhudqDNrf/Svr93ptMcrNU9EFD2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yXVk04xl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H7VU+smq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yXVk04xl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H7VU+smq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yXVk04xl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H7VU+smq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yXVk04xl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H7VU+smq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A3B7B2200A;
	Sun,  4 Feb 2024 12:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJyTGPU4nl2GwcIXm5/9yAE4DzRH8YCi/5FAWNksPhM=;
	b=yXVk04xlqcQiODey5Ad56MgOLfjlNTcmq+GOzFaaO7RwMvQZes2yTdbryIzD3V8n+8ZkB1
	uSOuA/UXT9aZRkTVv9NE9ScrgEluGo5TzBNVwzJ6xHDbQP6P6KDQj8gxdG5CYP4fb3aV0o
	ZG8pJ8laxQLQrp8/q+VoI+W9YOvBQg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJyTGPU4nl2GwcIXm5/9yAE4DzRH8YCi/5FAWNksPhM=;
	b=H7VU+smqThERPtZYW9SCpLF6Wc0tuQC9SRm96zgjQ69pdTZ3PtZ16baOjGu8qWeEg46b0E
	WTGpX66dfnH8ThDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJyTGPU4nl2GwcIXm5/9yAE4DzRH8YCi/5FAWNksPhM=;
	b=yXVk04xlqcQiODey5Ad56MgOLfjlNTcmq+GOzFaaO7RwMvQZes2yTdbryIzD3V8n+8ZkB1
	uSOuA/UXT9aZRkTVv9NE9ScrgEluGo5TzBNVwzJ6xHDbQP6P6KDQj8gxdG5CYP4fb3aV0o
	ZG8pJ8laxQLQrp8/q+VoI+W9YOvBQg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJyTGPU4nl2GwcIXm5/9yAE4DzRH8YCi/5FAWNksPhM=;
	b=H7VU+smqThERPtZYW9SCpLF6Wc0tuQC9SRm96zgjQ69pdTZ3PtZ16baOjGu8qWeEg46b0E
	WTGpX66dfnH8ThDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84A1E132DD;
	Sun,  4 Feb 2024 12:33:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2EFLCRCEv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:33:20 +0000
Message-ID: <8bb5e14b-c5fd-4247-9e69-9cf786eb4234@suse.de>
Date: Sun, 4 Feb 2024 20:33:20 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/26] null_blk: Introduce fua attribute
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-16-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.71
X-Spamd-Result: default: False [-1.71 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.42)[78.26%];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On 2/2/24 15:30, Damien Le Moal wrote:
> Add the fua configfs attribute and module parameter to allow
> configuring if the device supports FUA or not. Using this attribute
> has an effect on the null_blk device only if memory backing is enabled
> together with a write cache (cache_size option).
> 
> This new attribute allows configuring a null_blk device with a write
> cache but without FUA support. This is convenient to test the block
> layer flush machinery.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/null_blk/main.c     | 12 ++++++++++--
>   drivers/block/null_blk/null_blk.h |  1 +
>   2 files changed, 11 insertions(+), 2 deletions(-)
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

