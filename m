From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Wed, 18 Jul 2007 17:36:01 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707181735110.15632@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.392129000@pademelon.sonytel.be>
 <Pine.LNX.4.64.0707181632200.5385@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1585306974-1184772961=:15632"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33469 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755753AbXGRPgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 11:36:08 -0400
In-Reply-To: <Pine.LNX.4.64.0707181632200.5385@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alessandro Rubini <rubini@ipvvis.unipv.it>, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1585306974-1184772961=:15632
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 18 Jul 2007, Jan Engelhardt wrote:
> On Jul 16 2007 18:15, Geert Uytterhoeven wrote:
> >Add a Disk Storage Driver for the PS3:
> >  - Implemented as a block device driver with a dynamic major
> >  - Disk names (and partitions) are of the format ps3d%c(%u)
> >  - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
> >    doesn't support scatter-gather
> 
> I wonder what virtualization has to do with a block device driver?

On the PS3, storage devices are virtualized by the hypervisor (yes, the PS3
runs all OSes under a hypervisor).

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
---584337861-1585306974-1184772961=:15632--
