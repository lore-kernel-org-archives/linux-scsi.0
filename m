Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223036;
	b=BDGkSzTTYuBQpcJoOzQdhIrhDbkX3lUJQTAxCIuOQfCnVktGKNpPATdiYRDL1Mn2yhyp
	 cN3tNx07oduJ8YH1U0f33epzgEJmDKT447yNHQDt5eAVwZjC74WoHotp0NWV1h6q4WYrc
	 BsIht6Tn4uXNKzRwxRl9brgHLKGyZnigj/SZzlDp7nuE4vzoGG47oRiwlG369UfFoICZQ
	 C4QgOKkqi+RRlUgwHV2fy+PMWvmqRRr8H9ON4feZw/Ougc+Lttsn1FTwEQuwDXEourKe4
	 XrShhtCSaBMWSQW1TcPJxSCrfEObDxM3Fv5JHxJlDl0E/lHXPF65PwGWcC1+hqt/ptA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223036;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=tLigefoABsN1NSRU94qqZVoS9TpPqbI8+Q5wgyCAO+U=;
	b=piIQCTHXTnU9K3gIwY88x1o3trJ9t9qHqT6XvDdQK3OFNlJmLYc+nr5i8yTwI9W2hFYe
	 Ovi5Rxa6zqD+X9newXyoB52aXHHCq8r4m0nttqW7XCbdrq6tEtWpLhJJ/2VzNNjJA5D/J
	 m0W6XlArr62E5jkSKg5pDqAVxfx2sXwuuN+/+nBiVNcq+ku2iEMkFW+Oo+UqcBzzQ++s6
	 ZbOr9nPf1n/t2M14bRq34E0R1fjSyZTg3uMPe+N0Y+grRKXWCkWTk9OK1V01qDMQhKtzz
	 uTBy7W/00yVRKbS16C01GSkdwAn9cCQJnfzl3uaqsqLqXo3GwD5aK8C5DAKyT12GR7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lt7uGFmt;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4iUimY2q;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZdPRMxQM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="CToNL8W/";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0D0606A334;
	Mon,  9 Nov 2026 11:17:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD0D0606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=lt7uGFmt;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4iUimY2q;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZdPRMxQM;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CToNL8W/
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1356221B6;
	Mon,  9 Nov 2026 11:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223033; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tLigefoABsN1NSRU94qqZVoS9TpPqbI8+Q5wgyCAO+U=;
	b=lt7uGFmtj9QU3iQ3KQjDdzsG/1Q8Ekck9NmE7ohH4a6//zHmWoFWvYaqDDj+OKlxNPUkjP
	/k85jEMBZ1/HPdVmaRQ6eEaSFrpp9YHfpld61v0Qre24NqIWd7mo4glpt2+5WNFbJxjaaL
	Pz9ThH06hlAYfh9mH3jQ1b1cHnIz1uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223033;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tLigefoABsN1NSRU94qqZVoS9TpPqbI8+Q5wgyCAO+U=;
	b=4iUimY2qicmr3NmTL7dHyoOEvQQ2BqQl0//fYmxkDXJ7O2M3mbPcvCQPOl4PgLNUhrK3LW
	SgexQIMkZwM+veCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZdPRMxQM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="CToNL8W/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tLigefoABsN1NSRU94qqZVoS9TpPqbI8+Q5wgyCAO+U=;
	b=ZdPRMxQMYj0jyMG08/AFYxM6R1iWrn4X3iv1mKHgw/rdR8+qht2zgnWC69X3desF5ea5Z1
	dmD/M1EeYQxXwjKQcxrT+sbhF+ORkVcnhG39VTBxsUhoJFxn7XlK0Js3+dv2Re7MdbeD/j
	eVcDC9L6oRGtMUEdQTVEHVKYSaCW4Bk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tLigefoABsN1NSRU94qqZVoS9TpPqbI8+Q5wgyCAO+U=;
	b=CToNL8W/HNckJDP+Y1nsCFU1PS4/9Wcr3ppSU9KqGo+kC2lxZJMbRFVSV3sFonByCTg/xp
	sRTZx9j+LlFkq1AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 630B113319;
	Mon,  9 Nov 2026 11:17:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r/SeDrir8WpeHAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:17:12 +0000
Message-ID: <128f0857-43be-473c-b7db-36f95a34f9f2@suse.de>
Date: Mon, 9 Nov 2026 12:17:11 +0100
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
Subject: Re: [PATCH v8 07/12] zloop: add storage element emulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-8-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1356221B6
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> Emulate the storage element depopulation feature of SMR disks in the
> zloop driver. This emulation is controlled using the new stor_elements
> option. This option can take several values:
>   - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
>   - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
>     (e.g.  read+write heads)
>   - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
>     elements (e.g. pairs of read and write heads)
> 
> If enabled with the value 1 or 2, the number of storage elements, or of
> pairs of fractional access storage elements, is automatically calculated
> based on the number of zones of the device so that we have at least 2 and
> at most 32 storage elements or pairs of fractional access storage
> elements.
> 
> The mapping of zones to storage elements is defined simply as the modulo
> of a zone number with the the number of storage elements for the all
> access storage elements emulation and with the number of storage element
> pairs for the fractional access storage element emulation case.
> E.g, removing a storage element from a set of 4 all access storage
> elements will offline 1 zone every 4 zones.
> 
> The storage element management operations are specified with the
> zloop_se_ops (struct blk_se_ops).
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   .../admin-guide/blockdev/zoned_loop.rst       |  11 +-
>   drivers/block/zloop.c                         | 684 ++++++++++++++++--
>   2 files changed, 653 insertions(+), 42 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
