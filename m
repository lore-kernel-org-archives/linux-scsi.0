From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Thu, 27 Sep 2012 11:09:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1209271107570.1347-100000@iolanthe.rowland.org>
References: <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43159 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754492Ab2I0PJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2012 11:09:13 -0400
In-Reply-To: <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Thu, 27 Sep 2012, Adrian Sandu wrote:

> I tried with a 3.3.8 , same thing happened. I don't understand why my
> gentoo (asrock) fails and fedora(laptop) didn't ! :|

Come to think of it, you could try running the same kernel on both 
computers to see what happens.  For example, boot both of them from a 
Fedora install disc in rescue mode.

Alan Stern

