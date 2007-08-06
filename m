From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] Playstation 3 BD-ROM access and LV1_DENIED_BY_POLICY
Date: Mon, 6 Aug 2007 15:38:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0708061533230.31116@pademelon.sonytel.be>
References: <46B1F92C.8030206@am.sony.com>  <1186072148.13194.46.camel@haakon2.linux-iscsi.org>
  <20070803110537.A84C.MOKUNO@sm.sony.co.jp> <1186133997.3198.19.camel@haakon2.linux-iscsi.org>
 <46B3770E.4070805@am.sony.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-338147029-1186407220=:31116"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46990 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762254AbXHFNiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 09:38:04 -0400
In-Reply-To: <46B3770E.4070805@am.sony.com>
Content-ID: <Pine.LNX.4.62.0708061533440.31116@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@kernel.org>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>, Masakazu Mokuno <mokuno@sm.sony.co.jp>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-338147029-1186407220=:31116
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0708061533441.31116@pademelon.sonytel.be>

On Fri, 3 Aug 2007, Geoff Levand wrote:
> Nicholas A. Bellinger wrote:
> > Thank you for this information.  I since been able to resolve my issue
> > on 2.6.16 (which ended up being my fault), and was able to determine
> > that the issue on 2.6.23-rc1 is due to
> > drivers/scsi/scsi_lib.c:scsi_execute_async() rejecting READ_10 and
> > TEST_UNIT_READY commands in certain cases (perhaps a race in
> > drivers/scsi/ps3rom.c..?) using this API that was causing the win32 side
> > to throw exceptions.
> 
> If you get more info on what was happening here, please report it to Geert
> so he can investigate.  He should return next week.

Indeed.

Perhaps because ps3rom cannot queue more than 1 command?
I'm CCing the SCSI guys, just in case this rings a bell.

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
---584337861-338147029-1186407220=:31116--
