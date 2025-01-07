Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE92918A6DE;
	Tue,  7 Jan 2025 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736246766; cv=none; b=dALP1HzuWfnm7Y+x5zZLc4MHjEOyx4AmkGwAss927Wjy/dwd/klYVPdPY09jr5YntayBFZgWzR7Sxr44pYkDvKR4aUnE/hgnJ5hBMYnEVCzmOmkGpAgDpYdIknp/jJ6zWD44wB1BzZhj13dxr9GjkUfv7NvEWfRBOf3/AFE5f4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736246766; c=relaxed/simple;
	bh=H0rWVBZ4nUu7/AMgOIuJbPm5FmTH5mc0QPSu8n+CDyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmA5O5S1GjT0ZHJYuoR8xaM1JxcGaXx9ng7n+ykZUjR41Qi7m6mz312JA9nx4d8TXZYK6hb52UT4fGAnDAuWZh3irRxYSVW/9MF4wTCVV4TS0OkyO4Y0dVncXk3GDUkTfNO3M1yMvzJZvSR7nOMegluLI5Ibh9YrIRvJS5weVjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZlqFg/JS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5tBsemY9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZlqFg/JS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5tBsemY9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZlqFg/JS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5tBsemY9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZlqFg/JS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5tBsemY9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D38B01F450;
	Tue,  7 Jan 2025 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736246762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKByFhURU9niNfsL5nKGeNpKM24LoYL3iYcagK9ogBI=;
	b=ZlqFg/JSxa/GIUYjVSqY4e6RDL6AcUsKjXeYDGKb3aVU1+8UTKbGLbt1SVPYy7U1NGVMHY
	bGYkPx34NKuG0Jqov5ZuVbxx+i3tufk4gAfU7E2PvuNNcr9dnDJERZARJiTHnUDUCJLAvj
	zCUMFz4jJntCvzdVhb+/PaVEklWglv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736246762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKByFhURU9niNfsL5nKGeNpKM24LoYL3iYcagK9ogBI=;
	b=5tBsemY9Jq9qPS1dqdGv60k27MgkpZ3PVuFRRkvRLGFwZAr0W+hfU4MXAe+IdDFyogMGT6
	1vypa9UKlMQsWxAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736246762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKByFhURU9niNfsL5nKGeNpKM24LoYL3iYcagK9ogBI=;
	b=ZlqFg/JSxa/GIUYjVSqY4e6RDL6AcUsKjXeYDGKb3aVU1+8UTKbGLbt1SVPYy7U1NGVMHY
	bGYkPx34NKuG0Jqov5ZuVbxx+i3tufk4gAfU7E2PvuNNcr9dnDJERZARJiTHnUDUCJLAvj
	zCUMFz4jJntCvzdVhb+/PaVEklWglv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736246762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nKByFhURU9niNfsL5nKGeNpKM24LoYL3iYcagK9ogBI=;
	b=5tBsemY9Jq9qPS1dqdGv60k27MgkpZ3PVuFRRkvRLGFwZAr0W+hfU4MXAe+IdDFyogMGT6
	1vypa9UKlMQsWxAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0AEA13763;
	Tue,  7 Jan 2025 10:46:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dZYFL+oFfWf9awAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 07 Jan 2025 10:46:02 +0000
Date: Tue, 7 Jan 2025 11:46:02 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <wagi@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Don Brace <don.brace@microchip.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Costa Shulyupin <costa.shul@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Sridhar Balaraman <sbalaraman@parallelwireless.com>, 
	"brookxu.cn" <brookxu.cn@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	storagedev@microchip.com, virtualization@lists.linux.dev
Subject: Re: [PATCH v4 1/9] lib/group_cpus: let group_cpu_evenly return
 number of groups
Message-ID: <63489abb-0cdd-4963-8618-a6ce17432732@flourine.local>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-1-5d355fbb1e14@kernel.org>
 <1a2fe8aa-d3e1-4e36-8cd5-27141c1d7178@suse.de>
 <1d7b96ca-a015-4730-9035-abb69cd6cda4@flourine.local>
 <5eaeec6d-48fd-4fb7-90ac-70f596572644@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eaeec6d-48fd-4fb7-90ac-70f596572644@suse.de>
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[39];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,oracle.com,marvell.com,microchip.com,redhat.com,linux.alibaba.com,linux-foundation.org,linutronix.de,suse.com,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	R_RATELIMIT(0.00)[to_ip_from(RLtq7xx1p6rx585ucya5i3u39z)]
X-Spam-Score: -6.80
X-Spam-Flag: NO

On Tue, Jan 07, 2025 at 11:35:10AM +0100, Hannes Reinecke wrote:
> On 1/7/25 09:20, Daniel Wagner wrote:
> > On Tue, Jan 07, 2025 at 08:51:57AM +0100, Hannes Reinecke wrote:
> > > >    void blk_mq_map_queues(struct blk_mq_queue_map *qmap)
> > > >    {
> > > >    	const struct cpumask *masks;
> > > > -	unsigned int queue, cpu;
> > > > +	unsigned int queue, cpu, nr_masks;
> > > > -	masks = group_cpus_evenly(qmap->nr_queues);
> > > > +	nr_masks = qmap->nr_queues;
> > > > +	masks = group_cpus_evenly(&nr_masks);
> > > 
> > > Hmph. I am a big fan of separating input and output paramenters;
> > > most ABI definitions will be doing that anyway.
> > > Makes it also really hard to track whether the output parameters
> > > had been set at all. Care to split it up?
> > 
> > What API do you have in mind?
> 
> ABI, not API.

I got that, still what C API do you want to see?
