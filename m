Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B598231A26;
	Mon, 13 Jan 2025 07:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752396; cv=none; b=r5J6KSJ14O4vxyrPqBia6vCZhXjcW3xYlq2EPjJikpMPeIUD6pbUasupfypTZyikrKUj8wJ4JC91LJaBrcmWzK3Y9eW64zdtlS56+sIRPRigs2TqWBUramW5A45UYy7NveUjQV3wufWGC7+yhaV8nZzyBRtRIDOUvtnHeVZ4iUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752396; c=relaxed/simple;
	bh=RoKrOcy9hixxN9gWWpDrJfjvvqpmFoQU5D22hhHWsg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CAZzjJO828C348VGFYAfvy/feYZMD6+nQwWfbnBp9w0N9lK4j2hAT1vCR0mp+sSN/N7N+ku4CAGAEssamzZpae6Xb8xWgWEbpP1YljEpqP+7RfvwVmtRTn9GsvR523u28xzC1jjLDZxZyIm5+EbFJN9M1wp5M0RQ+A6+KcVSEPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FQgsBOt3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pPCelx9h; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FQgsBOt3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pPCelx9h; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FQgsBOt3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pPCelx9h";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FQgsBOt3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pPCelx9h"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 95D0A1F365;
	Mon, 13 Jan 2025 07:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMCQSOX1uo6qNSIkIuDnMg3sFAMfn/oPf9iHmN+dSF8=;
	b=FQgsBOt3PQ+0L7ZIaJMrgvclhvXixwpCSd5t9GOkznmy6UJxiPnA+9cfmeurhtNIzvnKLF
	X8ZW7aUxkvQ4vVzmh79Bh8+3kcbXFQz3be5XBbDImtVV3MNIXNuGCvpba1+ipy4nJa6hjD
	XYEuVWHQHNfJSrkAydOnc7PMA0pTCwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMCQSOX1uo6qNSIkIuDnMg3sFAMfn/oPf9iHmN+dSF8=;
	b=pPCelx9hM2bir/xoh/9pTo1LTyDd1AaPfAMAbLcptg9EAXKoRjTMtkmf/2PMmTybHaM8M/
	LaOXoITBwFqu53Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMCQSOX1uo6qNSIkIuDnMg3sFAMfn/oPf9iHmN+dSF8=;
	b=FQgsBOt3PQ+0L7ZIaJMrgvclhvXixwpCSd5t9GOkznmy6UJxiPnA+9cfmeurhtNIzvnKLF
	X8ZW7aUxkvQ4vVzmh79Bh8+3kcbXFQz3be5XBbDImtVV3MNIXNuGCvpba1+ipy4nJa6hjD
	XYEuVWHQHNfJSrkAydOnc7PMA0pTCwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cMCQSOX1uo6qNSIkIuDnMg3sFAMfn/oPf9iHmN+dSF8=;
	b=pPCelx9hM2bir/xoh/9pTo1LTyDd1AaPfAMAbLcptg9EAXKoRjTMtkmf/2PMmTybHaM8M/
	LaOXoITBwFqu53Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B17C813876;
	Mon, 13 Jan 2025 07:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s0aaKQa9hGcRKwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:13:10 +0000
Message-ID: <7beae89f-182d-4d88-a6a5-fffd4324dcda@suse.de>
Date: Mon, 13 Jan 2025 08:13:10 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/9] blk-mq: use hk cpus only when isolcpus=managed_irq
 is enabled
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
 <20250110-isolcpus-io-queues-v5-7-0e4f118680b0@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250110-isolcpus-io-queues-v5-7-0e4f118680b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 1/10/25 17:26, Daniel Wagner wrote:
> When isolcpus=managed_irq is enabled all hardware queues should run on
> the housekeeping CPUs only. Thus ignore the affinity mask provided by
> the driver. Also we can't use blk_mq_map_queues because it will map all
> CPUs to first hctx unless, the CPU is the same as the hctx has the
> affinity set to, e.g. 8 CPUs with isolcpus=managed_irq,2-3,6-7 config
> 
>    queue mapping for /dev/nvme0n1
>          hctx0: default 2 3 4 6 7
>          hctx1: default 5
>          hctx2: default 0
>          hctx3: default 1
> 
>    PCI name is 00:05.0: nvme0n1
>          irq 57 affinity 0-1 effective 1 is_managed:0 nvme0q0
>          irq 58 affinity 4 effective 4 is_managed:1 nvme0q1
>          irq 59 affinity 5 effective 5 is_managed:1 nvme0q2
>          irq 60 affinity 0 effective 0 is_managed:1 nvme0q3
>          irq 61 affinity 1 effective 1 is_managed:1 nvme0q4
> 
> where as with blk_mq_hk_map_queues we get
> 
>    queue mapping for /dev/nvme0n1
>          hctx0: default 2 4
>          hctx1: default 3 5
>          hctx2: default 0 6
>          hctx3: default 1 7
> 
>    PCI name is 00:05.0: nvme0n1
>          irq 56 affinity 0-1 effective 1 is_managed:0 nvme0q0
>          irq 61 affinity 4 effective 4 is_managed:1 nvme0q1
>          irq 62 affinity 5 effective 5 is_managed:1 nvme0q2
>          irq 63 affinity 0 effective 0 is_managed:1 nvme0q3
>          irq 64 affinity 1 effective 1 is_managed:1 nvme0q4
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   block/blk-mq-cpumap.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 65 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
