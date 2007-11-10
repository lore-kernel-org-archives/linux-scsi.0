From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 13/32] aha1542.c: convert to accessors and !use_sg
 cleanup
Date: Fri, 9 Nov 2007 18:32:08 -0800
Message-ID: <20071109183208.9b04af74.randy.dunlap@oracle.com>
References: <47164306.6090702@panasas.com>
	<47164C07.1070301@panasas.com>
	<20071109183048.a714e766.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:61551 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928AbXKJCee (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 21:34:34 -0500
In-Reply-To: <20071109183048.a714e766.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

On Fri, 9 Nov 2007 18:30:48 -0800 Randy Dunlap wrote:

> On Wed, 17 Oct 2007 19:53:11 +0200 Boaz Harrosh wrote:
> 
> > 
> >  - convert to accessors and !use_sg cleanup
> > 
> > Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> > ---
> 
> Tested-by: Randy Dunlap <randy.dunlap@oracle.com> // aha152x_cs

Negative.  Different driver.  Sorry about that.


> >  drivers/scsi/aha1542.c |   46 ++++++++++------------------------------------
> >  1 files changed, 10 insertions(+), 36 deletions(-)


---
~Randy
