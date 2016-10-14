From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] scsi: ufs: changing maintainer
Date: Fri, 14 Oct 2016 16:59:23 +0100
Message-ID: <f5407f0a989e0bd67e648d418d44f11043d1fde4.1476460353.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:57973 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbcJNP72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 11:59:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Cc: Manjunath.MB@synopsys.com, Prabu.T@synopsys.com, Joao Pinto <Joao.Pinto@synopsys.com>

I am going to leave Synopsys and so this patch changes the Maintainer
for UFS Synopsys' specific drivers to my colleagues Manjunath and Prabu.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5ac91d8a..d9855b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12084,7 +12084,8 @@ F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
-M:	Joao Pinto <Joao.Pinto@synopsys.com>
+M:	Manjunath M Bettegowda <manjumb@synopsys.com>
+M:	Prabu Thangamuthu <prabut@synopsys.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ufs/*dwc*
-- 
1.8.1.5

