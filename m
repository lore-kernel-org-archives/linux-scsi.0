Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792575934;
	b=ThWjxZfzy3Lf4cbuLVUbc0iGGvx93nEFWDIPqwXxYmll+a/fZN5U7raX3yDumSwy+D9L
	 KT0UiPjXydcITh2lCyOhS8GKGy8XDRqEx5iF58RyLp/PpRqvlrwW5avtYUWvNl+GXQ6CY
	 UNgqI2kmntMA1eJvc8lN0S/ysTr5WkdXod9vGwWEsu4yezliLTp22FWD222KimY/+Gc/W
	 X7iptBAax+2ZkIuovj6U7GqbPv+X43tj8hK++vZHRBQAJOVZXE6lrf96etn2AoPlvzkGi
	 btuuJBuWxGn/JrBdNNrRNAlK6LVsRTe1sNQvLZZMT0EQZe3cs3fSCzVX7P/jNFTWB2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792575934;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:
	 X-Spam-Level:X-Spam-Flag;
	bh=GKQlFBofvdQ7UPjpNR4JdVsvRg1fAT51dUsu8Om4kRE=;
	b=pYdOwHvTXbbkYhXgvqKmHY5Yn8YwID5V+MIksWR7yBvlVuKX6od5h9bib4VwpHFjtqs+
	 ki913ic0GT48FJlLMROCB/AuPZcONWyHAzVl4Rpp40brKe8CKr15wb7bgkQt43/4k1DK0
	 459NEhebAIhbNlMJGGwa7kzHnIDD6xsDnmUaYNEyd1grEFsYgiujvg3KRb6LAbt+dBDAy
	 HtQHSg+mEkFTuYku3HAGFRwl/78Cl6h1q6y35Gnh57BhE4SZQ+mbx90KOFTWcAOR6pSCx
	 J6g5wVd9OspPOzOi1BtFdfCGFCnBK9Fi+R0JKhJQ/qMXeejPvT12iRfU3mZ4hmKe+sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IBbDs4fi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=slYK6ydr;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IBbDs4fi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=slYK6ydr;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AFA606A31B;
	Wed, 21 Oct 2026 09:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90AFA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IBbDs4fi;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=slYK6ydr;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IBbDs4fi;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=slYK6ydr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E43151F461;
	Wed, 21 Oct 2026 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKQlFBofvdQ7UPjpNR4JdVsvRg1fAT51dUsu8Om4kRE=;
	b=IBbDs4fi+BU/sRpXLk8OjTFC8gG9ckZNtvo/N5e0CP22hoKjw1Nw0W2zYVWkToowxIe+ue
	vd4cewriZPc8NbQ9pEIaHfXnJqOUwJghHXNanClBfA3CfzgibK9hdkvbnnkBJdzFR2xtyb
	igCEVMtH4KCvpmSn1+IRzlXw9kpjApg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKQlFBofvdQ7UPjpNR4JdVsvRg1fAT51dUsu8Om4kRE=;
	b=slYK6ydrJg0Hsby36XjiZ0I8rw3wJbFvq5J5su7GzV2SOddCPFnKHl5m5FlteC8r8zi/B3
	b7RpFbjwSUlCYyBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792575931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKQlFBofvdQ7UPjpNR4JdVsvRg1fAT51dUsu8Om4kRE=;
	b=IBbDs4fi+BU/sRpXLk8OjTFC8gG9ckZNtvo/N5e0CP22hoKjw1Nw0W2zYVWkToowxIe+ue
	vd4cewriZPc8NbQ9pEIaHfXnJqOUwJghHXNanClBfA3CfzgibK9hdkvbnnkBJdzFR2xtyb
	igCEVMtH4KCvpmSn1+IRzlXw9kpjApg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792575931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKQlFBofvdQ7UPjpNR4JdVsvRg1fAT51dUsu8Om4kRE=;
	b=slYK6ydrJg0Hsby36XjiZ0I8rw3wJbFvq5J5su7GzV2SOddCPFnKHl5m5FlteC8r8zi/B3
	b7RpFbjwSUlCYyBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B02C4134FD;
	Wed, 21 Oct 2026 09:45:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A3V4IruJ2GrqJQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:45:31 +0000
Message-ID: <6dcc78eb-4bf5-42d3-afbb-a60a9e8121ce@suse.de>
Date: Wed, 21 Oct 2026 11:45:31 +0200
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/10] block: add storage element management ioctls
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-5-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spam-Flag: NO

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Define the new ioctl commands BLKREPORTSTORELEMS, BLKREMOVESTORELEM, and
> BLKRESTORESTORELEMS to provide users accessing zoned block devices
> directly with an interface to the storage elements management operations
> of the block layer.
> 
> The ioctl BLKREPORTSTORELEMS allows to get the total number of storage
> elements of a zoned block device and to get an array of storage element
> descriptors (struct blk_se) describing the current state of the device
> storage elements.
> 
> The ioctl BLKREMOVESTORELEM can be used to remove (depopulate) a storage
> element that has a degraded status (i.e. BLK_SE_STS_DEGRADED).
> 
> Finally, the BLKRESTORESTORELEMS ioctl interfaces with
> bdev_restore_storage_elements() to restore the depopulated storage
> elements of a zoned device.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c             | 134 ++++++++++++++++++++++++++++++++++
>   block/blk.h                   |   9 +++
>   block/ioctl.c                 |   4 +
>   include/uapi/linux/blkzoned.h |  36 +++++++++
>   include/uapi/linux/fs.h       |   1 +
>   5 files changed, 184 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
