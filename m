From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Thu, 23 Dec 2004 00:30:44 +0100
Message-ID: <1103758244.9893.6.camel@zezette>
References: <0B1E13B586976742A7599D71A6AC733C02F2CB@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp7.wanadoo.fr ([193.252.22.24]:13043 "EHLO smtp7.wanadoo.fr")
	by vger.kernel.org with ESMTP id S262040AbULVVWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2004 16:22:31 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F2CB@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James, thank you for the clarification (and I didn't mean to string
anyone :).

Ramesh, I don't feel like going through the hassle of supporting
multiple synthax until the multipath target has made its way into the
standard kernel, so I'll keep guessing the node_name in
behing /sys/class/fc_transport/target<host>:<channel>:<target> or skip
the node_name fetch.

ok with you ?

regards,
cvaroqui

Le mercredi 22 d?embre 2004 =C3=A0 16:05 -0500, James.Smart@Emulex.Com =
a
=C3=A9crit :
> Qlogic shouldn't be strung out. It wasn't them....
>=20
> As part of a change that went into the FC transport - the device repo=
rted under this directory was moved from the LUN device to the Target d=
evice - thus the change in name format (it killed replication of target=
 data that was being done for all luns). The attributes underneath rema=
in the same. I believe this change occurred in the first rc1 patch to 2=
=2E6.9.
>=20
> As to the grand plan - you should be fine if you :
>  pre-2.6.10: it's the older name format "/sys/class/fc_transport/<hos=
t>:<channel>:<target>:<lun>"
>  2.6.10 and later : it's the new format "/sys/class/fc_transport/targ=
et<host>:<channel>:<target>"
>=20
>  and the folks running a patched 2.6.9 have to live by the new format=
=2E
>=20
> --


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
