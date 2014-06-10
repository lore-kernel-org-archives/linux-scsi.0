From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 linux-scsi-ml] linux-firmware: qla2xxx: Update ql2{4,5}00_fw.bin
 to version 7.03.00
Date: Tue, 10 Jun 2014 12:00:39 +0200
Message-ID: <5396D747.9000107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:52699 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaFJKAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 06:00:46 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so1867678wes.40
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 03:00:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Qlogic internal list <linux-driver@qlogic.com>, Linux Firmware Maintainers <linux-firmware@kernel.org>

resent to linux-scsi-ml, without the binary blob(244K).

Firmwares were taken from http://ldriver.qlogic.com/firmware/

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Joe Carnuccio <joe.carnuccio@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Qlogic internal list <linux-driver@qlogic.com>
Cc: Linux Firmware Maintainers <linux-firmware@kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 WHENCE        |   4 ++--
 ql2400_fw.bin | Bin 259332 -> 260656 bytes
 ql2500_fw.bin | Bin 265420 -> 266912 bytes
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/WHENCE b/WHENCE
index 6a64fc2..f257a93 100644
--- a/WHENCE
+++ b/WHENCE
@@ -429,9 +429,9 @@ Version: 3.03.28 IPX
 File: ql2322_fw.bin
 Version: 3.03.28 IPX
 File: ql2400_fw.bin
-Version: 7.01.00 MID
+Version: 7.03.00 MID
 File: ql2500_fw.bin
-Version: 7.01.00 MIDQ
+Version: 7.03.00 MIDQ
  Licence: Redistributable. See LICENCE.qla2xxx for details

diff --git a/ql2400_fw.bin b/ql2400_fw.bin
 [...]

diff --git a/ql2500_fw.bin b/ql2500_fw.bin
 [...]
-- 
1.9.3

