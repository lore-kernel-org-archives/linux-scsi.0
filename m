Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8C9224CC;
	Sun,  4 Feb 2024 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707050214; cv=none; b=ZIu8X8bEyQWwnylGhOcq8ndG7iGf6B2yH/4Iokk/Lzka/ytxgmF0GF0wm52hGgTprnapDv1zmkzjz0e2NoHVg29NlU64wJFMtJDaejXX40DAfQuHmug8wv0rqSkzZ2YhUk9BoUPezNp2ARZPchtJWc3UeVM0JMsO7c6j5DxnmoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707050214; c=relaxed/simple;
	bh=ttuvprPtfm4pLWyrlG3oAOasH/qvdCKy2MYo4jim/yY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gf6fJ+zocUgpzU01LzsTjhPmhLIxYs5eGR/Gi62ty+RBHnvRlrBSIUKpOnzdaXkt+MBrsTgn6qOfYuGp8zPwAPQPkTXAnswXxuZLtqPyWmbhy8LErhtwm5hVOWfyRUFPLBqzOgHlF7WGDDre77vHDT28tPSPDDfxNoU0OlTUOq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SIsVkX8r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=atc760BK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SIsVkX8r; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=atc760BK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SIsVkX8r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="atc760BK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SIsVkX8r";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="atc760BK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 321CC1F80C;
	Sun,  4 Feb 2024 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n1lvw7WqfHXe4Zn0kOwo8Ppo40zdl1FmiHhHSwFMEA0=;
	b=SIsVkX8rruJ+7E3oMLebexoRwMXmMfE3/wmwWUmBm7FbpDClKx51bpwYxde75m9RUGTZm5
	j/N7ugapgsacMnaB0IYFXuRHfpqv7BpcSwhjAvkeu4qz/6VtDCpff5+zdFWhDhYS7vViMz
	vGgjOJdw4va0XR5ZHPqz2Qo1509J7g0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n1lvw7WqfHXe4Zn0kOwo8Ppo40zdl1FmiHhHSwFMEA0=;
	b=atc760BKh9N1Evf+UPh1nMuHpctrADUk6qTd/FHjUXoO1wmxrUChnYh6l12TYNrVrcFUkR
	tFzV0cjCLhNWaLBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707050211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n1lvw7WqfHXe4Zn0kOwo8Ppo40zdl1FmiHhHSwFMEA0=;
	b=SIsVkX8rruJ+7E3oMLebexoRwMXmMfE3/wmwWUmBm7FbpDClKx51bpwYxde75m9RUGTZm5
	j/N7ugapgsacMnaB0IYFXuRHfpqv7BpcSwhjAvkeu4qz/6VtDCpff5+zdFWhDhYS7vViMz
	vGgjOJdw4va0XR5ZHPqz2Qo1509J7g0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707050211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n1lvw7WqfHXe4Zn0kOwo8Ppo40zdl1FmiHhHSwFMEA0=;
	b=atc760BKh9N1Evf+UPh1nMuHpctrADUk6qTd/FHjUXoO1wmxrUChnYh6l12TYNrVrcFUkR
	tFzV0cjCLhNWaLBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 028EF132DD;
	Sun,  4 Feb 2024 12:36:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MPwmKt+Ev2U8JwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 04 Feb 2024 12:36:47 +0000
Message-ID: <d47ccfb0-f980-4455-b184-adb8e3eff3a0@suse.de>
Date: Sun, 4 Feb 2024 20:36:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/26] block: Remove elevator required features
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-21-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240202073104.2418230-21-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
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
	 BAYES_HAM(-0.00)[31.25%];
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
> The only elevator feature ever implemented is ELEVATOR_F_ZBD_SEQ_WRITE
> for signaling that a scheduler implements zone write locking to tightly
> control the dispatching order of write operations to zoned block
> devices. With the removal of zone write locking support in mq-deadline
> and the reliance of all block device drivers on the block layer zone
> write plugging to control ordering of write operations to zones, the
> elevator feature ELEVATOR_F_ZBD_SEQ_WRITE is completely unused.
> Remove it, and also remove the now unused code for filtering the
> possible schedulers for a block device based on required features.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-settings.c   | 16 ---------------
>   block/elevator.c       | 46 +++++-------------------------------------
>   block/elevator.h       |  1 -
>   include/linux/blkdev.h | 10 ---------
>   4 files changed, 5 insertions(+), 68 deletions(-)
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

