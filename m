From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: arm: fas216: Use %llu to print 'u64' format
Date: Thu, 10 Jul 2014 23:34:44 -0700
Message-ID: <20140711063444.GA6945@infradead.org>
References: <1405035187-27737-1-git-send-email-festevam@gmail.com>
 <20140711062302.GA12385@infradead.org>
 <53BF8479.9090109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGKGer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 02:34:47 -0400
Content-Disposition: inline
In-Reply-To: <53BF8479.9090109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Fabio Estevam <festevam@gmail.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>

On Fri, Jul 11, 2014 at 08:30:17AM +0200, Hannes Reinecke wrote:
> On 07/11/2014 08:23 AM, Christoph Hellwig wrote:
> >Thanks Fabio,
> >
> >this looks good to me.  Are there any other warnings you got from that
> >autobuilder?
> >
> It _should_ have been fixed with my latest patch for fixing the 64bit LUN
> fallout. Christoph, have you applied it?

Looks like this is in, indeed.  Seems like that latest drivers-for-3.17
update hasn't made it into James' for-next and thus linux-next, though.

