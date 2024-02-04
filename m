Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DB422081;
	Sun,  4 Feb 2024 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707047767; cv=none; b=BTk99K4BPJsHpdh6omZh25XBCF3JsYfNk61VKK9YBjqFFYB0vUeO4LmWthx//JMBk1NIsa8iSeqWueVLD2f4ts4pZAk/jxtLQHYq7U8um1HvC3enBi7qhbA1jEjQrSp/9a7snsmXa8cifm+D/+ahPMFKCSvBfw/oz707mocZAKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707047767; c=relaxed/simple;
	bh=NIKJSnCtWl0/XkPrQHdMXeVMxqIb4sBjJjzO0FgS1SA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4d/hTkptJIg0T5qn5DoFMLUD0Au4kiBovi2e8kfrwyaVs6rrUgrODqaLDTYgruPrtU92xVqXRoPwtL3nVP11GdOxSnZmWQiihNhpcUs65jK8ZCP1nxbUmf/Mh4sawgWFADV6szuq8bWg8IaXobIW9jMDbJbaJZJbrJdHBD+qEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cy3Vtq4L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CHFKPpUp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cy3Vtq4L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CHFKPpUp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cy3Vtq4L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CHFKPpUp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cy3Vtq4L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CHFKPpUp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3763822238;
	Sun,  4 Feb 2024 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2lx9UVlFl2mGgJhy0qngmHfgYDXN+wZ9tX3D2ybiUY=;
	b=Cy3Vtq4LsQOULcj2LAnGItts6/j8fJdNjWlekpYtcTD1ZVC1//qX7yYRIS/3A053HlI7x3
	4IldGIn+yU/jEFnngEGHIyctCWsxFlP+QVY+RZ8CZHyhCUx7//Q8p6Ss6mNchJYmREg05S
	USzMl2EKne8oYNXv34juOrqjf6pJy5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2lx9UVlFl2mGgJhy0qngmHfgYDXN+wZ9tX3D2ybiUY=;
	b=CHFKPpUpnS/TjEXGq6MAaeSKTVoMglpuZQwnOMZraf8SR9QIK/TS/MJirMntVn3Cgnyd4u
	G4aU7z9vpnqoaDDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707047763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2lx9UVlFl2mGgJhy0qngmHfgYDXN+wZ9tX3D2ybiUY=;
	b=Cy3Vtq4LsQOULcj2LAnGItts6/j8fJdNjWlekpYtcTD1ZVC1//qX7yYRIS/3A053HlI7x3
	4IldGIn+yU/jEFnngEGHIyctCWsxFlP+QVY+RZ8CZHyhCUx7//Q8p6Ss6mNchJYmREg05S
	USzMl2EKne8oYNXv34juOrqjf6pJy5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707047763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g2lx9UVlFl2mGgJhy0qngmHfgYDXN+wZ9tX3D2ybiUY=;
	b=CHFKPpUpnS/TjEXGq6MAaeSKTVoMglpuZQwnOMZraf8SR9QIK/TS/MJirMntVn3Cgnyd4u
	G4aU7z9vpnqoaDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7128C1338E;
	Sun,  4 Feb 2024 11:55:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RyIVI017v2U2IAAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 11:55:57 +0000
Message-ID: <d8a0e13c-2320-4227-891c-743efd224c71@suse.de>
Date: Sun, 4 Feb 2024 19:55:50 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/26] block: Restore sector of flush requests
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-2-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.29
X-Spamd-Result: default: False [-1.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[43.77%];
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
> On completion of a flush sequence, blk_flush_restore_request() restores
> the bio of a request to the original submitted BIO. However, the last
> use of the request in the flush sequence may have been for a POSTFLUSH
> which does not have a sector. So make sure to restore the request sector
> using the iter sector of the original BIO. This BIO has not changed yet
> since the completions of the flush sequence intermediate steps use
> requeueing of the request until all steps are completed.
> 
> Restoring the request sector ensures that blk_mq_end_request() will see
> a valid sector as originally set when the flush BIO was submitted.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-flush.c | 1 +
>   1 file changed, 1 insertion(+)
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

