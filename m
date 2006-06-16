From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: "Please contact" message received in syslog
Date: Fri, 16 Jun 2006 20:22:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606162003500.4068@poirot.grange>
References: <646765f40606160438v7f10f390jc7804aac1d47c721@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:39583 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751289AbWFPSWz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jun 2006 14:22:55 -0400
In-Reply-To: <646765f40606160438v7f10f390jc7804aac1d47c721@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 16 Jun 2006, Julian Calaby wrote:

> I received the following message in my log:
> 
> drivers/scsi/dc395x.c: Please, contact <linux-scsi@vger.kernel.org> to
> help improve support for your system.
> 
> Umm, so here I am =)

Thanks for writing.

> I received this whilst burning a CD, and can attempt to re-produce it if
> needed.

First I'd like to ask you for some more information about your system: CPU 
(32/64 bit), amount of RAM, and if you get any other messages in your log 
around this one. Was it the first time you burned a CD on this system with 
this kernel? If not, maybe you could look in your logs if this message has 
come before, and, possibly, under which circumstances? Do you have other 
devices on this SCSI bus? Did the operation (CD-burning) succeed and was 
the CD burned correctly (maybe, read back and compare)?

If indeed the message is pretty reproducible (I don't want to ask you to 
burn 10 CDs to reproduce it once more:-)), maybe you could try to apply 
the following two patches:

http://marc.theaimsgroup.com/?l=linux-scsi&m=114400790021967&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114565338708969&w=2

in this order and re-test?

Thanks
Guennadi
---
Guennadi Liakhovetski
