From: Rusty Trivial Russell <trivial@rustcorp.com.au>
Subject: [TRIVIAL] 2.6] 2 spelling patches in helps
Date: Thu, 11 Sep 2003 16:32:56 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911064459.F1F702C4AB@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:39869 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266185AbTIKGpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 02:45:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org, axboe@suse.de

From:  Maciej Soltysiak <solt@dns.toxicfilms.tv>

  Hi,
  
  please consider these patches to fix spelling.
  
  Regards,
  Maciej Soltysiak
  

--- trivial-2.6.0-test5-bk1/net/Kconfig.orig	2003-09-11 16:25:22.000000000 +1000
+++ trivial-2.6.0-test5-bk1/net/Kconfig	2003-09-11 16:25:22.000000000 +1000
@@ -623,7 +623,7 @@
 	depends on EXPERIMENTAL
 	---help---
 	  This option enables NIC (Network Interface Card) hardware throttling
-	  during periods of extremal congestion. At the moment only a couple
+	  during periods of extreme congestion. At the moment only a couple
 	  of device drivers support it (really only one -- tulip, a modified
 	  8390 driver can be found at
 	  <ftp://ftp.inr.ac.ru/ip-routing/fastroute/fastroute-8390.tar.gz>).
--- trivial-2.6.0-test5-bk1/Documentation/scsi/ncr53c8xx.txt.orig	2003-09-11 16:25:22.000000000 +1000
+++ trivial-2.6.0-test5-bk1/Documentation/scsi/ncr53c8xx.txt	2003-09-11 16:25:22.000000000 +1000
@@ -1025,7 +1025,7 @@
 then it will for sure win the next SCSI BUS arbitration.
 
 Since, there is no way to know what devices are trying to arbitrate for the 
-BUS, using this feature can be extremally unfair. So, you are not advised 
+BUS, using this feature can be extremely unfair. So, you are not advised
 to enable it, or at most enable this feature for the case the chip lost 
 the previous arbitration (boot option 'iarb:1').
 
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Maciej Soltysiak <solt@dns.toxicfilms.tv>: [TRIVIAL][PATCH 2.6] 2 spelling patches in helps
