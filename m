From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 02:45:47 -0700 (PDT)
Message-ID: <20071017.024547.74747794.davem@davemloft.net>
References: <20071017.021305.74746838.davem@davemloft.net>
	<20071017091629.GK5043@kernel.dk>
	<20071017182401X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36363
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbXJQJpg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 05:45:36 -0400
In-Reply-To: <20071017182401X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 17 Oct 2007 18:24:01 +0900

> On Wed, 17 Oct 2007 11:16:29 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 17 2007, David Miller wrote:
> > > I would suggest that other sg_last() uses be audited for the same bug.
> > 
> > Agree.
> 
> Only libata, I think.

There are a few other spots, like ide-scsi
