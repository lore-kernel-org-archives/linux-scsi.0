From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 15:08:55 -0800
Message-ID: <20050119230855.GA5646@kroah.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com> <20050119230350.GA23553@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:46541 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261965AbVASXJI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 18:09:08 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0JN97CO640122
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 18:09:07 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0JN97Um455918
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:09:07 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0JN96m8003283
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2005 16:09:06 -0700
Content-Disposition: inline
In-Reply-To: <20050119230350.GA23553@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 11:03:50PM +0000, Christoph Hellwig wrote:
> On Wed, Jan 19, 2005 at 02:40:16PM -0800, Greg KH wrote:
> > I had a patch to do that around here somewhere, but I think it was
> > rejected as people can get the same info by using 'modinfo' instead.
> > You know, the old, "use a userspace tool instead of wasting kernel
> > memory" argument :)
> 
> How's that supposed to work for builtin drivers?

Look at /sys/modules these days.  It shows all builtin modules now :)

Oh wait.  I get your point.  Hm, I don't know.  Want me to dig up the
patch?  It also added such unneeded things as module author and license
just to be "complete".

thanks,

greg k-h
