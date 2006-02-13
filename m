From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Mon, 13 Feb 2006 17:21:52 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0602131713160.8102@goblin.wat.veritas.com>
References: <Pine.LNX.4.61.0602040004020.5406@goblin.wat.veritas.com>
 <20060211223810.GA12064@tau.solarneutrino.net>
 <Pine.LNX.4.61.0602121838050.15101@goblin.wat.veritas.com>
 <200602122229.33244.ak@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silver.veritas.com ([143.127.12.111]:19062 "EHLO
	silver.veritas.com") by vger.kernel.org with ESMTP id S932127AbWBMRV3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 12:21:29 -0500
Received: from goblin.wat.veritas.com([10.10.97.2]) (2130 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1F8hNt-0001VJC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2006 09:21:09 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <200602122229.33244.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>
Cc: Ryan Richter <ryan@tau.solarneutrino.net>, Brian King <brking@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, James.Bottomley@steeleye.com, rolandd@cisco.com, Kai.Makisara@kolumbus.fi, dougg@torque.net, osst@riede.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 12 Feb 2006, Andi Kleen wrote:
> On Sunday 12 February 2006 19:57, Hugh Dickins wrote:
> 
> > So I'd like to believe that your x86_64-gart-dma-merge.patch is the
> > final answer to this issue, and see it go forward into 2.6.16-rc -
> > if you feel it's ready now.  Then we can just throw away those driver
> > patches I posted a week ago (including the "ipr" one of this thread).
> 
> Yes, it's probably ready to go. I will submit it later if Andrew doesn't
> beat me.

And you got the fix into 2.6.16-rc3, last on the train: many thanks.
Andrew, please now drop from -mm my unnecessary, driver-complicating

ib-dont-doublefree-pages-from-scatterlist.patch
ipr-dont-doublefree-pages-from-scatterlist.patch
osst-dont-doublefree-pages-from-scatterlist.patch

Thanks,
Hugh
