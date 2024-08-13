Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7269313AA2D;
	Tue, 13 Aug 2024 12:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723551484; cv=none; b=niA2ejR9P4k+21eQO64SdO0Ud0hQ8U1fuZR3MY/BTYZlcwkXk4nW61KRBxkcdidn+Es4Rc5y8WAXqo1xpoFFvurpgiomJkYiu08pVejKIeqZlVsQm5jzRxajPfFQnnSSRjzif5mmbQhY0nQfPUD+FRIZ1b0G+f88vcuE3eh1oaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723551484; c=relaxed/simple;
	bh=wsbGbeEJzQPJE2NKVwVa0vtP/1h0qACt3EDL8aIpuOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZQpoDtEo8azv2+TDjDblytYlyN87ZAxl0LRrdk2zEiboUQQ0RxoKOEWeYkAfsZ2M4ZBprZlockOdNcs/QZRzB0JUP4o25dbTu7yC4dOZwg1dweZXKka6uGlx6eCgUmBYKolovmaXXHv2r/yt7SqUwfwmla5e0RT4ORB+VmvI4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SJ/3n9mH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kqGovRh5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SJ/3n9mH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kqGovRh5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SJ/3n9mH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kqGovRh5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SJ/3n9mH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kqGovRh5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8FE5227C6;
	Tue, 13 Aug 2024 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723551480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bUnP8H0MFd0Vy0Rk4/ku8LtrtayAnI+xZK51aPc0WlE=;
	b=SJ/3n9mH5+eZc79ywnDNNBZy712ttAXvGho6oslO4n6FTrjX7P7nnmYQZU/BgB0LFGlTE/
	uDJKlFH3xeCut3aos7ypTf0yT7y7TX8tJA3KmWuXJ/zIPswzhY2uN85GXJJwKw+fbyEBif
	oAciqqjraPVTSsgvvaLfABDScPTjwfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723551480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bUnP8H0MFd0Vy0Rk4/ku8LtrtayAnI+xZK51aPc0WlE=;
	b=kqGovRh5WJwUNyvr3ezligOM7FXcxrJAdr4kWr34BMWV/Pse5p3j71BZYWhTj2luB2dwim
	RKu9mnvL887TnDDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723551480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bUnP8H0MFd0Vy0Rk4/ku8LtrtayAnI+xZK51aPc0WlE=;
	b=SJ/3n9mH5+eZc79ywnDNNBZy712ttAXvGho6oslO4n6FTrjX7P7nnmYQZU/BgB0LFGlTE/
	uDJKlFH3xeCut3aos7ypTf0yT7y7TX8tJA3KmWuXJ/zIPswzhY2uN85GXJJwKw+fbyEBif
	oAciqqjraPVTSsgvvaLfABDScPTjwfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723551480;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bUnP8H0MFd0Vy0Rk4/ku8LtrtayAnI+xZK51aPc0WlE=;
	b=kqGovRh5WJwUNyvr3ezligOM7FXcxrJAdr4kWr34BMWV/Pse5p3j71BZYWhTj2luB2dwim
	RKu9mnvL887TnDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BEF713983;
	Tue, 13 Aug 2024 12:18:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JdrQIfhOu2b1fAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 13 Aug 2024 12:18:00 +0000
Date: Tue, 13 Aug 2024 14:17:59 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
	Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	John Garry <john.g.garry@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth patil <chandrakanth.patil@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Jonathan Corbet <corbet@lwn.net>, 
	Frederic Weisbecker <frederic@kernel.org>, Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Sridhar Balaraman <sbalaraman@parallelwireless.com>, "brookxu.cn" <brookxu.cn@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, virtualization@lists.linux.dev, megaraidlinux.pdl@broadcom.com, 
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <844ee653-241c-42b8-84e0-1065ae715005@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
 <ZrI5TcaAU82avPZn@fedora>
 <253ec223-98e1-4e7e-b138-0a83ea1a7b0e@flourine.local>
 <ZrRXEUko5EwKJaaP@fedora>
 <856091db-431f-48f5-9daa-38c292a6bbd2@flourine.local>
 <ZrYtXDrdPjn48r6k@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrYtXDrdPjn48r6k@fedora>
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
	RCPT_COUNT_TWELVE(0.00)[33];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,lst.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLqmh8xjmb7g5apbd4gmjneg9b)];
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

