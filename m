From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
Date: Fri, 30 Jan 2009 19:32:38 -0800
Message-ID: <20090131033238.GC2947@kroah.com>
References: <200901271854.n0RIs73a026759@swe37.brocade.com> <20090127221618.GA26480@infradead.org> <4C94DE2070B172459E4F1EE14BD2364E027534DA@HQ-EXCH-5.corp.brocade.com> <1233164662.3236.93.camel@localhost.localdomain> <4C94DE2070B172459E4F1EE14BD2364E02753674@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779AbZAaDfI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 22:35:08 -0500
Content-Disposition: inline
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E02753674@HQ-EXCH-5.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Krishna Gudipati <kgudipat@Brocade.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

On Wed, Jan 28, 2009 at 10:02:43AM -0800, Jing Huang wrote:
> > This might take a while.  I can offer to put this driver in the staging
> > tree while you work on it if that would be helpful?
> > 
> > The way the staging tree works is that drivers are held in a separate
> > area (drivers/staging) in the linux kernel while they're being worked
> > on.  The driver can be installed by users while it's in the staging tree
> > (so made use of) but it will taint the kernel with a warning that it's
> > not of linux kernel quality yet.  Once we get an acceptable driver in
> > drivers/staging, I'll move it across to drivers/scsi and remove the
> > taint.
> > 
> > James
> > 
> > 
> 
> This is definitely helpful, thanks James!

Does this mean someone will send me a patch to add this to the
drivers/staging/ tree?  Or should I just grab these patches and use them
to add them to the tree myself (preserving author attributes of course)?

thanks,

greg k-h
