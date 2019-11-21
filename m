Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F55C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4775206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfKUQDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:03:18 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:46255 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfKUQDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 11:03:18 -0500
Received: from orion.localdomain ([95.115.120.75]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M3VAI-1iXGxS16va-000aMP; Thu, 21 Nov 2019 17:03:08 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH] drivers: scsi: Kconfig: minor indention fixes
Date:   Thu, 21 Nov 2019 17:02:50 +0100
Message-Id: <20191121160250.29550-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:Z/KGzKYZjrlXQbBuU9VIG+nxEaMt5xZK3P/AazMTDwDiMWrn7l7
 cJPrG46z+knfobETUJ+YwFFiOD7WiUtt2nxc44iTuQQlmtNCeMiCceEajv3w0CrgcvQgWGp
 SfnBtJWH9Gz6X3IWJ9Oo92kNDn9xj6BnWzPX2KcXiuWEw/7XvYtWTWshZeXk6y6/HEVC3mH
 CqjshLNP5eTr/t4iqAgQg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:B/HK5rhMmco=:pNVI92OOy9tsAylT0lqQlW
 3zRoDO4YbOIVu/q+jlN4FITz8fX7V91HBWRNuOiNdSVx0zKJdS4hZlCBi8vvbe5+KDqCb0vrl
 4nNExAbqdExErukVeUgwClZd1ZWxRzriVzxK4Njq5o9Bx519QRZcIXb+viADjw8khhAR/DmrJ
 9mBRoT/6FDEpCd17LWd2esOSX5/l4cdiMJl6ApZLPyPZ44QjcH6tejhqh27VRHorcadpMxnoK
 DqpZSR2OwKNoiY2XZFBol+CTc5j1dxAsHx54XEEyXSYOR0qnqz5FmFisSjSpedbJppAheU0f5
 mSPABzQyGmaFTMaznyfomlAS+yI8b3Joa8+1KZxAaBKS8IfE2T3FsOtIWAmXZSqa4VjPU7VFC
 5a9ctlHxkPNkyEqEfPkCwfmd3G317+wwgq9PORNNyVm5ewSqIMGpVJDEqCHFmcI7N83qMCXpO
 dduiFxkB/mK9umyWsVxgOJw6N+DdH7TDeOnvdfQeVeAc5Ea5X4CQYE8X9jwFFC/i6+R46bU/N
 +G0a3jQ6zhrlejCS/C7dGYKnwK6QNN0/IdJnPevqdOyoLvHQX3Vsuujk6xepjR5QBhxzN/v2e
 0DFkXSr6m8ndZ4z4JMHhhgTTwVSD9YAm6rsTnzFFYw5ma0wWLj/iuQkwt4a6KRV1mJAv23bGT
 IytByag8SfHu8haKEKEnmr0aMNXNgoRLQ6ivVcFV5kHVGs5GFSMqPHG3W++W12FhiRFZcE4gY
 2MCCQODlKlVSdKvO8vE+c5baV7d9kRAj0ZS0tA6/VdQn92NcR04CdzYQ3ag6BEGVlYlyUTo4d
 kIvyEM1S0ObnHo0laXFQRh1Np1aiSJB5t1LbHoNs+6HoYbtD/zIkqyvoUq/1+z7NtcIdJh1rF
 hYYCRCfYCXbP9Hjm323w==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Align the indentions to the common practise in Kconfig files,
make it look at little bit prettier. Just whitespace changes.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/scsi/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 90cf4691b8c3..329ddbb46222 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -2,9 +2,9 @@
 menu "SCSI device support"
 
 config SCSI_MOD
-       tristate
-       default y if SCSI=n || SCSI=y
-       default m if SCSI=m
+	tristate
+	default y if SCSI=n || SCSI=y
+	default m if SCSI=m
 
 config RAID_ATTRS
 	tristate "RAID Transport Class"
@@ -1480,14 +1480,14 @@ config ZFCP
 	depends on S390 && QDIO && SCSI
 	depends on SCSI_FC_ATTRS
 	help
-          If you want to access SCSI devices attached to your IBM eServer
-          zSeries by means of Fibre Channel interfaces say Y.
-          For details please refer to the documentation provided by IBM at
-          <http://oss.software.ibm.com/developerworks/opensource/linux390>
+	  If you want to access SCSI devices attached to your IBM eServer
+	  zSeries by means of Fibre Channel interfaces say Y.
+	  For details please refer to the documentation provided by IBM at
+	  <http://oss.software.ibm.com/developerworks/opensource/linux390>
 
-          This driver is also available as a module. This module will be
-          called zfcp. If you want to compile it as a module, say M here
-          and read <file:Documentation/kbuild/modules.rst>.
+	  This driver is also available as a module. This module will be
+	  called zfcp. If you want to compile it as a module, say M here
+	  and read <file:Documentation/kbuild/modules.rst>.
 
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
@@ -1518,8 +1518,8 @@ config SCSI_VIRTIO
 	tristate "virtio-scsi support"
 	depends on VIRTIO
 	help
-          This is the virtual HBA driver for virtio.  If the kernel will
-          be used in a virtual machine, say Y or M.
+	  This is the virtual HBA driver for virtio. If the kernel will
+	  be used in a virtual machine, say Y or M.
 
 source "drivers/scsi/csiostor/Kconfig"
 
-- 
2.11.0

