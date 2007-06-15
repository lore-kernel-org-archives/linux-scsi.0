From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 20:05:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0706152004090.15507@pademelon.sonytel.be>
References: <20070615113919.142332000@pademelon.sonytel.be>
 <20070615120848.352093000@pademelon.sonytel.be> <1181918159.25228.543.camel@pmac.infradead.org>
 <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
 <20070615171545.316dfac7@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1688040106-1181930705=:15507"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757022AbXFOSFp@vger.kernel.org>
In-Reply-To: <20070615171545.316dfac7@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1688040106-1181930705=:15507
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jun 2007, Alan Cox wrote:
> > > Any particular reason why this is done as a separate block device driver
> > > rather than as SCSI?
> > 
> > Because no new fake SCSI drivers are accepted anymore.
> 
> Where did drivers/ata come from ;)

I was told that one got in just before the moratorium on fake SCSI.

> How about making it a fake ata driver if James is being fussy 8)

I don't think Christoph likes fake ATA drivers neither ;-)

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
---584337861-1688040106-1181930705=:15507--
