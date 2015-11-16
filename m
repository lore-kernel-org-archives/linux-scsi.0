From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 32/32] MAINTAINERS: add maintainer for HiSi SAS driver
Date: Mon, 16 Nov 2015 21:06:18 +0800
Message-ID: <1447679178-220222-33-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Add maintainer for HiSilicon SAS driver.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9caa4b..c7081bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5035,6 +5035,13 @@ F:	include/uapi/linux/if_hippi.h
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
