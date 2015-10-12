From: John Garry <john.garry@huawei.com>
Subject: [PATCH 25/25] MAINTAINERS: add maintainer for HiSi SAS driver
Date: Mon, 12 Oct 2015 23:20:37 +0800
Message-ID: <1444663237-238302-26-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:14839 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbJLPP4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:15:56 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add maintainer for HiSilicon SAS driver.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 797236b..edea297 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4935,6 +4935,13 @@ F:	include/uapi/linux/if_hippi.h
 F:	net/802/hippi.c
 F:	drivers/net/hippi/
 
+HISILICON SAS Controller
+M:	John Garry <john.garry@hisilicon.com>
+W:	http://www.hisilicon.com
+S:	Supported
+F:	drivers/scsi/hisi_sas/
+F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
+
 HOST AP DRIVER
 M:	Jouni Malinen <j@w1.fi>
 L:	hostap@shmoo.com (subscribers-only)
-- 
1.9.1

