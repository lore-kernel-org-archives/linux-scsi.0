From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't work with LSI MegaRAID i4 since release 2.00.4
Date: Wed, 14 Feb 2007 17:19:52 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229921145@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46325 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbXBOAU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 19:20:29 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Belhomme <rico@ricospirit.net>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>


megaraid_mbox and megaraid_mm  are the modules for "new generation".
There is no dependency of these modules to megaraid legacy.
Could you please send me the lspci output from the system under test?

--Sumant

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Eric Belhomme
Sent: Wednesday, February 14, 2007 1:55 AM
To: James Bottomley
Cc: Andrew Morton; linux-scsi@vger.kernel.org; bugme-daemon@kernel-bugs=
=2Eosdl.org
Subject: Re: Fw: [Bugme-new] [Bug 7999] New: MegaRAID Legacy doesn't wo=
rk with LSI MegaRAID i4 since release 2.00.4

James Bottomley a =E9crit :

>> So if I understand well, the module actively used with the LSI card=20
>> is megaraid, the legacy one ! but the mbox and mm are loaded and=20
>> seems to be necessary for the legacy driver ?
>=20
> Actually, it shouldn't be.  megaraid_mbox depends on megaraid_mm as=20
> your lsmod shows, which is correct.  However, nothing's depending on=20
> legacy megaraid ... I'm not sure why it's showing as loaded and in us=
e.
>=20
but it is ! moreover I have a /proc/megaraid/hba1/ directory structure =
fully filled with my RAID card, drives, and RAID volumes informations, =
and I don't hav any entry in sysfs directory tree (witch is the right p=
lace for megaraid NG module)

I'd like to understand _why_ this module supposed to be independant fro=
m the "new generation" megaraid module needs megaraid NG to be compiled=
 to work correctly ?

I looked over the sources but I didn't found any link between the legac=
y driver and the newgen one... quite strange !

Regards,

--
Rico

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the body of a message to majordomo@vger.kernel.org More majordomo inf=
o at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
