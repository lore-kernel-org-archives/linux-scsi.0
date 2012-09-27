From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Thu, 27 Sep 2012 13:04:33 -0700
Message-ID: <20120927200433.GB27721@xanatos>
References: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA@mail.gmail.com>
 <Pine.LNX.4.44L0.1209271447340.1230-100000@iolanthe.rowland.org>
 <CAEG-z29dU=C49u7_Hi--dKLLf4OuS_LgB3azR4ui4ngu8dt-bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab2I0UEj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2012 16:04:39 -0400
Content-Disposition: inline
In-Reply-To: <CAEG-z29dU=C49u7_Hi--dKLLf4OuS_LgB3azR4ui4ngu8dt-bQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Sandu <dexter@d3xt3r01.tk>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Thu, Sep 27, 2012 at 10:02:22PM +0300, Adrian Sandu wrote:
> > Since you are using the same live CD on both computers, this has to be
> > caused by a difference in the hardware.  What do "lspci -vvv" and
> > "lspci -vvv -n" show on the two computers?
> 
> http://d3xt3r01.tk/~dexter/usbmon/asrock_lspci
> http://d3xt3r01.tk/~dexter/usbmon/vaio_lspci

They're the same chipset.  There's minor differences in the PCI
capabilities, but not much else.  It could be something electrically
wrong with the AsRock system, I suppose.  That's possible if you see
the errors popping up erratically.

Any chance you can exchange the AsRock system?

Sarah Sharp
