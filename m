From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: provide UAPI version of scsi/sg.h and
	scsi/scsi_ioctl.h
Date: Wed, 16 Sep 2015 16:23:40 +0200
Message-ID: <20150916142340.GA11338@lst.de>
References: <1442308888-17911-1-git-send-email-pbonzini@redhat.com> <20150916133926.GA9658@lst.de> <55F97992.6050905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37178 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbbIPOXm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2015 10:23:42 -0400
Content-Disposition: inline
In-Reply-To: <55F97992.6050905@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: houcheng@gmail.com, Andy Grover <agrover@redhat.com>, James Bottomley <jbottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Wed, Sep 16, 2015 at 04:15:46PM +0200, Paolo Bonzini wrote:
> I'm trying to cater to the objections that were made to Andy's patch.
> If you mean the non-UAPI headers, James wanted them to stay in scsi/; if
> you mean the UAPI headers, Douglas complained about the flat structure
> of include/linux/.

Yes, keep the non-UAPI ones as is and move the UAPI ones to linux/ - the flat
structure is a feature, not a bug.

> > Also scsi/scsi.h has some additional ioctl defintions that should be
> > added to the UAPI scsi_ioctl.h.  Otherwise this looks ok to me.
> 
> I can do this, but I think they are obsoleted by SG_GET_SCSI_ID, except
> for SCSI_IOCTL_GET_PCI which is horrible anyway. :)  The comment about
> conflicts with CDROM ioctls is also interesting.  I can see why one
> would want to keep them out of the new canonical place for SCSI ioctls.

No point in hiding them.  We can still officially deprecate them, but I'd
much rather have them in a single place than hidden away somewhere.
