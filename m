From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Support for lun > 7 on HP's XP128 storage
Date: Wed, 18 Jun 2003 09:16:09 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <004a01c33561$1c3cc3b0$6e51960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.wsp.ro ([193.231.199.126]:3005 "EHLO www.wsp.ro")
	by vger.kernel.org with ESMTP id S265080AbTFRGCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 02:02:14 -0400
Received: from EEL (mta1.xnet.ro [217.10.192.225])
	(authenticated (0 bits))
	by www.wsp.ro (8.12.4/8.11.6) with ESMTP id h5I6G9fV016983
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2003 09:16:09 +0300
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am running a 2.4.18-ac3 kernel on a ia32 system.
This system is connected to a SAN via an Emulex LP8000 HBA. The storage is
HP's XP128. The controller on the storage reports scsi version 2 however,
luns with ID > 7 are also supported. When the HBA driver is loaded, no LUNs
are detected but if "scsi add-single-device" is used later, the luns are
visible.

Maybe it should be added to the kernel with BLIST_LARGELUN - correct me if I
am wrong.

Thanks,
Ionut

