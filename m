From: Mark Bellon <mbellon@mvista.com>
Subject: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Mon, 27 Oct 2003 13:40:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9D82BD.4080609@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:38640 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S263513AbTJ0Ukb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2003 15:40:31 -0500
Received: from mvista.com (av [127.0.0.1])
	by av.mvista.com (8.9.3/8.9.3) with ESMTP id MAA24396
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2003 12:40:29 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Initial availability of User-Space System Device Enumeration (uSDE) 
package, version 0.74, can be found at http://sourceforge.net/projects/usde

The uSDE provides an open framework for the enumeration (specification) 
of system devices in a dynamic environment. Device handling is 
implemented via plug-in programs known as policy methods. Policy methods 
are free to handle their devices in any way, from trivial to complex - 
anything from providing LSB device nodes to persistent device name 
handling with
replacement and relocation strategies.

The uSDE depends on /sbin/hotplug (for dynamic insertions and removals), 
sysfs (for device information) and /proc (various pieces of 
information). It is not dependent on initrd - it explicitly scans sysfs 
upon system startup to determine the initial device ensemble.

Part of the uSDE release is a collection of sample polices:

disk-ide-policy - handles IDE, EIDE, SATA and USB-EIDE disks. Implements 
persistent device naming, automatic device replacement and automatic 
device relocation features.

disk-scsi-policy - handles SCSI, IEEE-1394, FibreChannel and USB-SCSI 
disks including multiported devices. Iplements persistent device naming, 
automatic device replacement and automatic device relocation features.

multipath-policy - handles the automatic provisioning of multipathing 
for multiported storage devices.

ethernet-policy - handles ethernet interefaces. Implements persistent 
interface naming, interface anchoring, automatic device replacement and 
automatic device relocation features.

floppy-policy - handles internal floppy disks.

simple-device-policy - a "catch all" policy for block and character devices.

devfs-policy - provides devfs device names.

lsb-policy - provides LSB device names.


Location:       http://sourceforge.net/projects/usde
Mailing list:   usde-general@lists.sourceforge.net

mark


