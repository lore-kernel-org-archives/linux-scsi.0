Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D16B224CE;
	Sun,  4 Feb 2024 12:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050175; cv=none; b=dxG37lCl83ymejpZBnRoVPCfw5wqfvUglAat6tWZwhtrGXqVs0SMaWpNitRU/iBW2nR38SFal5ZZFDAMuQ3B5vR9FfPxi19ISUI+61UM9G1N+wHw1R3Hs3RsMFBfBQb1VUn+MW2N71jmqG7eVW32a5LCCr9PWqnfoG+/NJOEjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050175; c=relaxed/simple;
	bh=V9Sv0/OGRLOGGuZVhpvwajpr6JGkBUsEV9Mu7MYxLYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqD7JoA8QXMaCgMHoNgpM28ECIEyrdX0Th2zewObMdg0VDXRfwj8glbwTbbbMikvmCnHEwjRgj9q0imsaN4tWrO1zy3oUBEja8Ojm58PHiHUEkZ4Nqx0RSCGUM5Ujf7DswZ49mYgqGtZMbiyVbPOXP9dQKqiDiVNpo6BHv1yTGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ODu1FAyT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pLn0DDBl; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ODu1FAyT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pLn0DDBl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ODu1FAyT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pLn0DDBl";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ODu1FAyT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pLn0DDBl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8AB91F80C;
	Sun,  4 Feb 2024 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlkTpS/kpeGgo5dkGk6rDkL9b2QUboQNOUNoH4Qwqw8=;
	b=ODu1FAyT/RNOReIoKPOQokcp7v4uQK8Lr9h8PqY/102bUVxP77xZIkMVbKK1rRvIqaQ/gy
	gaBM0+f0lhLnT4a/qT/exYkPwrWtgQqtHYCZsS0gCqYmnp33SxNmRa650TkI4vbn60LH+F
	VHup4v7oCZSb5JOsoYMleiB+D8GpPwo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlkTpS/kpeGgo5dkGk6rDkL9b2QUboQNOUNoH4Qwqw8=;
	b=pLn0DDBlt9S3kydrrjuQBOz7m5HzVYsS2q2MtoU55yYW4NO+nnbTC793MzwfIMEVeDddkI
	q+WO8cwJulC6uBDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlkTpS/kpeGgo5dkGk6rDkL9b2QUboQNOUNoH4Qwqw8=;
	b=ODu1FAyT/RNOReIoKPOQokcp7v4uQK8Lr9h8PqY/102bUVxP77xZIkMVbKK1rRvIqaQ/gy
	gaBM0+f0lhLnT4a/qT/exYkPwrWtgQqtHYCZsS0gCqYmnp33SxNmRa650TkI4vbn60LH+F
	VHup4v7oCZSb5JOsoYMleiB+D8GpPwo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SlkTpS/kpeGgo5dkGk6rDkL9b2QUboQNOUNoH4Qwqw8=;
	b=pLn0DDBlt9S3kydrrjuQBOz7m5HzVYsS2q2MtoU55yYW4NO+nnbTC793MzwfIMEVeDddkI
	q+WO8cwJulC6uBDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30567132DD;
	Sun,  4 Feb 2024 12:36:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cPuWNLiEv2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:36:08 +0000
Message-ID: <3aae3657-662e-4688-ab96-c895daa23fb0@suse.de>
Date: Sun, 4 Feb 2024 20:36:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/26] block: mq-deadline: Remove support for zone write
 locking
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-20-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -1.33
X-Spamd-Result: default: False [-1.33 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.04)[58.90%];
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
> With the block layer generic plugging of write operations for zoned
> block devices, mq-deadline, or any other scheduler, can only ever
> see at most one write operation per zone at any time. There is thus no
> sequentiality requirements for these writes and thus no need to tightly
> control the dispatching of write requests using zone write locking.
> 
> Remove all the code that implement this control in the mq-deadline
> scheduler and remove advertizing support for the
> ELEVATOR_F_ZBD_SEQ_WRITE elevator feature.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/mq-deadline.c | 176 ++------------------------------------------
>   1 file changed, 6 insertions(+), 170 deletions(-)
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

