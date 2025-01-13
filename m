Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AB91C1AB6;
	Mon, 13 Jan 2025 07:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736753031; cv=none; b=ENkX5aODuiU0X/WSnijhjZz+gTAE+3l5aGhDatjLW/BPhhvALWTwKzc8KDwvrQlzLgzKZTnAjKTCKmo7uOH4RDzf1aurLS9FHFW/QrB6pkWOVGNDxVqdUyGJYzlt28WjqTz8k5978TvpfMvyXVyovnsv1nt+5Q/8lltWC/FP5fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736753031; c=relaxed/simple;
	bh=SHy4/mLWTjla7La4IVZlchwyWlS6l+ebgxi8jMArQds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HX+giFBAEi4G/ve6JdsNf3i6apDqnk3kmSeALASFftaAaXaIaBXkCt5KoEKvUEmKdNtJi3N8kGmKI/TPVsj3YxY1DWyhLH9uSAud89ZdEuafFtf9sVdgjYEGDfBO9Iela5VgHmQWYaTfWlID05U/Aaj02IJUv8Pg30oi6gPoG4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lkTXapxi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZdhKumHe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RyoHyhaa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=x5o7pwdF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lkTXapxi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZdhKumHe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RyoHyhaa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="x5o7pwdF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 34D531F37E;
	Mon, 13 Jan 2025 07:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736753028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOFqz/OKng2mpmOdlz3ZYXHYAZbTaDBWXmGjJpAHPYw=;
	b=lkTXapxiIVqQs1YI2goF8aDH00o7PIcWE0bGwZ50ndhwENaC6zRSo+ihqH+fxB0R9yva89
	pToKrgPX7G8x6pZduTG0iCTtgKRfOEs89swUzChq4dO10MBpo1R3DXXPH4XbDJS6sJIqPD
	8rjsMlwG5a0VXWYKUdZsdUHEy9sY45M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736753028;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOFqz/OKng2mpmOdlz3ZYXHYAZbTaDBWXmGjJpAHPYw=;
	b=ZdhKumHeChZskj7AUIoUkduA6lJsvZj0E2yFD2XaOFDS4G6ls1ye4tk3vP74BUBsMhb5np
	b02960EXrM3SxjDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736753027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOFqz/OKng2mpmOdlz3ZYXHYAZbTaDBWXmGjJpAHPYw=;
	b=RyoHyhaa6rlH2NTed3hBG6l1xVfWW7iUNksG4xyaMRK0f0ss7ykhP+pA+jLz7/T8DtjsvC
	kaJMBhVAMpYvfZwVK+VyeP51e2qWQonsVYs40uzyf2WMg9+UlNJTl+MYEPSkgWWHJxRVDd
	vgdliXaq4IkdaWMM8NJfCPXV+o9Eb8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736753027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOFqz/OKng2mpmOdlz3ZYXHYAZbTaDBWXmGjJpAHPYw=;
	b=x5o7pwdFEU3QNumAt/TGArffyH0YVsbkdbbpzEEUu17zfEIYuT2nnzBvSBdVVZ0RL/dxOu
	iMoNwNtfCJips8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7721813310;
	Mon, 13 Jan 2025 07:23:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mAe4FoK/hGfZLQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:23:46 +0000
Message-ID: <4f63b30e-54cd-4776-aeef-5257b66d9e80@suse.de>
Date: Mon, 13 Jan 2025 08:23:45 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, nbd@other.debian.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-4-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250108092520.1325324-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 1/8/25 10:25, Christoph Hellwig wrote:
> When __blk_mq_update_nr_hw_queues changes the number of tag sets, it
> might have to disable poll queues.  Currently it does so by adjusting
> the BLK_FEAT_POLL, which is a bit against the intent of features that
> describe hardware / driver capabilities, but more importantly causes
> nasty lock order problems with the broadly held freeze when updating the
> number of hardware queues and the limits lock.  Fix this by leaving
> BLK_FEAT_POLL alone, and instead check for the number of poll queues in
> the bio submission and poll handlers.  While this adds extra work to the
> fast path, the variables are in cache lines used by these operations
> anyway, so it should be cheap enough.
> 
> Fixes: 8023e144f9d6 ("block: move the poll flag to queue_limits")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-core.c  | 17 ++++++++++++++---
>   block/blk-mq.c    | 17 +----------------
>   block/blk-sysfs.c |  6 +++++-
>   block/blk.h       |  1 +
>   4 files changed, 21 insertions(+), 20 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
