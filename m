Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3678C377EBF;
	Mon,  5 Oct 2026 11:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791198845; cv=none; b=NyCeQaMNf2d/WtrJau+QmUITndrakFMqbrG85QuQwHJaJVqqjQswsa2RL2WnXm3681VTf/g1dJqU7ZNaCTUtTJ7vrylErMlYIUCmMqURPnke8rSDx9OkPSajXugEUGO0nfR/6j9eJjglcJ0hMpgufhZ6TAqVoxD9eq9jXzOQqvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791198845; c=relaxed/simple;
	bh=xY/SZvqXwtiMK5MaLP4K/STlLP2vYlFpTF4vrcUVV7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UmoVBqapca8Ec7o1FyKnY3CUFLAheIT+5GKVdK/oCRQBuNc4L042TuZDGBKjkOumPFWhzIVDmkYmTpLDYrvhyc/F9QHIjqNoUC65/HGxVErCF3LM9tFkOopoVsUHws9jyynNvNrmLjFDkTg5jNTYi6GEHPrIVaxnYylbe3B+14A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KreObeIM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ECZo5KLQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=i4DwLzE4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MZxBvxqw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KreObeIM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ECZo5KLQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="i4DwLzE4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MZxBvxqw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E67D221CE3;
	Mon,  5 Oct 2026 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791198838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HpbRKJJJQF0XLyNnfSpO7isBopd8GZ+PinFPn8v4KUc=;
	b=KreObeIMekCpQCObs+OTDrVCDs0i9dG4yuYQIMf8z0Rt2V5E5sT3hMlfNEArHNgsrBM42X
	Yz3StGX2q28kG+vwfTi00l1q1AESSTe5/WeGu8ovZAIHd+OhEWPnynFbbZ/IRzV4CszJ74
	b9f+HLML5vvmPOY0ztWA/cvi25wWMLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791198838;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HpbRKJJJQF0XLyNnfSpO7isBopd8GZ+PinFPn8v4KUc=;
	b=ECZo5KLQnHQeDJyfeMZaWs4ONEPO7bL5jx0sbbVYOOC4Ga5G+Zzgohut2d2hJyxWP0mw0p
	r9oEBcI7XF7UluDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791198833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HpbRKJJJQF0XLyNnfSpO7isBopd8GZ+PinFPn8v4KUc=;
	b=i4DwLzE4FId75nm5AosuUOQyIbiQ2Ir5cFsAaYNoP7BXKpo6gLi/MaAQzPEtCstz2aHZNa
	1iugEggZhMHsBWffGIl1oiAL/nnK5TLYmbvzA78lqXQwRxgkPt70NOLtUd5G5ob9Jto3um
	pfgVNg/WG3FS6cU2lJiNH11Cheu1FtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791198833;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HpbRKJJJQF0XLyNnfSpO7isBopd8GZ+PinFPn8v4KUc=;
	b=MZxBvxqwUCappwI4M6R1onDqzLSekJQwZINTfrqY+kLhO8jy1hcSPlny3uIQP2dIY2xOSv
	DfLoUhenGjmebGCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3AC3139BF;
	Mon,  5 Oct 2026 11:13:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mI9cI3GGw2qHVwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 05 Oct 2026 11:13:53 +0000
Message-ID: <8be158cd-2199-4538-a05f-7c37ef9f622d@suse.de>
Date: Mon, 5 Oct 2026 13:13:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Add support for storage element depopulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261005094632.580753-1-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261005094632.580753-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.979];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO

On 10/5/26 11:46 AM, Damien Le Moal wrote:
> Jens,
> 
> These patches define a new set of block device operations for generically
> using from the block layer the storage element depopulation feature of
> zoned block devices. Support for this feature is added to the SCSI disk
> driver and an emulation of this feature added to the zloop driver.
> 
> The management operations can be accessed using block layer API, which is
> intended for file systems (e.g. zonefs and XFS), as well as using ioctls
> for users using zoned disks directly from user space.
> 
> Damien Le Moal (7):
>    block: fail reads to offline zones early
>    block: introduce storage element management
>    block: add storage element management ioctls
>    zloop: add storage element emulation
>    zloop: add degrade_element control command
>    scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
>    scsi: sd_zbc: define storage element management operations
> 
I wonder: shouldn't we send a uevent after either operation?
I guess that this would be helpful for admins, and not forgetting
udev which might want to re-run any rules the admin might have
configured.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
