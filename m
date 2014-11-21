From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 00/37] Fixes, cleanups and modernization for NCR5380
 drivers
Date: Fri, 21 Nov 2014 02:23:13 -0800
Message-ID: <20141121102313.GA12886@infradead.org>
References: <20141112051146.525489687@telegraphics.com.au>
 <20141120155659.GA2450@infradead.org>
 <546EFEE3.4090207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaKUKXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 05:23:16 -0500
Content-Disposition: inline
In-Reply-To: <546EFEE3.4090207@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Fri, Nov 21, 2014 at 09:59:15AM +0100, Hannes Reinecke wrote:
> Speaking of which, what is the decision for my next round of logging
> updates?
> I _think_ I've got all things fixed (minus the suggestion from Doug,
> but this can be fixed up with the next round).

I was waiting for that to do another deep review.  In generall I' fine
with it, but with all the fallout from logging hanges so far I'm tempted
to not merged it for the 3.19 window that is about to close, but as the
first thing for the 3.20 merge window.
