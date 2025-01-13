Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E820231A4D;
	Mon, 13 Jan 2025 07:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752453; cv=none; b=OJpX0gPWedPOm5EsAELpkQU3g3HQvRZmv1lLInNNS0S/2Eo8F+iLEt8AWTyl5ZBxZ/GdElcPonuD+dMkDu5BgC18eXZfSqJ9r3KFbJEEFsFPxuL/Zufk9SQojGvIg9N6pDVN/+hXALPVQqX26LTWdyik/DDg4jb3cIVDuGwabgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752453; c=relaxed/simple;
	bh=SoLrxViE+3fqLYHiDGYOlh+jAC8ZrpIWjB4G8t+Yv04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eYBPMZI7M3hoRef7yxSXFe7GrRCz6XpP5VWKF8f2tTy45e+973IGJcnMJXodi7ry9oQuEJCWSGh8IM1J32sJyxswTwjVlKq1u6sBGK3l0W3CJKxhbIeWg0F4mDzzUvpwYIyQBpTZib51swJu9BZZgjaaghNc+ekCf/GA3kurEHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jNbHxYW8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E/q4UC9P; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vEU59qsd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iHpmaVVf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jNbHxYW8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E/q4UC9P";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vEU59qsd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iHpmaVVf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 627871F37C;
	Mon, 13 Jan 2025 07:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+b3bSlFsRbYm4kFAiNykurqoL574dz6g6daOUGbiVM=;
	b=jNbHxYW840HT/WWydH8K3QAmI24Lfrv9SfiL4ydd1YOFnFJqIeM93mGqx7EbKHq7hWeFZt
	6Aee3Lt95vICjH1P0I7PJvEAaVxRR+9peX8hM2gkNpukq4bwsueMj3ThEopHJYkDCnO10g
	wxQ1InZfp5f9YrXHMa51cr1d8n3MSzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752450;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+b3bSlFsRbYm4kFAiNykurqoL574dz6g6daOUGbiVM=;
	b=E/q4UC9PUVxTjkLCSfFHrpX51V6WCp/j9c6l9uo9+VqZ+qJQCUpj7wsG+zW9nvrQ8zOTqx
	GYNrMswWXUT+VYDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+b3bSlFsRbYm4kFAiNykurqoL574dz6g6daOUGbiVM=;
	b=vEU59qsd9gcFXM6DaKZP53q3bCPSad0SvE8A5QblqWnVJuq94hRJzcbthwLahhMKXub5dY
	yH/mrICiTrgzIIm9D8mNf3FlwD081OF6GDpsogFzgJhfQBjnpDcoe1F8l14SbdMl+VftVM
	Y25YvapGkWFWQZo2rt8v++mrYtdanMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752449;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+b3bSlFsRbYm4kFAiNykurqoL574dz6g6daOUGbiVM=;
	b=iHpmaVVfP/Vwnp28RTf2CAjWdmjk5W93c7Xc6qSXuPaIcf2zGq/9O16WJxwym+1dQxvI6i
	7jdFhpJ1DynLFRDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84D6713310;
	Mon, 13 Jan 2025 07:14:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pHJ+HkC9hGdKKwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:14:08 +0000
Message-ID: <53654909-609a-4385-82dc-6cab3dd5e611@suse.de>
Date: Mon, 13 Jan 2025 08:14:08 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] blk-mq: issue warning when offlining hctx with
 online isolcpus
To: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev,
 GR-QLogic-Storage-Upstream@marvell.com
References: <20250110-isolcpus-io-queues-v5-0-0e4f118680b0@kernel.org>
 <20250110-isolcpus-io-queues-v5-8-0e4f118680b0@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250110-isolcpus-io-queues-v5-8-0e4f118680b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 1/10/25 17:26, Daniel Wagner wrote:
> When isolcpus=managed_irq is enabled, and the last housekeeping CPU for
> a given hardware context goes offline, there is no CPU left which
> handles the IOs anymore. If isolated CPUs mapped to this hardware
> context are online and an application running on these isolated CPUs
> issue an IO this will lead to stalls.
> 
> The kernel will not schedule IO to isolated CPUS thus this avoids IO
> stalls.
> 
> Thus issue a warning when housekeeping CPUs are offlined for a hardware
> context while there are still isolated CPUs online.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
