From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 34/34] iscsi-target: update Kconfig and Makefile
Date: Sun, 14 Feb 2016 23:15:41 +0530
Message-ID: <0279d54f735556f8e6318b1505eb6d494974da62.1455467089.git.varun@chelsio.com>
References: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

update Makefile and Kconfig for
compiling cxgbit.ko.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/Kconfig  | 2 ++
 drivers/target/iscsi/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
index 8345fb4..bbdbf9c 100644
--- a/drivers/target/iscsi/Kconfig
+++ b/drivers/target/iscsi/Kconfig
@@ -7,3 +7,5 @@ config ISCSI_TARGET
 	help
 	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
 	Target Mode Stack.
+
+source	"drivers/target/iscsi/cxgbit/Kconfig"
diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
index 0f43be9..0f18295 100644
--- a/drivers/target/iscsi/Makefile
+++ b/drivers/target/iscsi/Makefile
@@ -18,3 +18,4 @@ iscsi_target_mod-y +=		iscsi_target_parameters.o \
 				iscsi_target_transport.o
 
 obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
+obj-$(CONFIG_ISCSI_TARGET_CXGB4) += cxgbit/
-- 
2.0.2
