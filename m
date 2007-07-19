From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 0/4] PS3 storage driver updates (was: Re: [patch 1/3] ps3:
 Disk Storage Driver)
Date: Thu, 19 Jul 2007 15:52:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191548070.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org>
 <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
 <20070719021045.c0b994ca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-146660919-1184852977=:8661"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43762 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S937928AbXGSNwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 09:52:37 -0400
In-Reply-To: <20070719021045.c0b994ca.akpm@linux-foundation.org>
Content-ID: <Pine.LNX.4.62.0707191549510.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-146660919-1184852977=:8661
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707191549511.8661@pademelon.sonytel.be>

	Hi Andrew,

On Thu, 19 Jul 2007, Andrew Morton wrote:
> On Thu, 19 Jul 2007 10:57:53 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > On Wed, 18 Jul 2007, Andrew Morton wrote:
> > > Your patchset significantly hits powerpc, scsi and block.  So who gets to
> > > merge this?  Jens?  James?  Paul?
> > > 
> > > Me, I guess ;)
> > 
> > As Paul is on holidays, please take it.
> 
> OK.
> 
> > The PS3 storage driver core support is
> > already in mainline, but the actual drivers aren't, as Paul was waiting for
> > acks from the maintainers.
> > 
> > BTW, do you prefer incremental patches for the comments below, or an update of
> > the full patchset?
> 
> Incremental is preferred, but I convert replacement patches into
> incremental patches at about 10Hz nowadays.  Whatever's easier.
> 
> (Actually, if it's a replacement patch then only I get to see the
> incremental patch, and the incremental patch is more reviewer-friendly).

Here are the updates:
  [1] ps3disk: use correct bio vector size
  [2] ps3disk: updates after final review
  [3] ps3rom: updates after final review
  [4] ps3flash: updates after final review

The first one is the bugfix for O_DIRECT, the other 3 patches are the updates
in response to your review.

Thanks for integrating (and forwarding to Linus)!

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-146660919-1184852977=:8661--
