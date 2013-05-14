From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 3/3] Documentation: devicetree: Add DT bindings for UFS host controller
Date: Tue, 14 May 2013 21:34:15 +0530
Message-ID: <1368547455-5211-4-git-send-email-santoshsy@gmail.com>
References: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44427 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab3ENQEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 12:04:55 -0400
Received: by mail-pd0-f180.google.com with SMTP id t10so552732pdi.11
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2013 09:04:55 -0700 (PDT)
In-Reply-To: <1368547455-5211-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Santosh Y <santoshsy@gmail.com>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Compatible list is used in commit 03b1781 but is not documented.
Add necessary device tree bindings to describe on-chip UFS host
controllers.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
new file mode 100644
index 0000000..20468b2
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -0,0 +1,16 @@
+* Universal Flash Storage (UFS) Host Controller
+
+UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "jedec,ufs-1.1"
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+- reg               : <registers mapping>
+
+Example:
+	ufshc@0xfc598000 {
+		compatible = "jedec,ufs-1.1";
+		reg = <0xfc598000 0x800>;
+		interrupts = <0 28 0>;
+	};
-- 
1.8.1.2

