From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Use queuedata accessors for device handler
Date: Mon, 22 Aug 2011 10:45:05 -0400
Message-ID: <20110822144505.GA5705@infradead.org>
References: <201108221335.p7MDZhBm013520@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37739
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab1HVOpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 10:45:08 -0400
Content-Disposition: inline
In-Reply-To: <201108221335.p7MDZhBm013520@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, Aug 22, 2011 at 03:35:43PM +0200, Hannes Reinecke wrote:
> 
> Starting multipath on a cciss device will cause a kernel
> warning to be triggered. Problem is that we're using the
> ->queuedata field of the request_queue to dereference the
> scsi device; however, for other (non-SCSI) devices this
> points to a totally different structure.
> So we should rather be using accessors here to make
> sure ->queuedata points to a valid sdev.

How do we match to attach a scsi device handler to a non-scsi queue?
I suspect that is the fundamental issue that needs addressing.

