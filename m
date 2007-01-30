From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: Fw: SAS1068 PCI-X Fusion-MPT SAS 1000:0055
Date: Tue, 30 Jan 2007 17:05:48 +0100
Message-ID: <45BF6CDC.1080102@ext.bull.net>
References: <664A4EBB07F29743873A87CF62C26D7055ECA0@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51200 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965381AbXA3QFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2007 11:05:54 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7055ECA0@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, areq@areq.eu.org, Andrew Morton <akpm@osdl.org>

Hi,

Also seen on a NEC server, a 1068 chip with a jumper used to switch chi=
p
PCI ID and its BIOS:
- PCI ID =3D 0054 =3D> 'MPT Fusion' BIOS
- PCI ID =3D 0055 =3D> 'MegaRAID' BIOS

I'm feeling that I submit this unusual chip ID to pciid DB some month a=
go...

More important: there's a driver for this chip when it is used in
'MegaRAID' mode (standard 'mptsas' driver may be used for MPT Fusion
mode) . This driver is named 'megasr' and is available (binaries) from
several server vendors (Intel/Supermicro/Hitachi...) for standard distr=
o
(RH,Suse).
Seems that this driver is provided by LSI (modinfo)...

regards
--
=46red


Moore, Eric a =E9crit :
> On Friday, January 26, 2007 12:53 PM, Jun'ichi Nomura wrote:=20
>> Hi,
>>
>>> I have new NEC server with SAS1068 PCI-X Fusion-MPT SAS
>>> pciid: 1000:0055
>>> mptsas form 2.6.20-rc5 don't recognize it ;(
>>>
>>> I see that driver support only 1000:0054 and 1000:0058 devices.
>> It might be that the device has software RAID feature and changes
>> device ID based on setup. (1000:0055 when software RAID is enabled
>> and 1000:0054 or something for normal SAS)
>>
>> If so, there is a chance you can disable the software RAID
>> via BIOS setup utility.
>>
>> Thanks,
>> --=20
>> Jun'ichi Nomura, NEC Corporation of America
>>
>=20
> You probably want to talk to the megaraid folks and see
> if the have a driver for that.
>=20
> I didn't submit a device id of 0055 to sourceforge.
>=20
> The only 1068 ids that are clamied by mptsas is 0054 and 0058
> which are the pcix and pcie solutions.   I notice that 0055 is
> listed in repository, but it was not me that submitted that.
> http://pci-ids.ucw.cz/iii/?i=3D1000=20
>=20
> Eric Moore
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
