From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Mon, 05 Feb 2007 07:49:04 +0100
Message-ID: <45C6D360.7050206@ext.bull.net>
References: <664A4EBB07F29743873A87CF62C26D7055ECA0@NAMAIL4.ad.lsil.com> <45BF6CDC.1080102@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59433 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbXBEGtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 01:49:04 -0500
In-Reply-To: <45BF6CDC.1080102@ext.bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

Eric,


Do you have more information about 'megasr' module, which seems able to
manage 'MegaRAID' on LSI 1068 ?

This module is also named 'megaswr'

Here's modinfo output for this module (binary for RH4, but can also be
found for SLES9)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[root@iotiger2 x86_64]# modinfo megaswr.ko
filename:       megaswr.ko
parm:           low_mem_g:Set to 1 to simulate low mem condition
parm:           dbglvl_g:driver-wide debug flag
license:        GPL
description:    LSI Logic SofrRAID Driver
author:         LSI Logic Corporation
alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
=2E..
alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
alias:          pci:v00000000d00000000sv00000000sd00000000bc*sc*i*
depends:        scsi_mod
vermagic:       2.6.9-22.ELsmp SMP gcc-3.4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


=3D> the module is provided by LSI (I get it from the web from supermic=
ro)
=3D> the module is under GPL (but sources aren't shipped, nor the GPL
license )
=3D> the module is shipped with a 'pci.ids' file, with following conten=
t:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
0x8086 0x2652   "megaswr"       "MegaSWR|INTEL-ICH6R"
0x8086 0x2682   "megaswr"       "MegaSWR|INTEL-ESB2"
0x8086 0x27C1   "megaswr"       "MegaSWR|INTEL-ICH7R"
0x8086 0x27C3   "megaswr"       "MegaSWR|INTEL-ICH7R"
0x1000 0x0030   "megaswr"       "MegaSWR|LSILogic-1030"
0x1000 0x0050   "megaswr"       "MegaSWR|LSILogic-1064"
0x1000 0x0054   "megaswr"       "MegaSWR|LSILogic-1068"
0x1000 0x0055   "megaswr"       "MegaSWR|LSILogic-1068"
0x1000 0x0057   "megaswr"       "MegaSWR|LSILogic-1064E"
0x1000 0x0059   "megaswr"       "MegaSWR|LSILogic-1068E"
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
(note the chip with id 1000:0055)

Hope that you can give us more details...

regards
--
=46rederic TEMPORELLI




=46rederic TEMPORELLI a =E9crit :
> Hi,
>=20
> Also seen on a NEC server, a 1068 chip with a jumper used to switch c=
hip
> PCI ID and its BIOS:
> - PCI ID =3D 0054 =3D> 'MPT Fusion' BIOS
> - PCI ID =3D 0055 =3D> 'MegaRAID' BIOS
>=20
> I'm feeling that I submit this unusual chip ID to pciid DB some month=
 ago...
>=20
> More important: there's a driver for this chip when it is used in
> 'MegaRAID' mode (standard 'mptsas' driver may be used for MPT Fusion
> mode) . This driver is named 'megasr' and is available (binaries) fro=
m
> several server vendors (Intel/Supermicro/Hitachi...) for standard dis=
tro
> (RH,Suse).
> Seems that this driver is provided by LSI (modinfo)...
>=20
> regards
> --
> Fred
>=20
>=20
> Moore, Eric a =E9crit :
>> On Friday, January 26, 2007 12:53 PM, Jun'ichi Nomura wrote:=20
>>> Hi,
>>>
>>>> I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
>>>> pciid: 1000:0055
>>>> mptsas form 2.6.20-rc5 don't recognize it ;(
>>>>
>>>> I see that driver support only 1000:0054 and 1000:0058 devices.
>>> It might be that the device has software RAID feature and changes
>>> device ID based on setup. (1000:0055 when software RAID is enabled
>>> and 1000:0054 or something for normal SAS)
>>>
>>> If so, there is a chance you can disable the software RAID
>>> via BIOS setup utility.
>>>
>>> Thanks,
>>> --=20
>>> Jun'ichi Nomura, NEC Corporation of America
>>>
>> You probably want to talk to the megaraid folks and see
>> if the have a driver for that.
>>
>> I didn't submit a device id of 0055 to sourceforge.
>>
>> The only 1068 ids that are clamied by mptsas is 0054 and 0058
>> which are the pcix and pcie solutions.   I notice that 0055 is
>> listed in repository, but it was not me that submitted that.
>> http://pci-ids.ucw.cz/iii/?i=3D1000=20
>>
>> Eric Moore
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
