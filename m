From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v16 2/9] ufs: add UFS 2.0 to ufshcd-pltfrm bindings
Date: Wed, 11 May 2016 12:21:26 +0100
Message-ID: <6aaf16cdc9d16a51b8bac2a68d32aa27eb020da7.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:52696 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbcEKLVn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 07:21:43 -0400
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

Add UFS 2.0 to the ufshcd-pltfrm devicetree binding.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
Changes v12->v16:
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

