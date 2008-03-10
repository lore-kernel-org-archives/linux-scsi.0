From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 04/10] ps3rom: use sg buffer copy helper funcitons
Date: Mon, 10 Mar 2008 11:15:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803101115070.22505@vixen.sonytel.be>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1478031325-1205144137=:22505"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43984 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbYCJKPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 06:15:38 -0400
In-Reply-To: <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1478031325-1205144137=:22505
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 9 Mar 2008, FUJITA Tomonori wrote:
> Note that if scsi_bufflen(cmd) is not zero, the command always has an
> sg list. So this patch doesn't do the error checking in
> fill_from_dev_buffer and fetch_to_dev_buffer did.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

Look OK (but not really tested yet by me).

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
---584349381-1478031325-1205144137=:22505--
