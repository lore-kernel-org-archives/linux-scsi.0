From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Wed, 22 Dec 2004 02:09:40 +0100
Message-ID: <1103677780.6030.4.camel@zezette>
References: <EA4DC661A6353747A2E5C0DE8792DDDE074BF47E@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE074BF47E@orsmsx404.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Le mardi 21 d?embre 2004 =C3=A0 14:02 -0800, Caushik, Ramesh a =C3=A9cr=
it :
> The devinfo.c file in the multipath-tools-0.4.1 appears to have a typ=
o
> in the code to get the node_name attr in the fc_transport sysfs entry=
=2E
> Path below should fix it. BTW why does a failure to get a node_name
> attribute, result in failure of multipath discovery (because devinfo
> returns failure)even if the "group_by_node_name" policy is not used ?
> Can't we just NULL out the tgt_node_name string in the sysfs_devinfo
> routine and fail the group_by_node_name routine if that policy was
> chosen ? That is what happened in my case. Multipath discovery failed
> due to above reason even though node_name grouping was not specified.=
=20
>=20
You are absolutely right.

I was aware that introducing that FC-ism would break for iSCSI and othe=
r
transports. I just thought I'll get that right in a next release becaus=
e
I wasn't aware someone was using the thing in such an "exotic"
environment.

I would gladly get a description of your topology, by the way.
It would help to get it right in the future.

Anyway, I'll fix that for 0.4.2

regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
