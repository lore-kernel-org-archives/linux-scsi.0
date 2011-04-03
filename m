From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sun, 03 Apr 2011 07:14:54 -0500
Message-ID: <1301832894.2631.2.camel@mulgrave.site>
References: <20110401202051.GL4183@linux.intel.com>
	 <20110402133643.GB18990@infradead.org>
	 <20110402210240.GD7286@parisc-linux.org>
	 <20110403110057.GC3872@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1DCMPA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Apr 2011 08:15:00 -0400
In-Reply-To: <20110403110057.GC3872@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org

On Sun, 2011-04-03 at 07:00 -0400, Christoph Hellwig wrote:
> On Sat, Apr 02, 2011 at 03:02:40PM -0600, Matthew Wilcox wrote:
> > Fair enough, but you're making the perfect the enemy of the good.
> > How about putting this patch in for now (since it harms nothing), and
> > then it'll all go away when you delete cmd_serial_number?
> 
> If you change it anyway for mpt2sas just keep the atomic counter in
> it's local structures.  Or even better verify with LSI if the
> serial_number check can't simply be removed entirely, which I think it
> could.

Also I'm not really sure atomic counter conversion is the correct thing
to do.  Someone from intel said it would perform worse than the current
spinlock based serial number the last time we discussed the conversion
(converting it to atomic was my first thought at the time).

James


