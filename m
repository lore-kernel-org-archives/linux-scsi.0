From: Steffen Weber <email@steffenweber.net>
Subject: LSI Logic SAS1064 PCI-X Fusion-MPT SAS
Date: Tue, 03 Jan 2006 20:30:16 +0100
Message-ID: <43BAD0C8.4040009@steffenweber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wp051.webpack.hosteurope.de ([80.237.132.58]:16512 "EHLO
	wp051.webpack.hosteurope.de") by vger.kernel.org with ESMTP
	id S932471AbWACTa0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 14:30:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I=B4m trying to install Linux 2.6.15 on a Sun Fire X4100, which has a=20
Serial Attached SCSI (SAS) controller from LSI Logic:

LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS (rev 02)

I have enabled the following kernel config options:
CONFIG_FUSION=3Dy
CONFIG_FUSION_SAS=3Dy
CONFIG_FUSION_MAX_SGE=3D128
CONFIG_SCSI_SAS_ATTRS=3Dy

When booting the controller is detected, but he does not see the disks:

=2E..
=46usion MPT base driver 3.03.04
Copyright (c) 1999 - 2005 LSI Logic Corporation
=46usion MPT SAS Host driver 3.03.04
GSI 20 sharing vector 0xC9 and IRQ 20
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 28 (level, low) -> IRQ 16
mptbase: Initiating ioc0 bringup
ioc0: SAS1064: Capabilities=3D{Initiator}
scsi0 : ioc0: LSISAS1064, FwRev=3D01040000h, Ports=3D1, MaxQ=3D511, IRQ=
=3D16
=2E..
[There is nothing releveant to the controller here]
=2E..
VFS: Cannot open root device "sda4" or unknown-block(0,0)
Please append a correct "root=3D" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on=20
unknown-block(0,0)

I=B4ve tried Linux 2.6.14 with no success, too. What could be the cause=
=20
that the disks are not detected?

Please cc me as I'm not subscribed to linux-scsi.

Thanks,
Steffen Weber
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
