From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: sym53c8xx parity errors on SuSE 9.1's hwscan?
Date: Thu, 23 Sep 2004 10:45:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m31xgt9xw0.fsf@merlin.emma.line.org>
References: <m3y8j1q4gs.fsf@merlin.emma.line.org>
	<20040923023914.GV16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:54704 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268328AbUIWIpk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2004 04:45:40 -0400
In-Reply-To: <20040923023914.GV16153@parcelfarce.linux.theplanet.co.uk>
	(Matthew Wilcox's message of "Thu, 23 Sep 2004 03:39:14 +0100")
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> On Thu, Sep 23, 2004 at 01:16:51AM +0200, Matthias Andree wrote:
>> SuSE Linux 9.1 (kernel 2.6.5 + SuSE patch set, but also 2.6.7 or a bit
>> milder in 2.6.9-rc2-mm1) uses some SuSE-specific "hwprobe" or "hwinfo"
>> tool to scan for hardware.
>
> Does anyone have the source?  I'd be interested to see what it's up
> to.

It's GPL'd stuff, get the source (505,597 bytes) from
ftp://ftp.suse.com/pub/suse/i386/9.1/suse/src/hwinfo-8.38-0.src.rpm

Just run dd reading from some SCSI drive and hwinfo --all.  Don't do
that if you need the machine in the following two minutes...

While testing, I got one more variant today:

Sep 23 10:13:58 merlin kernel: sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
Sep 23 10:13:58 merlin kernel: sym0:1: ERROR (81:0) (8-0-0) (10/9d/0) @ (mem 48000818:ffffffff).
Sep 23 10:13:58 merlin kernel: sym0: regdump: da 00 00 9d 47 10 01 07 00 08 81 00 80 00 0f 0a ff 90 e4 0d 02 ff ff ff.
Sep 23 10:13:58 merlin kernel: sym0: SCSI BUS reset detected.
Sep 23 10:13:58 merlin kernel: sym0: SCSI BUS has been reset.

> I have a suggestion.  If the probe attempts to size the BARs of the
> chip, this is a destructive process that could well cause the chip to
> start spewing errors are require a reset to work again.

The "BAR" stuff goes well over my head at this time.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
