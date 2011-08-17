From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] scsi: document generic scsi host sysfs attributes
Date: Wed, 17 Aug 2011 13:20:47 -0500
Message-ID: <20110817182047.8821.55211.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:39536 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab1HQSUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 14:20:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/ABI/testing/sysfs-bus-scsi |  121 ++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-scsi

diff --git a/Documentation/ABI/testing/sysfs-bus-scsi b/Documentation/ABI/testing/sysfs-bus-scsi
new file mode 100644
index 0000000..fe4d36e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-scsi
@@ -0,0 +1,121 @@
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/unique_id
+Date:		February, 2003
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only unsigned integer uniquely identifying the SCSI host
+		within the system.  This value is assigned by the low level
+		driver.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/host_busy
+Date:		February 2003
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only unsigned short integer indicating whether the SCSI
+		host is busy.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/cmd_per_lun
+Date:		February 2003
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only short integer indicating how many concurrent
+		commands per logical unit the SCSI host supports.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/can_queue
+Date:		October, 2006
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only short integer indicating the total number of
+		concurrent commands the SCSI host supports.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/sg_tablesize
+Date:		February, 2003
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only unsigned short integer indicating how many scatter
+		gather entries are available for each command.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/sg_prot_tablesize
+Date:		September, 2010
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only unsigned short integer which indicates how many
+		scatter gather entries are available for DIX integrity data.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/unchecked_isa_dma
+Date:		February, 2003
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/proc_name
+Date:		March, 2004
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/scan
+Date:		August, 2003
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only integer which indicates whether the host is an
+		ancient ISA device which therefore requires extra bounce
+		buffering.
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/hstate
+Date:		February, 2008
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		String value which indicates the state of the SCSI host.
+		Possible values are: "created", "running", "cancel",
+		"deleted", "recovery", "cancel/recovery" and "deleted/recovery"
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/supported_mode
+Date:		October, 2007
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only string value which indicates the supported modes of
+		the SCSI host.  Possible modes are: "Initiator" and "Target".
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/active_mode
+Date:		October, 2007
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only string value which indicates the currently active
+		mode of the SCSI host.  Possible values are "Initiator",
+		"Target" and "unknown".
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/prot_capabilities
+Date:		July, 2008
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only unsigned integer bitmap which indicates what
+		data integrity capabilities the SCSI host supports.
+		Bit 0: T10 DIF type 1
+		Bit 1: T10 DIF type 2
+		Bit 2: T10 DIF type 3
+		Bit 3: DIX between OS and HBA only.
+		Bit 4: DIX with DIF type 1
+		Bit 5: DIX with DIF type 2
+		Bit 6: DIX with DIF type 3
+
+What:		/sys/bus/scsi/devices/host*/scsi_host/host*/prot_guard_type
+Date:		July, 2008
+KernelVersion:	Unknown
+Contact:	James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Read only unsigned short bitmap value which indicates what
+		checksums DIX capable controllers implement.
+		Bit 0: DIX guard CRC.
+		Bit 1: DIX guard IP.
+

