From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [UPDATED PATCH] SGIWD93: use cached memory access to make driver work on IP28
Date: Sun, 27 Jan 2008 00:25:38 +0100
Message-ID: <20080126232538.GA9797@alpha.franken.de>
References: <20080125163245.2B246C2F89@solo.franken.de> <1201279480.3119.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elvis.franken.de ([193.175.24.41]:38535 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYAZX1o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 18:27:44 -0500
Content-Disposition: inline
In-Reply-To: <1201279480.3119.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 25, 2008 at 10:44:40AM -0600, James Bottomley wrote:
> > +	void *cpu;
> > +	void *dev;
> 
> This should be struct device *dev; shouldn't it (that seems to be how
> it's always used)?

of course, no need for the void *.

> And that should be dma_free_noncoherent(&pdev->dev, ...) shouldn't it?

yes it should.

I'm sending an updated patch in a couple of seconds. Thanks for
the review.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
