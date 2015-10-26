From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 32/32] MAINTAINERS: add maintainer for HiSi SAS driver
Date: Mon, 26 Oct 2015 22:15:03 +0800
Message-ID: <1445868903-183817-33-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:19560 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbbJZOCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2015 10:02:08 -0400
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Add maintainer for HiSilicon SAS driver.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddc88c0..4ca8d79 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4951,6 +4951,13 @@ F:	include/uapi/linux/if_hippi.h
 F:	net/802/hippi.c
 F:	drivers/net/hippi/
 
+HISILICON SAS Controller
+M:	John Garry <john.garry@huawei.com>
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

