From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Linux-2.6.13-rc6: aic7xxx testers please..
Date: Tue, 09 Aug 2005 14:58:36 -0500
Message-ID: <1123617516.5170.42.camel@mulgrave>
References: <Pine.LNX.4.58.0508071136020.3258@g5.osdl.org>
	 <200508081954.52638.jesper.juhl@gmail.com>
	 <17145.1417.329260.524528@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42125 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932419AbVHIT7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 15:59:02 -0400
In-Reply-To: <17145.1417.329260.524528@smtp.charter.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-08-09 at 15:35 -0400, John Stoffel wrote:
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: COMPAQ   Model: HC01841729       Rev: 3208
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>   Vendor: COMPAQ   Model: BD018222CA       Rev: B016
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 06 Lun: 00
>   Vendor: SUN      Model: DLT7000          Rev: 1E48
>   Type:   Sequential-Access                ANSI SCSI revision: 02
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>   Vendor: EPSON    Model: Stylus Storage   Rev: 1.00
>   Type:   Direct-Access                    ANSI SCSI revision: 02

So basically the problem is on scsi1 with the tape device, which
apparently negotiates only narrow async?

What do the domain validation messages say about this device?  They
should be in dmesg.  I'm fairly certain that DLT tapes do better than
narrow async.

James


