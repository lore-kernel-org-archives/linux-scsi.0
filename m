From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsas: convert to standard kernel debugging
Date: Wed, 26 Jan 2011 20:24:36 +0000
Message-ID: <1296073476.4893.80.camel@mulgrave.site>
References: <1295792340.3007.5.camel@mulgrave.site>
	 <20110126202157.GA11101@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1AZUYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2011 15:24:42 -0500
In-Reply-To: <20110126202157.GA11101@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2011-01-26 at 15:21 -0500, Christoph Hellwig wrote:
> On Sun, Jan 23, 2011 at 08:19:00AM -0600, James Bottomley wrote:
> > Instead of using a config option for debugging, just dump the
> > messages with KERN_DEBUG.
> 
> SAS_DPRINTK is far too verbose to just enable it all the time
> and fill the kernel log buffer.

It's less verbose than the PM stuff.  It actually only prints mostly at
either discovery or error time.  It's pretty much silent during normal
operation.

>   Some of it would be a good fit
> for tracepoints, and some of should simply be removed.

Possibly ... I'll look into that later.

James


