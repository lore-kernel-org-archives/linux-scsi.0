From: Jens Schmalzing <j.s@lmu.de>
Subject: Re: CONFIG_SCSI_SYM53C8XX_IOMAPPED
Date: 16 Sep 2004 16:22:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <hh656el2dd.fsf@alsvidh.mathematik.uni-muenchen.de>
References: <hhsm9iv8ws.fsf@alsvidh.mathematik.uni-muenchen.de>
	<20040916141323.GL642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alsvidh.mathematik.uni-muenchen.de ([129.187.111.42]:24515 "EHLO
	alsvidh.mathematik.uni-muenchen.de") by vger.kernel.org with ESMTP
	id S268097AbUIPOW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2004 10:22:57 -0400
In-Reply-To: <20040916141323.GL642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org

Hi,

Matthew Wilcox writes:

> As upstream maintainer, I'd like more information about it please ...

>  - How does it "not work properly"?  Does it hang on first access to
>    the chip, or does it suffer data corruption?

It outputs a "can't map PCI MMIO region" and does nothing at all.

>  - Are the io memory resources on this Thinkpad properly programmed?

Most likely they aren't.  Any idea how I could find out?

>  - What kernel were you trying, 2.4 or 2.6?

I was using the official Debian kernel, version 2.6.8, from the
installation CD, built with:

CONFIG_SCSI_SYM53C8XX_2=3Dm
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

Regards, Jens.

--=20
J'qbpbe, le m'en fquz pe j'qbpbe!
Le veux aimeb et mqubib panz je p=E9zqbpbe je djuz tqtaj!
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
