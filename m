From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: Fri, 12 Nov 2004 16:15:51 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C3FF742@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51671 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262666AbUKLXQB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2004 18:16:01 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iACNEKcq009970
	for <linux-scsi@vger.kernel.org>; Fri, 12 Nov 2004 15:14:20 -0800 (PST)
Received: from nacos172.ad.lsil.com (nacos172.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iACNFsoO030226
	for <linux-scsi@vger.kernel.org>; Fri, 12 Nov 2004 15:15:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Highlights for this release:

In addition to SAS support =3D>

* Christoph's Requested Changes:

=B7	Changing how command line options are passed,=20
passing the mptscsih string has been removed. Use modinfo
to see usage and description of the new parameters.
=B7	Removed IOCTL mptctl_hba_pciinfo=20
=B7	Removed mptscsih_slave_destroy vdev !=3D NULL check fixed=20
by removing the DEVICE_NOT_THERE calling of same function.
=2E 	Replaced ioc_chip with bus_type.
=2E 	kill one MPTSCSIH_DBG_TIMEOUT in ->queuecommand
=2E 	removed TRUE/FALSE defines in mptctl.h

Please review, and send me your suggestions for other changes.


This patch applied against bk://linux-scsi.bkbits.net/scsi-misc-2.6
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.02.=
07.02
/mptlinux-3.02.07.02.patch

Regards,
Eric Moore
LSI Logic Corporation
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
