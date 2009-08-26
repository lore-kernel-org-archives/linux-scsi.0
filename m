From: Joachim <subcon@c2i.net>
Subject: [Bugme-new] [Bug 13988] New: Oops and NULL pointer with USB disk
Date: Wed, 26 Aug 2009 18:24:44 +0200
Message-ID: <op.uy92ji0ua0dvw8@system-8510>
References: <bug-13988-10286@http.bugzilla.kernel.org/> <20090818163211.1a0d0ff4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090818163211.1a0d0ff4.akpm@linux-foundation.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

P=E5 Wed, 19 Aug 2009 01:32:11 +0200, skrev Andrew Morton =20
<akpm@linux-foundation.org>:
>
> (switched to email.  Please respond via emailed reply-to-all, not via=
 the
> bugzilla web interface).
>
> On Sat, 15 Aug 2009 10:44:40 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
>
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D13988
>>
>>            Summary: Oops and NULL pointer with USB disk
>>            Product: IO/Storage
>>            Version: 2.5
>>     Kernel Version: 2.6.30.4
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Serial ATA
>>         AssignedTo: jgarzik@pobox.com
>>         ReportedBy: subcon@c2i.net
>>         Regression: No
>>
>
> Something for everyone here!
>
>> Connected an IDE disk to an USB adapter and got lots of the followin=
g =20
>> messages:
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>>
>> Eventually it times out and gives a call trace. (dmesg below)
>> When I unplugged the disk I got a NULL pointer dereference. (also in=
 =20
>> dmesg
>> below)
>>
>> I am running Arch Linux with stock kernel. Kernel config can be foun=
d =20
>> here:
>> http://repos.archlinux.org/viewvc.cgi/kernel26/repos/core-x86_64/
>>
>> PS: This disk might be broken.
>>
>>
>> Initializing USB Mass Storage driver...
>> scsi8 : SCSI emulation for USB Mass Storage devices
>> usbcore: registered new interface driver usb-storage
>> USB Mass Storage support registered.
>> usb-storage: device found at 2
>> usb-storage: waiting for device to settle before scanning
>> scsi 8:0:0:0: Direct-Access     SAMSUNG  SP0411N          0-11 PQ: 0=
 =20
