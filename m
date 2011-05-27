From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt
 coalescing to device 	attributes in sysfs
Date: Thu, 26 May 2011 20:23:18 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAD848FB@SC-VEXCH4.marvell.com>
References: <mvsas-intr-coal>
 <1306247507-6136-1-git-send-email-yxlraid@gmail.com>
 <20110526021809.GA22496@kroah.com>
 <F766E4F80769BD478052FB6533FA745D19FAD846E0@SC-VEXCH4.marvell.com>
 <20110526141430.GD4164@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110526141430.GD4164@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org

> >>Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >>>coalescing to device attributes in sysfs

> >>On Thu, May 26, 2011 at 02:00:21AM -0700, Xiangliang Yu wrote:
> >
> >Subject: Re: [PATCH 3/9] [SCSI] mvsas: Add driver version and interrupt >coalescing to device attributes in sysfs
> >> 
> >> -- Add support for driver version and interrupt coalescing device attributes.
> >>
> >>When you add a sysfs file, you must also add a Documentation/ABI file as
> >>well.  Please do that here.
> >
> >These device attributes are sysft class properties for the scsi host,
>> and the sysfs files are within scsi host sysfs directory. so, do you
>> think I need add a ABI file?  and , I can't find anything about scsi
>> host sysfs file under directory Documentation/ABI.

>Yes, again, if you add a sysfs file, you need to add documentation
>explaining exactly what it is there for and what it does.
>
>And if there isn't already a file for this device, then please add it.
How about this:

.../ABI/testing/sysfs-bus-pci-scsi-devices-mvsas   |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas

diff --git a/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas b/Documentation/ABI/testing/sysfs-bus-pci-scsi
-devices-mvsas
new file mode 100644
index 0000000..45f597e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-pci-scsi-devices-mvsas
@@ -0,0 +1,13 @@
+What:          /sys/devices/pci/<devices>/<dev>/host/scsi_host/host/driver_version
+Date:          May 2011
+Kernel Version:        2.6.39
+Contact:       yuxiangl@marvell.com
+Description:   Display the mvsas drivers version
+
+What:          /sys/devices/pci/<devices>/<dev>/host/scsi_host/host/interrupt_coalescing
+Date:          May 2011
+Kernel Version:        2.6.39
+Contact:       yuxiangl@marvell.com
+Description:   Determines the maximum time the 88SE94XX waits after the occurrence of a
+               Command Done before generating an interrupt.The maximum number of the 
+               variable is less than 0x10000.
