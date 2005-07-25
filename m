From: Steve McIntyre <steve@einval.com>
Subject: Re: Is it possible to support a sector size 8192
Date: Mon, 25 Jul 2005 20:08:48 +0100
Message-ID: <E1Dx8Jk-0006vH-Ra@sledge.mossbank.org.uk>
References: <E1Dw26Z-0005m7-JQ@sledge.mossbank.org.uk> <200507231528.20356.jhml@gmx.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:13326 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S261442AbVGYTJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 15:09:00 -0400
In-Reply-To: <dc31bt$6ti$1@dent.deepthot.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: denebeim@deepthot.org
Cc: linux-scsi@vger.kernel.org

Jay Denebeim wrote:
>In article <200507231528.20356.jhml@gmx.net>,
>Johann Hanne <jhml@gmx.net> wrote:
>>Wow, an answer directly from Plasmon, that's nice. :-)
>
>>I've already got the FUSE driver (udofs-1.1-92.i386.rpm, based on
>>FUSE 1.4, is this current?!). It is nice for a standalone drive, but
>>we use a SCSI robotic changer in conjunction with an HSM system
>>(Legato DiskXtender 2.9) which needs some kind of direct access to
>>the drive. It probes for /dev/nst*, but I guess /dev/sd* would also
>>work.
>
>I'm a little confused here.  Tape devices have variable sector sizes.
>I believe they're required to handle up to 64K in a unix environment.
>The drives I work on go up to 256k.

Tapes are different. The UDO drive that Johann was asking about is an
optical _disk_ drive...

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
Support the Campaign for Audiovisual Free Expression: http://www.eff.org/cafe/
