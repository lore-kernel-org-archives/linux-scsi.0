Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74F51DA22;
	Wed, 27 Mar 2024 07:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524476; cv=none; b=r0wzfhhKvoNJ5supqS2msdFJkpRFmMw1ZL27Kexdw72NALAuClmiCmdyHKOV5IgosaEQHRfoHdtJmVmumKCIBfdBRdmqsnH8uKA3nMAQXusaKUebbFCTLi3kb9zUPHrt6njLzSJt5BkAlt0RbcfOd6cZG4ycVa2gwaaCXOxzb1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524476; c=relaxed/simple;
	bh=K8UFWwqJMnQd1KggvSe6p1AxgD+Owxnm9wRQm7DQvco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W1swqPwiV3B3ydMoVtjrbBwFuGzJ91qdlmMoOos01ZFuPxlPBP5UR2DsbI5gIshUVBGuME3vmlX8VtbjctOGKYMFqqMnXiNxVk/qitSZOCwIbr4NygJ6TvopZ18abvA5txetWqaln4FwTQZj/hTLbirdVtvqyjkIWh6qkmYklVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U1NlZe7M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iHAC7g8K; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U1NlZe7M; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iHAC7g8K; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U1NlZe7M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iHAC7g8K";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U1NlZe7M";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iHAC7g8K"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B30885FFD1;
	Wed, 27 Mar 2024 07:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711523996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogq/GMixvT96FUGl1yf2QBpGkJlyjSMBn6iuyUUbJ24=;
	b=U1NlZe7MxHzmx6MzPkJye5/CjWacJJd/JkRNfLbKmBpKn0iOqhdvhZYHSIIqbxbjbjAGLp
	3b3gjIT/gun9U9QsmM8l22zHiQSGboQ8NK7yuG59nRTAg7uTCT9IoBtQoYUssVOpgg4+3h
	x4fjBMR1n+YVoVN1d5/USyQxijY2qfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711523996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogq/GMixvT96FUGl1yf2QBpGkJlyjSMBn6iuyUUbJ24=;
	b=iHAC7g8K7lw/8ZyaF7Na0nTZBqB7rdRRfAFCkyddqf4E+4DuFiaiY6dVOYTrGoJc4oqrwC
	iwPxJMFeio7D+CDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711523996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogq/GMixvT96FUGl1yf2QBpGkJlyjSMBn6iuyUUbJ24=;
	b=U1NlZe7MxHzmx6MzPkJye5/CjWacJJd/JkRNfLbKmBpKn0iOqhdvhZYHSIIqbxbjbjAGLp
	3b3gjIT/gun9U9QsmM8l22zHiQSGboQ8NK7yuG59nRTAg7uTCT9IoBtQoYUssVOpgg4+3h
	x4fjBMR1n+YVoVN1d5/USyQxijY2qfY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711523996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogq/GMixvT96FUGl1yf2QBpGkJlyjSMBn6iuyUUbJ24=;
	b=iHAC7g8K7lw/8ZyaF7Na0nTZBqB7rdRRfAFCkyddqf4E+4DuFiaiY6dVOYTrGoJc4oqrwC
	iwPxJMFeio7D+CDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5595213688;
	Wed, 27 Mar 2024 07:19:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uMDeEZvIA2ZLeQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:19:55 +0000
Message-ID: <6b2aca56-9a0b-4caf-878b-3331dc938a90@suse.de>
Date: Wed, 27 Mar 2024 08:19:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/28] block: Use a mempool to allocate zone write
 plugs
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-9-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.29
X-Spamd-Result: default: False [-1.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[33.89%];
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
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Flag: NO

On 3/25/24 05:44, Damien Le Moal wrote:
> Allocating zone write plugs using a struct kmem_cache does not guarantee
> that enough write plugs can be allocated to simultaneously write up to
> the maximum number of active zones of a zoned block device.
> 
> Avoid any issue with memory allocation by using a mempool with a size
> equal to the disk maximum number of open zones or maximum number of
> active zones, whichever is larger. For zoned devices that do not have
> open or active zone limits, the default 128 is used as the mempool size.
> If a change to the zone limits is detected, the mempool is resized in
> blk_revalidate_disk_zones().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c      | 62 ++++++++++++++++++++++++++++++------------
>   include/linux/blkdev.h |  3 ++
>   2 files changed, 47 insertions(+), 18 deletions(-)
> 
Why isn't this part of the previous patch?
But that shouldn't hold off the patchset, so:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

