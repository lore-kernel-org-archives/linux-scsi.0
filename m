From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 5/5] bfa: Brocade BFA FC SCSI driver (maint)
Date: Wed, 1 Apr 2009 20:35:47 -0700
Message-ID: <200904020335.n323Zl7F004493@blc-10-2.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx10.brocade.com ([208.185.105.18]:29613 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbZDBDi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 23:38:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: huangj@brocade.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com, vravindr@brocade.com

From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

This patch contains updated MAINTAINERS file.

Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
---
 MAINTAINERS |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff -urpN orig/MAINTAINERS patch/MAINTAINERS
--- orig/MAINTAINERS	2009-04-01 20:08:51.279209000 -0700
+++ patch/MAINTAINERS	2009-04-01 20:08:51.259600000 -0700
@@ -1016,6 +1016,12 @@ M:	mchan@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+BROCADE BFA FC SCSI DRIVER
+P:     Jing Huang
+M:     huangj@brocade.com
+L:     linux-scsi@vger.kernel.org
+S:     Supported
+
 BSG (block layer generic sg v4 driver)
 P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
@@ -3350,8 +3356,10 @@ S:	Maintained
 PARISC ARCHITECTURE
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
-P:	Helge Deller
-M:	deller@gmx.de
+P:	Matthew Wilcox
+M:	matthew@wil.cx
+P:	Grant Grundler
+M:	grundler@parisc-linux.org
 L:	linux-parisc@vger.kernel.org
 W:	http://www.parisc-linux.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git
@@ -3876,15 +3884,6 @@ L:	linux-ide@vger.kernel.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 S:	Supported
 
-SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
-P:	Sathya Perla
-M:	sathyap@serverengines.com
-P:      Subbu Seetharaman
-M:      subbus@serverengines.com
-L:      netdev@vger.kernel.org
-W:      http://www.serverengines.com
-S:      Supported
-
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
