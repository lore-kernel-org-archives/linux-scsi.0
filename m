From: Olaf Hering <olh@suse.de>
Subject: [PATCH] mptfusion depends on scsi
Date: Sat, 24 Apr 2004 21:04:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040424190440.GA9515@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:59544 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261706AbUDXTGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Apr 2004 15:06:14 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@odsl.org


mptfusion depends on scsi.
If it was =3Dy, and scsi is set to =3Dm, it will remain =3Dy and give l=
ink errors.

2.6.6-rc2-bk3


--- ./drivers/message/fusion/Kconfig~   2004-04-04 05:38:27.000000000 +=
0200
+++ ./drivers/message/fusion/Kconfig    2004-04-24 20:58:32.000000000 +=
0200
@@ -3,7 +3,7 @@ menu "Fusion MPT device support"
=20
 config FUSION
        tristate "Fusion MPT (base + ScsiHost) drivers"
-       depends on PCI
+       depends on PCI && SCSI
        ---help---
          LSI Logic Fusion(TM) Message Passing Technology (MPT) device =
support
          provides high performance SCSI host initiator, and LAN [1] in=
terface

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
