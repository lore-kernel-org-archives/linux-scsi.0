From: Adrian Bunk <bunk@stusta.de>
Subject: Re: Problem with 2.6.14 and up...
Date: Fri, 13 Jan 2006 00:21:04 +0100
Message-ID: <20060112232104.GD29663@stusta.de>
References: <200511211724.47826.jsanchez@todounix.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57092 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1161463AbWALXVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 18:21:05 -0500
Content-Disposition: inline
In-Reply-To: <200511211724.47826.jsanchez@todounix.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Jos=E9_Luis_S=E1nchez?= <jsanchez@todounix.homeip.net>
Cc: linux-kernel@vger.kernel.org, axboe@suse.de, linux-scsi@vger.kernel.org, matthew@wil.cx

On Mon, Nov 21, 2005 at 05:24:47PM +0100, Jos=E9 Luis S=E1nchez wrote:

> Hi,

Hi Jos=E9,

> >From 2.6.14 I have a nasty problem with my SCSI devices. First, see =
my HW:
>=20
> ----------------------------------
> 00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Ho=
st bridge=20
> (rev 03)
> 00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP=
 bridge=20
> (rev 03)
> 00:04.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02=
)
> 00:04.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev=
 01)
> 00:04.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (re=
v 01)
> 00:04.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
> 00:0a.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (re=
v 26)
> 00:0b.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclo=
ne] (rev=20
> 64)
> 00:0d.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (=
rev 06)
> 00:0d.1 Input device controller: Creative Labs SB Live! MIDI/Game Por=
t (rev=20
> 06)
> 01:00.0 VGA compatible controller: nVidia Corporation NV28 [GeForce4 =
Ti 4200=20
> AGP 8x] (rev a1)
> ------------------------
>=20
> I'm using the ncr53c8xx SCSI driver. When I run K3b, the program stal=
ls a few=20
> minutes and this appears in the messages file:
>=20
> sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 0:0:1:0: Attached scsi CD-ROM sr0
> sr1: scsi3-mmc drive: 24x/16x writer cd/rw xa/form2 cdda tray
> sr 0:0:2:0: Attached scsi CD-ROM sr1
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> sr 0:0:1:0: Attached scsi generic sg1 type 5
> sr 0:0:2:0: Attached scsi generic sg2 type 5
>  0:0:5:0: Attached scsi generic sg3 type 1
> sr 0:0:2:0: phase change 2-1 12@01bbcf60 resid=3D6.
> sr 0:0:2:0: ABORT operation started.
> sr 0:0:2:0: ABORT operation timed-out.
> sr 0:0:2:0: DEVICE RESET operation started.
> sr 0:0:2:0: DEVICE RESET operation timed-out.
> sr 0:0:2:0: BUS RESET operation started.
> sym0: SCSI BUS reset detected.
> sym0: SCSI BUS has been reset.
> sr 0:0:2:0: BUS RESET operation complete.
> sr 0:0:2:0: phase change 2-1 12@01bbcf60 resid=3D6.
> Device not ready. Make sure there is a disc in the drive.
> Device not ready. Make sure there is a disc in the drive.
> sr 0:0:2:0: phase change 2-1 12@01bbcf60 resid=3D6.
> sr 0:0:2:0: phase change 2-3 12@01bbcf60 resid=3D2.
> sr 0:0:2:0: phase change 2-3 12@01bbcf60 resid=3D2.
> sr 0:0:2:0: phase change 2-3 12@01bbcf60 resid=3D2.
> ....
>=20
> I'm very sure what the SCSI card, the cabling and the devices are OK,=
 why=20
> don't have any problem with 2.4.32 kernel.
>=20
> Ideas?


is this problem still present in kernel 2.6.15?


> Jos=E9 Luis


cu
Adrian

--=20

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
