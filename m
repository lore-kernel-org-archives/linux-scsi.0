From: bazooka@vekoll.vein.hu (Banai Zoltan)
Subject: [2.5.70] aic7xxx patch
Date: Sun, 1 Jun 2003 15:38:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030601133855.GA1035@bazooka.saturnus.vein.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bazooka.saturnus.vein.hu ([193.6.40.77]:3714 "EHLO
	bazooka.saturnus.vein.hu") by vger.kernel.org with ESMTP
	id S264605AbTFANZe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jun 2003 09:25:34 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

I've got a complie error in aic7xxx_osm.c, witch seems to be sloved by
the following  patch. (please check carefully!)

Greetings,
-- 
     Banai Zoltan <bazooka@vekoll.vein.hu>, <ICQ UIN:73057258>
Key fingerprint = 0952 25F0 7027 5561 469B  59EC A6D6 639D AEE6 B709
     finger://bazooka@vekoll.vein.hu, http://www.keyserver.net

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="aic7xxx_osm.patch"

--- aic7xxx_osm.c~	2003-06-01 15:26:37.000000000 +0200
+++ aic7xxx_osm.c	2003-05-31 21:42:25.000000000 +0200
@@ -764,7 +764,7 @@
 			consumed++;
 			next_sg = sg + 1;
 			next_sg->addr = 0;
-			next_len = 0x100000000 - (addr & 0xFFFFFFFF);
+			next_len = 0x10000000 - (addr & 0xFFFFFFFF);
 			len -= next_len;
 			next_len |= ((addr >> 8) + 0x1000000) & 0x7F000000;
 			next_sg->len = ahc_htole32(next_len);

--EVF5PPMfhYS0aIcm--
