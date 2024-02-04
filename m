Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB63225A2;
	Sun,  4 Feb 2024 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050339; cv=none; b=CS+HGEn5ljAAYSkpncr+j5phFHjboq8H0VoixF4v6zdoL+stPGGqmJMyf67Hy3/SwHyXEoOPrXhTEEQTv56nlmDlKwmteOTraQ0f+A4tAxDeFW6XbeTfnbAyS/vbQFXKiqMUNIiEou5F1WDiZRoN3JTi7xH3QTBZtruljnEu99A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050339; c=relaxed/simple;
	bh=mzJGMV2qgQ/Nkv0VqFOAdCxBRjjZVKzexFbLhOMfet0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDtQry0SlGuLmZANbR7o7eml+B0qfyfAKt+Hm6xbHVCmLlQ1o9IvKSJZQwVFp1mBqpMZv+CP3WL+GtlbWLa2QIV3NgQ/XExt1JtBIUmifnWT+P8hls8rmRDgfNU6KfjSyM5Ayo8jHfEJsyKf06IP8cJoZKUskk4d+IQ2JAhmZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vmo2quRm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3urfhU9a; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vmo2quRm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3urfhU9a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vmo2quRm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3urfhU9a";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vmo2quRm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3urfhU9a"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 28CE01F80C;
	Sun,  4 Feb 2024 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWUZuXLOxTUPIucfTm/eSdZHmBlQpQsRRW5s9aqJaOg=;
	b=Vmo2quRmIGKUgok47XAtzcaNGi+81nSvAMWYyWmV57EV7/RNcmzdawZnZqmXhvQA4atSy4
	uRRLnqPtZry9mPGSaI7ns/xCzeR5RdTnhmVna+fINwo4QfAM2mSP4PzUVsUdY64DD1G6Pg
	eQhwwx2mSntDsy6BTkcHPLrEo7R8MS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050335;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWUZuXLOxTUPIucfTm/eSdZHmBlQpQsRRW5s9aqJaOg=;
	b=3urfhU9aLXgEAnqHWFaGCEUzQWZDfrud9ooYe5HuTFVIoSvRfmvqAOiyxpxIjq38FlVyMm
	cqNz58y55Y2nInDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWUZuXLOxTUPIucfTm/eSdZHmBlQpQsRRW5s9aqJaOg=;
	b=Vmo2quRmIGKUgok47XAtzcaNGi+81nSvAMWYyWmV57EV7/RNcmzdawZnZqmXhvQA4atSy4
	uRRLnqPtZry9mPGSaI7ns/xCzeR5RdTnhmVna+fINwo4QfAM2mSP4PzUVsUdY64DD1G6Pg
	eQhwwx2mSntDsy6BTkcHPLrEo7R8MS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050335;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JWUZuXLOxTUPIucfTm/eSdZHmBlQpQsRRW5s9aqJaOg=;
	b=3urfhU9aLXgEAnqHWFaGCEUzQWZDfrud9ooYe5HuTFVIoSvRfmvqAOiyxpxIjq38FlVyMm
	cqNz58y55Y2nInDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 03228132DD;
	Sun,  4 Feb 2024 12:38:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eI9pJVuFv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:38:51 +0000
Message-ID: <13560fed-8872-4cc1-b71b-471dc5d53e50@suse.de>
Date: Sun, 4 Feb 2024 20:38:51 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] block: Remove zone write locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-24-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-24-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spamd-Result: default: False [-0.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.00)[43.43%];
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
X-Spam-Score: -0.09

On 2/2/24 15:31, Damien Le Moal wrote:
> Zone write locking is now unused and replaced with zone write plugging.
> Remove all code that was implementing zone write locking, that is, the
> various helper functions controlling request zone write locking and
> the gendisk attached zone bitmaps.
> 
> The "zone_wlock" mq-debugfs entry that was listing zones that are
> write-locked is replaced with the zone_plugged_wplugs entry which lists
> the number of zones that have a zone write plug throttling write
> operations.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-mq-debugfs.c    |  3 +-
>   block/blk-mq-debugfs.h    |  4 +-
>   block/blk-zoned.c         | 98 ++++++---------------------------------
>   include/linux/blk-mq.h    | 83 ---------------------------------
>   include/linux/blk_types.h |  1 -
>   include/linux/blkdev.h    | 36 ++------------
>   6 files changed, 21 insertions(+), 204 deletions(-)
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

