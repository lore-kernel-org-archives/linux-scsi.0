From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning
	down disk
Date: Fri, 28 Sep 2007 12:33:04 -0700
Message-ID: <20070928193304.GG8385@kroah.com>
References: <Pine.LNX.4.44L0.0709251012210.3909-100000@iolanthe.rowland.org> <200709251711.01216.oliver@neukum.org> <20070928042710.GA24458@kroah.com> <200709280902.45557.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41553 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbXI1T6B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2007 15:58:01 -0400
Content-Disposition: inline
In-Reply-To: <200709280902.45557.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Fri, Sep 28, 2007 at 09:02:45AM +0200, Oliver Neukum wrote:
> Am Freitag 28 September 2007 schrieb Greg KH:
> > On Tue, Sep 25, 2007 at 05:11:00PM +0200, Oliver Neukum wrote:
> > > 
> > > PS: Whoever designed klists is suffering from a case of overengineeringosis.
> > 
> > No objection from me there. ?If you can think of a way to do list
> > traversal without taking locks, please, feel free to redo the whole
> > klist stuff.
> 
> No, I just was happy to be able to avoid using them.
> 
> But it is not just overengineered, it is also underengineered:
> 
> int bus_for_each_dev(struct bus_type * bus, struct device * start,
> 		     void * data, int (*fn)(struct device *, void *))
> 
> An interface should be designed to note where it fails, thus:
> 
> int bus_for_each_dev(struct bus_type * bus, struct device ** current,
> 		     void * data, int (*fn)(struct device *, void *))

You know that patches are always gladly accepted :)

thanks,

greg k-h
