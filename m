From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: use_10_for_ms revisited?
Date: Sun, 29 Jun 2003 12:22:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030629102222.GA14962@win.tue.nl>
References: <3EFE8784.4000101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kweetal.tue.nl ([131.155.3.6]:17162 "EHLO kweetal.tue.nl")
	by vger.kernel.org with ESMTP id S265596AbTF2KIF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 06:08:05 -0400
Content-Disposition: inline
In-Reply-To: <3EFE8784.4000101@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Jun 29, 2003 at 02:30:28AM -0400, Jeff Garzik wrote:

> I was reading the specs just now, and I see that the inquiry page 
> defines how ATAPI and USB devices indicate they are compliant with MMC-4.
> 
> And, MMC-4 does not define read/write/modesen/modesel 6-byte commands at 
> all.
> 
> My conclusion is that we should notice up front when MMC-4 is supported, 
> and simply adhere to the spec by always sending 10-byte commands for 
> that device.  I do not think that translation of 6-to-10 byte commands 
> is answer, which is what happens now.  Our SCSI layer (sr.c, etc.) 
> should, IMO, be compliant with MMC-4 and simply send the right commands.
> 
> This also implies that use_10_for_ms simply need not exist -- "first try 
> 10 byte commands for this device" is false...  for some devices we 
> should be unconditionally sending 10 byte commands, no ifs, ands, or buts :)
> 
> I'll see if I can work up a patch, if noone objects...

Jeff, let me object.

You are an optimist - it is as if I hear Andre, who has just read
the latest ATA draft.

The firmware of existing devices is not magically updated when
a new draft standard is released. So reading yesterdays version
gives very little information on the real world.

Andries


[And no, none of my USB devices announces MMC-4 compliance.]

