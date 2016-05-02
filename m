From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v15 2/9] ufs: add UFS 2.0 to ufshcd-pltfrm bindings
Date: Mon,  2 May 2016 14:55:28 +0100
Message-ID: <e78fbfccb802a9a06837e5fb97af9d877bd2dcce.1462187952.git.jpinto@synopsys.com>
References: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:46479 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbcEBNzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 09:55:46 -0400
In-Reply-To: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
In-Reply-To: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
References: <c6e39c4050ec0d43186465b04fb8c4b18b93e98e.1462187952.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, Joao Pinto <Joao.Pinto@synopsys.com>

Add UFS 2.0 to the ufshcd-pltfrm devicetree binding.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
Changes v12->v15:
- Nothing changed (just to keep up with patch set version).
Changes v0->v12 (Tomas Winkler):
- This patch only appeared in v12

 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 66f6adf..a99ed55 100644
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

