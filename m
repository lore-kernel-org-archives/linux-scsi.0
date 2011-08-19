From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] scsi: Document generic scsi device attributes
Date: Fri, 19 Aug 2011 09:44:27 -0500
Message-ID: <20110819144427.15191.54676.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 Documentation/ABI/testing/sysfs-class-scsi_devices |  130 ++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_devices

diff --git a/Documentation/ABI/testing/sysfs-class-scsi_devices b/Documentation/ABI/testing/sysfs-class-scsi_devices
new file mode 100644
index 0000000..cee5619
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-scsi_devices
@@ -0,0 +1,130 @@
+What:           /sys/class/scsi_device/..../device/device_blocked
+Date:           December, 2002
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only integer attribute indicates whether the
+		device is blocked.  A non-zero value indicates the device
+		is blocked, zero indicates the device is not blocked.
+
+What:           /sys/class/scsi_device/..../device/type
+Date:           December, 2002
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only decimal integer value indicates the
+		SCSI device type.  See also table 47 in section 8.2.5.1
+		"Standard INQUIRY data" of the SCSI-2 specification.
+
+What:           /sys/class/scsi_device/..../device/scsi_level
+Date:           January, 2003
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only decimal integer value indicates the
+		SCSI revision level the device claims to support.
+
+What:           /sys/class/scsi_device/..../device/vendor
+Date:           December, 2002
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only string attribute contains the vendor of the SCSI
+		device.
+
+What:           /sys/class/scsi_device/..../device/model
+Date:           December 2002
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only string attribute contains the model of the SCSI
+		device.
+
+What:           /sys/class/scsi_device/..../device/rev
+Date:           December, 2002
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only string attribute contains the product revision
+		of the SCSI device.
+
+What:           /sys/class/scsi_device/..../device/rescan
+Date:           March, 2003
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		When written to, this write-only attribute causes the 
+		target device driver to rescan the device if the target
+		driver implements any sort of rescan -- currently only the
+		sd driver does.
+
+What:           /sys/class/scsi_device/..../device/delete
+Date:           August, 2003
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		Writing to this write only attribute causes the SCSI device to
+		be removed from the SCSI midlayer.
+
+What:           /sys/class/scsi_device/..../device/state
+Date:           April, 2004
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read/write string attribute allows setting or retrieving
+		the current state of the SCSI device.  Possible values are
+		"created", "running", "cancel", "deleted", "quiesce", "offline",
+		"blocked" and "created-blocked"
+
+What:           /sys/class/scsi_device/..../device/timeout
+Date:           May, 2004
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read/write decimal integer attribute contains the number
+		of seconds which may elapse after sending a command to the
+		device before that command is considered to have timed out.
+
+What:           /sys/class/scsi_device/..../device/iocounterbits
+Date:           March, 2005
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only integer value shows the number of bits
+		used to represent the various I/O counters.
+
+What:           /sys/class/scsi_device/..../device/iorequest_cnt
+Date:           March, 2005
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only integer value indicates how many I/O requests
+		have been submitted to the SCSI device.
+
+What:           /sys/class/scsi_device/..../device/iodone_cnt
+Date:           March, 2005
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only integer value indicates how many I/O requests
+		have been completed by the SCSI device.
+
+What:           /sys/class/scsi_device/..../device/ioerr_cnt
+Date:           March, 2005
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only integer value indicates how many I/O requests
+		have been completed with errors by the SCSI device.
+
+What:           /sys/class/scsi_device/..../device/modalias
+Date:           April, 2007
+KernelVersion:  Unknown
+Contact:        James Bottomley <James.Bottomley@HansenPartnership.com>
+Description:
+		This read only string value contains a string of the form
+		"scsi:t-0xXX" where "XX" are two hex digits representing the
+		SCSI device type.  See also the "type" attribute and table 47
+		in section 8.2.5.1 "Standard INQUIRY data" of the SCSI-2
+		specification.
+
