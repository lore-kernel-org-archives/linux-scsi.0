From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Thu, 20 Jan 2005 06:41:34 -0800
Message-ID: <20050120144134.GA13036@kroah.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com> <20050119230350.GA23553@infradead.org> <20050119230855.GA5646@kroah.com> <20050119231559.GA10404@lists.us.dell.com> <20050119234219.GA6294@kroah.com> <20050120051200.GA20064@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:18892 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S262131AbVATOvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 09:51:36 -0500
Content-Disposition: inline
In-Reply-To: <20050120051200.GA20064@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Christoph Hellwig <hch@infradead.org>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 11:12:00PM -0600, Matt Domsch wrote:
> On Wed, Jan 19, 2005 at 03:42:19PM -0800, Greg KH wrote:
> > Here it was against 2.6.9.  Odds are it doesn't apply anymore due to
> > some recent changes in this area.  If anyone wants to take it and fix it
> > up, please do so.
> > 
> > Note, this patch needs the evil strdup() function to work properly.
> > That's one of the main reasons I decided to not submit it to the main
> > kernel tree...
> 
> How would you feel if instead, we just didn't drop the .modinfo
> section?  That would eliminate the need to copy the strings, and then
> the field##_get_function would just use the string from the .modinfo
> section directly?

That makes sense to me, but you might want to ask Rusty about it, as
it's his code.

thanks,

greg k-h
