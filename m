From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: LSI Logic SAS1064 PCI-X Fusion-MPT SAS
Date: Tue, 3 Jan 2006 14:54:21 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F153483@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4839 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964968AbWACVya convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 16:54:30 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Weber <email@steffenweber.net>
Cc: linux-scsi@vger.kernel.org

On Tuesday, January 03, 2006 12:30 PM, Steffen Weber wrote:

> I=B4m trying to install Linux 2.6.15 on a Sun Fire X4100, which has a=
=20
> Serial Attached SCSI (SAS) controller from LSI Logic:
>=20
> LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 02)
>=20
> I have enabled the following kernel config options:
> CONFIG_FUSION=3Dy
> CONFIG_FUSION_SAS=3Dy
> CONFIG_FUSION_MAX_SGE=3D128
> CONFIG_SCSI_SAS_ATTRS=3Dy
>=20
> When booting the controller is detected, but he does not see=20
> the disks:
>=20
> ...
> Fusion MPT base driver 3.03.04
> Copyright (c) 1999 - 2005 LSI Logic Corporation
> Fusion MPT SAS Host driver 3.03.04
> GSI 20 sharing vector 0xC9 and IRQ 20
> ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 28 (level, low) -> IRQ 16
> mptbase: Initiating ioc0 bringup
> ioc0: SAS1064: Capabilities=3D{Initiator}
> scsi0 : ioc0: LSISAS1064, FwRev=3D01040000h, Ports=3D1, MaxQ=3D511, I=
RQ=3D16
> ...
> [There is nothing releveant to the controller here]
> ...
> VFS: Cannot open root device "sda4" or unknown-block(0,0)
> Please append a correct "root=3D" boot option
> Kernel panic - not syncing: VFS: Unable to mount root fs on=20
> unknown-block(0,0

Are the disks belonging to a RAID volume?

Eric Moore
LSI Logic
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
