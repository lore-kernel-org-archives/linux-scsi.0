Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835BA20B7F4;
	Fri, 10 Jan 2025 09:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500913; cv=none; b=XUew0rIzaDL4IrwrKNfhrPhjsQ/aq0j7RDloYBxbC9AR2VBLZGg/Nj4Nx7DQEkYKgzrra94RFfVd1spCWzc/MRTlzjX4ygf4bM5709fdhQm55WGK0tJqqdgwmVoemKwk9AGAC8M89suizUaDp0t7CIiR1zQ4nr8FrYTPo4sHPrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500913; c=relaxed/simple;
	bh=JPFn7TpJptfEglULM9N+4ezAx2VVTnRpHNdjHv6+cWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6lNA5J3Y4vUHY0dYPz2jxUfBcocp2lv66AbE9eFUYDcnsBM2bBCtgW83mOYSCuIMP0h0rihqcw21riE+utDF9p8XW4FnM/hwL1V4kBcW+6/D3xfgdinMvNvHEec0yD28epHwlNddzhAYe0kDAtFll7GVu6WktG1E3dUsR+9LYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VggD9E13; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=l5r1KcXL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VggD9E13; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=l5r1KcXL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VggD9E13";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="l5r1KcXL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VggD9E13";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="l5r1KcXL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D4A421137;
	Fri, 10 Jan 2025 09:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736500909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5K5tRuf9RAXyTMoNI3bIMwCXOB93swtFl5w0aetpzz4=;
	b=VggD9E131ngIixhrfT/RlutwzoWzOw2j7y1EcB/S/80M+0q77ykQTRRDVCT4X8TSteJrX+
	V9iXI+sfAK338e6EZmXI1PimDlvVcBlqS+pimhRSFSD0KwBC3EiEvp1Ww/a+VBJkxCvkjt
	+uYQH6q/P3gytibK0E6MjK/V2SUGXNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736500909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5K5tRuf9RAXyTMoNI3bIMwCXOB93swtFl5w0aetpzz4=;
	b=l5r1KcXL8dDVVpqBGbbkpennMgaXNaAVW+B60EdIMryESE92hDmk2b6AyiqCW+Jt4sGHWf
	1OFCLYlv/L5VDMBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1736500909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5K5tRuf9RAXyTMoNI3bIMwCXOB93swtFl5w0aetpzz4=;
	b=VggD9E131ngIixhrfT/RlutwzoWzOw2j7y1EcB/S/80M+0q77ykQTRRDVCT4X8TSteJrX+
	V9iXI+sfAK338e6EZmXI1PimDlvVcBlqS+pimhRSFSD0KwBC3EiEvp1Ww/a+VBJkxCvkjt
	+uYQH6q/P3gytibK0E6MjK/V2SUGXNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1736500909;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5K5tRuf9RAXyTMoNI3bIMwCXOB93swtFl5w0aetpzz4=;
	b=l5r1KcXL8dDVVpqBGbbkpennMgaXNaAVW+B60EdIMryESE92hDmk2b6AyiqCW+Jt4sGHWf
	1OFCLYlv/L5VDMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7930613763;
	Fri, 10 Jan 2025 09:21:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l8OMHa3mgGecDwAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 10 Jan 2025 09:21:49 +0000
Date: Fri, 10 Jan 2025 10:21:49 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Ming Lei <ming.lei@redhat.com>
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
	Valentin Schneider <vschneid@redhat.com>, Waiman Long <llong@redhat.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Sridhar Balaraman <sbalaraman@parallelwireless.com>, "brookxu.cn" <brookxu.cn@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, storagedev@microchip.com, 
	virtualization@lists.linux.dev
Subject: Re: [PATCH v4 8/9] blk-mq: use hk cpus only when
 isolcpus=managed_irq is enabled
Message-ID: <ae9abe4c-010a-41ff-be44-1d52a331eb11@flourine.local>
References: <20241217-isolcpus-io-queues-v4-0-5d355fbb1e14@kernel.org>
 <20241217-isolcpus-io-queues-v4-8-5d355fbb1e14@kernel.org>
 <Z2PlbL0XYTQ_LxTw@fedora>
 <cc5e44dd-e1dc-4f24-88d9-ce45a8b0794f@flourine.local>
 <Z2UwvQoDM3f4zAxG@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2UwvQoDM3f4zAxG@fedora>
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[39];
	FREEMAIL_CC(0.00)[kernel.org,kernel.dk,lst.de,grimberg.me,broadcom.com,oracle.com,marvell.com,microchip.com,redhat.com,linux.alibaba.com,linux-foundation.org,linutronix.de,suse.com,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLtq7xx1p6rx585ucya5i3u39z)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

