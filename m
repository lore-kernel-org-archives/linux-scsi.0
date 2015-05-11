From: Christoph Hellwig <hch@infradead.org>
Subject: Re: hosts resets in SRP and the rest of the world, was: Re: [PATCH
 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Mon, 11 May 2015 04:47:18 -0700
Message-ID: <20150511114718.GA32341@infradead.org>
References: <20150430093719.GA23486@infradead.org>
 <5542034D.5010300@sandisk.com>
 <554204D7.9050204@dev.mellanox.co.il>
 <55420AEA.10108@sandisk.com>
 <20150430172516.GA19200@infradead.org>
 <5549E600.9050208@sandisk.com>
 <20150511075058.GA18483@infradead.org>
 <55506E46.2060103@sandisk.com>
 <20150511093130.GA30217@infradead.org>
 <55507D63.6010007@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbbEKLr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 07:47:27 -0400
Content-Disposition: inline
In-Reply-To: <55507D63.6010007@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Mon, May 11, 2015 at 11:58:59AM +0200, Bart Van Assche wrote:
> Your proposal absolutely makes sense to me but unfortunately I do not have
> the time available now to implement it. Would it be acceptable if I rework
> scsi_wait_for_queuecommand() such that per-CPU counters are introduced in
> blk-mq instead of one counter per hctx ?

If we can't fix this for real I'd prefer to do nothing, or at least
almost nothing for now, e.g. keep your original patch and ignore the
blk-mq case for now.
