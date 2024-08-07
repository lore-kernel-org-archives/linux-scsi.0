Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E8C1E6748;
	Wed,  7 Aug 2024 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723035002; cv=none; b=c7QlYoqTad6zgotN48b2un0cWNbHrSpLB/eYNEONiSNP1AWXTEiJq7HYNeHWxk+OH1y/GivCjNWAjbuswk8AikhIV1Tek7q0V3026nUnCcfuYf2DTAyfTdcxYC6F2g0i56b3Xvf/h/jmRigUl0kAPzr3OIIBxGLB1jiHc8Yqvqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723035002; c=relaxed/simple;
	bh=TmRBTZawowUbCmLEiK4lPCX13rGRnyKjFv7HXndQl00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KoZRPuLbrYVOY5ABRODgjryxutymeb1aB8jhyV4KhxuODV6cdgaTLX/YVvC0NnMmuc5ZAP1sMzUCd26X5j/G6dQhghXjIczeH3wcg0L7IosWwDUFODq1EFsmVE8U0qotC+FfANYvQby5Z0HezaJATBtXbPVAwsxO2zCW77ng31o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xXFyDK4f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qX5SzNUJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xXFyDK4f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qX5SzNUJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xXFyDK4f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qX5SzNUJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xXFyDK4f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qX5SzNUJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D71AF21A4D;
	Wed,  7 Aug 2024 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723034998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgSgRKbajCjZ0BozhcNSEcCwMqodRgUv22hvhr2PfDE=;
	b=xXFyDK4fRusQ+KLvxjr2WhuadFvP2nIrlfDrNHwMciaCiZvF0iVCXE5H097uiLhZqVo4V2
	GhrCRkrGhZ1skP5Pc90tgjo9I8I59em/4F+FZsmIarvjy9hQtA0J1DHxRedqPIomrfNN/f
	2aK8LQ1V7S19duRmWF57TfiLl95RY/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723034998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgSgRKbajCjZ0BozhcNSEcCwMqodRgUv22hvhr2PfDE=;
	b=qX5SzNUJ7nZ/6SSmTX0jHCnKrBEkKo+awdWpPoAQw8tXA8PUwDoEwDId7xmkcLqAapowPA
	9VOD93t/iInKK0AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723034998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgSgRKbajCjZ0BozhcNSEcCwMqodRgUv22hvhr2PfDE=;
	b=xXFyDK4fRusQ+KLvxjr2WhuadFvP2nIrlfDrNHwMciaCiZvF0iVCXE5H097uiLhZqVo4V2
	GhrCRkrGhZ1skP5Pc90tgjo9I8I59em/4F+FZsmIarvjy9hQtA0J1DHxRedqPIomrfNN/f
	2aK8LQ1V7S19duRmWF57TfiLl95RY/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723034998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LgSgRKbajCjZ0BozhcNSEcCwMqodRgUv22hvhr2PfDE=;
	b=qX5SzNUJ7nZ/6SSmTX0jHCnKrBEkKo+awdWpPoAQw8tXA8PUwDoEwDId7xmkcLqAapowPA
	9VOD93t/iInKK0AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE04F13297;
	Wed,  7 Aug 2024 12:49:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H8RhLnZts2bKSAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Wed, 07 Aug 2024 12:49:58 +0000
Date: Wed, 7 Aug 2024 14:49:58 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Thomas Gleixner <tglx@linutronix.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
	Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <frederic@kernel.org>, 
	Mel Gorman <mgorman@suse.de>, Hannes Reinecke <hare@suse.de>, 
	Sridhar Balaraman <sbalaraman@parallelwireless.com>, "brookxu.cn" <brookxu.cn@gmail.com>, 
	Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, virtualization@lists.linux.dev, 
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 03/15] blk-mq: introduce blk_mq_dev_map_queues
Message-ID: <8468546d-adae-4477-9306-ca08f32b19ca@flourine.local>
References: <20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de>
 <20240806-isolcpus-io-queues-v3-3-da0eecfeaf8b@suse.de>
 <20240806132645.GC13883@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806132645.GC13883@lst.de>
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.990];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,grimberg.me,linutronix.de,oracle.com,redhat.com,broadcom.com,marvell.com,lwn.net,suse.de,parallelwireless.com,gmail.com,vger.kernel.org,lists.infradead.org,lists.linux.dev,microchip.com];
	R_RATELIMIT(0.00)[to_ip_from(RLqmh8xjmb7g5apbd4gmjneg9b)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, Aug 06, 2024 at 03:26:45PM GMT, Christoph Hellwig wrote:
> > +
> > +/**
> > + * blk_mq_virtio_get_queue_affinity - get affinity mask queue mapping for virtio device
> 
> Please avoid the overly long line here.

I thought for some reason the brief description needs to be on one
line. It can be multiple lines:

https://www.kernel.org/doc/html/v6.10/doc-guide/kernel-doc.html#structure-union-and-enumeration-documentation
