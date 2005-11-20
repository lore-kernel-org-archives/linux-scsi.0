From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 3/5 RESEND] edit makefile
Date: Sun, 20 Nov 2005 15:28:09 -0600
Message-ID: <1132522089.7983.20.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6274 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932113AbVKTV21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 16:28:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org

edit Make file to reflect new files

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


--- linux-2.6.15-rc2/drivers/scsi/Makefile	2005-11-19 21:25:03.000000000 -0600
+++ linux-2.6.15-rc2.diff/drivers/scsi/Makefile	2005-11-20 15:09:20.000000000 -0600
@@ -164,6 +164,7 @@ CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
 libata-objs	:= libata-core.o libata-scsi.o
+scsi_transport_iscsi-objs	:= libiscsi.o iscsi_if.o
 
 # Files generated that shall be removed upon make clean
 clean-files :=	53c7xx_d.h 53c700_d.h	\


