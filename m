From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH-v3 12/14] xen-scsiback: Convert to TARGET_SCF_ACK_KREF I/O
 krefs
Date: Tue, 2 Feb 2016 17:31:23 +0100
Message-ID: <56B0D9DB.90901@suse.com>
References: <1454137558-30396-1-git-send-email-nab@daterainc.com>
 <1454137558-30396-13-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000406000605050409090303"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbcBBQb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 11:31:27 -0500
In-Reply-To: <1454137558-30396-13-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>, David Vrabel <david.vrabel@citrix.com>

This is a multi-part message in MIME format.
--------------000406000605050409090303
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 30/01/16 08:05, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Sorry, with your patches applied xen-scsiback isn't working any more.
I've tried multiple times with and without your patches. Without the
patches everything is fine, while with the patches applied I get the
warnings shown in the attached log. I just passed through a DVD drive
and did "eject" in the domain.


Juergen


--------------000406000605050409090303
Content-Type: text/plain; charset=UTF-8;
 name="dom0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dom0.log"

[10984.266570] ------------[ cut here ]------------
[10984.266597] WARNING: CPU: 0 PID: 0 at drivers/target/target_core_transport.c:717 target_complete_cmd+0x1cb/0x200 [target_core_mod]()
[10984.266601] Modules linked in: xt_physdev br_netfilter iptable_filter ip_tables x_tables loop target_core_pscsi target_core_file target_core_iblock iscsi_target_mod tcm_loop xen_scsiback bridge stp llc iscsi_ibft iscsi_boot_sysfs tun arc4 iwldvm mac80211 joydev iwlwifi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core snd_hda_codec_realtek cfg80211 snd_hda_codec_hdmi snd_hda_codec_generic videodev intel_rapl x86_pkg_temp_thermal e1000e intel_powerclamp snd_hda_intel media snd_hda_codec coretemp crct10dif_pclmul iTCO_wdt snd_hda_core crc32_pclmul iTCO_vendor_support dell_laptop crc32c_intel sdhci_pci rfkill ghash_clmulni_intel ptp snd_hwdep hmac i2c_hid drbg snd_pcm ansi_cprng hid dell_wmi ppdev snd_timer sparse_keymap dcdbas dell_smm_hwmon parport_pc parport snd 
 i2c_designware_platform
[10984.266670]  i2c_designware_core thermal tpm_tis xhci_pci tpm evdev mei_me xhci_hcd aesni_intel mei aes_x86_64 psmouse shpchp lrw lpc_ich gf128mul i2c_i801 soundcore mfd_core pps_core ac glue_helper ablk_helper battery serio_raw pcspkr cryptd wmi target_core_mod xenfs xen_privcmd configfs dm_mod ext4 crc16 mbcache jbd2 sd_mod sr_mod cdrom i915 ehci_pci ehci_hcd i2c_algo_bit drm_kms_helper ahci libahci libata usbcore usb_common drm sdhci_acpi video sdhci mmc_core button xen_acpi_processor xen_pciback xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn sg scsi_mod autofs4
[10984.266735] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.5.0-rc1-pv+ #1
[10984.266739] Hardware name: Dell Inc. Latitude E6440/0159N7, BIOS A07 06/26/2014
[10984.266742]  ffffffffa0422408 ffffffff812e8bb4 0000000000000000 ffffffff8106e95c
[10984.266748]  ffff8800d2e007d0 ffff8800d2e008e0 0000000000000001 ffffffffa08c3150
[10984.266753]  0000000000000000 ffffffffa04091ab ffff8800da13ea20 ffff88000294f7c0
[10984.266758] Call Trace:
[10984.266761]  <IRQ>  [<ffffffff812e8bb4>] ? dump_stack+0x40/0x5c
[10984.266776]  [<ffffffff8106e95c>] ? warn_slowpath_common+0x7c/0xb0
[10984.266784]  [<ffffffffa08c3150>] ? pscsi_bi_endio+0x10/0x10 [target_core_pscsi]
[10984.266794]  [<ffffffffa04091ab>] ? target_complete_cmd+0x1cb/0x200 [target_core_mod]
[10984.266799]  [<ffffffffa08c30f5>] ? pscsi_req_done+0x85/0xd0 [target_core_pscsi]
[10984.266811]  [<ffffffffa00125c7>] ? scsi_end_request+0xf7/0x1a0 [scsi_mod]
[10984.266820]  [<ffffffffa001481a>] ? scsi_io_completion+0xfa/0x5f0 [scsi_mod]
[10984.266830]  [<ffffffff812c4833>] ? blk_done_softirq+0x73/0x90
[10984.266836]  [<ffffffff81072b5c>] ? __do_softirq+0xcc/0x240
[10984.266842]  [<ffffffff81072eb6>] ? irq_exit+0x86/0x90
[10984.266852]  [<ffffffff8139c8bc>] ? xen_evtchn_do_upcall+0x2c/0x40
[10984.266862]  [<ffffffff8158772e>] ? xen_do_hypervisor_callback+0x1e/0x40
[10984.266864]  <EOI>  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[10984.266874]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
[10984.266882]  [<ffffffff8100afdc>] ? xen_safe_halt+0xc/0x20
[10984.266891]  [<ffffffff8101edd3>] ? default_idle+0x13/0x90
[10984.266898]  [<ffffffff810a92fd>] ? cpu_startup_entry+0x25d/0x2f0
[10984.266903]  [<ffffffff8190a06a>] ? start_kernel+0x471/0x47c
[10984.266907]  [<ffffffff81909a00>] ? set_init_arg+0x50/0x50
[10984.266912]  [<ffffffff8190c324>] ? xen_start_kernel+0x522/0x52c
[10984.266916] ---[ end trace 07ad307d0cb62aa4 ]---

