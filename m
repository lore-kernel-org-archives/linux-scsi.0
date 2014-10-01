From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Wed, 1 Oct 2014 14:14:23 -0700
Message-ID: <20141001211423.GD24820@infradead.org>
References: <541C27BF.6070609@acm.org>
 <541C28E0.7010705@acm.org>
 <CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>
 <541C49EC.6030404@acm.org>
 <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
 <541C4D2F.9060907@acm.org>
 <541C4DF1.4090604@kernel.dk>
 <542C270B.5020002@acm.org>
 <542C31C4.1020702@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaJAVO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 17:14:26 -0400
Content-Disposition: inline
In-Reply-To: <542C31C4.1020702@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <Elliott@hp.com>

On Wed, Oct 01, 2014 at 10:54:28AM -0600, Jens Axboe wrote:
> Lets get rid of the blk_mq_tag struct and just have it be an u32 or
> something. We could potentially typedef it, but I'd prefer to just have it
> be an unsigned 32-bit int.

Agreed.
