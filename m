From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Tue, 19 Dec 2006 15:09:24 +0100
Message-ID: <20061219140924.GS5010@kernel.dk>
References: <20061216001753F.fujita.tomonori@lab.ntt.co.jp> <20061215185704.GZ5010@kernel.dk> <200612191355.kBJDtIWk000664@r-dd.iij4u.or.jp> <20061219140258.GR5010@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:1787 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbWLSOHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 09:07:41 -0500
Content-Disposition: inline
In-Reply-To: <20061219140258.GR5010@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Tue, Dec 19 2006, Jens Axboe wrote:
> > Thanks. The patchset is on the top of the two minor patches:
> > 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265732083&w=2
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265731963&w=2
> > 
> > The latter needs small modifications if you will change
> > blk_rq_unmap_user interface.
> 
> I'll rebase the bsg tree as soon as Linus pulls the for-linus branch,
> which has a number of SG_IO related changes and fixes. Ah I'll just
> rebase bsg now and send you a note, then please resend the pending
> patches against that and I'll include it.

bsg branch rebased, please send the patch against the current one. HEAD
of tree is fc68dbc4630ffef6dce5198fd90bdec37a9bbf44.

-- 
Jens Axboe

