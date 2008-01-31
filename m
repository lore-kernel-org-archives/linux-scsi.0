From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [PATCH] ps3rom: sector size should be 512 bytes
Date: Thu, 31 Jan 2008 19:48:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801311947380.957@vixen.sonytel.be>
References: <dc3abf350801290318u66474599n2f293832373f3706@mail.gmail.com>
 <Pine.LNX.4.64.0801311414380.15534@vixen.sonytel.be>
 <1201788625.11265.23.camel@haakon2.linux-iscsi.org>
 <1201793647.3131.8.camel@localhost.localdomain> <1201795855.11265.67.camel@haakon2.linux-iscsi.org>
 <1201796764.3131.15.camel@localhost.localdomain>
 <1201800489.11265.134.camel@haakon2.linux-iscsi.org>
 <Pine.LNX.4.64.0801311840230.15534@vixen.sonytel.be>
 <1201802761.3131.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-876994926-1201805295=:957"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62256 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757710AbYAaSsR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 13:48:17 -0500
In-Reply-To: <1201802761.3131.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Aegis Lin <aegislin@gmail.com>, Masakazu Mokuno <Masakazu_Mokuno@hq.scei.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@lst.de>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-876994926-1201805295=:957
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 31 Jan 2008, James Bottomley wrote:
> On Thu, 2008-01-31 at 18:41 +0100, Geert Uytterhoeven wrote:
> > James, do you have any comment about the first email in this thread, increasing
> > scsi_host_template.max_sectors?
> 
> Assuming your BOUNCE_SIZE is in bytes, and represents your largest
> transfer, then yes, setting .max_sectors to BOUNCE_SIZE>>9 is exactly
> the right way of phrasing this, since .max_sectors is counted in units
> of the internal block sector (or 512 bytes).

OK, thanks for the confirmation!

> Were you going to submit a full patch to linux-scsi?

Yes I will.

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
---584349381-876994926-1201805295=:957--
