From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
Date: Wed, 9 Feb 2011 09:28:51 -0800
Message-ID: <20110209092851.bba6c40c.randy.dunlap@oracle.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:19076 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1BIRaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 12:30:00 -0500
In-Reply-To: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, scsi <linux-scsi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

x86_64, nearly allmodconfig.  No target hardware.


[  144.508473] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[  144.509901] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
[  144.512026] CPU 1 
[  144.512026] Modules linked in: target_core_mod(-) configfs af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod mousedev joydev evdev mac_hid snd_hda_codec_analog usbmouse snd_hda_intel snd_hda_codec usbkbd usbhid hid snd_hwdep snd_seq 8250_pnp snd_seq_device dcdbas pcspkr sr_mod i2c_i801 cdrom tg3 sg iTCO_wdt snd_pcm 8250 iTCO_vendor_support rtc_cmos serial_core rtc_core snd_timer rtc_lib snd processor button thermal_sys soundcore intel_agp hwmon snd_page_alloc intel_gtt unix ide_p
 ci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base [last unload!
 ed: microcode]
[  144.512026] 
[  144.512026] Pid: 2597, comm: rmmod Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745                 
[  144.512026] RIP: 0010:[<ffffffff810c3e5f>]  [<ffffffff810c3e5f>] __lock_acquire+0xd8/0x4e8
[  144.512026] RSP: 0018:ffff88006df1bb78  EFLAGS: 00010006
[  144.512026] RAX: 0000000000000002 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000
[  144.512026] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6be3
[  144.512026] RBP: ffff88006df1bbd8 R08: 0000000000000001 R09: 0000000000000000
[  144.512026] R10: 0000000000000006 R11: ffffffffa06ab0ef R12: 0000000000000000
[  144.512026] R13: ffff88006dec3000 R14: 0000000000000000 R15: 0000000000000000
[  144.512026] FS:  00007fe0320d36f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[  144.512026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  144.512026] CR2: 0000003fadc7bf20 CR3: 000000006de4f000 CR4: 00000000000006e0
[  144.512026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  144.512026] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  144.512026] Process rmmod (pid: 2597, threadinfo ffff88006df1a000, task ffff88006dec3000)
[  144.512026] Stack:
[  144.512026]  0000000000000118 ffff8800000003a7 0000000000000005 00000000810b175b
[  144.512026]  ffff88006df1bba8 0000000000000000 ffff88006dec3000 0000000000000000
[  144.512026]  ffff88006dec3000 ffffffffa06ab0ef 0000000000000001 0000000000000000
[  144.512026] Call Trace:
[  144.512026]  [<ffffffffa06ab0ef>] ? spin_lock+0x15/0x1e [configfs]
[  144.512026]  [<ffffffff810c436f>] lock_acquire+0x100/0x150
[  144.512026]  [<ffffffffa06ab0ef>] ? spin_lock+0x15/0x1e [configfs]
[  144.512026]  [<ffffffffa06ac40f>] ? detach_groups+0x91/0x12e [configfs]
[  144.512026]  [<ffffffffa06ac40f>] ? detach_groups+0x91/0x12e [configfs]
[  144.512026]  [<ffffffff81556300>] _raw_spin_lock+0x44/0xaf
[  144.512026]  [<ffffffffa06ab0ef>] ? spin_lock+0x15/0x1e [configfs]
[  144.512026]  [<ffffffff810c47db>] ? lock_release_nested+0xfb/0x133
[  144.512026]  [<ffffffffa06ab0ef>] spin_lock+0x15/0x1e [configfs]
[  144.512026]  [<ffffffffa06ab144>] dget+0x2e/0x56 [configfs]
[  144.512026]  [<ffffffffa06ac3a4>] detach_groups+0x26/0x12e [configfs]
[  144.512026]  [<ffffffffa06ac363>] configfs_detach_group+0x2d/0x48 [configfs]
[  144.512026]  [<ffffffffa06ac41f>] detach_groups+0xa1/0x12e [configfs]
[  144.512026]  [<ffffffffa06ac363>] configfs_detach_group+0x2d/0x48 [configfs]
[  144.512026]  [<ffffffffa06ac41f>] detach_groups+0xa1/0x12e [configfs]
[  144.512026]  [<ffffffffa06ac363>] configfs_detach_group+0x2d/0x48 [configfs]
[  144.512026]  [<ffffffffa06ac41f>] detach_groups+0xa1/0x12e [configfs]
[  144.512026]  [<ffffffffa06ac363>] configfs_detach_group+0x2d/0x48 [configfs]
[  144.512026]  [<ffffffffa06ac41f>] detach_groups+0xa1/0x12e [configfs]
[  144.512026]  [<ffffffffa06ac363>] configfs_detach_group+0x2d/0x48 [configfs]
[  144.512026]  [<ffffffffa06ace26>] configfs_unregister_subsystem+0x105/0x194 [configfs]
[  144.512026]  [<ffffffffa06baf55>] target_core_exit_configfs+0x185/0x1eb [target_core_mod]
[  144.512026]  [<ffffffff810d46a8>] sys_delete_module+0x2d6/0x368
[  144.512026]  [<ffffffff8155602d>] ? lockdep_sys_exit_thunk+0x35/0x67
[  144.512026]  [<ffffffff81555fb7>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  144.512026]  [<ffffffff8100e942>] system_call_fastpath+0x16/0x1b
[  144.512026] Code: 05 8f 32 8d 01 e8 6c b1 fb ff 48 ff 05 8b 32 8d 01 48 ff 05 8c 32 8d 01 48 ff 05 95 32 8d 01 e9 e3 03 00 00 48 ff 05 81 32 8d 01 <48> 81 3b 40 5f 26 82 75 07 48 ff 05 81 32 8d 01 83 fe 01 77 13 
[  144.512026] RIP  [<ffffffff810c3e5f>] __lock_acquire+0xd8/0x4e8
[  144.512026]  RSP <ffff88006df1bb78>
[  144.512026] ---[ end trace 37e0ba5347875330 ]---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
