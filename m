From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: sym53c8xx_2 funkiness...
Date: Sat, 31 Jul 2004 17:33:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3zn5gnqcp.fsf@merlin.emma.line.org>
References: <20040718030514.GJ1105@eriador.mirkwood.net>
	<20040724165625.GA1105@eriador.mirkwood.net>
	<m3zn5nxi6j.fsf@merlin.emma.line.org>
	<20040726160214.GB1105@eriador.mirkwood.net>
	<20040726161825.GA14799@merlin.emma.line.org>
	<20040728124509.GK1105@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:63213 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S267699AbUGaPdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jul 2004 11:33:46 -0400
In-Reply-To: <20040728124509.GK1105@eriador.mirkwood.net>
	(pf-linux-scsi-20040717@mirkwood.net's message of "Wed, 28 Jul 2004
	08:45:09 -0400")
List-Id: linux-scsi@vger.kernel.org
To: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Cc: linux-scsi@vger.kernel.org

PinkFreud <pf-linux-scsi-20040717@mirkwood.net> writes:

> Alas, 2.4.26's Documentation/ only seems to contain:
> scsi-changer.txt  scsi-generic.txt  scsi.txt          
>
> Nothing directly referencing sym53c8xx.

In 2.4, the documentation is in drivers/scsi/sym53c8xx_2/Documentation.txt

> I've looked at the sym53c8xx docs from 2.6.x, though.  You're right in
> saying they're detailed.  Unfortunately, there are quite a few options
> one can pass to the driver, and I'm not sure which might help me, and
> what arguments I should use.
>
> It's like trying to find a needle in a haystack... in the dark.

You have these options AFAICS:

1- Only applies if your adapator is one with either Symbios/LSI or
   Tekram BIOS: just disable disconnect for the device in the BIOS
   The driver inherits the BIOS settings.

2- echo "setflag 4 no_disc" >/proc/scsi/sym53c8xx/0
   The 4 needs to be changed to the device's ID
   and the 0 at the end may need adjustment if you have more than one of
   these adaptors or if you'd unloaded and reloaded the sym53c8xx module
   (If you've built it as module).

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
