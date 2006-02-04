From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 6007] New: oops inside scsi_target_reap_work
 on x86_64
Date: Sat, 4 Feb 2006 00:38:05 -0800
Message-ID: <20060204003805.13cf711a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24274 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1946171AbWBDIi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2006 03:38:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Sat, 4 Feb 2006 00:29:40 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 6007] New: oops inside scsi_target_reap_work on x86_64


http://bugzilla.kernel.org/show_bug.cgi?id=6007

           Summary: oops inside scsi_target_reap_work on x86_64
    Kernel Version: 2.6.16-rc2
            Status: NEW
          Severity: high
             Owner: andmike@us.ibm.com
         Submitter: bug-track@fisher-privat.net


Most recent kernel where this bug did not occur:2.6.16-rc1 - 2.6.16-rc2
Distribution: Ubuntu Breezy x86_64
Hardware Environment: usb-storage deivce.
Software Environment:
Problem Description:
after usb-storage is attached (dasn't metter wat kind of usb-storage) come
fallowing message:
[ 8023.490364] sd 2:0:0:0: Attached scsi removable disk sdb
[ 8023.490376] kobject 2:0:0:0: registering. parent: scsi_device, set: class_obj
[ 8023.490385] kobject_uevent
[ 8023.490391] fill_kobj_path: path = '/class/scsi_device/2:0:0:0'
[ 8023.490398] fill_kobj_path: path =
'/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/host2/target2:0:0/2:0:0:0'
[ 8023.490632] kobject target2:0:1: registering. parent: host2, set: devices
[ 8023.490643] kobject_uevent
[ 8023.490983] kobject <NULL>: cleaning up
[ 8023.490996] kobject target2:0:2: registering. parent: host2, set: devices
[ 8023.491014] kobject_uevent
[ 8023.491066] general protection fault: 0000 [1] 
[ 8023.491072] CPU 0 
[ 8023.491074] Modules linked in: usb_storage binfmt_misc fan container
af_packet piix snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_timer snd snd_page_alloc nls_cp437 vfat fat nls_utf8 ntfs unix
[ 8023.491089] Pid: 4, comm: events/0 Not tainted 2.6.16-rc1-debug #1
[ 8023.491093] RIP: 0010:[<ffffffff8025c3c7>] <ffffffff8025c3c7>{device_del+61}

After this keyboard is dead.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
