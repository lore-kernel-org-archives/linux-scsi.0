From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: missing mptsas support for  LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS [1000:0055] (rev 02)
Date: Fri, 19 Nov 2010 19:39:07 +0100
Message-ID: <201011191939.07573.a.miskiewicz@gmail.com>
References: <201011191842.25939.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45036 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab0KSSjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 13:39:12 -0500
Received: by ewy5 with SMTP id 5so692097ewy.19
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2010 10:39:11 -0800 (PST)
In-Reply-To: <201011191842.25939.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

On Friday 19 of November 2010, Arkadiusz Miskiewicz wrote:
> Hi,
>=20
> I wonder if mptsas driver is able to support this hardware?
>=20
> 04:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS=
1068
> PCI- X Fusion-MPT SAS [1000:0055] (rev 02)
>         Subsystem: Intel Corporation Device [8086:3504]
>=20
> Currently driver doesn't handle 1000:0055 pciid. The problem seems qu=
ite
> old since I found someone asking for it long time ago
> http://lkml.org/lkml/2007/1/23/87

[root@rescue mptsas]# echo 1000 0055 > new_id
[root@rescue mptsas]#

drives were detected, I was able to create filesystem, write, read few =
files
and these short tests worked well.=20

So I wonder what's the case with it not being added to mptsas driver? T=
hanks.

[ 5689.436551] mptsas 0000:04:08.0: PCI INT A -> GSI 16 (level, low) ->=
 IRQ 16
[ 5689.436886] mptbase: ioc0: Initiating bringup
[ 5690.042770] ioc0: : Capabilities=3D{Initiator}
[ 5699.421066] scsi8 : ioc0: , FwRev=3D01120000h, Ports=3D1, MaxQ=3D511=
, IRQ=3D16
[ 5699.458704] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id=
 0, phy 0, sas_addr 0x1221000000000000
[ 5699.461495] scsi 8:0:0:0: Direct-Access     ATA      ST9500420AS    =
  SDM1 PQ: 0 ANSI: 5
[ 5699.465182] sd 8:0:0:0: [sda] 976773168 512-byte logical blocks: (50=
0 GB/465 GiB)
[ 5699.465822] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id=
 1, phy 1, sas_addr 0x1221000001000000
[ 5699.466599] sd 8:0:0:0: Attached scsi generic sg0 type 0
[ 5699.469232] scsi 8:0:1:0: Direct-Access     ATA      ST9500420AS    =
  SDM1 PQ: 0 ANSI: 5
[ 5699.471140] sd 8:0:1:0: Attached scsi generic sg1 type 0
[ 5699.472842] sd 8:0:1:0: [sdb] 976773168 512-byte logical blocks: (50=
0 GB/465 GiB)
[ 5699.801422] sd 8:0:0:0: [sda] Write Protect is off
[ 5699.801425] sd 8:0:0:0: [sda] Mode Sense: 73 00 00 08
[ 5699.806427] sd 8:0:1:0: [sdb] Write Protect is off
[ 5699.806431] sd 8:0:1:0: [sdb] Mode Sense: 73 00 00 08
[ 5699.822024] sd 8:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[ 5699.827135] sd 8:0:1:0: [sdb] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
[ 5699.928108]  sda:
[ 5699.933163]  sdb: unknown partition table
[ 5699.962440]  unknown partition table
[ 5700.068369] sd 8:0:0:0: [sda] Attached SCSI disk
[ 5700.073759] sd 8:0:1:0: [sdb] Attached SCSI disk


--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
