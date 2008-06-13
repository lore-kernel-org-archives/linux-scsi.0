From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media
 change and delay
Date: Fri, 13 Jun 2008 19:33:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1094079654-1213378380=:30730"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54063 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750991AbYFMRdD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2008 13:33:03 -0400
In-Reply-To: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: David Martin <tasio@tasio.net>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1094079654-1213378380=:30730
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 Jun 2008, Geert Uytterhoeven wrote:
> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
> from it, we get:

Apparently the fix didn't make it to all the CCed lists...

http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1094079654-1213378380=:30730--
