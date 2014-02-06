From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Thu, 06 Feb 2014 14:26:16 +0100
Message-ID: <52F38D78.2070002@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de>	<52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>	<60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>	<52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>	<52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>	<CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>	<52F010F9.5090305@tributary.com> <52F389A9.808@suse.de> <yq1eh3gv0l9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259AbaBFN0S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 08:26:18 -0500
In-Reply-To: <yq1eh3gv0l9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, =?ISO-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

On 02/06/2014 02:21 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> Moving EVPD page 0x83 (and maybe 0x80, too) into sysfs will s=
ave
> Hannes> quite a lot of headache we have currently; udev won't have to
> Hannes> call 'sg_inq', information will be present even though the
> Hannes> device itself might be temporarily unavailable yadda yadda.
>=20
> Hannes> So I've decided to bite the bullet and sent out a patch, chec=
k
> Hannes> for 'Add EVPD page 0x83 entries to sysfs'.
>=20
> I'm already doing something similar since I need it for xcopy.
>=20
Hehe. Beat you to it.

> My patch provides both the original VPD 0x83 and 0x80 bits as well as=
 a
> handle identical to /sbin/scsi_id.
>=20
Bah, don't do that.
That should better be handled by udev rules.
I've got a set of patches moving from scsi_id to sg_inq, which can
be easily adapted to using sysfs directly.

Once we figure out if that's the direction we want to go ...

> I'll take a look at your patch later today...
>=20
Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
