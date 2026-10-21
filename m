Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576293;
	b=NX8pB3PCv6ZQ/6akcG17VexVWwEAOTdo9aXpWzc0MwKTM5FeVTjhxczZm0NjgYSY1vwi
	 UMnrOjKckP7Ow5a6Fkk+auIwmEq3M6JvYwrVCeLSOaKyu1EYRPrx9NZCka4flTVlT5EL3
	 bxU6oi3maIU53TSZjeqduw70T+/YOPYMWrsqLnDevbppru9rBkDffpPrNA7jkxL3LK8/V
	 z3Xp3XuJwWK5HAU7c2kmPSVh9lmEpIGIgqrrfvePw5gaDC19WhZD+4I4MWeGgoJy9Y99d
	 TQlmtbxtrI3b71wwIi9bvmb6mRBkUXnI3tILObxXaGCwIobvwNq6tAYwg8ifQBhlZmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576293;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=07ME8O1Q7CXvJY/KhmtdDrYzbwIpfBp2OjMWxyPd0GI=;
	b=lDCEvmSscfyWRWvJI6ZrSDIs6+UDn4clT3J1GacjdQ20FARNkxfy6bxWfVBxkEzEmoKg
	 /PNMg2x8P2a8jhoO+QYK/qeSh4b/v1CoSihD0Zc8ZQCmClhgqa5Kys4p8XvE5f4B/sFup
	 I/H/hj7AJkU6yRZqvS29SXKIm2sFl959VP/0nmOV4lfbKg8Uo+vKAglxLwxn9+fsipiF9
	 LkvagCK4UpeEyuf6I+Qat0sawcKzgFfDW9OljEUR/ckam3chmb1jhVYattt7Q/Cdu31YU
	 BLM42QmNqHdHmJaRZUbVj0BDq4TxomPMzq7cVTTITifnrhSXDf3ZCJePnkpAkQKGDOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=H0I2QWVx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="F32/76HX";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2Ci5n1ka;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vyVOoR5f;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB56B606A31B;
	Wed, 21 Oct 2026 09:51:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB56B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=H0I2QWVx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=F32/76HX;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=2Ci5n1ka;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vyVOoR5f
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0295E1F461;
	Wed, 21 Oct 2026 09:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07ME8O1Q7CXvJY/KhmtdDrYzbwIpfBp2OjMWxyPd0GI=;
	b=H0I2QWVxiTm6kWoF8xbrXgO+ttZgkEXf9M2Cv3ePQCxT98y3CfTqgUvSlZvsBFYgeEyotV
	bI4/IDpq0aSQCQQtjW15UpeiGqi03Eumlrzc6Z4KRpAcGXwEhLwpkqVYfYx5qpGwMOcagT
	v7YQsWwSb7m61GzkrdMyvTLfm0T/UBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07ME8O1Q7CXvJY/KhmtdDrYzbwIpfBp2OjMWxyPd0GI=;
	b=F32/76HXmGzx2K1F+jEse6PqGzBqd8benZy+qbNXsUdhne7MwingjKM/ztaD1iAy3HCX1L
	TY3yv+0x06igfnDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2Ci5n1ka;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vyVOoR5f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07ME8O1Q7CXvJY/KhmtdDrYzbwIpfBp2OjMWxyPd0GI=;
	b=2Ci5n1kaMslbQSt1S8LhnmLEOFF3U9ghdtzTQKRanWNpetHan9ODosKoY+dOCq3cPuS8YK
	ONSBD0NVHGEdAg61vQGDflZnt5CUIkjl8t9x/iRqs46HLmFz7+3fG5mkSeElzBls4KG2yS
	/ZgMl354Q6nXp1e/Prb0Ig8XMCR41yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07ME8O1Q7CXvJY/KhmtdDrYzbwIpfBp2OjMWxyPd0GI=;
	b=vyVOoR5fARRn0sVrxJwGqkpESvSGq2F3xP6utEvH2sRFpf9q2ijztVqpOYTKAs6uc0LY6p
	m8Te05892eSTCwAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B67D8134FD;
	Wed, 21 Oct 2026 09:51:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uoP2IyGL2GoiLAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:51:29 +0000
Message-ID: <54f49260-cbc5-4644-9545-ab3d6b8a4f69@suse.de>
Date: Wed, 21 Oct 2026 11:51:29 +0200
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
Subject: Re: [PATCH v6 07/10] zloop: add degrade_element control command
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-8-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0295E1F461
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> Allow users to mark storage elements of a zloop device as degraded using
> the new "degrade_element" control command. The element to degrade is
> indicated using the element_id option. Example:
> 
> echo "degrade_element id=0,element_id=2" > /dev/zloop-control
> 
> If the element ID identifies an all access storage element, read and write
> operations targeting a zone served by the degraded lement are failed.
> For a partial access storage element, read or write operations are failed
> depending on the storage element type. This check for an element status
> is done without taking the storage elements mutex lock, so in order to
> avoid memory access ordering issues, storage element status access is
> changed to use READ_ONCE() and WRITE_ONCE().
> 
> The zoned_loop.rst documentation file is also updated to explain this new
> feature.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   .../admin-guide/blockdev/zoned_loop.rst       | 19 +++-
>   drivers/block/zloop.c                         | 88 ++++++++++++++++++-
>   2 files changed, 104 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
