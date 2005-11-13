From: Graham Knap <graham.knap@rogers.com>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 11:47:32 -0500 (EST)
Message-ID: <20051113164732.73492.qmail@web88010.mail.re2.yahoo.com>
References: <1131855418.4179.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web88010.mail.re2.yahoo.com ([206.190.37.197]:32598 "HELO
	web88010.mail.re2.yahoo.com") by vger.kernel.org with SMTP
	id S964933AbVKMQrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:47:33 -0500
In-Reply-To: <1131855418.4179.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> My best guess would be that the bus is slightly marginal.  The
> aic7xxx drivers are notoriously sensitive to bus problems.  Could you
> try lowering the bus speed to 10MHz in the aic7xxx bios and see if
> that helps?

Sure. I changed the device to 20MByte/s max. Now the driver shows
10MHz, 16-bit wide... and DV still fails, with what looks like the same
messages.

As for the bus being marginal, I don't see why it would be, but
anything is possible.

Host adapter termination is set to "Automatic". If I understand things
correctly, since there's no cable attached to the internal 50pin
connector or the external connector, I could try forcing it to "Low ON
/ High ON"... right?

The cabling looks like this:

[HBA] -- [disk] -- [unused connector] -- [terminator]

I'm pretty sure the cable is U160 rated (it wasn't cheap). The
terminator isn't integrated into the cable -- it's a plug-in Active SE
terminator.

The drive is LVD capable, but I've never had trouble running it in SE
mode. The "Force SE" jumper is not installed, but I suppose I could try
that too.

http://www.hitachigst.com/tech/techlib.nsf/products/Ultrastar_36LZX

BTW -- Another oddity I should mention is that if I warm-reboot the
system after DV fails, the drive isn't detected during POST. Power
cycling fixes it. (In other cases, warm-rebooting works fine.)

Let me know what I should try next.

-- graham

