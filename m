From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Wed, 22 Dec 2004 13:54:45 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE075013FE@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr17.intel.com ([134.134.136.16]:3772 "EHLO
	orsfmr002.jf.intel.com") by vger.kernel.org with ESMTP
	id S262056AbULVVzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2004 16:55:07 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

The newer Qlogic (qla2xxx) driver for kernel versions 2.6.9 and later d=
o not support the fc_transport class. The support is #ifdefed for kerne=
ls > 2.6.6 & < 2.6.9. So I will have to wait till they support this for=
 newer kernels. Meanwhile I can work with a patched version of multipat=
h tools. Thanks for feedback.=20

Ramesh.  =20

-----Original Message-----
=46rom: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com=
] On Behalf Of christophe varoqui
Sent: Wednesday, December 22, 2004 3:31 PM
To: device-mapper development
Cc: linux-raid@vger.kernel.org; linux-hotplug-devel@lists.sourceforge.n=
et; linux-scsi@vger.kernel.org
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1

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

Le mercredi 22 d?embre 2004 =E0 16:05 -0500, James.Smart@Emulex.Com a
=E9crit :
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


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
