From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Locking in NCR5380_select
Date: Mon, 9 Aug 2004 23:00:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809230013.A10976@infradead.org>
References: <20040808223809.GB17161@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:53261 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267301AbUHIWAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 18:00:22 -0400
Content-Disposition: inline
In-Reply-To: <20040808223809.GB17161@excalibur.research.wombat.ie>; from kenn@linux.ie on Sun, Aug 08, 2004 at 11:38:09PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kenn Humborg <kenn@linux.ie>
Cc: linux-scsi@vger.kernel.org

On Sun, Aug 08, 2004 at 11:38:09PM +0100, Kenn Humborg wrote:
> 
> Hi,
> 
> I'm working on the Linux/VAX port and I'm writing a driver for a
> 5380 SCSI controller.  Running on UP with CONFIG_DEBUG_SPINLOCK=y
> throws up some locking problems in NCR5380_main and NCR5380_select.
> 
> NCR5380_main expects NCR5380_select to always return with the host
> adapter lock acquired.  However, there is inconsistent locking within
> NCR5380_select (I've removed most of the code, but left in all the
> spinlock calls, and return paths):

Yes, this is a known bug.  I have a fix and will post it as soon as I have
recovered from travelling.

