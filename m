Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603B5230D18;
	Mon, 13 Jan 2025 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736752496; cv=none; b=U84Jktn8c57Q9YWbEvVKyBEz0b2UlpOgIKPyWu1FyRHUUmvpjaFeGfWDTAkyrZ9ZKLfpbdIxhIw9G1dp7Yfh0fVrq9F2J/9P2kKX6ILkvY5OGq35COx6Dv1XjQ5XbGlF3bWwEH1SVQv+jE9OI4NrpJSrVWrtF8dPuqqtFqBx454=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736752496; c=relaxed/simple;
	bh=ANhoQnK5pupHxJENPV+xM0UAn/lWls7ujuIWNl2IiTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SMR+SfiO0iToVmvR6zwKZsnEdxINqh9TxpvfZJQzjjljEE8iVeT0mqHcLQw6+LNlabg1RfBb9VADZz3pY4YLc6cF1Bimi1Zi+qlruWEzEeuiAmzyhr5qOT5s1wnktmYmynPTzHn0LYO9CI0Bh970/ygF6VEjbATDTz5SOGddpCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YNjI3iRu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5jlek5/O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YNjI3iRu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5jlek5/O; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YNjI3iRu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5jlek5/O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YNjI3iRu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5jlek5/O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAA4B1F37C;
	Mon, 13 Jan 2025 07:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulSOiBud7NT55dZGFodvslB3QoYPMq3us4a4P0xo/9w=;
	b=YNjI3iRuZGnkcJRRaMBS9ZxtpB2ALnq1LeZFTiHzBrCfEXPD4Zh1KETt9CjYqDDiBrnA0g
	T+5WG/S1U9x8ErgV1suJsAzcaFAHHlP82XorW4DVGBYX7P9LViUQDNleo+CkClW7WFlTWq
	O5glpKn+WW9y9W0ofO9zz8hy7C0x7vM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulSOiBud7NT55dZGFodvslB3QoYPMq3us4a4P0xo/9w=;
	b=5jlek5/O7OhTnwC5/nUCb1Xs3Hm7G+mNUKkmVbx8QlbVwuZJq3Tvj0JHWKvDvtIgGYS5Pz
	u/eVQOvJfy8+1iCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736752493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulSOiBud7NT55dZGFodvslB3QoYPMq3us4a4P0xo/9w=;
	b=YNjI3iRuZGnkcJRRaMBS9ZxtpB2ALnq1LeZFTiHzBrCfEXPD4Zh1KETt9CjYqDDiBrnA0g
	T+5WG/S1U9x8ErgV1suJsAzcaFAHHlP82XorW4DVGBYX7P9LViUQDNleo+CkClW7WFlTWq
	O5glpKn+WW9y9W0ofO9zz8hy7C0x7vM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736752493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulSOiBud7NT55dZGFodvslB3QoYPMq3us4a4P0xo/9w=;
	b=5jlek5/O7OhTnwC5/nUCb1Xs3Hm7G+mNUKkmVbx8QlbVwuZJq3Tvj0JHWKvDvtIgGYS5Pz
	u/eVQOvJfy8+1iCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16DDB13310;
	Mon, 13 Jan 2025 07:14:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vwHxA229hGd3KwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Jan 2025 07:14:53 +0000
Message-ID: <d75ccb2a-17b7-46f1-b370-c97896878b23@suse.de>
Date: Mon, 13 Jan 2025 08:14:52 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] doc: update managed_irq documentation
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
 <20250110-isolcpus-io-queues-v5-9-0e4f118680b0@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250110-isolcpus-io-queues-v5-9-0e4f118680b0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLtwh1cu5tij3fa8finjukruks)];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 1/10/25 17:26, Daniel Wagner wrote:
> The managed_irq documentation is a bit difficult to understand. Rephrase
> the current text and add the latest changes how managed_irq CPU sets are
> handled.
> 
> Isolated CPUs and housekeeping CPUs are grouped into sets and the
> possibility of stalls if all housekeeping CPUs are offlined in a set.
> 
> Signed-off-by: Daniel Wagner <wagi@kernel.org>
> ---
>   Documentation/admin-guide/kernel-parameters.txt | 46 +++++++++++++------------
>   1 file changed, 24 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
