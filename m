From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/7 v3] initdev:kernel:USB init device discovery
 notification
Date: Fri, 7 Aug 2009 11:44:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908071142260.3063-100000@iolanthe.rowland.org>
References: <9b2b86520908070832p2d1658b0t8b1d89d1a034bb9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55487 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753216AbZHGPou (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 11:44:50 -0400
In-Reply-To: <9b2b86520908070832p2d1658b0t8b1d89d1a034bb9a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: David VomLehn <dvomlehn@cisco.com>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org

On Fri, 7 Aug 2009, Alan Jenkins wrote:

> > +/* The mask of possible USB boot devices depends on what drivers and
> > + * options have been configured into the kernel.  There are too many
> > + * USB network config options to list here, so just assume it is always
> > + * possible to have a USB network device.
> > + */
> 
> That could be fixed though.  Make the "USB Network Adaptors" menu into
> an option.  Then you just have e.g. "CONFIG_NETDEV_USB", plus the two
> class devices outside the menu (CONFIG_USB_ACM and CONFIG_USB_WDM).

That could be done.  It might even meet with the approval of the
networking maintainer, independent of this patch series.

But what if somebody adds yet another networking class driver outside
the menu?

Alan Stern

