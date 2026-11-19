Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072744;
	b=qhgyCvEvVLfbOdDr4W3T8JtcTX1UF0P6TE/bCD4FLiw5tzF6NK+g5+iek3GHwFeU7E7I
	 +rAmbe+yN+m70I1F4j9VUBjP9cPKi/9Ioah4gYZSI1cLWX78oyf48/EPPF3haJb2sfZuN
	 LCKfwwg9hFY0X1AHTn0HwjdAokgtkqoAdF6OmglX8u4vdeVODMTlfVg1SskidoJYeNexV
	 6N1xK9V9+KpH9MnrI3KN41mfVyldsSSx7PbJmgRaxWZvQNjftAe1JHxHQMFxwbuZKq7cH
	 I3idWzBuKQuTteStQgmg0g8MT/g7N/rIAYTdAm0mbq4wC57rJKFZky0pRrQZJNRoVSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072744;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=zWFAMyvhT6rjpquKWPpA95qWxKxEyMPNditsJ2mJjo0=;
	b=ZbvldcEhZ9iAJKWXvstYIyDGe7Vf3oTjvPh9u/cVYDMmIQw9rfpPOrtE2gaW9TmMbVBu
	 9PepTV9E8DB9QAGc6VerKZckYdjkaLp8yusLHIyzlOP8peqpkLrOoAtstCHaIN1cgmg//
	 NGwEuYLGiixfjlgGzCwPf5o4sddnvlYcR+/flEm84QPSBbMQZN2Aa4bKHXJZsfeqYT2G0
	 g4jmQXeD+j3Ox3jznoAXev6j1oPnEysCkjt6Gm02Gv3DHmYHerQag9qxb37RF2OiDqiVT
	 c1rbRAUn+3kRgKsdN27VyTCMKaF0bKl6VUZINaOf8MuZxRzK67bSGjN8zWaF8Wp8c5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0hE5AXuR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XasQfpen;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KE93dF8W;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="yi/7zzuQ";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2555606A320;
	Thu, 19 Nov 2026 07:19:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2555606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0hE5AXuR;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XasQfpen;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KE93dF8W;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yi/7zzuQ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD382220AB;
	Thu, 19 Nov 2026 07:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795072742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWFAMyvhT6rjpquKWPpA95qWxKxEyMPNditsJ2mJjo0=;
	b=0hE5AXuRP8Q/RByav5Auwt+2lj3nqJONvTyiRadc6rZQ8MMmc1b1uaWn3f6HBQMpF/USRl
	gsP5R6AnVdCydCk0LrSkXtpsousitoGxIdDsWo17uz2gJu14YZ4r38NGRBGIh9TmgkTR58
	qFXEEfxs4wklzi+MMD+IycWPOtxbUoM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795072742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWFAMyvhT6rjpquKWPpA95qWxKxEyMPNditsJ2mJjo0=;
	b=XasQfpen3ZwllTk/Q+MbY+3vqrVuKl741INO35w2gt/mAmZWyC2mbEJWB++gNB9rEGHBfg
	4A9jm0QrgUNSITAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KE93dF8W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="yi/7zzuQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795072740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWFAMyvhT6rjpquKWPpA95qWxKxEyMPNditsJ2mJjo0=;
	b=KE93dF8W+yGSRgUf3rOLeOZhuE8ANDt9EHluYq9uFIkGy5UNgrK4xLlKY9Ouqz1o1wnspR
	vXOIBYQVFMP/HTX5P7d485zxzyHovjdBnUYSsytTXK1NWx9ezBGL3bUnq89LZveGAlzqce
	c9dU9+4iiYA84ho6x3Zb9DWfUCCFBLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795072740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWFAMyvhT6rjpquKWPpA95qWxKxEyMPNditsJ2mJjo0=;
	b=yi/7zzuQk5a8gB88ZbQEvR7Y6DC5PWgQSwZ3RevlIM/kNItLrWNT+zvNfPHUKCvNa9VEmD
	XIER2KBd32QHVqAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82E2F1334C;
	Thu, 19 Nov 2026 07:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id feqNFeSi/mo4TAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 19 Nov 2026 07:19:00 +0000
Message-ID: <353ac8d2-1fff-4772-bdc4-561a63cb326d@suse.de>
Date: Thu, 19 Nov 2026 08:19:00 +0100
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
Subject: Re: [PATCH v11 06/13] zloop: fix ordered zone append handling
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-7-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261116213702.225970-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD382220AB
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -13.50

On 11/16/26 10:36 PM, Damien Le Moal wrote:
> For oredered zone append commands, the function
> zloop_set_zone_append_sector() increments a zone write pointer without
> checking if the zone is already open (implicitly or explicitly). This
> check is done only when the command is later executed using a work item,
> and the zone is only then implicitly open if needed. This creates a short
> time window where a report zone can show an empty zone with a write
> pointer that is not equal to the zone start sector, which is incorrect.
> 
> Calling zloop_do_open_zone() in zloop_set_zone_append_sector() is required
> but introduces locking complexity as the zone mutex cannot be taken in the
> context of zloop_queue_rq(). Instead introduce the ordered workqueue
> append_workqueue to handle zone append commands when ordered zone append
> is enabled. This ensure that all zone append operations are executed in
> the order of there submission. This removes the need for setting the
> command sector in the context of zloop_queue_rq() and we can rely on the
> reguar command execution done by zloop_rw(). With this change,
> zloop_seq_write_prep() is simplified and zloop_set_zone_append_sector() is
> removed entirely.
> 
> This change does reduce the command execution concurrency and impact
> performance with ordered zone append enabled for file systems using zone
> append. This is however not a critical option and the default unordered
> zone append handling is unaffected.
> 
> Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/zloop.c | 113 +++++++++++++++++-------------------------
>   1 file changed, 45 insertions(+), 68 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
