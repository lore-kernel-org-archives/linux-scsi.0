From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 33/34] cxgbit: add Kconfig and Makefile
Date: Sun, 14 Feb 2016 23:15:40 +0530
Message-ID: <09a09d398b03524da6b382ca7155b2729276236f.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/Kconfig  | 7 +++++++
 drivers/target/iscsi/cxgbit/Makefile | 6 ++++++
 2 files changed, 13 insertions(+)
 create mode 100644 drivers/target/iscsi/cxgbit/Kconfig
 create mode 100644 drivers/target/iscsi/cxgbit/Makefile

diff --git a/drivers/target/iscsi/cxgbit/Kconfig b/drivers/target/iscsi/cxgbit/Kconfig
new file mode 100644
index 0000000..cf335b4
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/Kconfig
@@ -0,0 +1,7 @@
+config ISCSI_TARGET_CXGB4
+	tristate "Chelsio iSCSI target offload driver"
+	depends on ISCSI_TARGET && CHELSIO_T4
+	select CHELSIO_T4_UWIRE
+	---help---
+	To compile this driver as module, choose M here: the module
+	will be called cxgbit.
diff --git a/drivers/target/iscsi/cxgbit/Makefile b/drivers/target/iscsi/cxgbit/Makefile
new file mode 100644
index 0000000..bd56c07
--- /dev/null
+++ b/drivers/target/iscsi/cxgbit/Makefile
@@ -0,0 +1,6 @@
+ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
+ccflags-y += -Idrivers/target/iscsi
+
+obj-$(CONFIG_ISCSI_TARGET_CXGB4)  += cxgbit.o
+
+cxgbit-y  := cxgbit_main.o cxgbit_cm.o cxgbit_target.o cxgbit_ddp.o
-- 
2.0.2
