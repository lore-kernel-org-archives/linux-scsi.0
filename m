From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 8/11] mpt2sas v00.100.11.11 : Kconfig
Date: Tue, 3 Mar 2009 22:13:05 -0700
Message-ID: <20090304051303.GJ4194@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:55668 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbZCDSx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 13:53:28 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n24IrOMs006046
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:53:24 -0800 (PST)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n24IrS3d015248
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 10:53:28 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kconfig

mpt2sas Kernel configuration file.

Signed-off-by: Eric Moore <eric.moore@lsi.com>
---

--- a/drivers/scsi/mpt2sas/Kconfig	1969-12-31 17:00:00.000000000 -0700
+++ b/drivers/scsi/mpt2sas/Kconfig	2009-03-03 10:29:13.000000000 -0700
@@ -0,0 +1,66 @@
+#
+# Kernel configuration file for the MPT2SAS
+#
+# This code is based on drivers/scsi/mpt2sas/Kconfig
+# Copyright (C) 2007-2008  LSI Corporation
+#  (mailto:DL-MPTFusionLinux@lsi.com)
+
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License
+# as published by the Free Software Foundation; either version 2
+# of the License, or (at your option) any later version.
+
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+
+# NO WARRANTY
+# THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+# LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+# solely responsible for determining the appropriateness of using and
+# distributing the Program and assumes all risks associated with its
+# exercise of rights under this Agreement, including but not limited to
+# the risks and costs of program errors, damage to or loss of data,
+# programs or equipment, and unavailability or interruption of operations.
+
+# DISCLAIMER OF LIABILITY
+# NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+# DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+# USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+# HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+# USA.
+
+config SCSI_MPT2SAS
+	tristate "LSI MPT Fusion SAS 2.0 Device Driver"
+	depends on PCI && SCSI
+	select SCSI_SAS_ATTRS
+	---help---
+	This driver supports PCI-Express SAS 6Gb/s Host Adapters.
+
+config SCSI_MPT2SAS_MAX_SGE
+	int "LSI MPT Fusion Max number of SG Entries (16 - 128)"
+	depends on PCI && SCSI && SCSI_MPT2SAS
+	default "128"
+	range 16 128
+	---help---
+	This option allows you to specify the maximum number of scatter-
+	gather entries per I/O. The driver default is 128, which matches
+	SAFE_PHYS_SEGMENTS.  However, it may decreased down to 16.
+	Decreasing this parameter will reduce memory requirements
+	on a per controller instance.
+
+config SCSI_MPT2SAS_LOGGING
+	bool "LSI MPT Fusion logging facility"
+	depends on PCI && SCSI && SCSI_MPT2SAS
+	---help---
+	This turns on a logging facility.
