From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16 commands to libata ATAPI devices
Date: Sun, 7 Jan 2007 21:00:37 -0800 (PST)
Message-ID: <141410.19366.qm@web31811.mail.mud.yahoo.com>
References: <459C066D.30507@torque.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:35260 "HELO
	web31811.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1160995AbXAHFAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 00:00:38 -0500
In-Reply-To: <459C066D.30507@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

--- Douglas Gilbert <dougg@torque.net> wrote:
> 
> I seem to be fighting a losing battle against the mindset

That may be the case.

> It is the _transport_ that should block the command,
> if it so chooses. In this case the transport is a
> virtual one between sr/sg and libata and libata should
> recognize SCSI ATA PASS-THROUGH (12+16) cdbs as
> transport related and not (directly) to be sent to
> the logical unit. And it is at this level we should
> add the wrinkle that if the pdt=5 (cd or dvd) then
> don't translate ATA_12. [I have already been around this
> loop with Luben and his SATL: sorted with the minimum
> of fuss.]

LOL, I don't think your mentioning my name in an email
to bottomley is going to convince him of anything, in
fact it may prompt him to do it the opposite way.

Good luck!

As to the "been around this loop", the fix was a two
liner, without checking the PDT, and ATA_16, ATA_12
and BLANK work as expected.

> ** I have been told that USB disk enclosures being designed
> now will include at a SATL. This will mean smartmontools

Absolutely.  Many reasons, one of which is having to deal
with battles like this one, probably the least one, but
still a reason which is sometimes mentioned.

    Luben

