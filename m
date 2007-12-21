From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/5] dma_map_sg_ring() helper
Date: Fri, 21 Dec 2007 11:22:56 +0900
Message-ID: <20071221112256X.fujita.tomonori@lab.ntt.co.jp>
References: <20071221090027K.fujita.tomonori@lab.ntt.co.jp>
	<200712211135.13150.rusty@rustcorp.com.au>
	<20071220.164000.210277365.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:33577 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbXLUCX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 21:23:26 -0500
In-Reply-To: <20071220.164000.210277365.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net
Cc: rusty@rustcorp.com.au, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

On Thu, 20 Dec 2007 16:40:00 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Fri, 21 Dec 2007 11:35:12 +1100
> 
> > On Friday 21 December 2007 11:00:27 FUJITA Tomonori wrote:
> > > We need to pass the whole sg entries to the IOMMUs at a time.
> > 
> > Hi Fujita,
> > 
> >     OK, it's certainly possible to have an arch override.  For which 
> > architecture is this BTW?
> 
> SPARC64, POWERPC, maybe IA-64 etc.

And x86_64, Alpha, and PARISC.


> Basically any platform that potentially does virtual
> remamping and thus linearization.
> 
> I think it should always be provided, the new APIs give
> less information to the implementation and that's a step
> backwards.

Agreed.
