From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Tue, 19 Dec 2006 23:25:48 +0900
Message-ID: <20061219232548Q.fujita.tomonori@lab.ntt.co.jp>
References: <200612191355.kBJDtIWk000664@r-dd.iij4u.or.jp>
	<20061219140258.GR5010@kernel.dk>
	<20061219140924.GS5010@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:50921 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbWLSOZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2006 09:25:45 -0500
In-Reply-To: <20061219140924.GS5010@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, dougg@torque.net

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] SG v4 support
Date: Tue, 19 Dec 2006 15:09:24 +0100

> On Tue, Dec 19 2006, Jens Axboe wrote:
> > > Thanks. The patchset is on the top of the two minor patches:
> > > 
> > > http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265732083&w=2
> > > http://marc.theaimsgroup.com/?l=linux-scsi&m=116621265731963&w=2
> > > 
> > > The latter needs small modifications if you will change
> > > blk_rq_unmap_user interface.
> > 
> > I'll rebase the bsg tree as soon as Linus pulls the for-linus branch,
> > which has a number of SG_IO related changes and fixes. Ah I'll just
> > rebase bsg now and send you a note, then please resend the pending
> > patches against that and I'll include it.
> 
> bsg branch rebased, please send the patch against the current one. HEAD
> of tree is fc68dbc4630ffef6dce5198fd90bdec37a9bbf44.

Thanks. I will update and resend the patches tomorrow.
