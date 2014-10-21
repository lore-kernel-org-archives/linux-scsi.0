From: Christoph Hellwig <hch@infradead.org>
Subject: Re: EH action after scsi_remove_host, was: Re: [PATCH v2 12/12]
 IB/srp: Add multichannel support
Date: Tue, 21 Oct 2014 01:51:07 -0700
Message-ID: <20141021085107.GE10407@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E585.607@acm.org>
 <20141017110102.GC7819@infradead.org>
 <544513E2.6050406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaJUIvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 04:51:10 -0400
Content-Disposition: inline
In-Reply-To: <544513E2.6050406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Oct 20, 2014 at 03:53:38PM +0200, Bart Van Assche wrote:
> The above assignment statement has been reported to fix a kernel oops that
> could be triggered by cable pulling. Regarding fixing the root cause: some
> time ago I had posted a patch series that makes scsi_remove_host() wait
> until all error handler callback functions have finished and also that
> prevents that any new error handler function calls are initiated after
> scsi_remove_host() has finished
> (http://thread.gmane.org/gmane.linux.scsi/82572/focus=87985). Should I
> repost that patch series ?

Please keep the workaround in srp for now, and then resend the series,
including a new patch to remove the workaround in srp.

