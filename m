From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion
 (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Wed, 1 Oct 2008 09:51:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810010949100.8836@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
 <1214925487.3316.12.camel@localhost.localdomain>
 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
 <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
 <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
 <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
 <806dafc20809301110h2817e9e8g42ba031220763e9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1323908993-1222847467=:8836"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38701 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753423AbYJAHvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 03:51:10 -0400
In-Reply-To: <806dafc20809301110h2817e9e8g42ba031220763e9d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Monty Montgomery <monty@xiph.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1323908993-1222847467=:8836
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 30 Sep 2008, Monty Montgomery wrote:
> > It happens on anything after 2.6.24 (cfr.
> > http://bugzilla.kernel.org/show_bug.cgi?id=10974).
> > E.g. mainline 2.6.27-rc8.
> 
> Ah.
> 
> Geert, I'm sorry this has come up and thanks for bringing it to my attention.

The bugzilla link has been in the subjects of the emails all the time ;-)

> > In this case, sg means scatter/gather, and it's a purely internal
> > interface.  It does not start/stop the drive, nor the scsi interface.
> 
> Ah, I confused it with a much older utility that would up/down an SG
> device entirely.

It is the command line utility.
James suggested to use it to load the CD.

Before that, my test sequence was less deterministic and not fully automated
(insert CD, wait until the blue LED is lit, launch cdparanoia).

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1323908993-1222847467=:8836--
