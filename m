From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [patch 02/17] Dell CERC support for megaraid_mbox
Date: Mon, 14 Apr 2008 09:56:43 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C265020D687C@NAMAIL1.ad.lsil.com>
References: <47FA1738.4020909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62660 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406AbYDNP5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 11:57:50 -0400
Content-class: urn:content-classes:message
In-Reply-To: <47FA1738.4020909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, "Patro, Sumant" <Sumant.Patro@lsi.com>

Hannes,

I was on vacation last week. Sorry for late response.  I am trying to f=
indout the details of the DELL FW 6.62 release and will give the update=
 as soon as I have them.

Regards.

Bo Yang  =20

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]=20
Sent: Monday, April 07, 2008 8:45 AM
To: Yang, Bo
Cc: akpm@linux-foundation.org; James.Bottomley@HansenPartnership.com; l=
inux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com; Patro, Sumant
Subject: Re: [patch 02/17] Dell CERC support for megaraid_mbox

Yang, Bo wrote:
> Hannes,
>=20
> We can not find out why need to disable the random deletion of the=20
> logical drive for the FW version>=3D6.62?  Where is the 6.62 come fro=
m?
>=20
=46rom the bug reports we had. Dell machines with a fw rev < 6.61 work =
with this driver, whereas newer rev (the said 6.62) don't.
As to the details: No idea. This is just what I found by comparing the =
older megaraid driver (which worked, but is unsupported) and the newer =
megaraid_mbox driver.
The noticeable difference was just the random deletion feature.
As I don't have any details about the driver I certainly can't tell you=
 any details. This is a workaround.
But as Dell (or LSI, for that matter) refuse to update the BIOS on thes=
e drivers we're stuck with it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
