From: "Gwendal Grignou" <ggrignou@Brocade.COM>
Subject: [PATCH] update mpt Kconfig help - with [TAB]
Date: Fri, 20 Jul 2007 12:38:36 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E33E166@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.brocade.com ([66.243.153.242]:33758 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751552AbXGTTii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 15:38:38 -0400
Received: from HQ-EXCHFE-2.corp.brocade.com (hq-vipexchfe-2.brocade.com [192.168.126.214])
	by discus.brocade.com (Postfix) with ESMTP id 0502923836F
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jul 2007 12:18:49 -0700 (PDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update help in Kconfig for mptfc driver to indicate the driver supports
Brocade FC 4G HBA.

signed-off-by: Gwendal Grignou <ggrignou@brocade.com>
---

drivers/message/fusion/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/Kconfig
b/drivers/message/fusion/Kconfig
index c88cc75..4494e0f 100644
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -37,6 +37,7 @@ config FUSION_FC
 	  LSIFC929
 	  LSIFC929X
 	  LSIFC929XL
+	  Brocade FC 410/420
 
 config FUSION_SAS
 	tristate "Fusion MPT ScsiHost drivers for SAS"
