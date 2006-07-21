From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Thu, 20 Jul 2006 23:01:02 -0400
Message-ID: <44C0436E.306@garzik.org>
References: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com> <44BFF539.4000700@garzik.org> <1153439728.4754.19.camel@mulgrave> <44C01CD7.4030308@garzik.org> <20060721010724.GB24176@suse.de> <44C02D1E.4090206@garzik.org> <20060721013822.GA25504@suse.de> <44C037B3.4080707@garzik.org> <20060721023647.GA29220@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:3006 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964827AbWGUDBG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jul 2006 23:01:06 -0400
In-Reply-To: <20060721023647.GA29220@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ed Lin <ed.lin@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>

Jens Axboe wrote:
> If I thought that it would ever be updated to use block tagging, I would
> not care at all. The motivation to add it from the Promise end would be
> zero, as it doesn't really bring any immediate improvements for them. So
> it would have to be done by someone else, which means me or you. I don't
> have the hardware to actually test it, so unless you do and would want
> to do it, chances are looking slim :-)
> 
> It's a bit of a chicken and egg problem, unfortunately. The block layer
> tagging _should_ be _the_ way to do it, and as such could be labelled a
> requirement. I know that's a bit harsh for the Promise folks, but
> unfortunately someone has to pay the price...

I think it's highly rude to presume that someone who has so-far been 
responsive, and responsible, will suddenly not be so.  That is not the 
way to encourage vendors to join the Linux process.

They set up an alias for Linux maintainer stuff and have been acting 
like a maintainer that will stick around.  Why punish them for good 
behavior?

	Jeff