>> ANSI: 2
>> CCS
>> sd 8:0:0:0: Attached scsi generic sg2 type 0
>> sd 8:0:0:0: [sdb] 78242976 512-byte hardware sectors: (40.0 GB/37.3 =
GiB)
>> sd 8:0:0:0: [sdb] Write Protect is off
>> sd 8:0:0:0: [sdb] Mode Sense: 00 38 00 00
>> sd 8:0:0:0: [sdb] Assuming drive cache: write through
>> sd 8:0:0:0: [sdb] Assuming drive cache: write through
>>  sdb:<6>sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> usb-storage: device scan complete
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> INFO: task async/0:3992 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =20
>> message.
>> async/0       D ffff8801353bb8d0     0  3992      2
>>  ffff8801353bb8d0 0000000000000046 ffff880124f2cf00 0000000088d0e6cd
>>  ffff880124dfd000 ffff880137c0f7f0 ffff8801353bbb70 00000000000111c0
>>  000000000000cb68 ffff8801353bbb70 ffff8801282b2730 0000000088d0e6cd
>> Call Trace:
>>  [<ffffffff802bf790>] ? sync_page+0x0/0x80
>>  [<ffffffff8054e529>] ? schedule+0x29/0x70
>>  [<ffffffff8054e5dd>] ? io_schedule+0x6d/0xd0
>>  [<ffffffff802bf7dd>] ? sync_page+0x4d/0x80
>>  [<ffffffff8054ec3a>] ? __wait_on_bit_lock+0x5a/0xc0
>>  [<ffffffff80330a30>] ? blkdev_readpage+0x0/0x40
>>  [<ffffffff802bf72c>] ? __lock_page+0x6c/0x90
>>  [<ffffffff8026c880>] ? wake_bit_function+0x0/0x70
>>  [<ffffffff802bff5c>] ? read_cache_page_async+0x19c/0x1b0
>>  [<ffffffff803bd444>] ? string+0x64/0x130
>>  [<ffffffff802bff89>] ? read_cache_page+0x19/0x80
>>  [<ffffffff8036575a>] ? read_dev_sector+0x3a/0xc0
>>  [<ffffffff8036a037>] ? read_lba+0xa7/0xe0
>>  [<ffffffff8036a411>] ? efi_partition+0xe1/0x8b0
>>  [<ffffffff8054d50b>] ? printk+0x50/0x6d
>>  [<ffffffff8036679a>] ? rescan_partitions+0x1ca/0x3f0
>>  [<ffffffff803312c2>] ? __blkdev_get+0x1a2/0x3c0
>>  [<ffffffff80365955>] ? register_disk+0x175/0x1a0
>>  [<ffffffff803a6ac2>] ? blk_register_region+0x32/0x50
>>  [<ffffffff803a6d24>] ? add_disk+0x94/0x170
>>  [<ffffffffa0168021>] ? sd_probe_async+0x1b1/0x320 [sd_mod]
>>  [<ffffffff80275042>] ? async_thread+0x112/0x280
>>  [<ffffffff802495c0>] ? default_wake_function+0x0/0x40
>>  [<ffffffff80274f30>] ? async_thread+0x0/0x280
>>  [<ffffffff8026c204>] ? kthread+0x64/0xc0
>>  [<ffffffff8024af20>] ? schedule_tail+0x30/0x80
>>  [<ffffffff8020d4fa>] ? child_rip+0xa/0x20
>>  [<ffffffff8026c1a0>] ? kthread+0x0/0xc0
>>  [<ffffffff8020d4f0>] ? child_rip+0x0/0x20
>
> We seem to be spending vast amounts of time retrying reads agains a d=
ud
> device.
>
>> ...
>>
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
>> sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
>> usb 2-3: USB disconnect, address 2
>> sd 8:0:0:0: [sdb] Unhandled error code
>> sd 8:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
>> end_request: I/O error, dev sdb, sector 0
>> Buffer I/O error on device sdb, logical block 0
>> scsi 8:0:0:0: [sdb] Unhandled error code
>> scsi 8:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
>> end_request: I/O error, dev sdb, sector 0
>> Buffer I/O error on device sdb, logical block 0
>> ldm_validate_partition_table(): Disk read failed.
>>  unable to read partition table
>
> Eventually we get the IO error.
>
>> BUG: unable to handle kernel NULL pointer dereference at =20
>> 0000000000000010
>> IP: [<ffffffff803a7158>] disk_part_iter_next+0x138/0x160
>> PGD bd713067 PUD bd6c2067 PMD 0
>> Oops: 0000 [#1] PREEMPT SMP
>> last sysfs file:
>> /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3:1.0/host8/target8:=
0:0/8:0:0:0/bsg/8:0:0:0/dev
>> CPU 1
>> Modules linked in: usb_storage usbhid hid usblp uvcvideo videodev =20
>> v4l1_compat
>> v4l2_compat_ioctl32 snd_usb_audio snd_usb_lib snd_rawmidi
>> snd_hda_codec_intelhdmi snd_hda_codec_idt snd_seq_dummy fan snd_seq_=
oss
>> snd_seq_midi_event snd_seq snd_seq_device battery ac snd_hda_intel
>> snd_hda_codec snd_hwdep snd_pcm snd_timer uhci_hcd cpufreq_ondemand =
snd
>> soundcore snd_page_alloc ehci_hcd usbcore acpi_cpufreq sg e1000e hec=
i(C)
>> psmouse thermal button iTCO_wdt iTCO_vendor_support serio_raw i2c_i8=
01 =20
>> evdev
>> freq_table processor coretemp rtc_cmos rtc_core rtc_lib dm_mod sd_mo=
d =20
>> sr_mod
>> cdrom pata_acpi ata_generic ata_piix ahci libata scsi_mod reiserfs i=
915
>> i2c_algo_bit video output drm i2c_core intel_agp
>> Pid: 3992, comm: async/0 Tainted: G         C 2.6.30-ARCH #1
>> RIP: 0010:[<ffffffff803a7158>]  [<ffffffff803a7158>]
>> disk_part_iter_next+0x138/0x160
>> RSP: 0000:ffff880124f19dc0  EFLAGS: 00010246
>> RAX: ffff880124dffc00 RBX: ffff880124f19df0 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: ffff880124dffc00 RDI: 0000000000000000
>> RBP: ffff88013b588a80 R08: 0000000000000000 R09: ffffffff805f9bf5
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880124dffc58
>> R13: 0000000000000000 R14: ffff880124dfd120 R15: ffff88012345fc10
>> FS:  0000000000000000(0000) GS:ffff88002803b000(0000) =20
>> knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 0000000000000010 CR3: 00000000bd7a8000 CR4: 00000000000406e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process async/0 (pid: 3992, threadinfo ffff880124f18000, task =20
>> ffff8801353bb8d0)
>> Stack:
>>  ffff88013b588a80 0000000088d0e6cd ffff880124dffc00 ffff88013b588a80
>>  ffff880124dffc58 ffffffff803658e3 ffff880124dffc00 0000000000000000
>>  0000000000000001 0000000088d0e6cd ffff880124dffc00 ffff880124dffc00
>> Call Trace:
>>  [<ffffffff803658e3>] ? register_disk+0x103/0x1a0
>>  [<ffffffff803a6d24>] ? add_disk+0x94/0x170
>>  [<ffffffffa0168021>] ? sd_probe_async+0x1b1/0x320 [sd_mod]
>>  [<ffffffff80275042>] ? async_thread+0x112/0x280
>>  [<ffffffff802495c0>] ? default_wake_function+0x0/0x40
>>  [<ffffffff80274f30>] ? async_thread+0x0/0x280
>>  [<ffffffff8026c204>] ? kthread+0x64/0xc0
>>  [<ffffffff8024af20>] ? schedule_tail+0x30/0x80
>>  [<ffffffff8020d4fa>] ? child_rip+0xa/0x20
>>  [<ffffffff8026c1a0>] ? kthread+0x0/0xc0
>>  [<ffffffff8020d4f0>] ? child_rip+0x0/0x20
>> Code: 38 48 83 c4 10 5b 5d 41 5c c3 66 0f 1f 84 00 00 00 00 00 48 8d=
 7d =20
>> 10 e8
>> 17 82 0b 00 48 89 6b 08 44 01 63 10 eb a5 0f 1f 44 00 00 <8b> 77 10 =
41 =20
>> bc 01 00
>> 00 00 e9 2b ff ff ff e8 45 7e ea ff e8 a0
>> RIP  [<ffffffff803a7158>] disk_part_iter_next+0x138/0x160
>>  RSP <ffff880124f19dc0>
>> CR2: 0000000000000010
>
> And disk_part_iter_next() goes splat.

Here are a couple of dmegs's with the add_disk-debug.patch from Tejun.

usb 1-1: new high speed USB device using ehci_hcd and address 5
usb 1-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
scsi 6:0:0:0: Direct-Access                                    PQ: 0 AN=
SI: =20
2 CCS
sd 6:0:0:0: Attached scsi generic sg1 type 0
XXX add_disk sdb
XXX add_disk sdb done
sd 6:0:0:0: [sdb] Attached SCSI disk
usb-storage: device scan complete
usb 1-1: USB disconnect, address 5
XXX disk_release sg1
XXX disk_release sdb
usb 1-1: new high speed USB device using ehci_hcd and address 6
usb 1-1: configuration #1 chosen from 1 choice
scsi7 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 7:0:0:0: Direct-Access     SAMSUNG  SP0411N          0-11 PQ: 0 AN=
SI: =20
2 CCS
sd 7:0:0:0: Attached scsi generic sg1 type 0
sd 7:0:0:0: [sdb] 78242976 512-byte hardware sectors: (40.0 GB/37.3 GiB=
)
sd 7:0:0:0: [sdb] Write Protect is off
sd 7:0:0:0: [sdb] Mode Sense: 00 38 00 00
sd 7:0:0:0: [sdb] Assuming drive cache: write through
XXX add_disk sdb
sd 7:0:0:0: [sdb] Assuming drive cache: write through
  sdb:<7>usb-storage: device scan complete
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
INFO: task async/0:1798 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
async/0       D 5e5f62fe     0  1798      2
  f616dc00 00000046 00000246 5e5f62fe f80cfba4 5e5f62fe f675a800 5e5f62=
fe
  f675a800 f6753c00 f80d598c c0542ac0 f616dda8 c053f1a4 c0542ac0 f60579=
c0
  f675a828 f616dda8 c0542ac0 000044cb f6bc8570 00000000 f616dc00 c27c27=
74
Call Trace:
  [<f80cfba4>] ? scsi_dispatch_cmd+0xd4/0x1e0 [scsi_mod]
  [<f80d598c>] ? scsi_request_fn+0x9c/0x430 [scsi_mod]
  [<c015f946>] ? getnstimeofday+0x56/0x110
  [<c03cfc70>] ? schedule+0x20/0x50
  [<c03cfcf8>] ? io_schedule+0x58/0xb0
  [<c019cf35>] ? sync_page+0x45/0x70
  [<c03d0247>] ? __wait_on_bit_lock+0x57/0xb0
  [<c019cef0>] ? sync_page+0x0/0x70
  [<c019ce9a>] ? __lock_page+0x8a/0xb0
  [<c01549c0>] ? wake_bit_function+0x0/0x90
  [<c019d652>] ? read_cache_page_async+0x162/0x170
  [<c01fe350>] ? blkdev_readpage+0x0/0x30
  [<c019d67d>] ? read_cache_page+0x1d/0x70
  [<c0223fcf>] ? read_dev_sector+0x4f/0xb0
  [<c022869b>] ? read_lba+0xfb/0x130
  [<c013bb53>] ? release_console_sem+0x1c3/0x230
  [<c0228a96>] ? efi_partition+0xe6/0x960
  [<c0224bff>] ? disk_name+0xcf/0xe0
  [<c0224d8a>] ? rescan_partitions+0x17a/0x480
  [<c03d0994>] ? __mutex_lock_slowpath+0x1d4/0x2c0
  [<c026875d>] ? kobject_get+0x1d/0x40
  [<c02289b0>] ? efi_partition+0x0/0x960
  [<c01fea41>] ? __blkdev_get+0x151/0x320
  [<c01fcdf0>] ? bdev_set+0x0/0x30
  [<c0224168>] ? register_disk+0x138/0x160
  [<c025c5ca>] ? blk_register_region+0x3a/0x60
  [<c025b7b0>] ? exact_match+0x0/0x30
  [<c025c85e>] ? add_disk+0x10e/0x180
  [<c025b7b0>] ? exact_match+0x0/0x30
  [<c025c030>] ? exact_lock+0x0/0x30
  [<f81aaae6>] ? sd_probe_async+0x186/0x280 [sd_mod]
  [<c015c97d>] ? async_thread+0xed/0x270
  [<c012b37f>] ? __wake_up_common+0x5f/0xa0
  [<c0136670>] ? default_wake_function+0x0/0x30
  [<c015c890>] ? async_thread+0x0/0x270
  [<c01544b2>] ? kthread+0x52/0x90
  [<c0154460>] ? kthread+0x0/0x90
  [<c01047e7>] ? kernel_thread_helper+0x7/0x10
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
INFO: task async/0:1798 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
async/0       D 5e5f62fe     0  1798      2
  f616dc00 00000046 00000246 5e5f62fe f80cfba4 5e5f62fe f675a800 5e5f62=
fe
  f675a800 f6753c00 f80d598c c0542ac0 f616dda8 c053f1a4 c0542ac0 f60579=
c0
  f675a828 f616dda8 c0542ac0 000044cb f6bc8570 00000000 f616dc00 c27c27=
74
Call Trace:
  [<f80cfba4>] ? scsi_dispatch_cmd+0xd4/0x1e0 [scsi_mod]
  [<f80d598c>] ? scsi_request_fn+0x9c/0x430 [scsi_mod]
  [<c015f946>] ? getnstimeofday+0x56/0x110
  [<c03cfc70>] ? schedule+0x20/0x50
  [<c03cfcf8>] ? io_schedule+0x58/0xb0
  [<c019cf35>] ? sync_page+0x45/0x70
  [<c03d0247>] ? __wait_on_bit_lock+0x57/0xb0
  [<c019cef0>] ? sync_page+0x0/0x70
  [<c019ce9a>] ? __lock_page+0x8a/0xb0
  [<c01549c0>] ? wake_bit_function+0x0/0x90
  [<c019d652>] ? read_cache_page_async+0x162/0x170
  [<c01fe350>] ? blkdev_readpage+0x0/0x30
  [<c019d67d>] ? read_cache_page+0x1d/0x70
  [<c0223fcf>] ? read_dev_sector+0x4f/0xb0
  [<c022869b>] ? read_lba+0xfb/0x130
  [<c013bb53>] ? release_console_sem+0x1c3/0x230
  [<c0228a96>] ? efi_partition+0xe6/0x960
  [<c0224bff>] ? disk_name+0xcf/0xe0
  [<c0224d8a>] ? rescan_partitions+0x17a/0x480
  [<c03d0994>] ? __mutex_lock_slowpath+0x1d4/0x2c0
  [<c026875d>] ? kobject_get+0x1d/0x40
  [<c02289b0>] ? efi_partition+0x0/0x960
  [<c01fea41>] ? __blkdev_get+0x151/0x320
  [<c01fcdf0>] ? bdev_set+0x0/0x30
  [<c0224168>] ? register_disk+0x138/0x160
  [<c025c5ca>] ? blk_register_region+0x3a/0x60
  [<c025b7b0>] ? exact_match+0x0/0x30
  [<c025c85e>] ? add_disk+0x10e/0x180
  [<c025b7b0>] ? exact_match+0x0/0x30
  [<c025c030>] ? exact_lock+0x0/0x30
  [<f81aaae6>] ? sd_probe_async+0x186/0x280 [sd_mod]
  [<c015c97d>] ? async_thread+0xed/0x270
  [<c012b37f>] ? __wake_up_common+0x5f/0xa0
  [<c0136670>] ? default_wake_function+0x0/0x30
  [<c015c890>] ? async_thread+0x0/0x270
  [<c01544b2>] ? kthread+0x52/0x90
  [<c0154460>] ? kthread+0x0/0x90
  [<c01047e7>] ? kernel_thread_helper+0x7/0x10
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 7:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 7:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
usb 1-1: USB disconnect, address 6
sd 7:0:0:0: [sdb] Unhandled error code
sd 7:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
sd 7:0:0:0: [sdb] Unhandled error code
sd 7:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
sd 7:0:0:0: [sdb] Unhandled error code
sd 7:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
ldm_validate_partition_table(): Disk read failed.
  unable to read partition table
XXX add_disk sdb done
sd 7:0:0:0: [sdb] Attached SCSI disk
XXX disk_release sg1
XXX disk_release sdb

Note that I don't get the NULL pointer dereference here. So I make a =20
second attempt.


usb 1-1: new high speed USB device using ehci_hcd and address 7
usb 1-1: configuration #1 chosen from 1 choice
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
usb 1-1: reset high speed USB device using ehci_hcd and address 7
usb 1-1: reset high speed USB device using ehci_hcd and address 7
scsi 8:0:0:0: Direct-Access     SAMSUNG  SP0411N          0-11 PQ: 0 AN=
SI: =20
2 CCS
sd 8:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete
sd 8:0:0:0: [sdb] 78242976 512-byte hardware sectors: (40.0 GB/37.3 GiB=
)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 00 38 00 00
sd 8:0:0:0: [sdb] Assuming drive cache: write through
XXX add_disk sdb
sd 8:0:0:0: [sdb] Assuming drive cache: write through
  sdb:<6>sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
sd 8:0:0:0: [sdb] Sense Key : 0x0 [current]
sd 8:0:0:0: [sdb] ASC=3D0x0 ASCQ=3D0x0
usb 1-1: USB disconnect, address 7
sd 8:0:0:0: [sdb] Unhandled error code
sd 8:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
XXX disk_release sg1
scsi 8:0:0:0: [sdb] Unhandled error code
scsi 8:0:0:0: [sdb] Result: hostbyte=3D0x07 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
ldm_validate_partition_table(): Disk read failed.
  unable to read partition table
XXX disk_release sdb
BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c025cb88>] disk_part_iter_next+0xf8/0x120
*pde =3D 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: =20
/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/host8/target8:0:0=
/8:0:0:0/type
Modules linked in: usb_storage nfsd exportfs nfs lockd fscache nfs_acl =
=20
auth_rpcgss sunrpc ipv6 pl2303 usbhid hid usbserial =20
snd_hda_codec_intelhdmi ata_generic pata_acpi pata_it8213 snd_seq_dummy=
 =20
