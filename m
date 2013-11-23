From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/1 linux-scs-ml] qla2xxx: Update ql2{4,5}00_fw.bin to version
 7.01.00
Date: Sat, 23 Nov 2013 14:00:14 +0100
Message-ID: <5290A6DE.8080008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51463 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3KWNAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Nov 2013 08:00:19 -0500
Received: by mail-wi0-f176.google.com with SMTP id hq4so1843538wib.9
        for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2013 05:00:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>

resent to linux-scsi-ml, without the binary blob(316K).

fw and licence were taken from http://ldriver.qlogic.com/firmware/

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 LICENCE.qla2xxx |  60 ++++++++++++++++++++++++--------------------------------
 WHENCE          |   4 ++--
 ql2400_fw.bin   | Bin 257108 -> 259332 bytes
 ql2500_fw.bin   | Bin 260064 -> 265420 bytes
 4 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/LICENCE.qla2xxx b/LICENCE.qla2xxx
index f669ae0..df67a9b 100644
--- a/LICENCE.qla2xxx
+++ b/LICENCE.qla2xxx
@@ -1,39 +1,31 @@
-Copyright (c)  2003-2006 QLogic Corporation
-QLogic Linux Fibre Channel HBA Firmware
+Copyright (c) 2003-2010 QLogic Corporation
+QLogic Linux Fibre Channel Adapter Firmware
 -You may redistribute the hardware specific firmware binary file
-under the following terms:
+Redistribution and use in binary form, without modification, for use in conjunction
+with QLogic authorized products is permitted provided that the following conditions
+are met:
 -	1. Redistribution of source code (only if applicable),
-	   must retain the above copyright notice, this list of
-	   conditions and the following disclaimer.
+1. Redistribution in binary form must reproduce the above copyright notice, this
+   list of conditions and the following disclaimer in the documentation and/or
+   other materials provided with the distribution.
+2. The name of QLogic Corporation may not be used to endorse or promote products
+   derived from this software without specific prior written permission.
+3. Reverse engineering, decompilation, or disassembly of this firmware is not
+   permitted.
 -	2. Redistribution in binary form must reproduce the above
-	   copyright notice, this list of conditions and the
-	   following disclaimer in the documentation and/or other
-	   materials provided with the distribution.
+REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,THIS PROGRAM IS
+PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
+INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
+FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
+GOODS OR SERVICES; LOSS OF USE,DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+LIABILITY,OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 -	3. The name of QLogic Corporation may not be used to
-	   endorse or promote products derived from this software
-	   without specific prior written permission
-
-REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
-THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
-EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
-PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
-BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
-TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
-DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
-ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
-OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-POSSIBILITY OF SUCH DAMAGE.
-
-USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
-CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
-OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
-TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
-ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT CREATE OR GIVE
+GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR OTHERWISE IN ANY INTELLECTUAL
+PROPERTY RIGHTS (PATENT, COPYRIGHT, TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY
+RIGHT) EMBODIED IN ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
 COMBINATION WITH THIS PROGRAM.
diff --git a/WHENCE b/WHENCE
index 2d52804..94f28a5 100644
--- a/WHENCE
+++ b/WHENCE
@@ -429,9 +429,9 @@ Version: 3.03.28 IPX
 File: ql2322_fw.bin
 Version: 3.03.28 IPX
 File: ql2400_fw.bin
-Version: 5.08.00 MID
+Version: 7.01.00 MID
 File: ql2500_fw.bin
-Version: 5.08.00 MIDQ
+Version: 7.01.00 MIDQ
  Licence: Redistributable. See LICENCE.qla2xxx for details
 diff --git a/ql2400_fw.bin b/ql2400_fw.bin
[...]
 diff --git a/ql2500_fw.bin b/ql2500_fw.bin
[...]
-- 
1.8.3.1


