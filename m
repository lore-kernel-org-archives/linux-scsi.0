From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [PATCH 2.6.13 0/14] sas-class: Kconfig
Date: Fri, 09 Sep 2005 15:38:44 -0400
Message-ID: <4321E4C4.1040905@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030371AbVIITjV@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

diff -X linux-2.6.13/Documentation/dontdiff -Naur linux-2.6.13-orig/drivers/scsi/sas-class/Kconfig linux-2.6.13/drivers/scsi/sas-class/Kconfig
--- linux-2.6.13-orig/drivers/scsi/sas-class/Kconfig	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.13/drivers/scsi/sas-class/Kconfig	2005-09-09 11:33:28.000000000 -0400
@@ -0,0 +1,40 @@
+#
+# Kernel configuration file for the SAS Class
+#
+# Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
+# Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
+#
+# This file is licensed under GPLv2.
+# 
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation; version 2 of the
+# License.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+# USA
+#
+# $Id: //depot/sas-class/Kconfig#2 $
+#
+
+config SAS_CLASS
+	tristate "SAS Layer and Discovery"
+	depends on SCSI
+	help
+		If you wish to use a SAS Low Level Device Driver (LLDD)
+		say Y or M here.  Otherwise, say N.
+
+config SAS_DEBUG
+	bool "Compile the SAS Layer in debug mode"
+	default y
+	depends on SAS_CLASS
+	help
+		Compiles the SAS Layer in debug mode.  In debug mode, the
+		SAS Layer prints diagnostic and debug messages.
