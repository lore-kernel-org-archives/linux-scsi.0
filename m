From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Kernel driver for Adaptec S-ATA 1420SA
Date: Fri, 12 Aug 2005 17:02:18 -0500
Message-ID: <1123884138.5031.30.camel@mulgrave>
References: <42FCDE2D.10602@sinister.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:6067 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751300AbVHLWC2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 18:02:28 -0400
In-Reply-To: <42FCDE2D.10602@sinister.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sinister@sinister.cz
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-12 at 19:36 +0200, sinister@sinister.cz wrote:
> I bought the Adaptec S-ATA II-1420SA controller but I have a problem=20
> with this type.
> I use the Linux Slackware 10.1 with the Linux Kernel 2.6.12-4 but I=20
> didn=B4t find any driver for this S-ATA controller.
> I don't need RAID but I need a 4x S-ATA port.

Adaptec only publishes binary drivers for it's SATA RAID cards.

The rumour is that Adaptec doesn't make the SATA chips in these, but
OEM's them and then adds Adaptec softraid on top, so theoretically one
of the in-kernel SATA drivers might be able to attach to the OEM chip.
Your best bet would be to ask Adaptec support about it.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
