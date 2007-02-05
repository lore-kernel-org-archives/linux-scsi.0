From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Mon, 5 Feb 2007 10:04:28 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70585801@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42927 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXBEREm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 12:04:42 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Cc: linux-scsi@vger.kernel.org

The 2.6.9-22.EL kernel is RHEL4 Update 2.   You may
want to contact someone from the LSI MegaRAID group,
or Red Hat since this is a binary only deliverable.  You
should be able to find a MegaRAID contact in the MAINTAINERS file
in the top directory of the kernel source tree.

I work on mpt fusion drivers, which is a seperate division within LSI.

Eric

On Sunday, February 04, 2007 11:49 PM, Frederic TEMPORELLI wrote:
>=20
> Eric,
>=20
>=20
> Do you have more information about 'megasr' module, which=20
> seems able to
> manage 'MegaRAID' on LSI 1068 ?
>=20
> This module is also named 'megaswr'
>=20
> Here's modinfo output for this module (binary for RH4, but can also b=
e
> found for SLES9)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@iotiger2 x86_64]# modinfo megaswr.ko
> filename:       megaswr.ko
> parm:           low_mem_g:Set to 1 to simulate low mem condition
> parm:           dbglvl_g:driver-wide debug flag
> license:        GPL
> description:    LSI Logic SofrRAID Driver
> author:         LSI Logic Corporation
> alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> ...
> alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
> depends:        scsi_mod
> vermagic:       2.6.9-22.ELsmp SMP gcc-3.4
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> =3D> the module is provided by LSI (I get it from the web from=20
> supermicro)
> =3D> the module is under GPL (but sources aren't shipped, nor the GPL
> license )
> =3D> the module is shipped with a 'pci.ids' file, with=20
> following content:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 0x8086 0x2652   "megaswr"       "MegaSWR|INTEL-ICH6R"
> 0x8086 0x2682   "megaswr"       "MegaSWR|INTEL-ESB2"
> 0x8086 0x27C1   "megaswr"       "MegaSWR|INTEL-ICH7R"
> 0x8086 0x27C3   "megaswr"       "MegaSWR|INTEL-ICH7R"
> 0x1000 0x0030   "megaswr"       "MegaSWR|LSILogic-1030"
> 0x1000 0x0050   "megaswr"       "MegaSWR|LSILogic-1064"
> 0x1000 0x0054   "megaswr"       "MegaSWR|LSILogic-1068"
> 0x1000 0x0055   "megaswr"       "MegaSWR|LSILogic-1068"
> 0x1000 0x0057   "megaswr"       "MegaSWR|LSILogic-1064E"
> 0x1000 0x0059   "megaswr"       "MegaSWR|LSILogic-1068E"
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> (note the chip with id 1000:0055)
>=20
> Hope that you can give us more details...
>=20
> regards
> --
> Frederic TEMPORELLI
>=20
>=20
>=20
>=20
> Frederic TEMPORELLI a =E9crit :
> > Hi,
> >=20
> > Also seen on a NEC server, a 1068 chip with a jumper used=20
> to switch chip
> > PCI ID and its BIOS:
> > - PCI ID =3D 0054 =3D> 'MPT Fusion' BIOS
> > - PCI ID =3D 0055 =3D> 'MegaRAID' BIOS
> >=20
> > I'm feeling that I submit this unusual chip ID to pciid DB=20
> some month ago...
> >=20
> > More important: there's a driver for this chip when it is used in
> > 'MegaRAID' mode (standard 'mptsas' driver may be used for MPT Fusio=
n
> > mode) . This driver is named 'megasr' and is available=20
> (binaries) from
> > several server vendors (Intel/Supermicro/Hitachi...) for=20
> standard distro
> > (RH,Suse).
> > Seems that this driver is provided by LSI (modinfo)...
> >=20
> > regards
> > --
> > Fred
> >=20
> >=20
> > Moore, Eric a =E9crit :
> >> On Friday, January 26, 2007 12:53 PM, Jun'ichi Nomura wrote:=20
> >>> Hi,
> >>>
> >>>> I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
> >>>> pciid: 1000:0055
> >>>> mptsas form 2.6.20-rc5 don't recognize it ;(
> >>>>
> >>>> I see that driver support only 1000:0054 and 1000:0058 devices.
> >>> It might be that the device has software RAID feature and changes
> >>> device ID based on setup. (1000:0055 when software RAID is enable=
d
> >>> and 1000:0054 or something for normal SAS)
> >>>
> >>> If so, there is a chance you can disable the software RAID
> >>> via BIOS setup utility.
> >>>
> >>> Thanks,
> >>> --=20
> >>> Jun'ichi Nomura, NEC Corporation of America
> >>>
> >> You probably want to talk to the megaraid folks and see
> >> if the have a driver for that.
> >>
> >> I didn't submit a device id of 0055 to sourceforge.
> >>
> >> The only 1068 ids that are clamied by mptsas is 0054 and 0058
> >> which are the pcix and pcie solutions.   I notice that 0055 is
> >> listed in repository, but it was not me that submitted that.
> >> http://pci-ids.ucw.cz/iii/?i=3D1000=20
> >>
> >> Eric Moore
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >=20
> > -
> > To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
