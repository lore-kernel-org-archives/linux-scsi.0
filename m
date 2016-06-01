From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v4 2/8] char: rpmb: add sysfs-class ABI documentation
Date: Wed,  1 Jun 2016 17:41:26 -0400
Message-ID: <1464817292-5407-3-git-send-email-tomas.winkler@intel.com>
References: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

V2: resend
V3: add more verbose description
V4: update kernel version to 4.8

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ABI/testing/sysfs-class-rpmb | 20 ++++++++++++++++++++
 MAINTAINERS                                |  1 +
 2 files changed, 21 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rpmb

diff --git a/Documentation/ABI/testing/sysfs-class-rpmb b/Documentation/ABI/testing/sysfs-class-rpmb
new file mode 100644
index 000000000000..44ee4d31dc0b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-rpmb
@@ -0,0 +1,20 @@
+What:		/sys/class/rpmb/
+Date:		Jun 2016
+KernelVersion:  4.8
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The rpmb/ class sub-directory belongs to RPMB device class.
+
+		Few storage technologies such is EMMC, UFS, and NVMe support
+		Replay Protected Memory Block (RPMB) hardware partition with
+		common protocol and frame layout.
+		Such a partition provides authenticated and replay protected access,
+		hence suitable as a secure storage.
+
+What:		/sys/class/rpmb/rpmbN/
+Date:		Jun 2016
+KernelVersion:	4.8
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN directory is created for
+		each RPMB registered device
diff --git a/MAINTAINERS b/MAINTAINERS
index e045c3a43920..b4228dd58e06 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9697,6 +9697,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/char/rpmb/*
 F:	include/linux/rpmb.h
+F:	Documentation/ABI/testing/sysfs-class-rpmb
 
 RTL2830 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
-- 
2.5.5
