From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/21] lpfc 8.3.30: Add additional compilation flag
Date: Thu, 1 Mar 2012 22:36:40 -0500
Message-ID: <1330659402.18500.38.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38860 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121Ab2CBDhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:37:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add additional compilation flag


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 Makefile |    2 ++
 1 file changed, 2 insertions(+)


diff -upNr a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
--- a/drivers/scsi/lpfc/Makefile	2012-01-12 22:43:34.000000000 -0500
+++ b/drivers/scsi/lpfc/Makefile	2012-03-01 17:33:44.000000000 -0500
@@ -22,6 +22,8 @@
 ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
 ccflags-$(GCOV) += -O0
 
+ccflags-y += -Werror
+
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
 lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o lpfc_hbadisc.o	\



