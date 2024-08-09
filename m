Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F63172BD6;
	Fri,  9 Aug 2024 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723188137; cv=none; b=NroOYfvdsipkMp0bYdD7zD4n0BVA9xvBher0btMdPNbsaKdq3MKkgkadh5N/91D1z9W7FaUZn/2A+OBrUgCYpK/atRkY8TUJhCK1s43k28XisWQLQcEcipXlmuN3lbfYi5ZB4CxNm7yPczsi7Z56K2dzG/gHc2AH80pwlw5iuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723188137; c=relaxed/simple;
	bh=gYlIP+lBGZf9p56OPaappGgP1Xv0GKlrY9dqQFRES04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXrRuDXLT+iG46WO8YmVZhduuCUx6O9EiRZ05ej6cSjSFRTij0e7yKEv3IA70Cqo6KaIxWtCZTj3abPfUUiIM2LXHtEXLd2K+hLExZauL2RXr4FB67oavKslO5he6RFct4S+xDb2wtoeHkbYZ2ohqy9NQDRuIDNe2tQmeL8iRHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qRBJYlZP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NTTbxdNS; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qRBJYlZP; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NTTbxdNS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qRBJYlZP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NTTbxdNS";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qRBJYlZP";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NTTbxdNS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9170B21EB4;
	Fri,  9 Aug 2024 07:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723188132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ahmUJlG6cvn11dfUj1+gsMh+RJ6l5CH2DKkmdQtjC1M=;
	b=qRBJYlZP10SZWLOuW224PwXJnb9NdkAwHqyzI4zJIbxa7x82Kn5LIRVQo6gYVBZJq/fRhb
	jWCfop6Rgz7eKAjnPVkWyPujE5f1ZWPn/Td/6U1/1QIQrXNw7NV1SxMc0TZBIg/oh8VFE+
	GigUI+02Aw/lncykX5e1s4atPk9xdak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723188132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ahmUJlG6cvn11dfUj1+gsMh+RJ6l5CH2DKkmdQtjC1M=;
	b=NTTbxdNSv22I/uNcvvM5kXc2YMty5QSKzyvVojSy9LCXC0bfiOUc+vbfTpPux/FGx2cW/V
	7qqDBipp3r8IDEAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723188132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ahmUJlG6cvn11dfUj1+gsMh+RJ6l5CH2DKkmdQtjC1M=;
	b=qRBJYlZP10SZWLOuW224PwXJnb9NdkAwHqyzI4zJIbxa7x82Kn5LIRVQo6gYVBZJq/fRhb
	jWCfop6Rgz7eKAjnPVkWyPujE5f1ZWPn/Td/6U1/1QIQrXNw7NV1SxMc0TZBIg/oh8VFE+
	GigUI+02Aw/lncykX5e1s4atPk9xdak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723188132;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ahmUJlG6cvn11dfUj1+gsMh+RJ6l5CH2DKkmdQtjC1M=;
	b=NTTbxdNSv22I/uNcvvM5kXc2YMty5QSKzyvVojSy9LCXC0bfiOUc+vbfTpPux/FGx2cW/V
	7qqDBipp3r8IDEAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77DA513A7D;
	Fri,  9 Aug 2024 07:22:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5Yc7HaTDtWbgEAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Fri, 09 Aug 2024 07:22:12 +0000
Date: Fri, 9 Aug 2024 09:22:11 +0200
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
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 15/15] blk-mq: use hk cpus only when isolcpus=io_queue
 is enabled
Message-ID: <856091db-431f-48f5-9daa-38c292a6bbd2@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-15-da0eecfeaf8b@suse.de>
 <ZrI5TcaAU82avPZn@fedora>
 <253ec223-98e1-4e7e-b138-0a83ea1a7b0e@flourine.local>
 <ZrRXEUko5EwKJaaP@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrRXEUko5EwKJaaP@fedora>
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,lst.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, Aug 08, 2024 at 01:26:41PM GMT, Ming Lei wrote:
> Isolated CPUs are removed from queue mapping in this patchset, when someone
> submit IOs from the isolated CPU, what is the correct hctx used for handling
> these IOs?

No, every possible CPU gets a mapping. What this patch series does, is
to limit/aligns the number of hardware context to the number of
housekeeping CPUs. There is still a complete ctx-hctc mapping. So
whenever an user thread on an isolated CPU is issuing an IO a
housekeeping CPU will also be involved (with the additional overhead,
which seems to be okay for these users).

Without hardware queue on the isolated CPUs ensures we really never get
any unexpected IO on those CPUs unless userspace does it own its own.
It's a safety net.

Just to illustrate it, the non isolcpus configuration (default) map
for an 8 CPU setup:

queue mapping for /dev/vda
        hctx0: default 0
        hctx1: default 1
        hctx2: default 2
        hctx3: default 3
        hctx4: default 4
        hctx5: default 5
        hctx6: default 6
        hctx7: default 7

and with isolcpus=io_queue,2-3,6-7

queue mapping for /dev/vda
        hctx0: default 0 2
        hctx1: default 1 3
        hctx2: default 4 6
        hctx3: default 5 7

> From current implementation, it depends on implied zero filled
> tag_set->map[type].mq_map[isolated_cpu], so hctx 0 is used.
> 
> During CPU offline, in blk_mq_hctx_notify_offline(),
> blk_mq_hctx_has_online_cpu() returns true even though the last cpu in
> hctx 0 is offline because isolated cpus join hctx 0 unexpectedly, so IOs in
> hctx 0 won't be drained.
> 
> However managed irq core code still shutdowns the hw queue's irq because all
> CPUs in this hctx are offline now. Then IO hang is triggered, isn't
> it?

