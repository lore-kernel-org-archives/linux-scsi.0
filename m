From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 07/12] IB/srp: Avoid that I/O hangs due to a cable
 pull during LUN scanning
Date: Tue, 21 Oct 2014 01:50:33 -0700
Message-ID: <20141021085033.GD10407@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E504.1070306@acm.org>
 <5443E66F.7050901@dev.mellanox.co.il>
 <5444FCCB.2030503@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50294 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaJUIui (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 04:50:38 -0400
Content-Disposition: inline
In-Reply-To: <5444FCCB.2030503@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On Mon, Oct 20, 2014 at 02:15:07PM +0200, Bart Van Assche wrote:
> How about renaming this function into shost_sdev_count() and moving its
> declaration to <scsi/scsi_device.h> and its implementation to
> drivers/scsi/scsi_lib.c ?

I'd prefer to defer this until we have an actual need for it elsewhere.

