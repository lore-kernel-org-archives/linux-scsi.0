From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] sdev_printk for ULDs, example with sd
Date: Thu, 22 Jan 2004 12:41:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122204130.GA3571@beaverton.ibm.com>
References: <200401191355.37522.dsteklof@us.ibm.com> <200401221144.48488.dsteklof@us.ibm.com> <1074802104.1877.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:59617 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265063AbUAVUh1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 15:37:27 -0500
Content-Disposition: inline
In-Reply-To: <1074802104.1877.58.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Daniel Stekloff <dsteklof@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Thu, 2004-01-22 at 14:44, Daniel Stekloff wrote:
> > In my recent post concerning sdev_printk I mentioned sdev_printk was useful 
> > for the mid-layer and LLDs. The macro is also useful for Upper Level Drivers 
> > as well. He's a patch adding sdev_printk to sd. Sample output includes:
> 
> Well, the thing about this is that it's a slippery slope that leads into
> posix logging.  This recently came up in network as well (for
> netdev_printk()):
> 
> http://marc.theaimsgroup.com/?t=107454443000004&r=1&w=2
> 
> The principle is sound, but I think the framework for doing it would
> have to cross all subsystems and be nicely extensible.  I'd really like
> to see us have some idea of the back end infrastructure before we do
> something that we'll then have to change again.
> 

I thought after passed discussions that dev_printk was the support to
build on? It should be extensible to a limit as the struct device is
passed in as a argument.

At least for some of the LLDDs that have implemented it I find it more
consistent when I load and unload modules to get the dev_printk type
message from the driver.

-andmike
--
Michael Anderson
andmike@us.ibm.com

