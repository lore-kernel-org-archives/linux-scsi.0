Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794223288;
	b=tk6YzUrKIFqiLeZP9U8+xfgP+YKu43BlIILu4pXs8KJ5csUq1E1W1tMQ4482LrgxvSdp
	 d8wp1iHRcXrleJVwUf+bRMkD2Kp5wpm1gH5fpab7vNHY5Ts0OsjFDTh4TwS3G7gAEZOFh
	 wU3SFg0yy/JTCb6XscgUdh7r2eEV2hAuGH6ukZy0b6uPaMxyZ8Ik9Gh9DsGB3yermTa/7
	 XDYmUiPxt0eRlT6qrmTvVWdTl2xPZ+wGYEkgj3YpmQlUwWRflwis1HWHD7/5ThT8Ur7R6
	 p/RwIpTgq7GRLKWo+zzvtrjrjD6hfhzUn6qDCatIqUwpOJjWJyGAJWxuvr6+OcwzMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794223288;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=JiXMv/EcQWr3XjuejMaPN148RDm9Cy5bCphqwOVJCTY=;
	b=X3qYkeXc4T8HX3r4AcC4OwNzJfXoxqu8n8YE1R8m9k6UTWVdwldjWQMDuzUdnLZZ8ldq
	 6UGc5e5gdB3Cv8Jj18szL1CKNNKOV7b+BAH3lloRlmJdF5NsMgK4kY6syLcKJLhz2Hf7Q
	 VIE+h+L7c+neHnfnt24bsmjKlCWPuSbR1CrGzNufzh1rrsxvCM8CBBLa1DQnLZttrQQv3
	 CYPz61BvnYX/iFLt2evDtGLTlLCMWYi+nHOmt/JvNVhiBCqsHZs++gG6QFaTGQogTqZk5
	 ds2STeXDVTIjqWa2EYpfxuB7o0VxzUQApc5trqg8knzWK4SLjn0x0rtsHjSwdmAZrBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hJLhju9q;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fm0MQnjF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1s+pmn7M;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RG8jR45i;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93708606A31C;
	Mon,  9 Nov 2026 11:21:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93708606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hJLhju9q;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fm0MQnjF;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1s+pmn7M;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RG8jR45i
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0F101FB71;
	Mon,  9 Nov 2026 11:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXMv/EcQWr3XjuejMaPN148RDm9Cy5bCphqwOVJCTY=;
	b=hJLhju9qq87jpjaqfFqmFzFEkmrPb2PHbsvH6ur/foBV9FPxHwlE+3eSpghYbPe+fLYV4J
	n/WBo9HuxXnidCkVEAb67T9Mu1t8FSd3wrKiEpT6akpYxQ61B/u8MqBPVfh2vBNmJ6IczF
	1jEEL/UV/7tG9xF7m7Sqnx7PIqcR+cI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXMv/EcQWr3XjuejMaPN148RDm9Cy5bCphqwOVJCTY=;
	b=fm0MQnjFmOQhpLwjbDAWUcfvxk0Ozt5KZbUoRhSF1PczRl8O56P3/BWp0jJRlIavbO/i13
	c8o6NhC8h/BqF8Dg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1s+pmn7M;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RG8jR45i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794223284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXMv/EcQWr3XjuejMaPN148RDm9Cy5bCphqwOVJCTY=;
	b=1s+pmn7MKInpgFiRVPdg5fgWyPIfcl9tpLvCGaL65sGhb7+zkENNpi1kLvHExG853+Jd7v
	wX5w5KPgdoA57kuYu6dC6iczrLt6W+7qXDYs6OTp1FwpZz6IrucSFlmUn3tNon9ej1JZ/k
	m7bYjxpF1O669NppWiqfJ0ofZUMP7kg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794223284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiXMv/EcQWr3XjuejMaPN148RDm9Cy5bCphqwOVJCTY=;
	b=RG8jR45iBL1sPf4t5gxUTUx2xjvN9IaxEtdCDMFJbfsYwFNGUoVb6g4w7WJ5dP9lo1ftFD
	Fs9rJsUPu6SvFwCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DAF613479;
	Mon,  9 Nov 2026 11:21:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PulsFLSs8Wp9IAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:21:24 +0000
Message-ID: <e4c7f439-2294-450a-a225-db1f612fa1e2@suse.de>
Date: Mon, 9 Nov 2026 12:21:24 +0100
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
Subject: Re: [PATCH v8 11/12] scsi: sd_zbc: define storage element management
 operations
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-12-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-12-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Queue-Id: A0F101FB71

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> Define the storage element management operations using struct blk_se_ops.
> These operations are valid only on SMR disks supporting the storage
> element depopulation featu, with support for the GET PHYSICAL ELEMENTS
> STATUS command being mandatory. The support for the modify_zones operation
> is already indicated by the depop_modify_zones_supported SCSI disk flag.
> sd_zbc_check_depop_supported() is modified to add detection for the
> command RESTORE ELEMENTS AND REBUILD, which is indicated with the new
> SCSI disk flag depop_restore_supported.
> 
> Both the remove_element and restore_elements operations will block
> until the operation completes or an error is detected.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c     |   3 +
>   drivers/scsi/sd.h     |   3 +
>   drivers/scsi/sd_zbc.c | 471 +++++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 476 insertions(+), 1 deletion(-)
> 
I am not sure if I particularly like the .ops method, but I'm also
not seeing an alternative approach.
So:

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
