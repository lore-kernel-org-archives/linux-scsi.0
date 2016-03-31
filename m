From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v12 2/9] add UFS 2.0 to ufshcd-pltfrm bindings
Date: Thu, 31 Mar 2016 19:57:15 +0100
Message-ID: <7bb21c8336102f6fff9a49132ff0a21055955d94.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tomas.winkler@intel.com
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Add UFS 2.0 to the ufshcd-pltfrm devicetree binding.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v0->v12 (Tomas Winkler):
- This patch only appeared in v12

 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 03c0e98..8d9a9d2 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -4,8 +4,8 @@ UFSHC nodes are defined to describe on-chip UFS host controllers.
 Each UFS controller instance should have its own node.
 
 Required properties:
-- compatible		: must contain "jedec,ufs-1.1", may also list one or more
-					  of the following:
+- compatible		: must contain "jedec,ufs-1.1" or "jedec,ufs-2.0", may
+			  also list one or more of the following:
 					  "qcom,msm8994-ufshc"
 					  "qcom,msm8996-ufshc"
 					  "qcom,ufshc"
-- 
1.8.1.5
