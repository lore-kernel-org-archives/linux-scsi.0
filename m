Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576364;
	b=OaNeLkTjK1Zz5I396BDOQsDzeGZxdurM/bQS+IM94bCtScYqcPZ2eG5YsmQLs4WLb0kX
	 9n3lPUwrWdJ5p3I/kPKPLr6pSiDvruEFaFnRseBI090wIffp5WhVObZPAnbEGk5EEVCEp
	 ZFQ19dwja6+AvvxHm9PPe9Sz3IhgjAv+5+w8aG2rIrY4ipty2keBoCFd/a22MFCackF+W
	 eRh8UVRUQtbex/IOS4as4AY9QQ/fBFay57D26blIpPmN+H92mTq9LHUTC8sBAwrgWy8OV
	 xK3mg9A4x8yDc41gBt55aDzCjMRDnwXhV5eA7i4K5FiosdaudqPNM7SCiyEJKWms3kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576364;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Flag:X-Spam-Score;
	bh=cO8BDvsFFXtmG9hfjtN1w7qQmC87FnkVIJUXtZtSdxA=;
	b=Ma4UGv+44YDReH4OYKsJxjx1nHrFh4xLQH9+1ztAa/cDXBTwzyDKdQh9nA7qzrOn5MrQ
	 pGjv6mg1m5lyQ9Synxk0Hd031UK9sE7F7VOasZWMzok6Aap4lUZCZyfuKp/HUno5uR+FS
	 aFaGitfAcKBLg/BXa52kYbERV2SgmH7wQ53ZxcE0c6CrD3PIXfjArrd3Yy6Wfb3CdJAoY
	 95tn9eEbLqmg6Ye+RII9nADKLEAxpYndoP8gevnaXM0KhREQGyit9JCLQO8x0UMcMyp0Y
	 bTBHA7iUOvS2kiMy1PawY7vpE5OC9MVwXh3Y0PWd7MjtjOFBTF8hddWlJS8PkKKILbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KOslxmCG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RiFQTvyG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KOslxmCG;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RiFQTvyG;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC6B606A31D;
	Wed, 21 Oct 2026 09:52:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECC6B606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KOslxmCG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RiFQTvyG;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=KOslxmCG;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RiFQTvyG
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 143281F461;
	Wed, 21 Oct 2026 09:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cO8BDvsFFXtmG9hfjtN1w7qQmC87FnkVIJUXtZtSdxA=;
	b=KOslxmCG4XjpzitYtuba7vRTn3ieXCvjd4+2cVRNVdlzv7EpavXQDrIo+k7gqpX9oNzGlJ
	dWw5y4RQUR9ZBCUA5FxgXpdy25NuqIIpyXaSzqa/4r3vEm+FmYJ3DCazsf9hAoG2QiANHO
	a2QS6xJYA8xfGYX3gwDQcmBwfN0YDyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cO8BDvsFFXtmG9hfjtN1w7qQmC87FnkVIJUXtZtSdxA=;
	b=RiFQTvyGIg/DohX7BTVr9t1577ArpxCbYgV4Jo5KyD4tLnoOUtSTjZ80HELG7Zhirjm0KS
	tqjBaLtCYDHpH9DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KOslxmCG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RiFQTvyG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792576357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cO8BDvsFFXtmG9hfjtN1w7qQmC87FnkVIJUXtZtSdxA=;
	b=KOslxmCG4XjpzitYtuba7vRTn3ieXCvjd4+2cVRNVdlzv7EpavXQDrIo+k7gqpX9oNzGlJ
	dWw5y4RQUR9ZBCUA5FxgXpdy25NuqIIpyXaSzqa/4r3vEm+FmYJ3DCazsf9hAoG2QiANHO
	a2QS6xJYA8xfGYX3gwDQcmBwfN0YDyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792576357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cO8BDvsFFXtmG9hfjtN1w7qQmC87FnkVIJUXtZtSdxA=;
	b=RiFQTvyGIg/DohX7BTVr9t1577ArpxCbYgV4Jo5KyD4tLnoOUtSTjZ80HELG7Zhirjm0KS
	tqjBaLtCYDHpH9DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AFE68134FD;
	Wed, 21 Oct 2026 09:52:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0MMwH2SL2GqILQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 21 Oct 2026 09:52:36 +0000
Message-ID: <b1be00e5-509f-45d0-a1ec-6b5659cc7bd9@suse.de>
Date: Wed, 21 Oct 2026 11:52:35 +0200
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
Subject: Re: [PATCH v6 09/10] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
 <20261013122750.2237843-10-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261013122750.2237843-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 143281F461
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,suse.de:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 10/13/26 2:27 PM, Damien Le Moal wrote:
> sd_zbc_revalidate_zones() skips revalidating the zones of a ZBC device if
> the zone size and total number of zones of the disk has not changed. This
> is to avoid a call to the rather slow blk_revalidate_disk_zones().
> 
> However, for ZBC devices that support data preserving head depopulation
> (REMOVE ELEMENT AND MODIFY ZONES command), a disk capacity and number of
> zones does not change after a head is depopulated but the condition of
> zones changes as the zones served by the head that was depopulated become
> either read-only or offline. In this case, not calling
> blk_revalidate_disk_zones() prevents the block layer from taking
> appropriate actions on the zone write plugs of the disk for the zones that
> became read-only or offline.
> 
> Avoid any issue with the block layer view of the zone conditions by not
> skipping the call to blk_revalidate_disk_zones() for disks that support
> the REMOVE ELEMENT AND MODIFY ZONES command. This check is done from
> sd_zbc_read_zones() using the helper function sd_zbc_check_modify_zones().
> The new scsi disk flag modify_zones_supported is defined to remember the
> result of this check.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.h     |  1 +
>   drivers/scsi/sd_zbc.c | 26 +++++++++++++++++++++++++-
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
