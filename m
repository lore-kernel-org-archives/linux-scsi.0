From: Rameshwar Prasad Sahu <rsahu@apm.com>
Subject: [PATCH] arm64: dts: apm: Fix compatible string for X-Gene 2 SATA
 controller DTS node
Date: Tue, 29 Mar 2016 15:24:54 +0530
Message-ID: <1459245294-22678-1-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, Rameshwar Prasad Sahu <rsahu@apm.com>, patches@apm.com, linux-ide@vger.kernel.org, ddutile@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Fix X-Gene SATA controller compatible string for Merlin board.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Acked-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm/apm-shadowcat.dtsi |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi b/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
index 5d87a3d..74d971e 100644
--- a/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
+++ b/arch/arm64/boot/dts/apm/apm-shadowcat.dtsi
@@ -524,7 +524,7 @@
 		};

 		sata1: sata@1a000000 {
-			compatible = "apm,xgene-ahci";
+			compatible = "apm,xgene-ahci-v2";
 			reg = <0x0 0x1a000000 0x0 0x1000>,
 			      <0x0 0x1f200000 0x0 0x1000>,
 			      <0x0 0x1f20d000 0x0 0x1000>,
@@ -534,7 +534,7 @@
 		};

 		sata2: sata@1a200000 {
-			compatible = "apm,xgene-ahci";
+			compatible = "apm,xgene-ahci-v2";
 			reg = <0x0 0x1a200000 0x0 0x1000>,
 			      <0x0 0x1f210000 0x0 0x1000>,
 			      <0x0 0x1f21d000 0x0 0x1000>,
@@ -544,7 +544,7 @@
 		};

 		sata3: sata@1a400000 {
-			compatible = "apm,xgene-ahci";
+			compatible = "apm,xgene-ahci-v2";
 			reg = <0x0 0x1a400000 0x0 0x1000>,
 			      <0x0 0x1f220000 0x0 0x1000>,
 			      <0x0 0x1f22d000 0x0 0x1000>,
--
1.7.1
