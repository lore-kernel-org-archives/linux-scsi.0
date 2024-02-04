Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B002232B;
	Sun,  4 Feb 2024 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707049769; cv=none; b=hrD6uGdmQm270sI4DQNCuksY6olKugJEqvzXApxhyUC6HKV6rWVhbpdpCTr+nmlz3KOFqkO+OAOF7TysY2xmKB3US5hSFIW9321WHeC1A/PIUCxvcJPJgIn3yAPXV75G3jEsfknu/4PswEUGOjqlO+jRV8KKPBuu9HN9GMCbHY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707049769; c=relaxed/simple;
	bh=fEQGK2sfGM5wmYUZOIJ/Kk+nuXS4qS9P9LT26dbtfTQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KusWo8+MufXwnq2ZeZEJ8A6okMGSfM/LuuYYQ25qZkE+4Lc5laOdgrMnaAwQBQDF2XmzkkAub3yyTSNgdVonViE4OBaFnJvlkth+EBcsAQobP4g4iQuaLwC89eoSdfEozIryYhieeo4QM690JZdqoI2XHF4iaQagsLvrU8F2x7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cck1tNVW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/1gauWQB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cck1tNVW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/1gauWQB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cck1tNVW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/1gauWQB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cck1tNVW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/1gauWQB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C2DE1F80B;
	Sun,  4 Feb 2024 12:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDNkZJOcBJw5IEize73fU5xkGgKhK4d4kFbJIGDXfnE=;
	b=Cck1tNVW4GQ19H62HusKdb8L5Ne4kLJkErArzbKyOfalfSeesSDXis3ny2A51iKYRX6zdY
	DngNPcOY1FLXs5cfJo/GHXMX58JFm0UOWK9vChNZj9lHs+oNtFoK8/Y9aOWxaJGCOBgA0u
	upZx1/nc1smn7HPVo1/CmIAelOyCXCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDNkZJOcBJw5IEize73fU5xkGgKhK4d4kFbJIGDXfnE=;
	b=/1gauWQB/5bwM689HxMBnKe6rahBnlMQYrpK879UbWLH0DdBgoPDRy6JzzfksCe9H9lUZp
	FYA48LDXNSyY5NBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707049766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDNkZJOcBJw5IEize73fU5xkGgKhK4d4kFbJIGDXfnE=;
	b=Cck1tNVW4GQ19H62HusKdb8L5Ne4kLJkErArzbKyOfalfSeesSDXis3ny2A51iKYRX6zdY
	DngNPcOY1FLXs5cfJo/GHXMX58JFm0UOWK9vChNZj9lHs+oNtFoK8/Y9aOWxaJGCOBgA0u
	upZx1/nc1smn7HPVo1/CmIAelOyCXCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707049766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDNkZJOcBJw5IEize73fU5xkGgKhK4d4kFbJIGDXfnE=;
	b=/1gauWQB/5bwM689HxMBnKe6rahBnlMQYrpK879UbWLH0DdBgoPDRy6JzzfksCe9H9lUZp
	FYA48LDXNSyY5NBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B555132DD;
	Sun,  4 Feb 2024 12:29:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FjaYAyODv2X4JgAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:29:23 +0000
Message-ID: <0bef7049-bd44-4d86-8696-add7cfecf66d@suse.de>
Date: Sun, 4 Feb 2024 20:29:20 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/26] scsi: sd: Use the block layer zone append emulation
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-12-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -2.34
X-Spamd-Result: default: False [-2.34 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-1.05)[87.70%];
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
> Set the request queue of a TYPE_ZBC device as needing zone append
> emulation by setting the device queue max_zone_append_sectors limit to
> 0. This enables the block layer generic implementation provided by zone
> write plugging. With this, the sd driver will never see a
> REQ_OP_ZONE_APPEND request and the zone append emulation code
> implemented in sd_zbc.c can be removed.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c     |   8 -
>   drivers/scsi/sd.h     |  19 ---
>   drivers/scsi/sd_zbc.c | 335 ++----------------------------------------
>   3 files changed, 10 insertions(+), 352 deletions(-)
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

