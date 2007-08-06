From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] ps3rom: convert to use the data buffer accessors
Date: Mon, 6 Aug 2007 15:12:27 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0708061512060.31116@pademelon.sonytel.be>
References: <20070723094232S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-541239771-1186405947=:31116"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46640 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763455AbXHFNMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 09:12:33 -0400
In-Reply-To: <20070723094232S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-541239771-1186405947=:31116
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 23 Jul 2007, FUJITA Tomonori wrote:
> This is against Linus' tree since scsi-misc doesn't include ps3rom
> driver yet.
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] ps3rom: convert to use the data buffer accessors
> 
> This converts ps3rom driver to use the new accessors for the sg lists
> and the parameters.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

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
---584337861-541239771-1186405947=:31116--
