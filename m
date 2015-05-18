From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 18 May 2015 18:03:45 +0200
Message-ID: <20150518160345.GA18673@twins.programming.kicks-ass.net>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net>
 <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net>
 <20150518152034.GC5404@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbbERQDt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 12:03:49 -0400
Content-Disposition: inline
In-Reply-To: <20150518152034.GC5404@twins.programming.kicks-ass.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Oelke, Mark" <mark.oelke@hp.com>
Cc: "don.brace@pmcs.com" <don.brace@pmcs.com>, ISS StorageDev <iss_storagedev@hp.com>, "storagedev@pmcs.com" <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, May 18, 2015 at 05:20:34PM +0200, Peter Zijlstra wrote:
> On Mon, May 18, 2015 at 01:57:39PM +0000, Oelke, Mark wrote:
> > The P212/P410/P411 firmware was recently spun to address an issue that sounds exactly like this problem.
> > Which version of controller firmware are you using?
> 
> Smart Array P212 in Slot 1
> 
>    Hardware Revision: C
>    Firmware Version: 6.60

I've updated to 6.62 and it appears to be working now; or rather, it has
not locked up yet where I think it would've locked up by now earlier.

I'll let it run for a few more hours before calling it fixed, I'll let
you know.

Thanks!
