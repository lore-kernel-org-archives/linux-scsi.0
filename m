From: thomas schorpp <t.schorpp@gmx.de>
Subject: [PATCH][DOC]aic7xxx: Correct wrong Kernel Documentation for Adaptec
 AHA19160(B) HBA
Date: Fri, 23 Mar 2007 17:45:52 +0100
Message-ID: <46040440.1020704@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56047 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752141AbXCWQpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Mar 2007 12:45:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

--- Documentation/scsi/aic7xxx.txt 2007-03-23 16:44:05.000000000 +0100
+++ Documentation/scsi/aic7xxx.txt 2007-03-23 17:01:19.000000000 +0100
@@ -28,7 +28,7 @@
    aic7880  10    PCI/32    20MHz    16Bit      16
    aic7890  20    PCI/32    40MHz    16Bit      16      3 4 5 6 7 8
    aic7891  20    PCI/64    40MHz    16Bit      16      3 4 5 6 7 8
-   aic7892  20   PCI/64-66  80MHz    16Bit      16      3 4 5 6 7 8
+   aic7892  20 PCI/32/64-66 80MHz    16Bit      16      3 4 5 6 7 8
    aic7895  15    PCI/32    20MHz    16Bit      16    2 3 4 5
    aic7895C 15    PCI/32    20MHz    16Bit      16    2 3 4 5     8
    aic7896  20    PCI/32    40MHz    16Bit      16    2 3 4 5 6 7 8
@@ -114,7 +114,7 @@
    AHA-29160N     aic7892   PCI/32      LVD-HD68F       SE-HD50F
                                          SE-50M
    AHA-29160LP    aic7892   PCI/64-66
-   AHA-19160      aic7892   PCI/64-66
+   AHA-19160      aic7892   PCI/32
    AHA-29150LP    aic7892   PCI/64-66
    AHA-29130LP    aic7892   PCI/64-66
    AHA-3960D      aic7899   PCI/64-66  2 X LVD-HD68F  2 X LVD-VHD68F

Correct documentation according to the aic7892 chip, adaptec aha19160 hba specs.

Signed-off-by tom schorpp <t.schorpp@gmx.de>

