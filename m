From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Fri, 07 Feb 2014 15:54:26 +0000
Message-ID: <bug-60758-11613-DIFrn8Tgyf@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaBGPya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 10:54:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C6E7520125
	for <linux-scsi@vger.kernel.org>; Fri,  7 Feb 2014 15:54:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 33DF72017B
	for <linux-scsi@vger.kernel.org>; Fri,  7 Feb 2014 15:54:27 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

kometch@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kometch@gmail.com

--- Comment #56 from kometch@gmail.com ---
I also tried to introduced something to CentOS 6.5 and KVM on Ubuntu13.10, was
the kernel compile the Kernel 3.13.2, but it does not start and continue to be
output "module scsi_wait_scan not found". 

In the following, there is no /block/virtio_blk.ko result of the execution of
lsinitrd. 

# Lsinitrd /boot/initramfs-3.13.2.img | grep virt 
drwxr-xr-x 2 root root 0 Feb 8 00:50 lib/modules/3.13.2/kernel/drivers/virtio 
-rw-r - r - 1 root root 13216 Feb 8 00:50
lib/modules/3.13.2/kernel/drivers/virtio/virtio.ko 
-rw-r - r - 1 root root 19944 Feb 8 00:50
lib/modules/3.13.2/kernel/drivers/virtio/virtio_pci.ko 
-rw-r - r - 1 root root 19448 Feb 8 00:50
lib/modules/3.13.2/kernel/drivers/virtio/virtio_ring.ko 

it did not improve work even reconfigure the initramfs with dracut. 

Is there a way to deal about this?

-- 
You are receiving this mail because:
You are the assignee for the bug.
