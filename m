From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c500_cs driver update
Date: Sat, 27 Nov 2004 12:35:52 +0000
Message-ID: <20041127123552.GA25857@infradead.org>
References: <20041127045011.F0214DBDB@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:29862 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261189AbUK0Mfx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2004 07:35:53 -0500
Content-Disposition: inline
In-Reply-To: <20041127045011.F0214DBDB@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@osdl.org, hch@infradead.org, James.Bottomley@steeleye.com

On Fri, Nov 26, 2004 at 10:50:11PM -0600, Bob Tracy wrote:
> (Previously posted a month ago to linux-kernel and linux-scsi with
> copies to James Bottomley and Christoph Hellwig.  No feedback received.
> Would like to see this included in 2.6.10.  Thanks!)
> 
> The attached minor patch to linux/drivers/scsi/pcmcia/sym53c500_cs.c
> allows interrupt sharing, which is evidently a "must have" feature for
> at least G4 PowerBooks (ppc architecture).  The other user of the New
> Media Bus Toaster reports that his powerbook consistently assigns the
> yenta CardBus controller IRQ to whatever card he inserts.
> 
> Applies to version 0.9b of the sym53c500_cs driver, as included with
> the 2.6.9 kernel.

The change is in Linus' tree already.