snd_seq_oss snd_hda_codec_realtek snd_seq_midi_event ide_pci_generic =20
snd_seq snd_seq_device fan battery ac snd_hda_intel snd_hda_codec =20
snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_mixer_oss cpufreq_ondemand =
snd =20
acpi_cpufreq soundcore i2c_i801 it8213 snd_page_alloc uhci_hcd ide_core=
 =20
intel_agp i2c_core iTCO_wdt ehci_hcd freq_table agpgart ppdev ohci1394 =
=20
usbcore lp parport_pc sg r8169 serio_raw iTCO_vendor_support ieee1394 =20
processor button thermal parport evdev pcspkr mii rtc_cmos rtc_core =20
rtc_lib dm_mod sd_mod floppy ahci libata scsi_mod reiserfs

Pid: 1902, comm: async/0 Not tainted (2.6.30-ARCH #1) EG45M-DS2H
EIP: 0060:[<c025cb88>] EFLAGS: 00010246 CPU: 2
EIP is at disk_part_iter_next+0xf8/0x120
EAX: f68fdc00 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: f5a5df10 EDI: f68fdc48 EBP: 00000000 ESP: f5a5dee0
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process async/0 (pid: 1902, ti=3Df5a5c000 task=3Df5ab2c00 task.ti=3Df5a=
5c000)
Stack:
  00001000 c01fe70e 00000001 f81ad960 25c2efca f68fdc00 f5a5df10 f68fdc=
48
  00000000 c0224109 f68fdc40 f68fdc0c f68fdc00 00000000 00000001 000000=
00
  25c2efca f68fdc00 f68fdc0c f5a87400 c025c85e c025b7b0 c025c030 f68fdc=
00
Call Trace:
  [<c01fe70e>] ? __blkdev_put+0x6e/0x170
  [<c0224109>] ? register_disk+0xd9/0x160
  [<c025c85e>] ? add_disk+0x10e/0x180
  [<c025b7b0>] ? exact_match+0x0/0x30
  [<c025c030>] ? exact_lock+0x0/0x30
  [<f81aaae6>] ? sd_probe_async+0x186/0x280 [sd_mod]
  [<c015c97d>] ? async_thread+0xed/0x270
  [<c012b37f>] ? __wake_up_common+0x5f/0xa0
  [<c0136670>] ? default_wake_function+0x0/0x30
  [<c015c890>] ? async_thread+0x0/0x270
  [<c01544b2>] ? kthread+0x52/0x90
  [<c0154460>] ? kthread+0x0/0x90
  [<c01047e7>] ? kernel_thread_helper+0x7/0x10
Code: 14 00 00 00 8b 46 04 75 32 83 c4 14 5b 5e 5f 5d c3 66 90 01 f9 89=
 cb =20
03 54 24 0c 29 fb 39 1c 24 8d 04 07 89 46 08 75 90 eb be 90 <8b> 42 08 =
bf =20
01 00 00 00 89 04 24 e9 53 ff ff ff e8 13 e8 ed ff
EIP: [<c025cb88>] disk_part_iter_next+0xf8/0x120 SS:ESP 0068:f5a5dee0
CR2: 0000000000000008
---[ end trace 51427c77326d03bb ]---
note: async/0[1902] exited with preempt_count 1

And it goes splat.

I have now updated to 2.6.30.5 still with stock Arch Linux kernel confi=
g.

- Joachim
