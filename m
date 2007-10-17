From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 20:08:43 +0900
Message-ID: <20071017200843O.fujita.tomonori@lab.ntt.co.jp>
References: <20071017091629.GK5043@kernel.dk>
	<20071017182401X.fujita.tomonori@lab.ntt.co.jp>
	<20071017.024547.74747794.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:39589 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759701AbXJQLIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 07:08:55 -0400
In-Reply-To: <20071017.024547.74747794.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 17 Oct 2007 02:45:47 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Wed, 17 Oct 2007 18:24:01 +0900
> 
> > On Wed, 17 Oct 2007 11:16:29 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Wed, Oct 17 2007, David Miller wrote:
> > > > I would suggest that other sg_last() uses be audited for the same bug.
> > > 
> > > Agree.
> > 
> > Only libata, I think.
> 
> There are a few other spots, like ide-scsi

Oops, I missed that. But seems that we have only three, ide-scsi,
libata, sparc64 iommu.
