From: " Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Fri, 5 Nov 2004 17:21:06 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C2D18BA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46847 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261275AbUKFAVI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 19:21:08 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iA60Jbcq025695
	for <linux-scsi@vger.kernel.org>; Fri, 5 Nov 2004 16:19:37 -0800 (PST)
Received: from nacos172.ad.lsil.com (nacos172.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iA60L7Ek016667
	for <linux-scsi@vger.kernel.org>; Fri, 5 Nov 2004 16:21:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We are pleased to announce the MPT Fusion release candidate for lk 2.6

Highlights of this release:
=B7	SAS Support - 1064, 1066, 1068
=B7	mpi headers v1.5.2

=B7	Also included are hch@ suggestions from previous 3.02.06 release
- 	remove ioc->chip_type checks, using the new bus_type member
-	removing SAS CSMI Ioctls
-	using scsi_remove_device and scsi_add_device =3D> for hot swap suppor=
t

This patch applied against bk://linux-scsi.bkbits.net/scsi-misc-2.6

Here is a link to this patch:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.02.=
07/mp
tlinux-3.02.07.patch
=46ull source are also provided at link above.

Eric Moore
Standard Storage Products Division
LSI Logic Corporation
Web: http://www.lsilogic.com/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
