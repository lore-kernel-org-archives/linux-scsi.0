Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCEE1BD9FF;
	Mon, 13 Jan 2025 07:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752863; cv=none; b=VgiFScCUSbyIQHkMi8h5BT0qGhRWofONRlTGoOzFfooIB0172RvhUJEkeJ3nIzzP4OpLWp1dFPFq2oAa36hdTaSRYnrVybC/f5dVu1o+Y4khQ481GYnaAUO/eM6/MKk8Ek1vqCG+NmUfVc+rECx5I7QptICs53f6B2K6OU8wIO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752863; c=relaxed/simple;
	bh=kbm8erPVtLnosW9AC/y+nYZaikW8VNMUhviOGkYiWCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W1oF3TULRTfu6cwwBsKHQbjK5S/aRfMkqeqQBiTt5d7atX/R9lPGBS98TZT9Zwxu1wfJAYBxgY6cfnrnnaDjK7CV66R51xAVSay3ixuDCla0+hV8kbW+dGVAYK25vpbsp7AUnt3nK+Hxk1MkeIiK3vm77BI7c3vWUUYdenxLrn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PZUS77ty; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8SuTSKBJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MjtXgVxq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M9wkXZbb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PZUS77ty";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8SuTSKBJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MjtXgVxq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M9wkXZbb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B369F1F37C;
	Mon, 13 Jan 2025 07:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEbXcZ9FxU3Bzk1bmtL3avw4j+KWudt6f1gRaHYmg5Q=;
	b=PZUS77tyQYwRnu51vZOKBXdK4rlU4q1hpLT9lqdouVhCsk+JzZcf1xBbGfVWob7RQ0J8cN
	86tPfg+LekyxIogIK0hNKSHBn3jbv6WqRt77RD6CgspQ+My/6iQ38Od1X0dFJbaYCXUDuj
	qTH5iJuT3Fm937u/u8JS/EokyK8Gg/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEbXcZ9FxU3Bzk1bmtL3avw4j+KWudt6f1gRaHYmg5Q=;
	b=8SuTSKBJPk5fwEiApCx9Eqjh7ZqauNIoUibzOwttCsx0JUg/QzjfC3jrk8luPYaEqfU3kv
	SBFif2m7vfHwjvCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEbXcZ9FxU3Bzk1bmtL3avw4j+KWudt6f1gRaHYmg5Q=;
	b=MjtXgVxq1OtTPfOK7Yma44e60zsgNZ8+Gdfv11J/rbGVbuHUJQRIJCMmPHnQYwojIdjM6m
	mmWDBdaKMzUInGUKoJwHOKUrVQmTAc+MJHyaXCBfYSY0YGbQPDWPkdvkvcLSYK90Iv/jX2
	lxG6WvIJYq3mkn8ka+YLurusyOrSBxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZEbXcZ9FxU3Bzk1bmtL3avw4j+KWudt6f1gRaHYmg5Q=;
	b=M9wkXZbberAdazkx/1bXDdLQznZ3lHGMnegB/DBFvw9x/jSt8jdgzG2ptRSPCwTudWg0Ku
	na7jC8ZS2PfXUNDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4679713310;
	Mon, 13 Jan 2025 07:20:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1/ZsD9q+hGcZLQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:20:58 +0000
Message-ID: <15cb40c2-df67-423d-a15c-c55e2bb2b8a9@suse.de>
Date: Mon, 13 Jan 2025 08:20:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] block: add a queue_limits_commit_update_frozen
 helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, nbd@other.debian.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-3-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250108092520.1325324-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 1/8/25 10:24, Christoph Hellwig wrote:
> Add a helper that freezes the queue, updates the queue limits and
> unfreezes the queue and convert all open coded versions of that to the
> new helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
> ---
>   block/blk-integrity.c      |  4 +---
>   block/blk-settings.c       | 24 ++++++++++++++++++++++++
>   block/blk-zoned.c          |  7 +------
>   drivers/block/virtio_blk.c |  4 +---
>   drivers/scsi/sd.c          | 17 +++++------------
>   drivers/scsi/sr.c          |  5 +----
>   include/linux/blkdev.h     |  2 ++
>   7 files changed, 35 insertions(+), 28 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
