From: Christoph Hellwig <hch@lst.de>
Subject: Re: [linux-iscsi-devel] [question] deferred sense
Date: Wed, 5 Jan 2005 16:23:33 +0100
Message-ID: <20050105152333.GA1453@lst.de>
References: <41DB21D7.5080904@us.ibm.com> <20050104234700.GA18343@visi.com> <20050105092144.GB26793@lst.de> <20050105152112.GA8472@visi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43470 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262476AbVAEPXv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2005 10:23:51 -0500
Content-Disposition: inline
In-Reply-To: <20050105152112.GA8472@visi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: Mike Christie <mikenc@us.ibm.com>, linux-iscsi-devel <linux-iscsi-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Wed, Jan 05, 2005 at 09:21:12AM -0600, Scott M. Ferris wrote:
> On Wed, Jan 05, 2005 at 10:21:44AM +0100, Christoph Hellwig wrote:
> > 
> > The kernel still doesn't hadle deferred sense correctly.  In fact I'm
> > not sure it's entirely possible to handle deferred sense correctly.
> > 
> > The iscsi driver variant of "translating" it to normal sense data and
> > that for disks only certainly doesn't make much sense.
> 
> To be more specific, there were some devices that would fail a command
> and return deferred sense.  The command didn't complete at the target,
> and the kernel wasn't retrying it because the sense was deferred
> rather than current.  For those devices, the translation produced the
> desired retry.

Do you remember these devices?  Might be worth adding a midlayer
blacklist entry for them.

And I suspect we should get linux-scsi in the loop for the discussion
about deferred sense handling.
