From: devzero@web.de
Subject: fw: smartd crashing recent 2.6.32 kernel
Date: Tue, 26 Jan 2010 23:01:07 +0100
Message-ID: <1114886585@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:64212 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0AZWWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 17:22:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: support@lsi.com

maybe someone has a clue....!?

see https://bugzillafiles.novell.org/attachment.cgi?id=3D338427

that box seems to crash in megaraid_mbox driver as soon as smartd is st=
arting - even with recent 2.6.32 kernel.

as this box will go into production between mid/end of february, i thin=
k that is not much time if there is something to fix (and then being te=
sted/confirmed to be fixed)

regards
roland


> -----Urspr=FCngliche Nachricht-----
> Von: <devzero@web.de>
> Gesendet: 25.01.10 12:15:09
> An: smartmontools-support@lists.sourceforge.net
> Betreff: smartd crashing recent 2.6.32 kernel
> Hi,=20
>=20
> just wanted to let you know that smartd is crashing my system at late=
 installation stage.
>=20
> have opened novell bugticket #573244 ( https://bugzilla.novell.com/sh=
ow_bug.cgi?id=3D573244 ) for this.
>=20
> regards
> roland
>=20


________________________________________________________________
Nur noch bis 31.01.2010: DSL Komplettpaket f=FCr 16,99 Euro/mtl.!*
http://produkte.web.de/go/02/

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
