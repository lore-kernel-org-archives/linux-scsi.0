From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 14:27:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD513D@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:440 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265099AbUFAS1p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 14:27:45 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: linux-scsi@vger.kernel.org

It's not the driver that needs to know, it's an information box on the
RAID applications that need to know via a management ioctl (see the
public domain raidutil tool for the cli variant). It's the `dptsig' tool
that reads the binary and provides version and processor type the binary
is compiled for.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Andi Kleen [mailto:ak@muc.de] 
Sent: Tuesday, June 01, 2004 2:21 PM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org
Subject: Re: 2.6.6 + Adaptec I2O

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:

> PROC_SEXIUM was reserved by our application software group when we
added
> PROC_PENTIUM. PROC_SEXIUM was simply a `followon' processor of a
> different feather. The dptsig.h file actually is shared with (many)
> other sources, so it carries an impact.
>
> Branching this file, notwithstanding ... sooo ... if it is to change,
> maybe it should be set to PROC_EM64T ...

Better call it PROC_X86_64 then. That's the standard name for the 
architecture on Linux.

What is this used for anyways? I'm not really sure why a driver should
know about the CPU type. How about just dropping it?

-Andi


