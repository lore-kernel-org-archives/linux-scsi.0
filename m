From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv2 0/4] scsi: export and clean up headers
Date: Tue, 29 Sep 2009 13:19:20 +0200
Message-ID: <20090929111918.GA17799@redhat.com>
References: <20090929103353.GA11183@redhat.com> <20090929124620.2c8abc4d@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZI2LV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 07:21:27 -0400
Content-Disposition: inline
In-Reply-To: <20090929124620.2c8abc4d@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>

On Tue, Sep 29, 2009 at 12:46:20PM +0200, Arjan van de Ven wrote:
> On Tue, 29 Sep 2009 12:33:53 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > This implements a minor cleanup of exported scsi headers,
> > and adds export of headers that are de-facto used by userspace.
> > The patches are on top of 2.6.32-rc1.
> > Can these be queued for 2.6.32?
> > Thanks.
> > 
> 
> one of the problems I've found is that glibc has its own copy
> of scsi headers, causing interesting conflicts. Do you know for
> sure that with these cleanups we can retire the glibc headers?
> (that would be very welcome)

I don't see why not.
The only differences with glibc headers that I can see:
- glic adds #include <features.h> on top of each header
- glibc has old SCSI_IOCTL_TAGGED_ENABLE/SCSI_IOCTL_TAGGED_DISABLE

> If not, do you know what it would take to get to that point?

Probably just talk to Ulrich or other glibc developers.
If there's some symbol that's missing, we can always add it.

> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
