From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] drop some attibutes from the FC transport class
Date: Wed, 19 Jan 2005 23:12:00 -0600
Message-ID: <20050120051200.GA20064@lists.us.dell.com>
References: <20050119171357.GA16136@lst.de> <20050119172106.GB32702@kroah.com> <20050119213924.GG5508@us.ibm.com> <20050119224016.GA5086@kroah.com> <20050119230350.GA23553@infradead.org> <20050119230855.GA5646@kroah.com> <20050119231559.GA10404@lists.us.dell.com> <20050119234219.GA6294@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:20698 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261812AbVATFMM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 00:12:12 -0500
Content-Disposition: inline
In-Reply-To: <20050119234219.GA6294@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, jejb@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, Jan 19, 2005 at 03:42:19PM -0800, Greg KH wrote:
> Here it was against 2.6.9.  Odds are it doesn't apply anymore due to
> some recent changes in this area.  If anyone wants to take it and fix it
> up, please do so.
> 
> Note, this patch needs the evil strdup() function to work properly.
> That's one of the main reasons I decided to not submit it to the main
> kernel tree...

How would you feel if instead, we just didn't drop the .modinfo
section?  That would eliminate the need to copy the strings, and then
the field##_get_function would just use the string from the .modinfo
section directly?

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
