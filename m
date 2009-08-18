From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 13988] New: Oops and NULL pointer with USB
 disk
Date: Tue, 18 Aug 2009 16:32:11 -0700
Message-ID: <20090818163211.1a0d0ff4.akpm@linux-foundation.org>
References: <bug-13988-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958AbZHRXdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2009 19:33:18 -0400
In-Reply-To: <bug-13988-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, subcon@c2i.net


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 15 Aug 2009 10:44:40 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13988
>
>            Summary: Oops and NULL pointer with USB disk
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.30.4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Serial ATA
>         AssignedTo: jgarzik@pobox.com
>         ReportedBy: subcon@c2i.net
>         Regression: No
>

Something for everyone here!

> Connected an IDE disk to an USB adapter and got lots of the following messages:
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>
> Eventually it times out and gives a call trace. (dmesg below)
> When I unplugged the disk I got a NULL pointer dereference. (also in dmesg
> below)
>
> I am running Arch Linux with stock kernel. Kernel config can be found here:
> http://repos.archlinux.org/viewvc.cgi/kernel26/repos/core-x86_64/
>
> PS: This disk might be broken.
>
>
> Initializing USB Mass Storage driver...
> scsi8 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> scsi 8:0:0:0: Direct-Access     SAMSUNG  SP0411N          0-11 PQ: 0 ANSI: 2
> CCS
> sd 8:0:0:0: Attached scsi generic sg2 type 0
> sd 8:0:0:0: [sdb] 78242976 512-byte hardware sectors: (40.0 GB/37.3 GiB)
> sd 8:0:0:0: [sdb] Write Protect is off
> sd 8:0:0:0: [sdb] Mode Sense: 00 38 00 00
> sd 8:0:0:0: [sdb] Assuming drive cache: write through
> sd 8:0:0:0: [sdb] Assuming drive cache: write through
>  sdb:<6>sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> usb-storage: device scan complete
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> INFO: task async/0:3992 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> async/0       D ffff8801353bb8d0     0  3992      2
>  ffff8801353bb8d0 0000000000000046 ffff880124f2cf00 0000000088d0e6cd
>  ffff880124dfd000 ffff880137c0f7f0 ffff8801353bbb70 00000000000111c0
>  000000000000cb68 ffff8801353bbb70 ffff8801282b2730 0000000088d0e6cd
> Call Trace:
>  [<ffffffff802bf790>] ? sync_page+0x0/0x80
>  [<ffffffff8054e529>] ? schedule+0x29/0x70
>  [<ffffffff8054e5dd>] ? io_schedule+0x6d/0xd0
>  [<ffffffff802bf7dd>] ? sync_page+0x4d/0x80
>  [<ffffffff8054ec3a>] ? __wait_on_bit_lock+0x5a/0xc0
>  [<ffffffff80330a30>] ? blkdev_readpage+0x0/0x40
>  [<ffffffff802bf72c>] ? __lock_page+0x6c/0x90
>  [<ffffffff8026c880>] ? wake_bit_function+0x0/0x70
>  [<ffffffff802bff5c>] ? read_cache_page_async+0x19c/0x1b0
>  [<ffffffff803bd444>] ? string+0x64/0x130
>  [<ffffffff802bff89>] ? read_cache_page+0x19/0x80
>  [<ffffffff8036575a>] ? read_dev_sector+0x3a/0xc0
>  [<ffffffff8036a037>] ? read_lba+0xa7/0xe0
>  [<ffffffff8036a411>] ? efi_partition+0xe1/0x8b0
>  [<ffffffff8054d50b>] ? printk+0x50/0x6d
>  [<ffffffff8036679a>] ? rescan_partitions+0x1ca/0x3f0
>  [<ffffffff803312c2>] ? __blkdev_get+0x1a2/0x3c0
>  [<ffffffff80365955>] ? register_disk+0x175/0x1a0
>  [<ffffffff803a6ac2>] ? blk_register_region+0x32/0x50
>  [<ffffffff803a6d24>] ? add_disk+0x94/0x170
>  [<ffffffffa0168021>] ? sd_probe_async+0x1b1/0x320 [sd_mod]
>  [<ffffffff80275042>] ? async_thread+0x112/0x280
>  [<ffffffff802495c0>] ? default_wake_function+0x0/0x40
>  [<ffffffff80274f30>] ? async_thread+0x0/0x280
>  [<ffffffff8026c204>] ? kthread+0x64/0xc0
>  [<ffffffff8024af20>] ? schedule_tail+0x30/0x80
>  [<ffffffff8020d4fa>] ? child_rip+0xa/0x20
>  [<ffffffff8026c1a0>] ? kthread+0x0/0xc0
>  [<ffffffff8020d4f0>] ? child_rip+0x0/0x20

