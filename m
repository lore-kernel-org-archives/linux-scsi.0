Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE5D1E47A4;
	Tue,  7 Jan 2025 10:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736246121; cv=none; b=qHuK7kwSj6w6LeiF2SGurlrnsLdYb7l634qqzrL2cf7CgQUbs7oG1P1vC2Dx0U0kUiVfSjBUXoAdE6R6Wq9kjkW58Dj5iZnhLAxsrJ7vrQn05NXrxHzkB1pbrupiQpyof7MfWcB+WUQa9zSjwIKLPw/WRj/opdnJceapv/zHMEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736246121; c=relaxed/simple;
	bh=7iq3Nq+KFFUgY6Oi/YzRCcTj+ChTG44ZPyAw0Y9Gm9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmy6e3cInKsFkJ0WDLFqI3dlIZZxrWJrDdG7j6X03y8md/jZQsBq65qAXBeDkcEA2I+3n0I7CuzkxKQzvff9WtkfvpBypBdyFZh9ovAJP1j4BIbK8Ge9y2i1P4/GNtPJ29LPsOe3N1uVEtbZWcq49gYTySeBjx3vD8I03No5fA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X7BBCGx3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5ndY/IYG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ka25hQY7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=soERdOG5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X7BBCGx3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5ndY/IYG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ka25hQY7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="soERdOG5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E907221109;
	Tue,  7 Jan 2025 10:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736246115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4ihRWi9dWWRNYoaRnE7jai/GZiNOG/j5hceB4sXBqw=;
	b=X7BBCGx3YSe1RFTqGqCz46xofKW4uN+D6It39NQUhCysxo/h9fBkEsfWj8yQGNnc/m4APs
	RSzVGJlmcj5mdGuxt5h6va/+ey48v7hu3A0nAGRLY5qB0xNDwOBqnLEjOgWERk6KMeALia
	PSxgCvGX8YtBcwIvCnQ+O2lExhjO3rs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736246115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4ihRWi9dWWRNYoaRnE7jai/GZiNOG/j5hceB4sXBqw=;
	b=5ndY/IYGpSzkHG8+jBqO5tPbNkDzDxyclH7J61dN9NROzVaEkDCxNkAmWRT8TS5LFfDF5e
	gd/3sSqXVMiPlqBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736246114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4ihRWi9dWWRNYoaRnE7jai/GZiNOG/j5hceB4sXBqw=;
	b=ka25hQY7n5ZP7m0XSSvseP5NZCQoFzQbF3EiLogU8vkwdOBj+mTRq5rjlH4U150Ds5Yw/J
	Srk68FKvDOkFc2dRyVp0PIdog7uVZZ9HKv70hA80j8CGs8RHiFKslGKB3ozGeJwup2vG2H
	zFLe3OnS5Q+4B2MPjmbig9m8XyRH9V4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736246114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4ihRWi9dWWRNYoaRnE7jai/GZiNOG/j5hceB4sXBqw=;
	b=soERdOG5ZAQXM45kqUF6T3R4y7BTZt9+xhyQpTveYXAmjlqiI6fLCgklLSQL7rh3+januN
	eS3IvXfhV5qmQvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF5D813763;
	Tue,  7 Jan 2025 10:35:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /h2uJ18DfWdYaAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 07 Jan 2025 10:35:11 +0000
Message-ID: <5eaeec6d-48fd-4fb7-90ac-70f596572644@suse.de>
Date: Tue, 7 Jan 2025 11:35:10 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] lib/group_cpus: let group_cpu_evenly return number
 of groups
To: Daniel Wagner <dwagner@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Kashyap Desai
 <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 Don Brace <don.brace@microchip.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Costa Shulyupin
 <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>,
 Ming Lei <ming.lei@redhat.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Frederic Weisbecker <frederic@kernel.org>,
 Mel Gorman <mgorman@suse.de>,
 Sridhar Balaraman <sbalaraman@parallelwireless.com>,
 "brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, virtualization@lists.linux.dev
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-1-5d355fbb1e14@kernel.org>
 <1a2fe8aa-d3e1-4e36-8cd5-27141c1d7178@suse.de>
 <1d7b96ca-a015-4730-9035-abb69cd6cda4@flourine.local>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <1d7b96ca-a015-4730-9035-abb69cd6cda4@flourine.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[39];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,oracle.com,marvell.com,microchip.com,redhat.com,linux.alibaba.com,linux-foundation.org,linutronix.de,suse.com,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev];
	R_RATELIMIT(0.00)[to_ip_from(RLwoqrtcdrtewo8fubna94zinu)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 1/7/25 09:20, Daniel Wagner wrote:
> On Tue, Jan 07, 2025 at 08:51:57AM +0100, Hannes Reinecke wrote:
>>>    void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
>>>    {
>>>    	const struct cpumask *masks;
>>> -	unsigned int queue, cpu;
>>> +	unsigned int queue, cpu, nr_masks;
>>> -	masks = group_cpus_evenly(qmap->nr_queues);
>>> +	nr_masks = qmap->nr_queues;
>>> +	masks = group_cpus_evenly(&nr_masks);
>>
>> Hmph. I am a big fan of separating input and output paramenters;
>> most ABI definitions will be doing that anyway.
>> Makes it also really hard to track whether the output parameters
>> had been set at all. Care to split it up?
> 
> What API do you have in mind?

ABI, not API.
x86 ABI has 'rdi' as the first input register, and 'rax' as the first 
output register. So there is no difference for the compiler whether
you have 'x(&a); b = a;' or 'x(a, &b)'.
But you gain on usability, as in the second case you can check whether
'b' had been set by the function.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
