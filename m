From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 15:31:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922153123.A23388@infradead.org>
References: <20030922004943.E32009@one-eyed-alien.net> <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:7694 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263166AbTIVOcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 10:32:16 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Mon, Sep 22, 2003 at 10:25:28AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Sep 22, 2003 at 10:25:28AM -0400, Alan Stern wrote:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106366112221507&w=2
> 
> At the moment, this MODE-SENSE page 8 is probably the most severe 
> outstanding problem with the usb-storage driver.  I'm all in favor of the 
> patch being adopted (hint, hint...).

Patch looks mostly fine to me, but please all flags should be unsigned instead
of signed and scsi_devinfo.h needs some inclusion guards.

