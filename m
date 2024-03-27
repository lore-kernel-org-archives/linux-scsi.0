Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221AD2C1A4;
	Wed, 27 Mar 2024 07:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524689; cv=none; b=oOD/MI8eMT2r2kAzE+OZfKBOEoJhhtR93foW0o48q5qTiDErYfSLwdKfNj1XypYvT6XLo+D98whBzaXAYg2l1DJpDwoPmFltZ1Z3gU6W+JPv+PPFdjFgDwWNcS3n8iO6sfGd6gfp0utOHNJJals5gud7YdsAB17RjaUoCeRrU9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524689; c=relaxed/simple;
	bh=dfBOszafYEo7cfb0M5cyiU6h21Q7P21whYNce5QIm0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LmK27R7eLn/rTT45Qfzxq0m0UPoR/upiSUmqKrWaaP3MSYRKvdgVkXOu2X5ACN2iEpzhtDuRZOO0f72PZgvsXKgqQ2J2IXbc3lAX1LJO1ts/7GR+p/MyuEOPjw2Q5A5UZl4toJ+gin4TKh1rQrPcWaPdy1e7vcbPTl4RKwgbqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pMSvHVJZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RMIfq1q5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pMSvHVJZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RMIfq1q5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pMSvHVJZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RMIfq1q5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pMSvHVJZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RMIfq1q5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D56535FFFA;
	Wed, 27 Mar 2024 07:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nQC8M8HgM+gtdI/UpxTmcdK+4OO/kqVQIJ7zMLAedA=;
	b=pMSvHVJZUhteI7hU1e+Kekk07h6HVblcNifde9RErhLE+ODCbdF4V1/5wB6wICKx6jbPhO
	OHzsUjNTrZKQRMu/S7TKU+ULpq6ME7tl+c4We+12cKl5S42dalS3Xd259xDp83aE+sJBIF
	z3oUS4otUxNwrrsCNBd9Xhoehtv7QdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nQC8M8HgM+gtdI/UpxTmcdK+4OO/kqVQIJ7zMLAedA=;
	b=RMIfq1q570rlHopWH5NggfDngJCH2WGgq1B/ZJq18v1r01j8EEITGlnO/g//xjIei7C1lj
	MaSKqUKabA8DNIBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nQC8M8HgM+gtdI/UpxTmcdK+4OO/kqVQIJ7zMLAedA=;
	b=pMSvHVJZUhteI7hU1e+Kekk07h6HVblcNifde9RErhLE+ODCbdF4V1/5wB6wICKx6jbPhO
	OHzsUjNTrZKQRMu/S7TKU+ULpq6ME7tl+c4We+12cKl5S42dalS3Xd259xDp83aE+sJBIF
	z3oUS4otUxNwrrsCNBd9Xhoehtv7QdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9nQC8M8HgM+gtdI/UpxTmcdK+4OO/kqVQIJ7zMLAedA=;
	b=RMIfq1q570rlHopWH5NggfDngJCH2WGgq1B/ZJq18v1r01j8EEITGlnO/g//xjIei7C1lj
	MaSKqUKabA8DNIBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5878213688;
	Wed, 27 Mar 2024 07:31:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8M/HE0rLA2ZKewAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:31:22 +0000
Message-ID: <fe99285c-5e32-4ef3-83aa-48d682242f14@suse.de>
Date: Wed, 27 Mar 2024 08:31:20 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/28] null_blk: Introduce zone_append_max_sectors
 attribute
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-18-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-18-dlemoal@kernel.org>
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
	 BAYES_HAM(-0.00)[14.29%];
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
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/block/null_blk/main.c     | 12 ++++++++++--
>   drivers/block/null_blk/null_blk.h |  1 +
>   drivers/block/null_blk/zoned.c    | 22 +++++++++++++++++++---
>   3 files changed, 30 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

