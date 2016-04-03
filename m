From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/8] char: rpmb: add sysfs-class ABI documentation
Date: Sun,  3 Apr 2016 12:42:46 +0300
Message-ID: <1459676572-29921-3-git-send-email-tomas.winkler@intel.com>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ABI/testing/sysfs-class-rpmb | 15 +++++++++++++++
 MAINTAINERS                                |  1 +
 2 files changed, 16 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rpmb

diff --git a/Documentation/ABI/testing/sysfs-class-rpmb b/Documentation/ABI/testing/sysfs-class-rpmb
new file mode 100644
index 000000000000..62d1959bf19e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-rpmb
@@ -0,0 +1,15 @@
+What:		/sys/class/rpmb/
+Date:		Mar 2016
+KernelVersion:	TBD
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The rpmb/ class sub-directory belongs to RPMB device class
+
+
+What:		/sys/class/rpmb/rpmbN/
+Date:		Mar 2016
+KernelVersion:	TBD
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN directory is created for
+		each RPMB registered device
diff --git a/MAINTAINERS b/MAINTAINERS
index d1d7b7ffedab..08316d8284ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9430,6 +9430,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/char/rpmb/*
 F:	include/linux/rpmb.h
+F:	Documentation/ABI/testing/sysfs-class-rpmb
 
 RTL2830 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
-- 
2.4.3