Hi Ming,

On Fri, Dec 20, 2024 at 04:54:21PM +0800, Ming Lei wrote:
> On Thu, Dec 19, 2024 at 04:38:43PM +0100, Daniel Wagner wrote:
> 
> > When isolcpus=managed_irq is enabled all hardware queues should run on
> > the housekeeping CPUs only. Thus ignore the affinity mask provided by
> > the driver.
> 
> Compared with in-tree code, the above words are misleading.
> 
> - irq core code respects isolated CPUs by trying to exclude isolated
> CPUs from effective masks
> 
> - blk-mq won't schedule blockd on isolated CPUs

I see your point, the commit should highlight the fact when an
application is issuing an I/O, this can lead to stalls.

What about a commit message like:

  When isolcpus=managed_irq is enabled, and the last housekeeping CPU for
  a given hardware context goes offline, there is no CPU left which
  handles the IOs anymore. If isolated CPUs mapped to this hardware
  context are online and an application running on these isolated CPUs
  issue an IO this will lead to stalls.

  The kernel will not schedule IO to isolated CPUS thus this avoids IO
  stalls.

  Thus issue a warning when housekeeping CPUs are offlined for a hardware
  context while there are still isolated CPUs online.

> If application aren't run on isolated CPUs, IO interrupt usually won't
> be triggered on isolated CPUs, so isolated CPUs are _not_ ignored.

FWIW, the 'usually' part is what made our customers nervous. They saw
some IRQ noise on the isolated CPUs with their workload and reported
with these changes all was good. Unfortunately, we never got the hands
on the workload, hard to say what was causing it.

> > On Thu, Dec 19, 2024 at 05:20:44PM +0800, Ming Lei wrote:
> > > > +	cpumask_andnot(isol_mask,
> > > > +		       cpu_possible_mask,
> > > > +		       housekeeping_cpumask(HK_TYPE_MANAGED_IRQ));
> > > > +
> > > > +	for_each_cpu(cpu, isol_mask) {
> > > > +		qmap->mq_map[cpu] = qmap->queue_offset + queue;
> > > > +		queue = (queue + 1) % qmap->nr_queues;
> > > > +	}
> > > 
> > > Looks the IO hang issue in V3 isn't addressed yet, is it?
> > > 
> > > https://lore.kernel.org/linux-block/ZrtX4pzqwVUEgIPS@fedora/
> > 
> > I've added an explanation in the cover letter why this is not
> > addressed. From the cover letter:
> > 
> > I've experimented for a while and all solutions I came up were horrible
> > hacks (the hotpath needs to be touched) and I don't want to slow down all
> > other users (which are almost everyone). IMO, it's just not worth trying
> 
> IMO, this patchset is one improvement on existed best-effort approach, which
> works fine most of times, so why you do think it slows down everyone?

I was talking about implementing the feature which would remap the
isolated CPUs to online hardware context when the current hardware
context goes offline. I didn't find a solution which I think would be
worth presenting. All involved some sort of locking/refcounting in the
hotpath, which I think we should just avoid.

> > to fix this corner case. If the user is using isolcpus and does CPU
> > hotplug, we can expect that the user can also first offline the isolated
> > CPUs. I've discussed this topic during ALPSS and the room came to the
> > same conclusion. Thus I just added a patch which issues a warning that
> > IOs are likely to hang.
> 
> If the change need userspace cooperation for using 'managed_irq', the exact
> behavior need to be documented in both this commit and Documentation/admin-guide/kernel-parameters.txt,
> instead of cover-letter only.
> 
> But this patch does cause regression for old applications which can't
> follow the new introduced rule:
> 
> 	```
> 	If the user is using isolcpus and does CPU hotplug, we can expect that the
> 	user can also first offline the isolated CPUs.
> 	```

Indeed, I forgot to update the documentation. I'll update it accordingly.

Thanks,
Daniel
