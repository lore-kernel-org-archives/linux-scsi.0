From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Fri, 21 Jul 2006 03:06:22 +0200
Message-ID: <20060721010622.GA24176@suse.de>
References: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com> <44BFF539.4000700@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:5717 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030425AbWGUBGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jul 2006 21:06:35 -0400
Content-Disposition: inline
In-Reply-To: <44BFF539.4000700@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ed Lin <ed.lin@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@SteelEye.com>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>

On Thu, Jul 20 2006, Jeff Garzik wrote:
> 5) [agreement/correction]  The block tagging API supports adapter-wide
> tags just fine.  HOWEVER, I nonetheless feel that block tagging API use
> should be considered post-merge.  The 'stex' driver is working and
> tested today.  Since _no individual SCSI driver_ uses the block layer
> tagging, it is likely that some instability and core kernel development
> will occur, in order to make that work.

I'd disagree. If the driver gets merged with the current tagging, I'll
get you two beers that it never gets changed.

And you are wrong, block layer tagging is used by at least one SCSI
driver. We definitely need to start pushing it more.

-- 
Jens Axboe