On Fri, Aug 09, 2024 at 10:53:16PM GMT, Ming Lei wrote:
> On Fri, Aug 09, 2024 at 09:22:11AM +0200, Daniel Wagner wrote:
> > On Thu, Aug 08, 2024 at 01:26:41PM GMT, Ming Lei wrote:
> > > Isolated CPUs are removed from queue mapping in this patchset, when someone
> > > submit IOs from the isolated CPU, what is the correct hctx used for handling
> > > these IOs?
> > 
> > No, every possible CPU gets a mapping. What this patch series does, is
> > to limit/aligns the number of hardware context to the number of
> > housekeeping CPUs. There is still a complete ctx-hctc mapping. So
> 
> OK, then I guess patch 1~7 aren't supposed to belong to this series,
> cause you just want to reduce nr_hw_queues, meantime spread
> house-keeping CPUs first for avoiding queues with all isolated cpu
> mask.

I tried to explain the reason for these patches in the cover letter. The
idea here is that it makes the later changes simpler, because we only
have to touch one place. Furthermore, the caller just needs to provide
an affinity mask the rest of the code then is generic. This allows to
replace the open coded mapping code in hisi for example. Overall I think
the resulting code is nicer and cleaner.

> OK, Looks I missed the point in patch 15 in which you added isolated cpu
> into mapping manually, just wondering why not take the current two-stage
> policy to cover both house-keeping and isolated CPUs in
> group_cpus_evenly()?

Patch #15 explains why this approach didn't work in the current form.
blk_mq_map_queues will map all isolated CPUs to the first hctx.

> Such as spread house-keeping CPUs first, then isolated CPUs, just like
> what we did for present & non-present cpus.

I've experimented with this approach and it didn't work (see above).

> When blk_mq_hctx_notify_offline() is running, the current CPU isn't
> offline yet, and the hctx is active, same with the managed irq, so it is fine
> to wait until all in-flight IOs originated from this hctx completed
> there.

But if the if for some reason these never complete (as in my case),
this blocks forever. Wouldn't it make sense to abort the wait after a
while?

> The reason is why these requests can't be completed? And the forward
> progress is provided by blk-mq. And these requests are very likely
> allocated & submitted from CPU6.

Yes, I can confirm that the in flight request have been allocated and
submitted by the CPU which is offlined.

Here a log snipped from a different debug session. CPU 1 and 2 are
already offline, CPU 3 is offlined. The CPU mapping for hctx1 is

        hctx1: default 1 3

I've added a printk to my hack timeout handler:

 blk_mq_hctx_notify_offline:3600 hctx 1 force timeout request
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3
 blk_mq_hctx_timeout_rq:3556 state 1 rq cpu 3

that means these request have been allocated on CPU 3 and are still
marked as in flight. I am trying to figure out why they are not
completed as next step.

> Can you figure out what is effective mask for irq of hctx2?  It is
> supposed to be cpu6. And block debugfs for vda should provide helpful
> hint.

The effective mask for the above debug output is

queue mapping for /dev/vda
        hctx0: default 0 2
        hctx1: default 1 3
        hctx2: default 4 6
        hctx3: default 5 7

PCI name is 00:02.0: vda
        irq 27 affinity 0-1 effective 0  virtio0-config
        irq 28 affinity 0 effective 0  virtio0-req.0
        irq 29 affinity 1 effective 1  virtio0-req.1
        irq 30 affinity 4 effective 4  virtio0-req.2
        irq 31 affinity 5 effective 5  virtio0-req.3

Maybe there is still something off with qemu and the IRQ routing and the
interrupts have been delivered to the wrong CPU.

> > going offline have already been shutdown, thus no progress?) and
> > blk_mq_hctx_notifiy_offline isn't doing anything in this scenario.
> 
> RH has internal cpu hotplug stress test, but not see such report so
> far.

Is this stress test running on real hardware? If so, it adds to my
theory that the interrupt might be lost in certain situation when
running qemu.

 > Couldn't we do something like:
> 
> I usually won't thinking about any solution until root-cause is figured
> out, :-)

I agree, though sometimes is also is okay to have some defensive
programming in place, such an upper limit when until giving up the wait.

But yeah, let's focus figuring out what's wrong.
