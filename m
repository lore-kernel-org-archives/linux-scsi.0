From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 1/3] scsi_forget_host - export function
Date: Fri, 11 Jun 2004 21:21:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612042106.GB21105@us.ibm.com>
References: <20040612041930.GA21105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:42935 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264629AbUFLEUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 00:20:53 -0400
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e6.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i5C4KqhF621508
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jun 2004 00:20:52 -0400
Received: from hmsbounty.us.ibm.com (sig-9-49-143-70.mts.ibm.com [9.49.143.70])
	by northrelay03.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i5C4Lc3q178604
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jun 2004 00:21:38 -0400
Content-Disposition: inline
In-Reply-To: <20040612041930.GA21105@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

DESC
scsi_forget_host - export function

Export scsi_forget_host for use by LLDD
Signed-off-by: Mike Anderson <andmike@us.ibm.com>
EDESC


 patched-2.6-andmike/drivers/scsi/scsi_priv.h |    1 -
 patched-2.6-andmike/drivers/scsi/scsi_syms.c |    1 +
 patched-2.6-andmike/include/scsi/scsi_host.h |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_priv.h~exp_scsi_forget_host drivers/scsi/scsi_priv.h
--- patched-2.6/drivers/scsi/scsi_priv.h~exp_scsi_forget_host	Sat Jun 12 00:47:35 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_priv.h	Sat Jun 12 00:47:35 2004
@@ -137,7 +137,6 @@ extern void scsi_exit_procfs(void);
 /* scsi_scan.c */
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, unsigned int, int);
-extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_rescan_device(struct device *);
 
 /* scsi_sysctl.c */
diff -puN drivers/scsi/scsi_syms.c~exp_scsi_forget_host drivers/scsi/scsi_syms.c
--- patched-2.6/drivers/scsi/scsi_syms.c~exp_scsi_forget_host	Sat Jun 12 00:47:35 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_syms.c	Sat Jun 12 00:52:50 2004
@@ -36,6 +36,7 @@ EXPORT_SYMBOL(scsi_register_interface);
 EXPORT_SYMBOL(scsi_host_alloc);
 EXPORT_SYMBOL(scsi_add_host);
 EXPORT_SYMBOL(scsi_scan_host);
+EXPORT_SYMBOL(scsi_forget_host);
 EXPORT_SYMBOL(scsi_remove_host);
 EXPORT_SYMBOL(scsi_host_get);
 EXPORT_SYMBOL(scsi_host_put);
diff -puN include/scsi/scsi_host.h~exp_scsi_forget_host include/scsi/scsi_host.h
--- patched-2.6/include/scsi/scsi_host.h~exp_scsi_forget_host	Sat Jun 12 00:47:35 2004
+++ patched-2.6-andmike/include/scsi/scsi_host.h	Sat Jun 12 00:52:50 2004
@@ -501,6 +501,7 @@ struct Scsi_Host {
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
+extern void scsi_forget_host(struct Scsi_Host *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);

_
