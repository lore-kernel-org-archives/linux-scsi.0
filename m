From: Christoph Hellwig <hch@infradead.org>
Subject: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 22:57:10 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117225710.A23533@infradead.org>
References: <200211172245.gAHMj199022666@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211172245.gAHMj199022666@leviathan.ele.uri.edu>; from mingz@ele.uri.edu on Sun, Nov 17, 2002 at 05:43:38PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 05:43:38PM -0500, Ming Zhang wrote:
> >Why you just do this in userspace?
> >
> that iscsi target have to be a kernel module.

why?

> >Umm, no.  Nothing but upperlayer drivers is supposed to talk to the scsi
> >midlayer directly. Implement an upperlayer driver and check for disks in
> >->attach instead.
> ~~~would u like to explain this in more detail? which ->attach?

The attach routine of the upper layer driver.  See struct
Scsi_Device_Template in hosts.h or look at one of the existing upper
layer drivers (like sd or sr)

