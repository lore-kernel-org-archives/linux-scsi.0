Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794222819;
	b=2vZdFt5ThAalU1SFkDts4964+TUlgfGMNPltwrIu7y4S9JscXvdUFsUJqDneiHAbmGkf
	 8jTQ+W89zsECHXgtvP7XHI625ka7UwEWJR4UtJaN/pb0gZ3jCtsXgHYoVk4NCddH7PWqT
	 s9+fenmvQ7ASMc9zZV131oFKdv+REwrm6FWiMvUXABWbU0lyJUkvgHIZnVRMYGh9EhQhZ
	 KYAeo96t72Mv9H0nLTfJa0YePSN6VM3A6DraOPEz2o8MAhYBoNlBedFI+SdaBsEGCg3SK
	 O4Qebl87ShFN1PSBwlbKx40nStuobmjkP5A+k3ZSLNP2gQaJVh/xfenZSQ0Bl6glG2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794222819;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=VG1cHE8Rjx6TPVkGBhtu7tTczzTnVFpfGPeEKAndecY=;
	b=dcTjhDbxJZQkmmHk4ZuCTBVSrfCrAArpXgszRgfZ8fUcjIPnPSXSf7tVL8S3NKjwFxsn
	 fqpCZY+edkJm2UlgyMlldo59GJvS0B0Z0+DoREEvcvKmELUGHFRtEMV0cp5AUNIB2DvLY
	 i87Mg2jqktSibATBPPRz/86VsznR6GbUQEuhxIyag+MrPiVq7l2wgDyNYh4txZqkwDWMf
	 6Ieowf62HWUJZYoJiFLFm/9/yD0Aqlf/7jAqKoNTaifc4JSkQkYOlHADNJvwrfE/ZxJoB
	 5m8Wrf8w7HP0nfnmfUwMBZ5PbtuQzmjTyAQWJDJHuMXFYkggno95/S4dbY3XmC3Q+iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mIpzqmr1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Raaz30z;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mIpzqmr1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Raaz30z;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B78C606A322;
	Mon,  9 Nov 2026 11:13:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B78C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mIpzqmr1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Raaz30z;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mIpzqmr1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Raaz30z
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76BD11F7F0;
	Mon,  9 Nov 2026 11:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG1cHE8Rjx6TPVkGBhtu7tTczzTnVFpfGPeEKAndecY=;
	b=mIpzqmr1D2B5ZvUcN1TPVaV33ud5moSvc1tGDDgkRf3mqaUDxhep4fyfJ5HCZdh/lQVEKq
	2YTzp3SI+7IVHcYnyCrd/BkKcWUeg8kwu+vsLyloymlklXAbuB5RMstOxyug8OSv5/mQNZ
	8JL+KWPg+X5UgLZUJYQd4E4W8tbpXSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG1cHE8Rjx6TPVkGBhtu7tTczzTnVFpfGPeEKAndecY=;
	b=8Raaz30zHT70Hw1+SEflfMR7+6kq+NwKitUF5r7hlaisIPzhAp/qHBrhVeNq81g4I5g9n2
	YzqxqDeZF+8euBDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794222816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG1cHE8Rjx6TPVkGBhtu7tTczzTnVFpfGPeEKAndecY=;
	b=mIpzqmr1D2B5ZvUcN1TPVaV33ud5moSvc1tGDDgkRf3mqaUDxhep4fyfJ5HCZdh/lQVEKq
	2YTzp3SI+7IVHcYnyCrd/BkKcWUeg8kwu+vsLyloymlklXAbuB5RMstOxyug8OSv5/mQNZ
	8JL+KWPg+X5UgLZUJYQd4E4W8tbpXSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794222816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VG1cHE8Rjx6TPVkGBhtu7tTczzTnVFpfGPeEKAndecY=;
	b=8Raaz30zHT70Hw1+SEflfMR7+6kq+NwKitUF5r7hlaisIPzhAp/qHBrhVeNq81g4I5g9n2
	YzqxqDeZF+8euBDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 460F613319;
	Mon,  9 Nov 2026 11:13:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LgZACOCq8Wp+GAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 09 Nov 2026 11:13:36 +0000
Message-ID: <7ff234cd-f7d3-468d-8c27-2c51ee7bacc6@suse.de>
Date: Mon, 9 Nov 2026 12:13:35 +0100
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
Subject: Re: [PATCH v8 03/12] block: allow dropping all zone write plugs on
 revalidation
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261109095144.819709-1-dlemoal@kernel.org>
 <20261109095144.819709-4-dlemoal@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20261109095144.819709-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.997];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -13.29

On 11/9/26 10:51 AM, Damien Le Moal wrote:
> In preparation for supporting storage element depopulation, modify the
> function disk_revalidate_zones() to take an additional boolean parameter
> drop_all_zwplugs to force removing all zone write plugs from a disk hash
> table.  Removing all zone write plugs is done in the same manner as for a
> capacity change, using the function disk_drop_zone_wplug() applied to all
> hashed zone write plugs.
> 
> Calls to disk_revalidate_zones() with the argument drop_all_zwplugs set to
> true will be used when restoring depopulated storage elements as such
> operation clears all sequential zones, modifying them to be empty.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
>

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
