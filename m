From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] jazz_esp converted to use esp_core
Date: Mon, 21 May 2007 16:54:09 -0700 (PDT)
Message-ID: <20070521.165409.17862510.davem@davemloft.net>
References: <20070521230041.GA12090@infradead.org>
	<20070521.164147.35664152.davem@davemloft.net>
	<46522F12.8030201@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46424
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755234AbXEUXyH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 19:54:07 -0400
In-Reply-To: <46522F12.8030201@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: hch@infradead.org, tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 21 May 2007 19:45:22 -0400

> David Miller wrote:
> > I disagree, I want people to be able to do test builds
> > even if their platform lacks a front-end driver.  And
> > for platforms with multiple front ends it's a complete
> > waste of space.
> 
> 
> Where is the waste of space?
> 
> If done properly, Makefile dependencies include precisely what is 
> required by the LLDD, no more no less.

I see what you're saying, I misunderstood how this stuff
works, this sounds like a good idea.
