From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 3787] New: Badness in scsi_device_set_state at
 drivers/scsi/scsi_lib.c:1717
Date: Sun, 21 Nov 2004 12:38:32 -0800
Message-ID: <20041121123832.3afab90f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:56709 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261705AbUKUUip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Nov 2004 15:38:45 -0500
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id iALKci919240
	for <linux-scsi@vger.kernel.org>; Sun, 21 Nov 2004 12:38:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Sun, 21 Nov 2004 06:25:30 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 3787] New: Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717


http://bugme.osdl.org/show_bug.cgi?id=3787

           Summary: Badness in scsi_device_set_state at
                    drivers/scsi/scsi_lib.c:1717
    Kernel Version: 2.6.10-rc2
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: matthias.christian@tiscali.de


Distribution: Arch Linux
Hardware Environment: Pentium4
Software Environment: GlibC 2.3.3, GCC 3.4.3
Problem Description:
usb 2-1: USB disconnect, address 3
/root/atmelwlandriver/objs/usbvnetr/release/callbacks.c: Rx Failed.!
Device atml0 closed
device disconnected
usb 2-1: new full speed USB device using uhci_hcd and address 4
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
  Vendor: Digital   Model: Camera            Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sda: 124160 512-byte hdwr sectors (64 MB)
sda: Write Protect is off
sda: Mode Sense: 00 06 00 00
sda: assuming drive cache: write through
 /dev/scsi/host0/bus0/target0/lun0: p1
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
usb-storage: device scan complete
usb 2-1: USB disconnect, address 4
 target0:0:0: Illegal state transition <NULL>->cancel
Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717
 [<c03baf61>] scsi_device_set_state+0xba/0x13e
 [<c03b5ed6>] scsi_device_cancel+0x2a/0xf3
 [<c03b5ffd>] scsi_device_cancel_cb+0x0/0x1c
 [<c0370a8f>] device_for_each_child+0x3c/0x69
 [<c03b604a>] scsi_host_cancel+0x31/0xbc
 [<c03b5ffd>] scsi_device_cancel_cb+0x0/0x1c
 [<c03029a4>] kobject_put+0x1e/0x22
 [<c03029a4>] kobject_put+0x1e/0x22
 [<c030297c>] kobject_release+0x0/0xa
 [<c03bd41a>] scsi_remove_device+0x7d/0xaf
 [<c03bc657>] scsi_forget_host+0x39/0x58
 [<c03b60f5>] scsi_remove_host+0x20/0x7d
 [<d91f4000>] storage_disconnect+0x83/0x98 [usb_storage]
 [<d8fe2104>] usb_unbind_interface+0x7c/0x7e [usbcore]
 [<c03718ab>] device_release_driver+0x7f/0x81
 [<c0371afc>] bus_remove_device+0x65/0xa7
 [<c03709e7>] device_del+0x59/0xa8
 [<d8fe9b18>] usb_disable_device+0x77/0xea [usbcore]
 [<d8fe4477>] usb_disconnect+0xb8/0x162 [usbcore]
 [<d8fe5ee8>] hub_port_connect_change+0x339/0x42d [usbcore]
 [<d8fe3135>] clear_port_feature+0x58/0x5c [usbcore]
 [<d8fe618c>] hub_events+0x1b0/0x3b3 [usbcore]
 [<d8fe63c6>] hub_thread+0x37/0x105 [usbcore]
 [<c0132a86>] autoremove_wake_function+0x0/0x57
 [<c0103042>] ret_from_fork+0x6/0x14
 [<c0132a86>] autoremove_wake_function+0x0/0x57
 [<d8fe638f>] hub_thread+0x0/0x105 [usbcore]
 [<c010128d>] kernel_thread_helper+0x5/0xb

Steps to reproduce:
I pluged-in my Digital Camera, I copied some files, I pluged it out und pluged
it in a second time.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
