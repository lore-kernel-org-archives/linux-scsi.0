From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/8]  qla4xxx: Settings
Date: Tue,  6 Sep 2005 15:10:01 -0700 (PDT)
Message-ID: <20050906221001.11409.48183.sendpatchset@plap.qlogic.com>
References: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40865 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751033AbVIFWKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 18:10:02 -0400
In-Reply-To: <20050906220841.11409.88669.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ISP4xxx driver settings.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla4xxx/ql4_settings.h |   67 ++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_version.h  |   68 +++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/qla4xxx/ql4_settings.h
 create mode 100644 drivers/scsi/qla4xxx/ql4_version.h

d7b9a2cde15c79a2908a32a3f80366d3d99767a4
diff --git a/drivers/scsi/qla4xxx/ql4_settings.h b/drivers/scsi/qla4xxx/ql4_settings.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_settings.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+/*
+ * Compile time Options:
+ *     0 - Disable and 1 - Enable
+ */
+#define	DISABLE_HBA_RESETS	0
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (c)  2003-2005 QLogic Corporation
+ * QLogic Linux iSCSI Driver
+ *
+ * This program includes a device driver for Linux 2.6 that may be
+ * distributed with QLogic hardware specific firmware binary file.
+ * You may modify and redistribute the device driver code under the
+ * GNU General Public License as published by the Free Software
+ * Foundation (version 2 or a later version) and/or under the
+ * following terms, as applicable:
+ *
+ * 	1. Redistribution of source code must retain the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission.
+ *
+ * You may redistribute the hardware specific firmware binary file
+ * under the following terms:
+ *
+ * 	1. Redistribution of source code (only if applicable),
+ * 	   must retain the above copyright notice, this list of
+ * 	   conditions and the following disclaimer.
+ *
+ * 	2. Redistribution in binary form must reproduce the above
+ * 	   copyright notice, this list of conditions and the
+ * 	   following disclaimer in the documentation and/or other
+ * 	   materials provided with the distribution.
+ *
+ * 	3. The name of QLogic Corporation may not be used to
+ * 	   endorse or promote products derived from this software
+ * 	   without specific prior written permission
+ *
+ * REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
+ * THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
+ * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
+ * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ *
+ * USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
+ * CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
+ * OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
+ * TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
+ * ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
+ * COMBINATION WITH THIS PROGRAM.
+ */
+
+#define QLA4XXX_DRIVER_VERSION      "5.00.03b15-k"
+
+#define QL4_DRIVER_MAJOR_VER	5
+#define QL4_DRIVER_MINOR_VER	0
+#define QL4_DRIVER_PATCH_VER	3
+#define QL4_DRIVER_BETA_VER	15

-- 
Andrew Vasquez
