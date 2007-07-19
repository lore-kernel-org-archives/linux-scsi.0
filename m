From: "Gwendal Grignou" <ggrignou@Brocade.COM>
Subject: [PATCH] update mpt Kconfig help
Date: Thu, 19 Jul 2007 12:26:54 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E33DEB6@HQ-EXCH-5.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.brocade.com ([66.243.153.242]:45590 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759379AbXGST07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 15:26:59 -0400
Received: from HQ-EXCHFE-2.corp.brocade.com (hq-vipexchfe-2.brocade.com [192.168.126.214])
	by discus.brocade.com (Postfix) with ESMTP id A3796238370
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jul 2007 12:07:08 -0700 (PDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update help in Kconfig for mptfc driver to indicate the driver supports 
Brocade FC 4G HBA.

signed-off-by: Gwendal Grignou <ggrignou@brocade.com>
---

diff --git a/drivers/message/fusion/Kconfig
b/drivers/message/fusion/Kconfig
index c88cc75..4494e0f 100644
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -37,6 +37,7 @@ config FUSION_FC
          LSIFC929
          LSIFC929X
          LSIFC929XL
+         Brocade FC 410/420

 config FUSION_SAS
        tristate "Fusion MPT ScsiHost drivers for SAS"