Thanks for the explanation. I was able to reproduce this scenario, that
is a hardware context with two CPUs which go offline. Initially, I used
fio for creating the workload but this never hit the hanger. Instead
some background workload from systemd-journald is pretty reliable to
trigger the hanger you describe.

Example:

  hctx2: default 4 6

CPU 0 stays online, CPU 1-5 are offline. CPU 6 is offlined:

  smpboot: CPU 5 is now offline
  blk_mq_hctx_has_online_cpu:3537 hctx3 offline
  blk_mq_hctx_has_online_cpu:3537 hctx2 offline

and there is no forward progress anymore, the cpuhotplug state machine
is blocked and an IO is hanging:

  # grep busy /sys/kernel/debug/block/*/hctx*/tags | grep -v busy=0
  /sys/kernel/debug/block/vda/hctx2/tags:busy=61

and blk_mq_hctx_notify_offline busy loops forever:

   task:cpuhp/6         state:D stack:0     pid:439   tgid:439   ppid:2      flags:0x00004000
   Call Trace:
    <TASK>
    __schedule+0x79d/0x15c0
    ? lockdep_hardirqs_on_prepare+0x152/0x210
    ? kvm_sched_clock_read+0xd/0x20
    ? local_clock_noinstr+0x28/0xb0
    ? local_clock+0x11/0x30
    ? lock_release+0x122/0x4a0
    schedule+0x3d/0xb0
    schedule_timeout+0x88/0xf0
    ? __pfx_process_timeout+0x10/0x10d
    msleep+0x28/0x40
    blk_mq_hctx_notify_offline+0x1b5/0x200
    ? cpuhp_thread_fun+0x41/0x1f0
    cpuhp_invoke_callback+0x27e/0x780
    ? __pfx_blk_mq_hctx_notify_offline+0x10/0x10
    ? cpuhp_thread_fun+0x42/0x1f0
    cpuhp_thread_fun+0x178/0x1f0
    smpboot_thread_fn+0x12e/0x1c0
    ? __pfx_smpboot_thread_fn+0x10/0x10
    kthread+0xe8/0x110
    ? __pfx_kthread+0x10/0x10
    ret_from_fork+0x33/0x40
    ? __pfx_kthread+0x10/0x10
    ret_from_fork_asm+0x1a/0x30
    </TASK>

I don't think this is a new problem this code introduces. This problem
exists for any hardware context which has more than one CPU. As far I
understand it, the problem is that there is no forward progress possible
for the IO itself (I assume the corresponding resources for the CPU
going offline have already been shutdown, thus no progress?) and
blk_mq_hctx_notifiy_offline isn't doing anything in this scenario.

Couldn't we do something like:

+static bool blk_mq_hctx_timeout_rq(struct request *rq, void *data)
+{
+       blk_mq_rq_timed_out(rq);
+       return true;
+}
+
+static void blk_mq_hctx_timeout_rqs(struct blk_mq_hw_ctx *hctx)
+{
+       struct blk_mq_tags *tags = hctx->sched_tags ?
+                       hctx->sched_tags : hctx->tags;
+       blk_mq_all_tag_iter(tags, blk_mq_hctx_timeout_rq, NULL);
+}
+
+
 static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 {
        struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
                        struct blk_mq_hw_ctx, cpuhp_online);
+       int i;

        if (blk_mq_hctx_has_online_cpu(hctx, cpu))
                return 0;
@@ -3551,9 +3589,16 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
         * requests.  If we could not grab a reference the queue has been
         * frozen and there are no requests.
         */
+       i = 0;
        if (percpu_ref_tryget(&hctx->queue->q_usage_counter)) {
-               while (blk_mq_hctx_has_requests(hctx))
+               while (blk_mq_hctx_has_requests(hctx) && i++ < 10)
                        msleep(5);
+               if (blk_mq_hctx_has_requests(hctx)) {
+                       pr_info("%s:%d hctx %d force timeout request\n",
+                               __func__, __LINE__, hctx->queue_num);
+                       blk_mq_hctx_timeout_rqs(hctx);
+               }
+

This guarantees forward progress and it worked in my test scenario, got
the corresponding log entries

  blk_mq_hctx_notify_offline:3598 hctx 2 force timeout request

and the hotplug state machine continued. Didn't see an IO error either,
but I haven't looked closely, this is just a POC.

BTW, when looking at the tag allocator, I didn't see any hctx state
checks for the batched alloction path. Don't we need to check if the
corresponding hardware context is active there too?

@ -486,6 +487,15 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
        if (data->nr_tags > 1) {
                rq = __blk_mq_alloc_requests_batch(data);
                if (rq) {
+                       if (unlikely(test_bit(BLK_MQ_S_INACTIVE,
+                                             &data->hctx->state))) {
+                               blk_mq_put_tag(blk_mq_tags_from_data(data),
+                                              rq->mq_ctx, rq->tag);
+                               msleep(3);
+                               goto retry;
+                       }
                        blk_mq_rq_time_init(rq, alloc_time_ns);
                        return rq;
                }

But given this is the hotpath and the hotplug path is very unlikely to
be used at all, at least for the majority of users, I would suggest to
try to get blk_mq_hctx_notify_offline to guarantee forward progress?.
This would make the hotpath an 'if' less.
