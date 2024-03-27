Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01CD652;
	Wed, 27 Mar 2024 07:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524087; cv=none; b=gC/ohsR/rHOsx0eviRZfhv3HHs2l68xqDa1xK7RPTdOQ2dB/mXfoZ1MpC7tm15BzdT9LE+omAbjms/muw35gmg+NBTi1FiAtdEX+5av/8tZSc1Pi6M2gVaKbN/UOcfxeatIZvPSc47tHJ3yCA4NLMKeTmiN+879g6L6S6NUVOF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524087; c=relaxed/simple;
	bh=9vGDbxOa8knUXCj+e8H7eyKBM72fsfu0Ob1PQSLhGOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S7LVVZ4CfWihPWn8N/LOxIilxYccs0qGtthRtbHbq2xAHdtjWs+DNSrDB1rVmYMd9g5hDs4+VlJ1NXBYOz7g/3Q73WcavkauD76bp8xqBAbB2QmS9k7ybGfQfIbzGo0uPjf+wOB+8ZFIoQLQ7xB+RZ45gisig9J8KVFXpdCBZ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lI4bNvS2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mY/EeYa+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lI4bNvS2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mY/EeYa+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lI4bNvS2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mY/EeYa+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lI4bNvS2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mY/EeYa+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 499B35F9FC;
	Wed, 27 Mar 2024 07:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/1mcUY8RNWWP6PpYU3W8q/DPyYvT567/wGQSCPpU6ic=;
	b=lI4bNvS2JXuQzRWNAWMVwkW7CXOudFUQeJc3OA3T/GSg7E3zFvVFa+xsSDhXDo/egdOxdP
	xN8i8RZ2sXrTDJTmDkVEl2L0DYnNAT3gZgt+Zx9hhQj9dNmXSKhl5zSWfc9Ltk6OoyC7xa
	9fwoxpLYI5ViSuNHkzaW0/sJmc5xj3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/1mcUY8RNWWP6PpYU3W8q/DPyYvT567/wGQSCPpU6ic=;
	b=mY/EeYa+V4FUyzY2pDWVd1Ykx9uN924fA6YlCd5NNR0dxdYVOZk7nXfPOqHgelSFIhsVFY
	q99+sbkAH8vLrVCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711524081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/1mcUY8RNWWP6PpYU3W8q/DPyYvT567/wGQSCPpU6ic=;
	b=lI4bNvS2JXuQzRWNAWMVwkW7CXOudFUQeJc3OA3T/GSg7E3zFvVFa+xsSDhXDo/egdOxdP
	xN8i8RZ2sXrTDJTmDkVEl2L0DYnNAT3gZgt+Zx9hhQj9dNmXSKhl5zSWfc9Ltk6OoyC7xa
	9fwoxpLYI5ViSuNHkzaW0/sJmc5xj3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711524081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/1mcUY8RNWWP6PpYU3W8q/DPyYvT567/wGQSCPpU6ic=;
	b=mY/EeYa+V4FUyzY2pDWVd1Ykx9uN924fA6YlCd5NNR0dxdYVOZk7nXfPOqHgelSFIhsVFY
	q99+sbkAH8vLrVCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2182113688;
	Wed, 27 Mar 2024 07:21:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aB/NBe/IA2ZLeQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 Mar 2024 07:21:19 +0000
Message-ID: <3751bf72-6a7e-44f5-9342-a1faf0c96e7c@suse.de>
Date: Wed, 27 Mar 2024 08:21:17 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/28] block: Fake max open zones limit when there is
 no limit
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-10-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240325044452.3125418-10-dlemoal@kernel.org>
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
	 BAYES_HAM(-0.00)[34.16%];
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
> For a zoned block device that has no limit on the number of open zones
> and no limit on the number of active zones, the zone write plug mempool
> size defaults to 128 zone write plugs. For such case, set the device
> max_open_zones queue limit to this value to indicate to the user the
> potential performance penalty that may happen when writing
> simultaneously to more zones than the mempool size.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c      | 22 ++++++++++++++++++++--
>   include/linux/blkdev.h |  1 +
>   2 files changed, 21 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