We seem to be spending vast amounts of time retrying reads agains a dud
device.

> ...
>
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
> sd 8:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> usb 2-3: USB disconnect, address 2
> sd 8:0:0:0: [sdb] Unhandled error code
> sd 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sdb, sector 0
> Buffer I/O error on device sdb, logical block 0
> scsi 8:0:0:0: [sdb] Unhandled error code
> scsi 8:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
> end_request: I/O error, dev sdb, sector 0
> Buffer I/O error on device sdb, logical block 0
> ldm_validate_partition_table(): Disk read failed.
>  unable to read partition table

Eventually we get the IO error.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> IP: [<ffffffff803a7158>] disk_part_iter_next+0x138/0x160
> PGD bd713067 PUD bd6c2067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3:1.0/host8/target8:0:0/8:0:0:0/bsg/8:0:0:0/dev
> CPU 1
> Modules linked in: usb_storage usbhid hid usblp uvcvideo videodev v4l1_compat
> v4l2_compat_ioctl32 snd_usb_audio snd_usb_lib snd_rawmidi
> snd_hda_codec_intelhdmi snd_hda_codec_idt snd_seq_dummy fan snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device battery ac snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_timer uhci_hcd cpufreq_ondemand snd
> soundcore snd_page_alloc ehci_hcd usbcore acpi_cpufreq sg e1000e heci(C)
> psmouse thermal button iTCO_wdt iTCO_vendor_support serio_raw i2c_i801 evdev
> freq_table processor coretemp rtc_cmos rtc_core rtc_lib dm_mod sd_mod sr_mod
> cdrom pata_acpi ata_generic ata_piix ahci libata scsi_mod reiserfs i915
> i2c_algo_bit video output drm i2c_core intel_agp
> Pid: 3992, comm: async/0 Tainted: G         C 2.6.30-ARCH #1
> RIP: 0010:[<ffffffff803a7158>]  [<ffffffff803a7158>]
> disk_part_iter_next+0x138/0x160
> RSP: 0000:ffff880124f19dc0  EFLAGS: 00010246
> RAX: ffff880124dffc00 RBX: ffff880124f19df0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff880124dffc00 RDI: 0000000000000000
> RBP: ffff88013b588a80 R08: 0000000000000000 R09: ffffffff805f9bf5
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880124dffc58
> R13: 0000000000000000 R14: ffff880124dfd120 R15: ffff88012345fc10
> FS:  0000000000000000(0000) GS:ffff88002803b000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000010 CR3: 00000000bd7a8000 CR4: 00000000000406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process async/0 (pid: 3992, threadinfo ffff880124f18000, task ffff8801353bb8d0)
> Stack:
>  ffff88013b588a80 0000000088d0e6cd ffff880124dffc00 ffff88013b588a80
>  ffff880124dffc58 ffffffff803658e3 ffff880124dffc00 0000000000000000
>  0000000000000001 0000000088d0e6cd ffff880124dffc00 ffff880124dffc00
> Call Trace:
>  [<ffffffff803658e3>] ? register_disk+0x103/0x1a0
>  [<ffffffff803a6d24>] ? add_disk+0x94/0x170
>  [<ffffffffa0168021>] ? sd_probe_async+0x1b1/0x320 [sd_mod]
>  [<ffffffff80275042>] ? async_thread+0x112/0x280
>  [<ffffffff802495c0>] ? default_wake_function+0x0/0x40
>  [<ffffffff80274f30>] ? async_thread+0x0/0x280
>  [<ffffffff8026c204>] ? kthread+0x64/0xc0
>  [<ffffffff8024af20>] ? schedule_tail+0x30/0x80
>  [<ffffffff8020d4fa>] ? child_rip+0xa/0x20
>  [<ffffffff8026c1a0>] ? kthread+0x0/0xc0
>  [<ffffffff8020d4f0>] ? child_rip+0x0/0x20
> Code: 38 48 83 c4 10 5b 5d 41 5c c3 66 0f 1f 84 00 00 00 00 00 48 8d 7d 10 e8
> 17 82 0b 00 48 89 6b 08 44 01 63 10 eb a5 0f 1f 44 00 00 <8b> 77 10 41 bc 01 00
> 00 00 e9 2b ff ff ff e8 45 7e ea ff e8 a0
> RIP  [<ffffffff803a7158>] disk_part_iter_next+0x138/0x160
>  RSP <ffff880124f19dc0>
> CR2: 0000000000000010

And disk_part_iter_next() goes splat.
