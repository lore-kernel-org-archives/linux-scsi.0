From: Kenn Humborg <kenn@linux.ie>
Subject: Re: Locking in NCR5380_select
Date: Mon, 9 Aug 2004 23:43:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809224347.GA24883@excalibur.research.wombat.ie>
References: <20040808223809.GB17161@excalibur.research.wombat.ie> <20040809230013.A10976@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.mail.iol.ie ([193.95.141.54]:17307 "EHLO
	mail2.mail.iol.ie") by vger.kernel.org with ESMTP id S267327AbUHIWod
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 18:44:33 -0400
Content-Disposition: inline
In-Reply-To: <20040809230013.A10976@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 09, 2004 at 11:00:13PM +0100, Christoph Hellwig wrote:
> On Sun, Aug 08, 2004 at 11:38:09PM +0100, Kenn Humborg wrote:
> > 
> > Hi,
> > 
> > I'm working on the Linux/VAX port and I'm writing a driver for a
> > 5380 SCSI controller.  Running on UP with CONFIG_DEBUG_SPINLOCK=y
> > throws up some locking problems in NCR5380_main and NCR5380_select.
> > 
> > NCR5380_main expects NCR5380_select to always return with the host
> > adapter lock acquired.  However, there is inconsistent locking within
> > NCR5380_select (I've removed most of the code, but left in all the
> > spinlock calls, and return paths):
> 
> Yes, this is a known bug.  I have a fix and will post it as soon as I have
> recovered from travelling.

Excellent!  Thanks.

Later,
Kenn

