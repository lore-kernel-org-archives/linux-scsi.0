From: James.Smart@Emulex.Com
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Thu, 23 Dec 2004 07:19:15 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E90B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I know that the driver in the kernel.org tree supports the fc_transport=
, at least the part relative to the discussion below (I made the mods).=
  I can't speak for their other driver sets.

-- james

> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com]On
> Behalf Of Caushik, Ramesh
> Sent: Wednesday, December 22, 2004 4:55 PM
> To: device-mapper development
> Cc: linux-raid@vger.kernel.org;
> linux-hotplug-devel@lists.sourceforge.net; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
>=20
>=20
> The newer Qlogic (qla2xxx) driver for kernel versions 2.6.9=20
> and later do not support the fc_transport class. The support=20
> is #ifdefed for kernels > 2.6.6 & < 2.6.9. So I will have to=20
> wait till they support this for newer kernels. Meanwhile I=20
> can work with a patched version of multipath tools. Thanks=20
> for feedback.=20
>=20
> Ramesh.  =20
>=20
> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of christophe varoqui
> Sent: Wednesday, December 22, 2004 3:31 PM
> To: device-mapper development
> Cc: linux-raid@vger.kernel.org;=20
> linux-hotplug-devel@lists.sourceforge.net; linux-scsi@vger.kernel.org
> Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
>=20
> James, thank you for the clarification (and I didn't mean to string
> anyone :).
>=20
> Ramesh, I don't feel like going through the hassle of supporting
> multiple synthax until the multipath target has made its way into the
> standard kernel, so I'll keep guessing the node_name in
> behing /sys/class/fc_transport/target<host>:<channel>:<target> or ski=
p
> the node_name fetch.
>=20
> ok with you ?
>=20
> regards,
> cvaroqui
>=20
> Le mercredi 22 d?embre 2004 =E0 16:05 -0500, James.Smart@Emulex.Com a
> =E9crit :
> > Qlogic shouldn't be strung out. It wasn't them....
> >=20
> > As part of a change that went into the FC transport - the=20
> device reported under this directory was moved from the LUN=20
> device to the Target device - thus the change in name format=20
> (it killed replication of target data that was being done for=20
> all luns). The attributes underneath remain the same. I=20
> believe this change occurred in the first rc1 patch to 2.6.9.
> >=20
> > As to the grand plan - you should be fine if you :
> >  pre-2.6.10: it's the older name format=20
> "/sys/class/fc_transport/<host>:<channel>:<target>:<lun>"
> >  2.6.10 and later : it's the new format=20
> "/sys/class/fc_transport/target<host>:<channel>:<target>"
> >=20
> >  and the folks running a patched 2.6.9 have to live by the=20
> new format.
> >=20
> > --
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
