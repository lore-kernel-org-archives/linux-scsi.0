From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 2/2] ps3rom: Simplify fill_from_dev_buffer()
Date: Mon, 25 Feb 2008 17:19:17 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802251719050.31208@vixen.sonytel.be>
References: <1203895523-4009-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0802251420270.31208@vixen.sonytel.be>
 <Pine.LNX.4.64.0802251423470.31208@vixen.sonytel.be> <20080224235154E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-428809084-1203956357=:31208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40636 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753969AbYBYQTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 11:19:19 -0500
In-Reply-To: <20080224235154E.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-428809084-1203956357=:31208
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Feb 2008, FUJITA Tomonori wrote:
> On Mon, 25 Feb 2008 14:24:31 +0100 (CET)
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> > Subject: [PATCH] ps3rom: Simplify fill_from_dev_buffer()
> > 
> > As we no longer need to calculate the data length of the whole scatterlist,
> > we can abort the loop earlier and coalesce req_len and act_len into one
> > variable, making fill_from_dev_buffer() more similar to fetch_to_dev_buffer().
> 
> I'll add new APIs to copy data between a sg list and a buffer soon
> after cleaning up (and fixing) some drivers on this area. I plan to
> remove fill_from_dev_buffer and fetch_to_dev_buffer in ps3rom. As you
> know, they are same functions that scsi_debug uses. There are other
> drivers that need similar functions. I expect my ps3rom patch to be
> applied to the scsi-fixes tree so I didn't change much as you did in
> this patch.

IC, thanks!

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
---584349381-428809084-1203956357=:31208--
