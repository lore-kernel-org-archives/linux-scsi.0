From: John Garry <john.garry@huawei.com>
Subject: [RFC PATCH] Documentation/ABI: Add sysfs-transport-sas
Date: Mon, 5 Nov 2018 22:12:17 +0800
Message-ID: <1541427137-113073-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, dann.frazier@canonical.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The SAS transport class ABI is currently undocumented.

Some systemd issues have been raised for SAS device support [1], [2].

Because of this, distros using systemd may have broken symlinks, like
/dev/disk/by-path

Unfortunately it is challenging to support SAS devices as the ABI is not well
documented and is not always intuitive, so add a stable ABI definition.

[1] https://github.com/systemd/systemd/issues/3943#issuecomment-240982482
[2] https://github.com/systemd/systemd/issues/7157

Signed-off-by: John Garry <john.garry@huawei.com>
--

I am sending this as an incomplete RFC to ensure it's the right thing to do, so
I don't bother writing the document to find it later rejected.

For now, this is just a minimal effort.

diff --git a/Documentation/ABI/stable/sysfs-transport-sas b/Documentation/ABI/stable/sysfs-transport-sas
new file mode 100644
index 0000000..6df6ffe
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-transport-sas
@@ -0,0 +1,21 @@
+What:		/sys/class/sas_phy/phy-<host>:<phy identifier>,
+				   phy-<host>:<scsi target id>:<phy identifier>
+Date:		Nov, 2018
+KernelVersion:	2.6.13
+Contact:	linux-scsi@vger.kernel.org
+Description:	SAS PHY entry directory, which includes interfaces to control
+		the PHY, physical layer information on the PHY, and other SAS
+		fabric management information asscoiated with the PHY.
+
+What:		/sys/class/sas_port/port-<host>:<port identifier>,
+				    port-<host>:<scsi target id>:<port identifier>
+Date:		Nov, 2018
+KernelVersion:	2.6.13
+Contact:	linux-scsi@vger.kernel.org
+Description:	SAS Port entry directory, with constituient PHY count and
+		other SAS fabric management information asscoiated with the
+		Port.
+
+
+
+
-- 
1.9.1
