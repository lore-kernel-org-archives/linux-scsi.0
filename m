From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libsas: convert to standard kernel debugging
Date: Wed, 26 Jan 2011 15:21:57 -0500
Message-ID: <20110126202157.GA11101@infradead.org>
References: <1295792340.3007.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1AZUV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 15:21:58 -0500
Content-Disposition: inline
In-Reply-To: <1295792340.3007.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Jan 23, 2011 at 08:19:00AM -0600, James Bottomley wrote:
> Instead of using a config option for debugging, just dump the
> messages with KERN_DEBUG.

SAS_DPRINTK is far too verbose to just enable it all the time
and fill the kernel log buffer.  Some of it would be a good fit
for tracepoints, and some of should simply be removed.