[10984.266940] ------------[ cut here ]------------
[10984.266953] WARNING: CPU: 0 PID: 2448 at drivers/target/target_core_transport.c:2120 target_complete_ok_work+0x291/0x2e0 [target_core_mod]()
[10984.266955] Modules linked in: xt_physdev br_netfilter iptable_filter ip_tables x_tables loop target_core_pscsi target_core_file target_core_iblock iscsi_target_mod tcm_loop xen_scsiback bridge stp llc iscsi_ibft iscsi_boot_sysfs tun arc4 iwldvm mac80211 joydev iwlwifi uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core snd_hda_codec_realtek cfg80211 snd_hda_codec_hdmi snd_hda_codec_generic videodev intel_rapl x86_pkg_temp_thermal e1000e intel_powerclamp snd_hda_intel media snd_hda_codec coretemp crct10dif_pclmul iTCO_wdt snd_hda_core crc32_pclmul iTCO_vendor_support dell_laptop crc32c_intel sdhci_pci rfkill ghash_clmulni_intel ptp snd_hwdep hmac i2c_hid drbg snd_pcm ansi_cprng hid dell_wmi ppdev snd_timer sparse_keymap dcdbas dell_smm_hwmon parport_pc parport snd 
 i2c_designware_platform
[10984.267013]  i2c_designware_core thermal tpm_tis xhci_pci tpm evdev mei_me xhci_hcd aesni_intel mei aes_x86_64 psmouse shpchp lrw lpc_ich gf128mul i2c_i801 soundcore mfd_core pps_core ac glue_helper ablk_helper battery serio_raw pcspkr cryptd wmi target_core_mod xenfs xen_privcmd configfs dm_mod ext4 crc16 mbcache jbd2 sd_mod sr_mod cdrom i915 ehci_pci ehci_hcd i2c_algo_bit drm_kms_helper ahci libahci libata usbcore usb_common drm sdhci_acpi video sdhci mmc_core button xen_acpi_processor xen_pciback xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn sg scsi_mod autofs4
[10984.267067] CPU: 0 PID: 2448 Comm: kworker/0:0 Tainted: G        W       4.5.0-rc1-pv+ #1
[10984.267070] Hardware name: Dell Inc. Latitude E6440/0159N7, BIOS A07 06/26/2014
[10984.267081] Workqueue: target_completion target_complete_ok_work [target_core_mod]
[10984.267084]  ffffffffa0422408 ffffffff812e8bb4 0000000000000000 ffffffff8106e95c
[10984.267089]  ffff8800d2e00908 ffff8800d2e007d0 0000000000000903 ffffe8ffffc0af00
[10984.267094]  0000000000000000 ffffffffa040c831 0000000000000000 ffff8800d2e00908
[10984.267099] Call Trace:
[10984.267103]  [<ffffffff812e8bb4>] ? dump_stack+0x40/0x5c
[10984.267108]  [<ffffffff8106e95c>] ? warn_slowpath_common+0x7c/0xb0
[10984.267117]  [<ffffffffa040c831>] ? target_complete_ok_work+0x291/0x2e0 [target_core_mod]
[10984.267124]  [<ffffffff81084709>] ? process_one_work+0x149/0x3b0
[10984.267128]  [<ffffffff81084dcd>] ? worker_thread+0x11d/0x4a0
[10984.267133]  [<ffffffff81084cb0>] ? rescuer_thread+0x340/0x340
[10984.267140]  [<ffffffff8108a068>] ? kthread+0xb8/0xd0
[10984.267146]  [<ffffffff81089fb0>] ? kthread_park+0x50/0x50
[10984.267152]  [<ffffffff81585d4f>] ? ret_from_fork+0x3f/0x70
[10984.267158]  [<ffffffff81089fb0>] ? kthread_park+0x50/0x50
[10984.267161] ---[ end trace 07ad307d0cb62aa5 ]---


--------------000406000605050409090303--
