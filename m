From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Tue, 21 Oct 2014 01:49:39 -0700
Message-ID: <20141021084939.GB10407@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E585.607@acm.org>
 <20141017110627.GD7819@infradead.org>
 <5444F8A1.4060701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaJUItn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 04:49:43 -0400
Content-Disposition: inline
In-Reply-To: <5444F8A1.4060701@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On Mon, Oct 20, 2014 at 01:57:21PM +0200, Bart Van Assche wrote:
> That pr_err() statement was convenient while debugging the multiqueue code
> in the SRP initiator driver but can be left out. Would you agree with
> leaving the above three lines of debug code out instead of adding an
> additional argument to scsi_host_find_tag() ?

Feel free to remove the check.

