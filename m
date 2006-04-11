From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: [PATCH 1/6] [RFC] iSER's Makefile and Kconfig
Date: Tue, 11 Apr 2006 16:48:15 +0300 (IDT)
Message-ID: <Pine.LNX.4.44.0604111647220.18200-100000@zuben>
References: <Pine.LNX.4.44.0604111646040.18200-100000@zuben>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from taurus.voltaire.com ([193.47.165.240]:1191 "EHLO
	taurus.voltaire.com") by vger.kernel.org with ESMTP
	id S1750926AbWDKNsQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 09:48:16 -0400
In-Reply-To: <Pine.LNX.4.44.0604111646040.18200-100000@zuben>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Or Gerlitz <ogerlitz@voltaire.com>

--- linux-2.6.17-rc1-orig/drivers/infiniband/ulp/iser/Makefile	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.17-rc1-iser/drivers/infiniband/ulp/iser/Makefile	2006-04-11 15:36:09.000000000 +0300
@@ -0,0 +1,6 @@
+obj-$(CONFIG_INFINIBAND_ISER)	+= ib_iser.o
+
+ib_iser-y			:= iser_verbs.o \
+				   iser_initiator.o \
+				   iser_memory.o \
+				   iscsi_iser.o 
--- linux-2.6.17-rc1-orig/drivers/infiniband/ulp/iser/Kconfig	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.17-rc1-iser/drivers/infiniband/ulp/iser/Kconfig	2006-04-11 15:27:56.000000000 +0300
@@ -0,0 +1,12 @@
+config INFINIBAND_ISER
+	tristate "ISCSI RDMA Protocol"
+	depends on INFINIBAND && SCSI
+	select SCSI_ISCSI_ATTRS
+	---help---
+
+	  Support for the ISCSI RDMA Protocol over InfiniBand.  This
+	  allows you to access storage devices that speak ISER/ISCSI
+	  over InfiniBand.
+
+	  The ISER protocol is defined by IETF.
+	  See <http://www.ietf.org/>.

