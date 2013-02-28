From: Chen Gang <gang.chen@asianux.com>
Subject: [PATCH] drivers/scsi/cxgbi: using ccflags-y instead of EXTRA_CFLAGS
 in Kbuild
Date: Thu, 28 Feb 2013 14:34:57 +0800
Message-ID: <512EFA91.5050101@asianux.com>
References: <50F15A35.4000400@asianux.com> <50FB9A33.2090204@asianux.com> <51077BB3.2010809@asianux.com> <512ECDDC.2020607@asianux.com> <512EF43D.1070805@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:31602 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3B1GfT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2013 01:35:19 -0500
In-Reply-To: <512EF43D.1070805@asianux.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, David Miller <davem@davemloft.net>, kxie@chelsio.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


  need using ccflags-y instead of EXTRA_CFLAGS
    can reference scripts/checkpatch.pl (1755..1766)

  when make EXTRA_CFLAGS=-W, the compiling issue will be occured.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/scsi/cxgbi/cxgb3i/Kbuild |    2 +-
 drivers/scsi/cxgbi/cxgb4i/Kbuild |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/Kbuild b/drivers/scsi/cxgbi/cxgb3i/Kbuild
index 6f095e2..961a12f 100644
--- a/drivers/scsi/cxgbi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgbi/cxgb3i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
+ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
 
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff --git a/drivers/scsi/cxgbi/cxgb4i/Kbuild b/drivers/scsi/cxgbi/cxgb4i/Kbuild
index 8290cda..3745864 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kbuild
+++ b/drivers/scsi/cxgbi/cxgb4i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
+ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_SCSI_CXGB4_ISCSI) += cxgb4i.o
-- 
1.7.7.6
