From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 17:15:59 -0600
Message-ID: <20050119231559.GA10404@lists.us.dell.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com> <20050119230350.GA23553@infradead.org> <20050119230855.GA5646@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:14527 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261969AbVASXQO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 18:16:14 -0500
Content-Disposition: inline
In-Reply-To: <20050119230855.GA5646@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 03:08:55PM -0800, Greg KH wrote:
> On Wed, Jan 19, 2005 at 11:03:50PM +0000, Christoph Hellwig wrote:
> > On Wed, Jan 19, 2005 at 02:40:16PM -0800, Greg KH wrote:
> > > I had a patch to do that around here somewhere, but I think it was
> > > rejected as people can get the same info by using 'modinfo' instead.
> > > You know, the old, "use a userspace tool instead of wasting kernel
> > > memory" argument :)
> > 
> > How's that supposed to work for builtin drivers?
> 
> Oh wait.  I get your point.  Hm, I don't know.  Want me to dig up the
> patch?

Yes, DKMS would like to use that too.


-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
