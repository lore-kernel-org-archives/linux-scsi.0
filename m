From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Thu, 27 Sep 2012 11:04:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209271104140.1596-100000@iolanthe.rowland.org>
References: <CAEG-z2_9SqrSZcDSDK45Pdax3i_fJnxs1Mmi94JCgmMzUdLmvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40950 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754246Ab2I0PEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 11:04:37 -0400
In-Reply-To: <CAEG-z2_9SqrSZcDSDK45Pdax3i_fJnxs1Mmi94JCgmMzUdLmvg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Thu, 27 Sep 2012, Adrian Sandu wrote:

> >> I tried with a 3.3.8 , same thing happened. I don't understand why my
> >> gentoo (asrock) fails and fedora(laptop) didn't ! :|
> >> Why ? What causes it to shutdown ? It can copy to/from drives ( in the
> >> hub or directly in the root hub ) .. but what makes it fail sometimes
> >> :|
> >
> > If we knew the answer, the problem would already be fixed.  :-)
> 
> Would a usbmon dump on a working 3.5.2 ( my fedora ) for comparison
> with the gentoo help ( when doing the same actions that would fail on
> the gentoo ) ?

I don't know.  Sarah is the expert on this stuff.

Alan Stern

