From: Jes Sorensen <jes@sgi.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: 18 Jan 2004 16:59:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074463172.1591.2.camel@lappy.trained-monkey.org>
References: <1074382860.1756.20.camel@mulgrave>
	 <20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
	 <20040118062157.GA11083@praka.local.home> <20040118073321.GC383498@sgi.com>
	  <1074437655.1804.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:13376 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S264163AbUARWAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 17:00:23 -0500
In-Reply-To: <1074437655.1804.12.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <praka@users.sourceforge.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-01-18 at 09:54, James Bottomley wrote:
> On Sun, 2004-01-18 at 02:33, Jeremy Higdon wrote:
> > James, with your code as it is now, ha->flags.enable_64bit_addressing
> > is always 0.  You'd need to add code to read the value out of the
> > nvram.  Then we'll need an nvram override for Altix.
> 
> Actually, I found it.  There was a missed endianness problem in the 64
> bit path (see patch).
> 
> However, I have another question for you:  Does the card BIOS actually
> get to run on bootup?  It doesn't (because it can't) on PA, so I get
> strange values for certain NVRAM quantities (like the 32 bit mode, but
> more importantly, the offset of all my devices gets set to 1).  I was
> thinking about doing an override to set them more sensibly and wondered
> if you were having the same problem.

Hi James,

Same problem on Altix, the BIOS can't run as there is no x86 emulation
in the EFI firmware on the box.

Cheers,
Jes


