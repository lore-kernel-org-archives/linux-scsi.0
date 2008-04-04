From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas and ioc0: ERRORs
Date: Fri, 04 Apr 2008 11:42:01 -0500
Message-ID: <1207327321.3065.12.camel@localhost.localdomain>
References: <20080331150434.a3fb336b.taeuber@bbaw.de>
	 <20080403123107.71d82746.taeuber@bbaw.de>
	 <1207231308.3048.14.camel@localhost.localdomain>
	 <20080404091430.66daa159.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43276 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbYDDQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2008 12:42:07 -0400
In-Reply-To: <20080404091430.66daa159.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2008-04-04 at 09:14 +0200, Lars T=C3=A4uber wrote:
> Hi James,
>=20
> James Bottomley <James.Bottomley@HansenPartnership.com> schrieb:
> > Actually, LSI support might be better.  This:
> >=20
> > > Mar 28 21:45:37 monosan kernel: mptscsih: ioc0: attempting task a=
bort! (sc=3Dffff8100395bd1c0)
> > > Mar 28 21:45:48 monosan kernel: mptbase: Initiating ioc0 recovery
> > > Mar 28 21:45:48 monosan kernel: mptbase: ioc0: WARNING - IOC is i=
n FAULT state!!!
> > > Mar 28 21:45:51 monosan kernel: mptbase: ioc0: Recovered from IOC=
 FAULT
> >=20
> > Indicates some type of firmware problem on the card (ioc fault mean=
s
> > fault in the firmware engine).
>=20
> thank you for this descriptive info.=20
> =20
> > This:
> >=20
> > > Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - Received =
a mf that was already freed
> > > Mar 28 21:47:23 monosan kernel: mptscsih: ioc0: ERROR - req_idx=3D=
8380 req_idx_MR=3D8380 mf=3Dffff81007db02900 mr=3D0000000000000000 sc=3D=
0000000000000000
> >=20
> > Indicates a rendezvous failure between the ioc firmware and the dri=
ver.
> > The firmware is sending a response to a task that the driver thinks=
 it
> > previously sent.
>=20
> Ah, ok. It's really good to understand the errors a bit better.=20
>=20
> > The problem for us is that while the driver is open source, it's re=
ally
> > just a translator for the on board firmware engine.  If the firmwar=
e
> > engine is truly the cause of these faults, there's not much anyone
> > except LSI can do to help.
>=20
> Do you think it helps to ask LSI directly?

Well, I did cc LSI on my reply.  However, if you have current support
for your card, you can raise the temperature a bit by calling their
support line.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
