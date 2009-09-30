From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Date: Wed, 30 Sep 2009 09:15:55 +0200
Message-ID: <20090930071555.GA13915@merkur.ravnborg.org>
References: <20090929103353.GA11183@redhat.com> <20090929124347.GA11375@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [195.41.46.235] ([195.41.46.235]:56683 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZI3HQC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2009 03:16:02 -0400
Content-Disposition: inline
In-Reply-To: <20090929124347.GA11375@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Ulrich Drepper <drepper@redhat.com>

On Tue, Sep 29, 2009 at 08:43:47AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 29, 2009 at 12:33:53PM +0200, Michael S. Tsirkin wrote:
> > This implements a minor cleanup of exported scsi headers,
> > and adds export of headers that are de-facto used by userspace.
> > The patches are on top of 2.6.32-rc1.
> > Can these be queued for 2.6.32?
> > Thanks.
> 
> Before we do anything in this area we need to find an agreement who
> owns /usr/include/scsi/ .  Right now that's glibc, and if we want to
> change it to the kernel headers we need to find a transition agreement
> with the glibc maintainer (aka mostly Uli).

The scsi headers are exported. So it does not matter if glibc or any
other libc for that amtter uses the headers or not.
Exported headers has some rules to follow and scsi are no exception here.

Now if we get the scsi headers in good shape then and only then we can 
go to glibc people and tell them that we have a better set of scsi headers
than they have.

Postponing updates to the exported scsi headers just beacause we do not
have any users of them at the moment is the wrong thing to do.
We should rather use the opportunity to streamline the exported headers
so we have a superior set of headers to offer.

	Sam
