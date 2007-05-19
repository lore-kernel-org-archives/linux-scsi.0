From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Fri, 18 May 2007 18:52:51 -0700
Message-ID: <20070519015251.GD3463@n6502ukq19261.qlogic.org>
References: <939b36a7f9795b71218bb5b4905e6250@cgw.capvert.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7598 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXESBwz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2007 21:52:55 -0400
Content-Disposition: inline
In-Reply-To: <939b36a7f9795b71218bb5b4905e6250@cgw.capvert.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johan Kragsterman <johan.kragsterman@capvert.se>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, sandip shete <sandipshete@gmail.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Fri, 18 May 2007, Johan Kragsterman wrote:

> >Most probably, the driver by link sent by Matthew Jacob will be a go=
od=20
> >starting point, where you can see examples how to work with the card=
, so=20
> >you can add it to the qla2x00t driver. Also you will need a manual t=
he=20
> >firmware interface specification for 2400 series of the cards. It is=
=20
> >under NDA, but you maybe lucky to get one from QLogic. Feel free to =
ask=20
> >me any SCST or qla2x00t driver related questions.
> >
> >> I have adequate experience of programming in the SCSI domain, howe=
ver i=20
> >> am not much conversant with the QLA driver code.
>=20
> That=B4s a very nice initiativ! Though I believe the most important t=
arget
> driver to develope is one for a PCI-Express HBA. I believe QLA24xx st=
ands
> for PCI-X, doesn=B4t it? And the PCI-Express HBA is called QLE-someth=
ing? But
> maybe with this driver we will come closer to a PCI-Express HBA targe=
t
> driver?

QLogic doesn't formally release target-mode drivers for their ISP
chips.  Matthew J. has done a great job at providing a community
available souce-base from which to draw ideas and code from.

Regards,
Andrew Vasquez
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
