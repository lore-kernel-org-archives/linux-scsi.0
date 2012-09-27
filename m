From: Peter Stuge <peter@stuge.se>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
	usb3 port
Date: Thu, 27 Sep 2012 17:25:26 +0200
Message-ID: <20120927152526.26675.qmail@stuge.se>
References: <CAEG-z28Whi7BufhFnUD8xLZAXjiV0qANc1JNF_62Toget_9CXg@mail.gmail.com> <Pine.LNX.4.44L0.1209271031340.1596-100000@iolanthe.rowland.org> <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:41164 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754729Ab2I0PZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2012 11:25:28 -0400
Content-Disposition: inline
In-Reply-To: <CAEG-z2-JCSsuiTOauUc9P9U7fNvbC0AB2Y=RmfRKrWb_d1SisQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

Adrian Sandu wrote:
> I tried with a 3.3.8 , same thing happened. I don't understand why my
> gentoo (asrock) fails and fedora(laptop) didn't ! :|

Try what Alan suggested, start the Gentoo userland with the Fedora
kernel.

Do you have some crazy USE flags for your toolchain?

If the Fedora kernel works, I would suggest to re-emerge binutils and
gcc with USE=vanilla, and then build a fresh kernel.


//Peter
