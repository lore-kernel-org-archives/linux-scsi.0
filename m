From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: Fri, 5 Dec 2003 17:15:14 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED8F@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Friday, December 05, 2003 12:53 PM, Andrew Vasquez wrote:
> All,
> 
> A new version of the 8.x series driver for Linux 2.6.x kernels has
> been uploaded to SourceForge: 
> 
> 	http://sourceforge.net/projects/linux-qla2xxx/
>

False start.  I've uploaded 8.00.00b8 to the SF site.  This driver
instructs the mid-layer to perform its initial scan with
scsi_scan_host().  During testing, I disable the scan.  Sorry for
the confusion.

BTW: a simple patch to fix the problem against b7 follows.  
Please dismiss 8.00.00b7 (I've since removed it from the SF site).

Regards,
Andrew Vasquez


diff -Nurd 80000b7/qla_os.c 80000b7-scan/qla_os.c
--- 80000b7/qla_os.c	2003-12-05 10:39:58.000000000 -0800
+++ 80000b7-scan/qla_os.c	2003-12-05 16:40:21.855654968 -0800
@@ -72,7 +72,7 @@
 
 int ql2xsuspendcount = SUSPEND_COUNT;
 
-int ql2xdoinitscan = 0;
+int ql2xdoinitscan = 1;
 
 int qla2x00_retryq_dmp;
 
