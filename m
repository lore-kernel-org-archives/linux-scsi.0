From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] 3w-abcd.h: TW_Device_Extension: remove an unused filed (fwd) (fwd)
Date: Sun, 16 Jan 2005 03:01:09 +0100
Message-ID: <20050116020109.GE4274@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:19214 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262383AbVAPCBN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Jan 2005 21:01:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linuxraid@amcc.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch forwarded below still applies and compiles against 
2.6.11-rc1-mm1.

Please apply.


----- Forwarded message from Adrian Bunk <bunk@stusta.de> -----

Date:	Tue, 4 Jan 2005 00:51:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>
Cc: linuxraid@amcc.com, James.Bottomley@SteelEye.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] 3w-abcd.h: TW_Device_Extension: remove an unused filed (fwd)


The trivial patch forwarded below still applies against 2.6.10-mm1.

Please apply.


----- Forwarded message from Adrian Bunk <bunk@stusta.de> -----

Date:	Tue, 14 Dec 2004 05:10:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linuxraid@amcc.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [2.6 patch] 3w-abcd.h: TW_Device_Extension: remove an unused filed

[ subject adapted to linux-kernel filters... ]

num_units in struct TAG_TW_Device_Extension is completely unused.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc3-mm1-full/drivers/scsi/3w-xxxx.h.old	2004-12-14 04:39:15.000000000 +0100
+++ linux-2.6.10-rc3-mm1-full/drivers/scsi/3w-xxxx.h	2004-12-14 04:39:20.000000000 +0100
@@ -397,7 +397,6 @@
 	unsigned long		*alignment_virtual_address[TW_Q_LENGTH];
 	unsigned long		alignment_physical_address[TW_Q_LENGTH];
 	int			is_unit_present[TW_MAX_UNITS];
-	int			num_units;
 	unsigned long		*command_packet_virtual_address[TW_Q_LENGTH];
 	unsigned long		command_packet_physical_address[TW_Q_LENGTH];
 	struct pci_dev		*tw_pci_dev;

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----


