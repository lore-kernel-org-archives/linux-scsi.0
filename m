From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: Re: 2.6.9 aacraid hangup
Date: Fri, 22 Oct 2004 14:26:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022122625.GC12619@mail.muni.cz>
References: <60807403EABEB443939A5A7AA8A7458B40B78D@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hell.sks3.muni.cz ([147.251.210.30]:48780 "EHLO
	hell.sks3.muni.cz") by vger.kernel.org with ESMTP id S271278AbUJVM0e
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 08:26:34 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B40B78D@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2004 at 08:20:20AM -0400, Salyzyn, Mark wrote:
> Contact Adaptec technical support, you may have a bad card, bad Mothe=
rboard
> PCI bus or power supply, SCSI bus issues, or other H/W problems. Driv=
e
> compatibility (requiring Drive F/W changes) may also be an issue so m=
ake sure
> you list the actual drives model and release when you contact them.
>=20
> I believe the latest released F/W for this card is 7244, but I may be
> mistaken. Not sure if 6011 had the high priority cache flush problem =
(causing
> the card to be reticent for periods into the minutes) that plagues us=
 on some
> of the earlier F/W releases of the Dell ROMB products when introduced=
 to
> faster and faster host processors. One way of checking this out is to=
 turn off
> the card's cache (both read and write).

However I tested it today and with 2.6.6-bk4 it is OK.=20

Anyway with F/W 5770 it sometimes resulted with message:
kernel: aacraid:ID(1:02:0) Abort Time-out. Resetting bus.
kernel: aacraid:SCSI bus reset issued on channel 1
kernel: aacraid:Drive 1:0:0 online on container 0:
kernel: aacraid:Drive 1:1:0 online on container 0:
kernel: aacraid:Drive 1:2:0 online on container 0:
kernel: aacraid:Drive 1:3:0 online on container 0:

--=20
Luk=E1=B9 Hejtm=E1nek
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
