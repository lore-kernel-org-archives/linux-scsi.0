From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] jazz_esp converted to use esp_core
Date: Mon, 21 May 2007 19:45:22 -0400
Message-ID: <46522F12.8030201@garzik.org>
References: <20070521210224.GA24573@alpha.franken.de>	<20070521230041.GA12090@infradead.org> <20070521.164147.35664152.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46455 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbXEUXp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 19:45:26 -0400
In-Reply-To: <20070521.164147.35664152.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

David Miller wrote:
> I disagree, I want people to be able to do test builds
> even if their platform lacks a front-end driver.  And
> for platforms with multiple front ends it's a complete
> waste of space.


Where is the waste of space?

If done properly, Makefile dependencies include precisely what is 
required by the LLDD, no more no less.

	Jeff


