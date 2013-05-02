From: ZX <jencce.kernel@gmail.com>
Subject: Re: linux-next: Tree for May 1
Date: Thu, 2 May 2013 15:37:41 +0800 (CST)
Message-ID: <alpine.DEB.2.02.1305021529430.23933@M2420>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-442319640-1367480283=:23933"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41060 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3EBHiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 03:38:07 -0400
In-Reply-To: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, hare@suse.de
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-442319640-1367480283=:23933
Content-Type: TEXT/PLAIN; charset=US-ASCII



On Wed, 1 May 2013, Stephen Rothwell wrote:

> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> Changes since 20130430:
> 
> The nfsd tree lost its build failure.
> 
> The xfs tree lost its build failure.
> 
> The vfs tree gained conflicts against Linus' and the powerpc trees and
> gained a build failure for which I applied a merge fix patch.
> 
> The drm-intel tree gained a conflict against the drm tree.
> 
> The block tree gained a conflict against Linus' tree.
> 
> The arm-soc tree gained a conflict against the arm tree.
> 
> The akpm tree lost a lot of patches that turned up elsewhere.
> 
> ----------------------------------------------------------------------------

randconf build failure:

make -C drivers/scsi/aic7xxx/aicasm
*** Install db development libraries
gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c 
aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
aicasm_symbol.c:48:19: fatal error: aicdb.h: No such file or directory
compilation terminated.


random config file attached.


> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
> sparc64 and arm defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> We are up to 224 trees (counting Linus' and 31 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
> 
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> $ git checkout master
> $ git reset --hard stable
> Merging origin/master (3094566 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial)
> Merging fixes/master (96d8683 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client)
> Merging kbuild-current/rc-fixes (a54292f kbuild: generate generic headers before recursing into scripts)
> Merging arc-current/for-curr (561daec ARC: [mm] Lazy D-cache flush (non aliasing VIPT))
> Merging arm-current/fixes (1783d45 ARM: 7700/2: Make cpu_init() notrace)
> Merging m68k-current/for-linus (e00c73e m68k: Remove inline strlen() implementation)
> Merging powerpc-merge/merge (5676005 powerpc/pseries/lparcfg: Fix possible overflow are more than 1026)
> Merging sparc/master (0fbd067 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc)
> Merging net/master (79f632c unix/stream: fix peeking with an offset larger than data in queue)
> Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net)
> Merging sound-current/for-linus (c5a4698 Merge tag 'asoc-maintainers-v3.9-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
> Merging pci-current/for-linus (d46fc8b x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0)
> Merging wireless/master (a8a48e6 Merge tag 'nfc-next-3.10-4' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next)
> Merging driver-core.current/driver-core-linus (c1be5a5 Linux 3.9)
> Merging tty.current/tty-linus (c1be5a5 Linux 3.9)
> Merging usb.current/usb-linus (c1be5a5 Linux 3.9)
> Merging staging.current/staging-linus (c1be5a5 Linux 3.9)
> Merging char-misc.current/char-misc-linus (c1be5a5 Linux 3.9)
> Merging input-current/for-linus (5846115 Input: wacom - fix "can not retrieve extra class descriptor" for DTH2242)
> Merging md-current/for-linus (32f9f57 MD: ignore discard request for hard disks of hybid raid1/raid10 array)
> Merging audit-current/for-linus (c158a35 audit: no leading space in audit_log_d_path prefix)
> Merging crypto-current/master (72a763d crypto: algif - suppress sending source address information in recvmsg)
> Merging ide/master (bf6b438 ide: gayle: use module_platform_driver_probe())
> Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
> Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros to inline functions)
> Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
> Merging devicetree-current/devicetree/merge (ab28698 of: define struct device in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
> Merging spi-current/spi/merge (0d2d0cc spi/davinci: fix module build error)
> Merging gpio-current/gpio/merge (e97f9b5 gpio/gpio-ich: fix ichx_gpio_check_available() return what callers expect)
> Merging rr-fixes/fixes (c1be5a5 Linux 3.9)
> Merging mfd-fixes/master (31880c3 Linux 3.9-rc6)
> Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overflow)
> Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
> Merging arc/for-next (07961ac Linux 3.9-rc5)
> Merging arm/for-next (4b6cce6 Merge branches 'devel-stable', 'entry', 'fixes', 'mach-types', 'misc' and 'smp-hotplug' into for-next)
> CONFLICT (content): Merge conflict in arch/arm/kvm/arm.c
> Merging arm-perf/for-next/perf (ab87304 Merge branches 'perf/fixes' and 'hw-breakpoint' into for-next/perf)
> Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
> Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
> CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
> Merging arm64/upstream (16c85a1 arm64: Use acquire/release semantics instead of explicit DMB)
> Merging blackfin/for-linus (f656c24 blackfin: time-ts: Remove duplicate assignment)
> Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_restore)
> Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic file)
> Merging hexagon/linux-next (e0e34de Hexagon: add v4 CS regs to core copyout macro)
> Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
> Merging m68k/for-next (e00c73e m68k: Remove inline strlen() implementation)
> Merging m68knommu/for-next (2842e5b0 m68knommu: enable Timer on coldfire 532x)
> Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB => 128KiB)
> Merging microblaze/next (01cc2cb microblaze: intc: set the default irq_domain)
> Merging mips/mips-for-linux-next (6eac6e6 Merge branches 'next/3.9-fixes', 'next/kvm' and 'next/micromips' into mips-for-linux-next)
> Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
> Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parameter from do_execve() in hpux_execve())
> Merging powerpc/next (1f6aaac powerpc: Update tlbie/tlbiel as per ISA doc)
> CONFLICT (content): Merge conflict in arch/powerpc/mm/numa.c
> CONFLICT (content): Merge conflict in arch/metag/mm/Kconfig
> Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
> Merging mpc5xxx/next (fdeaf0e powerpc/512x: add ifm ac14xx board)
> Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bridge device node for T4/B4)
> Merging s390/features (1c21351 s390/pci: use pci_scan_root_bus)
> Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/serial-of' into sh-latest)
> Merging sparc-next/master (07df841 sparc64: Do not save/restore interrupts in get_new_mmu_context())
> Merging tile/master (9fc1894 arch/tile: Fix syscall return value passed to tracepoint)
> Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIMENTAL)
> Merging xtensa/for_next (4e34bf6 xtensa: provide default platform_pcibios_init implementation)
> Merging btrfs/next (6aec51f Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux into for-linus-3.9)
> Merging ceph/testing (1de1777 rbd: refactor rbd_dev_probe_update_spec())
> CONFLICT (content): Merge conflict in net/ceph/osdmap.c
> CONFLICT (content): Merge conflict in fs/ceph/addr.c
> CONFLICT (content): Merge conflict in drivers/block/rbd.c
> Merging cifs/for-next (bf81710 Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending)
> Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
> Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
> Merging ext3/for_next (e162b2f jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset)
> Merging ext4/dev (0d606e2 ext4: fix type-widening bug in inode table readahead code)
> Merging f2fs/dev (d23bfc6 f2fs: avoid deadlock during evict after f2fs_gc)
> Merging fuse/for-next (efb9fa9 fuse: truncate file if async dio failed)
> Merging gfs2/master (222cb53 GFS2: Flush work queue before clearing glock hash tables)
> Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shifting by 32 bits)
> Merging logfs/master (3394661 Fix the call to BUG() caused by no free segment found)
> Merging nfs/linux-next (8dbec78 NFSv4.x: Fix handling of partially delegated locks)
> Merging nfsd/nfsd-next (d28fcc8 svcrpc: fix gss-proxy to respect user namespaces)
> Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
> Merging omfs/for-next (976d167 Linux 3.1-rc9)
> Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for block_size and block_log match)
> Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
> Merging ubifs/linux-next (c1be5a5 Linux 3.9)
> Merging xfs/for-next (123887e xfs: Teach dquot recovery about CONFIG_XFS_QUOTA)
> CONFLICT (content): Merge conflict in fs/xfs/xfs_iomap.c
> Merging vfs/for-next (3c3a685 minimal !CONFIG_PROC_FS fixes)
> CONFLICT (content): Merge conflict in fs/proc/internal.h
> CONFLICT (content): Merge conflict in drivers/staging/vt6655/device_main.c
> CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_specproc.c
> CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_ports_ops.c
> CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_net_ops.c
> CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_mon_ops.c
> CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_dpa_ops.c
> CONFLICT (modify/delete): drivers/staging/ccg/rndis.c deleted in HEAD and modified in vfs/for-next. Version vfs/for-next of drivers/staging/ccg/rndis.c left in tree.
> CONFLICT (modify/delete): drivers/staging/ccg/f_fs.c deleted in HEAD and modified in vfs/for-next. Version vfs/for-next of drivers/staging/ccg/f_fs.c left in tree.
> CONFLICT (content): Merge conflict in drivers/firmware/efivars.c
> CONFLICT (content): Merge conflict in arch/powerpc/kernel/rtas_flash.c
> $ git rm -f drivers/staging/ccg/f_fs.c drivers/staging/ccg/rndis.c
> Applying: fs: fix up for changes to proc_fs include files
> Applying: SUNRPC: update for PDE removal
> Merging pci/next (d4f09c5 Merge branch 'pci/gavin-msi-cleanup' into next)
> Merging hid/for-next (46b1897 Merge branch 'for-3.10/hid-debug' into for-next)
> Merging i2c/i2c/for-next (c39e8e4 i2c: xiic: must always write 16-bit words to TX_FIFO)
> CONFLICT (content): Merge conflict in drivers/staging/media/go7007/go7007-driver.c
> CONFLICT (content): Merge conflict in drivers/media/pci/bt8xx/bttv-input.c
> Applying: i2c: fixup for code movement from bttv_input.c
> Merging jdelvare-hwmon/master (c662b7a hwmon: (lm75) Add support for the Dallas/Maxim DS7505)
> Merging hwmon-staging/hwmon-next (6445e66 hwmon: (nct6775) Fix coding style problems)
> Merging v4l-dvb/master (1d62caa Merge /home/v4l/v4l/patchwork)
> Merging kbuild/for-next (1567364 Merge branch 'kbuild/kconfig' into kbuild/for-next)
> Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set to 'y' not 'm')
> Merging libata/NEXT (2cc1144 sata_highbank: Rename proc_name to the module name)
> Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into for-next)
> Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
> Merging pm/linux-next (371deb9 Merge branch 'pm-cpufreq')
> CONFLICT (content): Merge conflict in include/linux/clockchips.h
> CONFLICT (content): Merge conflict in drivers/acpi/scan.c
> Merging idle/next (5c99726b Merge branch 'fspin' into next)
> Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm)
> Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fixes-next)
> CONFLICT (content): Merge conflict in drivers/base/power/qos.c
> Merging cpupowerutils/master (f166033 cpupower tools: add install target to the debug tools' makefiles)
> Merging thermal/next (de6558d Merge branch 'MAINTAINERS-update' of .git into next)
> Merging ieee1394/for-next (6fe9efb firewire: ohci: dump_stack() for PHY regs read/write failures)
> Merging ubi/linux-next (f6161aa Linux 3.9-rc2)
> Merging dlm/next (9000831 dlm: avoid unnecessary posix unlock)
> Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce since there are no external consumers)
> Merging scsi/for-next (73b22ec Merge branch 'misc' into for-next)
> Merging target-updates/for-next (04b59ba tcm_vhost: Enable VIRTIO_SCSI_F_HOTPLUG)
> Merging target-merge/for-next-merge (b8d26b3 iser-target: Add iSCSI Extensions for RDMA (iSER) target driver)
> Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
> Merging isci/all (6734092 isci: add a couple __iomem annotations)
> Merging slave-dma/next (0b03930 Merge branch 'for-linus' into next)
> Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
> Merging net-next/master (fe86d71 mlx4_en: fix a build error on 32bit arches)
> CONFLICT (content): Merge conflict in tools/Makefile
> CONFLICT (content): Merge conflict in include/linux/pci.h
> CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb4/qp.c
> Applying: drivers:net: fix up for code movement from rt2x00pci.c
> Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch table)
> Merging wireless-next/master (a8a48e6 Merge tag 'nfc-next-3.10-4' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next)
> Merging bluetooth/master (975aba3 Bluetooth: Fix multiple LE socket handling)
> Merging mtd/master (cdb6404 mtd: omap2: Use module_platform_driver())
> Merging l2-mtd/master (98927a2 mtd: get the ECC info from the parameter page for ONFI nand)
> Merging crypto/master (3862de1 crypto: caam - fix job ring cleanup code)
> Merging drm/drm-next (33896bf udl: bind the framebuffer to the correct device.)
> Merging drm-intel/drm-intel-next-queued (dce3271 drm/i915: reference count for i915_hw_contexts)
> CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_reg.h
> Merging sound/for-next (4ca231b ALSA: usb-audio: caiaq: fix endianness bug in snd_usb_caiaq_maschine_dispatch)
> Merging sound-asoc/for-next (615973d Merge remote-tracking branch 'asoc/fix/wm8994' into asoc-linus)
> Merging modules/modules-next (a53a11f3 modpost: fix unwanted VMLINUX_SYMBOL_STR expansion)
> Merging virtio/virtio-next (c2ecd51 lguest: improve code readability in lg_cpu_start.)
> CONFLICT (content): Merge conflict in drivers/char/virtio_console.c
> CONFLICT (modify/delete): Documentation/virtual/virtio-spec.txt deleted in virtio/virtio-next and modified in HEAD. Version HEAD of Documentation/virtual/virtio-spec.txt left in tree.
> $ git rm -f Documentation/virtual/virtio-spec.txt
> Merging input/next (0c6a616 Input: trackpoint - Optimize trackpoint init to use power-on reset)
> Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in core)
> Merging cgroup/for-next (2a0010a cpuset: fix compile warning when CONFIG_SMP=n)
> Merging block/for-next (b5bb021 Merge branch 'for-3.10/core' into for-next)
> CONFLICT (content): Merge conflict in include/linux/blk_types.h
> CONFLICT (content): Merge conflict in drivers/block/drbd/drbd_proc.c
> Merging device-mapper/master (f8efabf This patch uses memalloc_noio_save to avoid a possible deadlock in dm-bufio.  (it could happen only with large block size, at most PAGE_SIZE << MAX_ORDER (typically 8MiB).)
> Merging embedded/master (4744b43 embedded: fix vc_translate operator precedence)
> Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
> Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
> Merging mmc/mmc-next (e4404fa mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE)
> Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
> Merging slab/for-next (7cccd80 slub: tid must be retrieved from the percpu area of the current processor)
> Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
> Merging md/for-next (1fef8be raid5: make release_stripe lockless)
> Merging mfd/master (99f4c6b mfd: si476x: Don't use 0bNNN)
> CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
> CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpuidle.c
> Merging battery/master (6b17080 pm2301-charger: Fix suspend/resume)
> Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
> Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in set_par)
> Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
> Merging regulator/for-next (bee5465 Merge remote-tracking branch 'regulator/topic/wm8994' into v3.9-rc8)
> Merging security/next (b7ae9f0 Merge branch 'tpmdd-04-17-13' of git://github.com/shpedoikal/linux into my-next)
> Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
> Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
> Merging watchdog/master (69c6612 watchdog: Fix race condition in registration code)
> Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables before creating superpage)
> Merging iommu/next (d4df35e2 Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/amd', 'ppc/pamu' and 'core' into next)
> Merging vfio/next (0b43c08 vfio: Use down_reads to protect iommu disconnects)
> Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on read error)
> Merging jc_docs/docs-next (5c050fb docs: update the development process document)
> Merging trivial/for-next (071361d mm: Convert print_symbol to %pSR)
> Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
> Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
> Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescence of IMC_DDRIO device)
> Merging edac-amd/for-next (9713fae EDAC: Merge mci.mem_is_per_rank with mci.csbased)
> Merging devicetree/devicetree/next (d347bc5 Merge branch 'robherring/for-next' from git://sources.calxeda.com/kernel/linux.git)
> Merging dt-rh/for-next (a2b9ea7 Documentation/devicetree: make semantic of initrd-end more explicit)
> Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the default pin configuration)
> Merging spi-mb/for-next (cd8d984 spi-topcliff-pch: fix to use list_for_each_entry_safe() when delete list items)
> Merging tip/auto-latest (979830a Merge branch 'x86/urgent')
> CONFLICT (modify/delete): drivers/firmware/efivars.c deleted in tip/auto-latest and modified in HEAD. Version HEAD of drivers/firmware/efivars.c left in tree.
> $ git rm -f drivers/firmware/efivars.c
> Applying: efivars: Include missing linux/magic.h inclusions
> Applying: efivars: use of kmalloc etc requires the inclusion of slab.h
> Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being added)
> Merging rcu/rcu/next (a9be854 Merge commit '6d87669357936bffa1e8fea7a4e7743e76905736' into next.2013.10.22a)
> Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc_show)
> Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singlestep exceptions)
> Merging kvm/linux-next (4cee4b7 kvm: KVM_CAP_IOMMU only available with device assignment)
> CONFLICT (content): Merge conflict in drivers/s390/kvm/virtio_ccw.c
> CONFLICT (content): Merge conflict in arch/s390/mm/pgtable.c
> Merging kvm-arm/kvm-arm-next (b8022d7 arm: kvm: arch_timer: use symbolic constants)
> Merging kvm-ppc/kvm-ppc-next (8b78645 KVM: PPC: Book3S: Facilities to save/restore XICS presentation ctrler state)
> Merging oprofile/for-next (23995bb oprofile, s390: Add support for IBM zEnterprise EC12)
> Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
> Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes)
> Merging xen-two/linux-next (6461b07 Merge branch 'stable/for-linus-3.10' into linux-next)
> Merging xen-arm/linux-next (9bc25a1 xen/arm: remove duplicated include from enlighten.c)
> Merging percpu/for-next (a1b2a55 percpu: add documentation on this_cpu operations)
> Merging workqueues/for-next (46aed11 Merge branch 'for-3.10' into for-next)
> Merging drivers-x86/linux-next (e6e5224 ideapad-laptop: Depend on BACKLIGHT_CLASS_DEVICE instead of selecting it)
> CONFLICT (content): Merge conflict in drivers/platform/x86/chromeos_laptop.c
> Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into hwpoison)
> Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may go away)
> Merging regmap/for-next (38a8179 Merge remote-tracking branch 'regmap/topic/range' into regmap-next)
> Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
> Merging leds/for-next (df92d5f leds: leds-asic3: switch to using SIMPLE_DEV_PM_OPS)
> Merging driver-core/driver-core-next (0d1d392 Merge 3.9-rc7 into driver-core-next)
> Merging tty/tty-next (45efcb2 tty/serial/sirf: fix MODULE_DEVICE_TABLE)
> Merging usb/usb-next (4626b8d USB: ehci-msm: USB_MSM_OTG needs USB_PHY)
> Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
> Merging staging/staging-next (a0eeed4 staging: comedi: ni_labpc: fix legacy driver build)
> Merging char-misc/char-misc-next (0e27263 Tools: hv: Fix a checkpatch warning)
> Merging bcon/master (06c6942 blockconsole: Mark a local work struct static)
> CONFLICT (content): Merge conflict in drivers/block/Kconfig
> Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
> Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in bdi_position_ratio())
> Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt boot interface)
> Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
> Merging pinctrl/for-next (d463f82 pinctrl: fix mutex deadlock in get_pinctrl_dev_from_of_node())
> Merging vhost/linux-next (6713ce9 vhost: fix error handling in RESET_OWNER ioctl)
> CONFLICT (content): Merge conflict in drivers/vhost/tcm_vhost.c
> CONFLICT (content): Merge conflict in drivers/vhost/net.c
> Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplement memblock allocation using reverse free area iterator)
> Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies for VIRTIO)
> CONFLICT (content): Merge conflict in drivers/remoteproc/Kconfig
> Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
> Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple domain first_irq)
> Merging gpio/gpio/next (753c598 gpio/em: Add Device Tree support)
> Merging gpio-lw/for-next (ab6ec0f gpio/omap: ensure gpio context is initialised)
> Merging gen-gpio/for_next (f4c5405 gpio: update gpio Chinese documentation)
> CONFLICT (modify/delete): drivers/usb/otg/Kconfig deleted in HEAD and modified in gen-gpio/for_next. Version gen-gpio/for_next of drivers/usb/otg/Kconfig left in tree.
> CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
> $ git rm -f drivers/usb/otg/Kconfig
> Applying: gen-gpio: GPIOLIB merge fix up
> Applying: merge fix for Convert selectors of GENERIC_GPIO to GPIOLIB
> Applying: merge fix 2 for Convert selectors of GENERIC_GPIO to GPIOLIB
> Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of sizeof in mailbox_msg_send())
> Merging arm-soc/for-next (d664025 Merge branch 'next/multiplatform' into for-next)
> CONFLICT (content): Merge conflict in drivers/usb/host/ohci-exynos.c
> CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-samsung.h
> CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-samsung.c
> CONFLICT (content): Merge conflict in drivers/pinctrl/Makefile
> CONFLICT (modify/delete): drivers/gpio/gpio-vt8500.c deleted in arm-soc/for-next and modified in HEAD. Version HEAD of drivers/gpio/gpio-vt8500.c left in tree.
> CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
> CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
> CONFLICT (content): Merge conflict in arch/arm/plat-orion/Makefile
> CONFLICT (add/add): Merge conflict in arch/arm/mach-zynq/platsmp.c
> CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
> CONFLICT (content): Merge conflict in arch/arm/mach-tegra/tegra.c
> CONFLICT (content): Merge conflict in arch/arm/mach-tegra/hotplug.c
> CONFLICT (content): Merge conflict in arch/arm/mach-spear/spear13xx.c
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadillo800eva.c
> CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2443.c
> CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2440.c
> CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2412.c
> CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2410.c
> CONFLICT (content): Merge conflict in arch/arm/mach-omap2/omap_hwmod.c
> CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
> CONFLICT (modify/delete): arch/arm/mach-imx/cpufreq.c deleted in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-imx/cpufreq.c left in tree.
> CONFLICT (content): Merge conflict in arch/arm/mach-highbank/highbank.c
> CONFLICT (content): Merge conflict in arch/arm/mach-exynos/cpuidle.c
> CONFLICT (content): Merge conflict in arch/arm/boot/dts/at91sam9x5.dtsi
> CONFLICT (content): Merge conflict in arch/arm/Kconfig
> CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
> $ git rm -f drivers/gpio/gpio-vt8500.c arch/arm/mach-imx/cpufreq.c
> Merging bcm2835/for-next (31880c3 Linux 3.9-rc6)
> Merging cortex/for-next (4477ca4 ARM: ARMv7-M: Allow the building of new kernel port)
> Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep93xx-for-next)
> Merging imx-mxs/for-next (3795b56 Merge branches 'mxs/dt-3.11' and 'imx/dt-3.11' into for-next)
> Merging ixp4xx/next (19f949f Linux 3.8)
> Merging msm/for-next (1df357a Merge branch 'msm-defconfig' into for-next)
> Merging renesas/next (cda9c03 Merge branch 'heads/soc-sh73a0' into next)
> CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/Kconfig
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadillo800eva.c
> Merging samsung/for-next (e0f8f91 Merge branch 'next/late-exynos' into for-next)
> CONFLICT (content): Merge conflict in arch/arm/mach-exynos/cpuidle.c
> Merging tegra/for-next (c0c1cb1 Merge branch 'for-3.10/defconfig' into for-next)
> Merging dma-mapping/dma-mapping-next (a937536 Linux 3.9-rc3)
> Merging pwm/for-next (affb923 pwm: lpc32xx: Don't change PWM_ENABLE bit in lpc32xx_pwm_config)
> Merging dma-buf/for-next (5320c97 dma-buf: double unlock in debugfs code)
> Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesystem)
> Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different machines)
> Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of macros)
> CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
> CONFLICT (content): Merge conflict in fs/splice.c
> CONFLICT (content): Merge conflict in fs/read_write.h
> CONFLICT (content): Merge conflict in fs/read_write.c
> CONFLICT (content): Merge conflict in fs/compat.c
> CONFLICT (content): Merge conflict in arch/tile/kernel/compat.c
> CONFLICT (content): Merge conflict in arch/tile/Kconfig
> CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
> Applying: cond_syscall and SYSCALL_ALIAS merge fixup
> Merging clk/clk-next (1e43525 clk: add clk_ignore_unused option to keep boot clocks on)
> Merging random/dev (b980955 random: fix locking dependency with the tasklist_lock)
> Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression speedup on ARM by using unaligned access)
> Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.org/sfrench/cifs-2.6)
> Merging akpm-current/current (0fbd067 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc)
> $ git checkout -b akpm remotes/origin/akpm/master
> Applying: revert "ipc: don't allocate a copy larger than max"
> Applying: drivers/char/random.c: fix priming of last_data
> Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
> Applying: x86: make 'mem=' option to work for efi platform
> Applying: kernel/auditfilter.c: tree and watch will memory leak when failure occurs
> Applying: kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
> Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in progress
> Applying: drivers/video: implement a simple framebuffer driver
> Applying: drivers-video-implement-a-simple-framebuffer-driver-fix
> Applying: cyber2000fb: avoid palette corruption at higher clocks
> Applying: inotify: invalid mask should return a error number but not set it
> Applying: inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix
> Applying: posix_cpu_timer: consolidate expiry time type
> Applying: posix_cpu_timers: consolidate timer list cleanups
> Applying: posix_cpu_timers: consolidate expired timers check
> Applying: selftests: add basic posix timers selftests
> Applying: posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
> Applying: posix_timers: Fix racy timer delta caching on task exit
> Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
> Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
> Applying: lglock: update lockdep annotations to report recursive local locks
> Applying: block: restore /proc/partitions to not display non-partitionable removable devices
> Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
> Applying: fs/dcache.c: add cond_resched() to shrink_dcache_parent()
> Applying: watchdog: trigger all-cpu backtrace when locked up and going to panic
> Applying: vm: adjust ifdef for TINY_RCU
> Applying: mm: frontswap: lazy initialization to allow tmem backends to build/run as modules
> Applying: frontswap: make frontswap_init use a pointer for the ops
> Applying: mm: frontswap: cleanup code
> Applying: frontswap: get rid of swap_lock dependency
> Applying: mm: cleancache: lazy initialization to allow tmem backends to build/run as modules
> Applying: cleancache: Make cleancache_init use a pointer for the ops
> Applying: mm: cleancache: clean up cleancache_enabled
> Applying: xen: tmem: enable Xen tmem shim to be built/loaded as a module
> Applying: xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix
> Applying: zcache/tmem: Better error checking on frontswap_register_ops return value.
> Applying: staging: zcache: enable ramster to be built/loaded as a module
> Applying: staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix
> Applying: staging: zcache: enable zcache to be built/loaded as a module
> Applying: mm/SPARC: use common help functions to free reserved pages
> Applying: clear_refs: sanitize accepted commands declaration
> Applying: clear_refs-sanitize-accepted-commands-declaration-fix
> Applying: clear_refs: introduce private struct for mm_walk
> Applying: pagemap: introduce pagemap_entry_t without pmshift bits
> Applying: pagemap: introduce the /proc/PID/pagemap2 file
> Applying: mm: soft-dirty bits for user memory changes tracking
> Applying: mem-soft-dirty: Reshuffle CONFIG_ options to be more Arch-friendly
> Applying: selftest: add simple test for soft-dirty bit
> Applying: mm: remove free_area_cache
> Applying: include/linux/mmzone.h: cleanups
> Applying: include-linux-mmzoneh-cleanups-fix
> Applying: mm: memmap_init_zone() performance improvement
> Applying: drop_caches: add some documentation and info message
> Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() with NULL dev
> Applying: mm/dmapool.c: fix null dev in dma_pool_create()
> Applying: memcg: debugging facility to access dangling memcgs
> Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
> Applying: mm: add vm event counters for balloon pages compaction
> Applying: kernel/range.c: subtract_range: fix the broken phrase issued by printk
> Applying: smp: Give WARN()ing when calling smp_call_function_many()/single() in serving irq
> Applying: x86: don't show trace beyond show_stack(NULL, NULL)
> Applying: sparc32: make show_stack() acquire %fp if @_ksp is not specified
> Applying: dump_stack: consolidate dump_stack() implementations and unify their behaviors
> Applying: dmi: morph dmi_dump_ids() into dmi_format_ids() which formats into a buffer
> Applying: dump_stack: implement arch-specific hardware description in task dumps
> Applying: dump_stack: unify debug information printed by show_regs()
> Applying: arc, print-fatal-signals: reduce duplicated information
> Applying: kthread: implement probe_kthread_data()
> Applying: workqueue: include workqueue info when printing debug dump of a worker task
> Applying: writeback: set worker desc to identify writeback workers in task dumps
> Applying: kernel/smp.c: use '|=' for csd_lock
> Applying: kernel/smp.c: remove 'priv' of call_single_data
> Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount write lock
> Applying: kernel/smp.c: cleanups
> Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
> Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
> Applying: lib/string_helpers: introduce generic string_unescape
> Applying: lib-string_helpers-introduce-generic-string_unescape-fix
> Applying: staging: speakup: remove custom string_unescape_any_inplace
> Applying: dynamic_debug: reuse generic string_unescape function
> Applying: binfmt_misc: reuse string_unescape_inplace()
> Applying: kernel/compat.c: make do_sysinfo() static
> Applying: kernel/timer.c: convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFINE
> Applying: kernel/timer.c: move some non timer related syscalls to kernel/sys.c
> Applying: kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes
> Applying: epoll: trim epitem by one cache line
> Applying: epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
> Applying: epoll: comment + BUILD_BUG_ON to prevent epitem bloat
> Applying: epoll: use RCU to protect wakeup_source in epitem
> Applying: epoll: fix suspicious RCU usage in ep_poll_callback
> Applying: epoll: lock ep->mtx in ep_free to silence lockdep
> Applying: epoll: cleanup: hoist out f_op->poll calls
> Applying: epoll: cleanup: use RCU_INIT_POINTER when nulling
> Applying: fs: make binfmt support for #! scripts modular and removable
> Applying: binfmt_elf: PIE: make PF_RANDOMIZE check comment more accurate
> Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
> Applying: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()
> Applying: dmi_scan: proper buf type in dmi_present()
> Applying: i2o: check copy_from_user() size parameter
> Applying: drivers/rtc/rtc-v3020.c: use gpio_request_array()
> Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
> Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
> Applying: drivers/rtc/rtc-pxa.c: use devm_* APIs
> Applying: nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption
> Applying: nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix
> Applying: nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()
> Applying: nilfs2: remove unneeded test in nilfs_writepage()
> Applying: hfs: add error checking for hfs_find_init()
> Applying: hfsplus: fix warnings in fs/hfsplus/bfind.c
> Applying: hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix
> Applying: hfs/hfsplus: convert dprint to hfs_dbg
> Applying: hfs/hfsplus: convert printks to pr_<level>
> Applying: hfsplus: add error propagation to __hfsplus_ext_write_extent()
> Applying: hfsplus: remove duplicated message prefix in hfsplus_block_free()
> Applying: fat: additions to support fat_fallocate
> Applying: fat-additions-to-support-fat_fallocate-fix
> Applying: ptrace: add ability to retrieve signals without removing from a queue (v4)
> Applying: selftest: add a test case for PTRACE_PEEKSIGINFO
> Applying: usermodehelper: export call_usermodehelper_exec() and call_usermodehelper_setup()
> Applying: usermodehelper-export-_exec-and-_setup-functions-fix
> Applying: kmod: split call to call_usermodehelper_fns()
> Applying: KEYS: split call to call_usermodehelper_fns()
> Applying: coredump: remove trailling whitespace
> Applying: usermodehelper: split remaining calls to call_usermodehelper_fns()
> Applying: kmod: remove call_usermodehelper_fns()
> Applying: coredump: only SIGKILL should interrupt the coredumping task
> Applying: coredump: ensure that SIGKILL always kills the dumping thread
> Applying: coredump: sanitize the setting of signal->group_exit_code
> Applying: coredump: introduce dump_interrupted()
> Applying: coredump: factor out the setting of PF_DUMPCORE
> Applying: coredump: change wait_for_dump_helpers() to use wait_event_interruptible()
> Applying: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN bytes
> Applying: set_task_comm: kill the pointless memset() + wmb()
> Applying: exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
> Applying: kexec: fix wrong types of some local variables
> Applying: kexec: Use min() and min_t() to simplify logic
> Applying: kexec-use-min_t-to-simplify-logic-fix
> Applying: ipc: clamp with min()
> Applying: ipc: separate msg allocation from userspace copy
> Applying: ipc: tighten msg copy loops
> Applying: ipc: set EFAULT as default error in load_msg()
> Applying: ipc: remove msg handling from queue scan
> Applying: ipc: implement MSG_COPY as a new receive mode
> Applying: ipc: simplify msg list search
> Applying: ipc: refactor msg list search into separate function
> Applying: ipc: find_msg can be static
> Applying: ipc/msgutil.c: use linux/uaccess.h
> Applying: ipc: remove bogus lock comment for ipc_checkid
> Applying: ipc: introduce obtaining a lockless ipc object
> Applying: ipc-introduce-obtaining-a-lockless-ipc-object-fix
> Applying: ipc: introduce lockless pre_down ipcctl
> Applying: ipc,sem: do not hold ipc lock more than necessary
> Applying: ipc,sem: prevent releasing RCU read lock twice in semctl_main
> Applying: ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes
> Applying: ipc,sem: open code and rename sem_lock
> Applying: ipcsem-open-code-and-rename-sem_lock-fix
> Applying: ipc,sem: have only one list in struct sem_queue
> Applying: ipc,sem: fine grained locking for semtimedop
> Applying: fix for sem_lock
> Applying: ipc, sem: prevent possible deadlock
> Applying: ipc,sem: fix locking in semctl_main
> Applying: ipc,sem: untangle RCU locking with find_alloc_undo
> Applying: ipc, sem: do not call sem_lock when bogus sma
> Applying: ipc: make refcounter atomic
> Applying: ipc,sem: fix lockdep false positive
> Applying: ipc/msg.c: use list_for_each_entry_[safe] for list traversing
> Applying: ipc: sysv shared memory limited to 8TiB
> Applying: ipc-sysv-shared-memory-limited-to-8tib-fix
> Applying: ipc/sem.c: alternatives to preempt_disable()
> Applying: mwave: fix info leak in mwave_ioctl()
> Applying: rapidio: make enumeration/discovery configurable
> Applying: rapidio: add enumeration/discovery start from user space
> Applying: rapidio: documentation update for enumeration changes
> Applying: rbtree_test: add extra rbtree integrity check
> Applying: rbtree_test: add __init/__exit annotations
> Applying: kernel/pid.c: improve flow of a loop inside alloc_pidmap.
> Applying: kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix
> Applying: pid_namespace.c/.h: simplify defines
> Applying: pid_namespacec-h-simplify-defines-fix
> Applying: nbd: increase default and max request sizes
> Applying: aoe: replace kmalloc and then memcpy with kmemdup
> Applying: drivers/net: rename random32() to prandom_u32()
> Applying: drivers-net-rename-random32-to-prandom_u32-fix
> Applying: brcm80211: fix the misaligned indentation
> Applying: remove unused random32() and srandom32()
> Applying: random: fix accounting race condition with lockless irq entropy_count update
> Applying: pps: hide more configuration symbols behind CONFIG_PPS
> Applying: pps: pps_kc_hardpps_lock can be static
> Applying: semaphore: use unlikely() for down's timeout
> Applying: semaphore: use `bool' type for semaphore_waiter's up
> Applying: drivers/memstick/host/r592.c: make r592_pm_ops static
> Applying: kernel/relay.c: remove unused function argument actor
> Applying: kernel/relay.c: move FIX_SIZE macro into relay.c
> Applying: relay: use macro PAGE_ALIGN instead of FIX_SIZE
> Applying: relay: fix timer madness
> Applying: mm: remove old aio use_mm() comment
> Applying: aio: remove dead code from aio.h
> Applying: gadget: remove only user of aio retry
> Applying: gadget-remove-only-user-of-aio-retry-checkpatch-fixes
> Applying: aio: remove retry-based AIO
> Applying: aio-remove-retry-based-aio-checkpatch-fixes
> Applying: char: add aio_{read,write} to /dev/{null,zero}
> Applying: aio: kill return value of aio_complete()
> Applying: aio: add kiocb_cancel()
> Applying: aio: move private stuff out of aio.h
> Applying: aio: dprintk() -> pr_debug()
> Applying: aio: do fget() after aio_get_req()
> Applying: aio: make aio_put_req() lockless
> Applying: aio-make-aio_put_req-lockless-checkpatch-fixes
> Applying: aio: refcounting cleanup
> Applying: aio-refcounting-cleanup-checkpatch-fixes
> Applying: wait: add wait_event_hrtimeout()
> Applying: aio: make aio_read_evt() more efficient, convert to hrtimers
> Applying: aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes
> Applying: aio: use flush_dcache_page()
> Applying: aio: use cancellation list lazily
> Applying: aio: change reqs_active to include unreaped completions
> Applying: aio: kill batch allocation
> Applying: aio: kill struct aio_ring_info
> Applying: aio: give shared kioctx fields their own cachelines
> Applying: aio: reqs_active -> reqs_available
> Applying: aio: percpu reqs_available
> Applying: generic dynamic per cpu refcounting
> Applying: generic-dynamic-per-cpu-refcounting-checkpatch-fixes
> Applying: generic-dynamic-per-cpu-refcounting-fix
> Applying: aio: percpu ioctx refcount
> Applying: aio: use xchg() instead of completion_lock
> Applying: aio: don't include aio.h in sched.h
> Applying: aio-dont-include-aioh-in-schedh-fix
> Applying: aio: kill ki_key
> Applying: aio: kill ki_retry
> Applying: aio-kill-ki_retry-fix
> Applying: aio-kill-ki_retry-checkpatch-fixes
> Applying: block: prep work for batch completion
> Applying: block-prep-work-for-batch-completion-checkpatch-fixes
> Applying: block-prep-work-for-batch-completion-checkpatch merge fixes
> Applying: block-prep-work-for-batch-completion-fix-2
> Applying: block-prep-work-for-batch-completion-fix-3
> Applying: block-prep-work-for-batch-completion-fix-3-fix
> Applying: block-prep-work-for-batch-completion-fix-4
> Applying: block-prep-work-for-batch-completion-fix-99
> Applying: block, aio: batch completion for bios/kiocbs
> Applying: block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
> Applying: block-aio-batch-completion-for-bios-kiocbs-fix
> Applying: virtio-blk: convert to batch completion
> Applying: mtip32xx: convert to batch completion
> Applying: aio: fix kioctx not being freed after cancellation at exit time
> Applying: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
> Applying: kconfig-consolidate-config_debug_strict_user_copy_checks-fix
> Applying: kconfig menu: move Virtualization drivers near other virtualization options
> Applying: init/Kconfig: re-order CONFIG_EXPERT options to fix menuconfig display
> Applying: UAPI: remove empty Kbuild files
> Applying: kernel/sys.c: make prctl(PR_SET_MM) generally available
> Applying: notifier-error-inject: fix module names in Kconfig
> Applying: decompressor: add LZ4 decompressor module
> Applying: lib: add support for LZ4-compressed kernel
> Applying: arm: add support for LZ4-compressed kernel
> Applying: x86: add support for LZ4-compressed kernel
> Applying: lib: add lz4 compressor module
> Applying: lib-add-lz4-compressor-module-fix
> Applying: crypto: add lz4 Cryptographic API
> Applying: crypto-add-lz4-cryptographic-api-fix
> Applying: lib/decompress.c: fix initconst
> Applying: seccomp: add generic code for jitted seccomp filters.
> Applying: ARM: net: bpf_jit: make code generation less dependent on struct sk_filter.
> Applying: ARM: net: bpf_jit: add support for jitted seccomp filters.
> Applying: bpf: add comments explaining the schedule_work() operation
> Applying: kgdb/sysrq: fix inconstistent help message of sysrq key
> Applying: power/sysrq: fix inconstistent help message of sysrq key
> Applying: ARM/etm/sysrq: fix inconstistent help message of sysrq key
> Applying: powerpc/xmon/sysrq: fix inconstistent help message of sysrq key
> Applying: sparc/sysrq: fix inconstistent help message of sysrq key
> Applying: ethernet/emac/sysrq: fix inconstistent help message of sysrq key
> Applying: Documentation/sysrq: fix inconstistent help message of sysrq key
> Merging akpm/master (843d8e2 Documentation/sysrq: fix inconstistent help message of sysrq key)
> 
--8323328-442319640-1367480283=:23933
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=randconf
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1305021537410.23933@M2420>
Content-Description: 
Content-Disposition: attachment; filename=randconf

Iw0KIyBBdXRvbWF0aWNhbGx5IGdlbmVyYXRlZCBmaWxlOyBETyBOT1QgRURJ
VC4NCiMgTGludXgveDg2IDMuOS4wIEtlcm5lbCBDb25maWd1cmF0aW9uDQoj
DQpDT05GSUdfNjRCSVQ9eQ0KQ09ORklHX1g4Nl82ND15DQpDT05GSUdfWDg2
PXkNCkNPTkZJR19JTlNUUlVDVElPTl9ERUNPREVSPXkNCkNPTkZJR19PVVRQ
VVRfRk9STUFUPSJlbGY2NC14ODYtNjQiDQpDT05GSUdfQVJDSF9ERUZDT05G
SUc9ImFyY2gveDg2L2NvbmZpZ3MveDg2XzY0X2RlZmNvbmZpZyINCkNPTkZJ
R19MT0NLREVQX1NVUFBPUlQ9eQ0KQ09ORklHX1NUQUNLVFJBQ0VfU1VQUE9S
VD15DQpDT05GSUdfSEFWRV9MQVRFTkNZVE9QX1NVUFBPUlQ9eQ0KQ09ORklH
X01NVT15DQpDT05GSUdfTkVFRF9ETUFfTUFQX1NUQVRFPXkNCkNPTkZJR19O
RUVEX1NHX0RNQV9MRU5HVEg9eQ0KQ09ORklHX0dFTkVSSUNfSFdFSUdIVD15
DQpDT05GSUdfUldTRU1fWENIR0FERF9BTEdPUklUSE09eQ0KQ09ORklHX0dF
TkVSSUNfQ0FMSUJSQVRFX0RFTEFZPXkNCkNPTkZJR19BUkNIX0hBU19DUFVf
UkVMQVg9eQ0KQ09ORklHX0FSQ0hfSEFTX0NBQ0hFX0xJTkVfU0laRT15DQpD
T05GSUdfQVJDSF9IQVNfQ1BVX0FVVE9QUk9CRT15DQpDT05GSUdfSEFWRV9T
RVRVUF9QRVJfQ1BVX0FSRUE9eQ0KQ09ORklHX05FRURfUEVSX0NQVV9FTUJF
RF9GSVJTVF9DSFVOSz15DQpDT05GSUdfTkVFRF9QRVJfQ1BVX1BBR0VfRklS
U1RfQ0hVTks9eQ0KQ09ORklHX0FSQ0hfSElCRVJOQVRJT05fUE9TU0lCTEU9
eQ0KQ09ORklHX0FSQ0hfU1VTUEVORF9QT1NTSUJMRT15DQpDT05GSUdfWk9O
RV9ETUEzMj15DQpDT05GSUdfQVVESVRfQVJDSD15DQpDT05GSUdfQVJDSF9T
VVBQT1JUU19PUFRJTUlaRURfSU5MSU5JTkc9eQ0KQ09ORklHX0FSQ0hfU1VQ
UE9SVFNfREVCVUdfUEFHRUFMTE9DPXkNCkNPTkZJR19BUkNIX0hXRUlHSFRf
Q0ZMQUdTPSItZmNhbGwtc2F2ZWQtcmRpIC1mY2FsbC1zYXZlZC1yc2kgLWZj
YWxsLXNhdmVkLXJkeCAtZmNhbGwtc2F2ZWQtcmN4IC1mY2FsbC1zYXZlZC1y
OCAtZmNhbGwtc2F2ZWQtcjkgLWZjYWxsLXNhdmVkLXIxMCAtZmNhbGwtc2F2
ZWQtcjExIg0KQ09ORklHX0FSQ0hfU1VQUE9SVFNfVVBST0JFUz15DQpDT05G
SUdfREVGQ09ORklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVfUkVMRUFT
RS8uY29uZmlnIg0KQ09ORklHX0NPTlNUUlVDVE9SUz15DQpDT05GSUdfSVJR
X1dPUks9eQ0KQ09ORklHX0JVSUxEVElNRV9FWFRBQkxFX1NPUlQ9eQ0KDQoj
DQojIEdlbmVyYWwgc2V0dXANCiMNCkNPTkZJR19CUk9LRU5fT05fU01QPXkN
CkNPTkZJR19JTklUX0VOVl9BUkdfTElNSVQ9MzINCkNPTkZJR19DUk9TU19D
T01QSUxFPSIiDQpDT05GSUdfTE9DQUxWRVJTSU9OPSIiDQojIENPTkZJR19M
T0NBTFZFUlNJT05fQVVUTyBpcyBub3Qgc2V0DQpDT05GSUdfSEFWRV9LRVJO
RUxfR1pJUD15DQpDT05GSUdfSEFWRV9LRVJORUxfQlpJUDI9eQ0KQ09ORklH
X0hBVkVfS0VSTkVMX0xaTUE9eQ0KQ09ORklHX0hBVkVfS0VSTkVMX1haPXkN
CkNPTkZJR19IQVZFX0tFUk5FTF9MWk89eQ0KQ09ORklHX0hBVkVfS0VSTkVM
X0xaND15DQojIENPTkZJR19LRVJORUxfR1pJUCBpcyBub3Qgc2V0DQojIENP
TkZJR19LRVJORUxfQlpJUDIgaXMgbm90IHNldA0KQ09ORklHX0tFUk5FTF9M
Wk1BPXkNCiMgQ09ORklHX0tFUk5FTF9YWiBpcyBub3Qgc2V0DQojIENPTkZJ
R19LRVJORUxfTFpPIGlzIG5vdCBzZXQNCiMgQ09ORklHX0tFUk5FTF9MWjQg
aXMgbm90IHNldA0KQ09ORklHX0RFRkFVTFRfSE9TVE5BTUU9Iihub25lKSIN
CiMgQ09ORklHX1NXQVAgaXMgbm90IHNldA0KIyBDT05GSUdfU1lTVklQQyBp
cyBub3Qgc2V0DQojIENPTkZJR19QT1NJWF9NUVVFVUUgaXMgbm90IHNldA0K
IyBDT05GSUdfRkhBTkRMRSBpcyBub3Qgc2V0DQpDT05GSUdfQVVESVQ9eQ0K
IyBDT05GSUdfQVVESVRTWVNDQUxMIGlzIG5vdCBzZXQNCkNPTkZJR19BVURJ
VF9MT0dJTlVJRF9JTU1VVEFCTEU9eQ0KQ09ORklHX0hBVkVfR0VORVJJQ19I
QVJESVJRUz15DQoNCiMNCiMgSVJRIHN1YnN5c3RlbQ0KIw0KQ09ORklHX0dF
TkVSSUNfSEFSRElSUVM9eQ0KQ09ORklHX0dFTkVSSUNfSVJRX1BST0JFPXkN
CkNPTkZJR19HRU5FUklDX0lSUV9TSE9XPXkNCkNPTkZJR19HRU5FUklDX0lS
UV9DSElQPXkNCkNPTkZJR19JUlFfRE9NQUlOPXkNCiMgQ09ORklHX0lSUV9E
T01BSU5fREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0lSUV9GT1JDRURfVEhS
RUFESU5HPXkNCkNPTkZJR19TUEFSU0VfSVJRPXkNCkNPTkZJR19DTE9DS1NP
VVJDRV9XQVRDSERPRz15DQpDT05GSUdfQVJDSF9DTE9DS1NPVVJDRV9EQVRB
PXkNCkNPTkZJR19BTFdBWVNfVVNFX1BFUlNJU1RFTlRfQ0xPQ0s9eQ0KQ09O
RklHX0dFTkVSSUNfVElNRV9WU1lTQ0FMTD15DQpDT05GSUdfR0VORVJJQ19D
TE9DS0VWRU5UUz15DQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CVUlM
RD15DQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UU19CUk9BRENBU1Q9eQ0K
Q09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfTUlOX0FESlVTVD15DQpDT05G
SUdfR0VORVJJQ19DTU9TX1VQREFURT15DQoNCiMNCiMgVGltZXJzIHN1YnN5
c3RlbQ0KIw0KQ09ORklHX1RJQ0tfT05FU0hPVD15DQpDT05GSUdfTk9fSFpf
Q09NTU9OPXkNCiMgQ09ORklHX0haX1BFUklPRElDIGlzIG5vdCBzZXQNCkNP
TkZJR19OT19IWl9JRExFPXkNCkNPTkZJR19OT19IWj15DQpDT05GSUdfSElH
SF9SRVNfVElNRVJTPXkNCg0KIw0KIyBDUFUvVGFzayB0aW1lIGFuZCBzdGF0
cyBhY2NvdW50aW5nDQojDQpDT05GSUdfVElDS19DUFVfQUNDT1VOVElORz15
DQojIENPTkZJR19WSVJUX0NQVV9BQ0NPVU5USU5HX0dFTiBpcyBub3Qgc2V0
DQojIENPTkZJR19JUlFfVElNRV9BQ0NPVU5USU5HIGlzIG5vdCBzZXQNCkNP
TkZJR19CU0RfUFJPQ0VTU19BQ0NUPXkNCkNPTkZJR19CU0RfUFJPQ0VTU19B
Q0NUX1YzPXkNCkNPTkZJR19UQVNLU1RBVFM9eQ0KQ09ORklHX1RBU0tfREVM
QVlfQUNDVD15DQpDT05GSUdfVEFTS19YQUNDVD15DQojIENPTkZJR19UQVNL
X0lPX0FDQ09VTlRJTkcgaXMgbm90IHNldA0KDQojDQojIFJDVSBTdWJzeXN0
ZW0NCiMNCkNPTkZJR19USU5ZX1JDVT15DQojIENPTkZJR19QUkVFTVBUX1JD
VSBpcyBub3Qgc2V0DQojIENPTkZJR19SQ1VfU1RBTExfQ09NTU9OIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1RSRUVfUkNVX1RSQUNFIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0lLQ09ORklHIGlzIG5vdCBzZXQNCkNPTkZJR19MT0dfQlVGX1NI
SUZUPTE3DQpDT05GSUdfSEFWRV9VTlNUQUJMRV9TQ0hFRF9DTE9DSz15DQpD
T05GSUdfQVJDSF9TVVBQT1JUU19OVU1BX0JBTEFOQ0lORz15DQpDT05GSUdf
QVJDSF9XQU5UU19QUk9UX05VTUFfUFJPVF9OT05FPXkNCkNPTkZJR19DR1JP
VVBTPXkNCiMgQ09ORklHX0NHUk9VUF9ERUJVRyBpcyBub3Qgc2V0DQojIENP
TkZJR19DR1JPVVBfRlJFRVpFUiBpcyBub3Qgc2V0DQojIENPTkZJR19DR1JP
VVBfREVWSUNFIGlzIG5vdCBzZXQNCiMgQ09ORklHX0NQVVNFVFMgaXMgbm90
IHNldA0KQ09ORklHX0NHUk9VUF9DUFVBQ0NUPXkNCkNPTkZJR19SRVNPVVJD
RV9DT1VOVEVSUz15DQojIENPTkZJR19NRU1DRyBpcyBub3Qgc2V0DQojIENP
TkZJR19DR1JPVVBfUEVSRiBpcyBub3Qgc2V0DQojIENPTkZJR19DR1JPVVBf
U0NIRUQgaXMgbm90IHNldA0KIyBDT05GSUdfQkxLX0NHUk9VUCBpcyBub3Qg
c2V0DQpDT05GSUdfQ0hFQ0tQT0lOVF9SRVNUT1JFPXkNCkNPTkZJR19OQU1F
U1BBQ0VTPXkNCiMgQ09ORklHX1VUU19OUyBpcyBub3Qgc2V0DQojIENPTkZJ
R19VU0VSX05TIGlzIG5vdCBzZXQNCkNPTkZJR19QSURfTlM9eQ0KIyBDT05G
SUdfTkVUX05TIGlzIG5vdCBzZXQNCkNPTkZJR19VSURHSURfQ09OVkVSVEVE
PXkNCkNPTkZJR19VSURHSURfU1RSSUNUX1RZUEVfQ0hFQ0tTPXkNCiMgQ09O
RklHX1NDSEVEX0FVVE9HUk9VUCBpcyBub3Qgc2V0DQojIENPTkZJR19TWVNG
U19ERVBSRUNBVEVEIGlzIG5vdCBzZXQNCkNPTkZJR19SRUxBWT15DQojIENP
TkZJR19CTEtfREVWX0lOSVRSRCBpcyBub3Qgc2V0DQojIENPTkZJR19DQ19P
UFRJTUlaRV9GT1JfU0laRSBpcyBub3Qgc2V0DQpDT05GSUdfU1lTQ1RMPXkN
CkNPTkZJR19BTk9OX0lOT0RFUz15DQpDT05GSUdfSEFWRV9VSUQxNj15DQpD
T05GSUdfU1lTQ1RMX0VYQ0VQVElPTl9UUkFDRT15DQpDT05GSUdfSE9UUExV
Rz15DQpDT05GSUdfSEFWRV9QQ1NQS1JfUExBVEZPUk09eQ0KQ09ORklHX0VY
UEVSVD15DQojIENPTkZJR19VSUQxNiBpcyBub3Qgc2V0DQojIENPTkZJR19T
WVNDVExfU1lTQ0FMTCBpcyBub3Qgc2V0DQpDT05GSUdfS0FMTFNZTVM9eQ0K
Q09ORklHX0tBTExTWU1TX0FMTD15DQpDT05GSUdfUFJJTlRLPXkNCiMgQ09O
RklHX0JVRyBpcyBub3Qgc2V0DQojIENPTkZJR19FTEZfQ09SRSBpcyBub3Qg
c2V0DQpDT05GSUdfUENTUEtSX1BMQVRGT1JNPXkNCiMgQ09ORklHX0JBU0Vf
RlVMTCBpcyBub3Qgc2V0DQojIENPTkZJR19GVVRFWCBpcyBub3Qgc2V0DQpD
T05GSUdfRVBPTEw9eQ0KIyBDT05GSUdfU0lHTkFMRkQgaXMgbm90IHNldA0K
IyBDT05GSUdfVElNRVJGRCBpcyBub3Qgc2V0DQpDT05GSUdfRVZFTlRGRD15
DQpDT05GSUdfU0hNRU09eQ0KIyBDT05GSUdfQUlPIGlzIG5vdCBzZXQNCkNP
TkZJR19QQ0lfUVVJUktTPXkNCkNPTkZJR19FTUJFRERFRD15DQpDT05GSUdf
SEFWRV9QRVJGX0VWRU5UUz15DQoNCiMNCiMgS2VybmVsIFBlcmZvcm1hbmNl
IEV2ZW50cyBBbmQgQ291bnRlcnMNCiMNCkNPTkZJR19QRVJGX0VWRU5UUz15
DQojIENPTkZJR19ERUJVR19QRVJGX1VTRV9WTUFMTE9DIGlzIG5vdCBzZXQN
CkNPTkZJR19WTV9FVkVOVF9DT1VOVEVSUz15DQpDT05GSUdfU0xVQl9ERUJV
Rz15DQojIENPTkZJR19DT01QQVRfQlJLIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1NMQUIgaXMgbm90IHNldA0KQ09ORklHX1NMVUI9eQ0KIyBDT05GSUdfU0xP
QiBpcyBub3Qgc2V0DQpDT05GSUdfUFJPRklMSU5HPXkNCkNPTkZJR19UUkFD
RVBPSU5UUz15DQpDT05GSUdfT1BST0ZJTEU9bQ0KIyBDT05GSUdfT1BST0ZJ
TEVfRVZFTlRfTVVMVElQTEVYIGlzIG5vdCBzZXQNCkNPTkZJR19IQVZFX09Q
Uk9GSUxFPXkNCkNPTkZJR19PUFJPRklMRV9OTUlfVElNRVI9eQ0KQ09ORklH
X0tQUk9CRVM9eQ0KQ09ORklHX0pVTVBfTEFCRUw9eQ0KQ09ORklHX09QVFBS
T0JFUz15DQojIENPTkZJR19IQVZFXzY0QklUX0FMSUdORURfQUNDRVNTIGlz
IG5vdCBzZXQNCkNPTkZJR19IQVZFX0VGRklDSUVOVF9VTkFMSUdORURfQUND
RVNTPXkNCkNPTkZJR19BUkNIX1VTRV9CVUlMVElOX0JTV0FQPXkNCkNPTkZJ
R19LUkVUUFJPQkVTPXkNCkNPTkZJR19VU0VSX1JFVFVSTl9OT1RJRklFUj15
DQpDT05GSUdfSEFWRV9JT1JFTUFQX1BST1Q9eQ0KQ09ORklHX0hBVkVfS1BS
T0JFUz15DQpDT05GSUdfSEFWRV9LUkVUUFJPQkVTPXkNCkNPTkZJR19IQVZF
X09QVFBST0JFUz15DQpDT05GSUdfSEFWRV9LUFJPQkVTX09OX0ZUUkFDRT15
DQpDT05GSUdfSEFWRV9BUkNIX1RSQUNFSE9PSz15DQpDT05GSUdfSEFWRV9E
TUFfQVRUUlM9eQ0KQ09ORklHX0dFTkVSSUNfU01QX0lETEVfVEhSRUFEPXkN
CkNPTkZJR19IQVZFX1JFR1NfQU5EX1NUQUNLX0FDQ0VTU19BUEk9eQ0KQ09O
RklHX0hBVkVfRE1BX0FQSV9ERUJVRz15DQpDT05GSUdfSEFWRV9IV19CUkVB
S1BPSU5UPXkNCkNPTkZJR19IQVZFX01JWEVEX0JSRUFLUE9JTlRTX1JFR1M9
eQ0KQ09ORklHX0hBVkVfVVNFUl9SRVRVUk5fTk9USUZJRVI9eQ0KQ09ORklH
X0hBVkVfUEVSRl9FVkVOVFNfTk1JPXkNCkNPTkZJR19IQVZFX1BFUkZfUkVH
Uz15DQpDT05GSUdfSEFWRV9QRVJGX1VTRVJfU1RBQ0tfRFVNUD15DQpDT05G
SUdfSEFWRV9BUkNIX0pVTVBfTEFCRUw9eQ0KQ09ORklHX0FSQ0hfSEFWRV9O
TUlfU0FGRV9DTVBYQ0hHPXkNCkNPTkZJR19IQVZFX0FMSUdORURfU1RSVUNU
X1BBR0U9eQ0KQ09ORklHX0hBVkVfQ01QWENIR19MT0NBTD15DQpDT05GSUdf
SEFWRV9DTVBYQ0hHX0RPVUJMRT15DQpDT05GSUdfQVJDSF9XQU5UX0NPTVBB
VF9JUENfUEFSU0VfVkVSU0lPTj15DQpDT05GSUdfQVJDSF9XQU5UX09MRF9D
T01QQVRfSVBDPXkNCkNPTkZJR19IQVZFX0FSQ0hfU0VDQ09NUF9GSUxURVI9
eQ0KQ09ORklHX1NFQ0NPTVBfRklMVEVSPXkNCkNPTkZJR19IQVZFX0NPTlRF
WFRfVFJBQ0tJTkc9eQ0KQ09ORklHX0hBVkVfSVJRX1RJTUVfQUNDT1VOVElO
Rz15DQpDT05GSUdfSEFWRV9BUkNIX1RSQU5TUEFSRU5UX0hVR0VQQUdFPXkN
CkNPTkZJR19IQVZFX0FSQ0hfU09GVF9ESVJUWT15DQpDT05GSUdfTU9EVUxF
U19VU0VfRUxGX1JFTEE9eQ0KQ09ORklHX09MRF9TSUdTVVNQRU5EMz15DQpD
T05GSUdfQ09NUEFUX09MRF9TSUdBQ1RJT049eQ0KDQojDQojIEdDT1YtYmFz
ZWQga2VybmVsIHByb2ZpbGluZw0KIw0KQ09ORklHX0dDT1ZfS0VSTkVMPXkN
CiMgQ09ORklHX0dDT1ZfUFJPRklMRV9BTEwgaXMgbm90IHNldA0KIyBDT05G
SUdfSEFWRV9HRU5FUklDX0RNQV9DT0hFUkVOVCBpcyBub3Qgc2V0DQpDT05G
SUdfU0xBQklORk89eQ0KQ09ORklHX1JUX01VVEVYRVM9eQ0KQ09ORklHX0JB
U0VfU01BTEw9MQ0KQ09ORklHX01PRFVMRVM9eQ0KQ09ORklHX01PRFVMRV9G
T1JDRV9MT0FEPXkNCiMgQ09ORklHX01PRFVMRV9VTkxPQUQgaXMgbm90IHNl
dA0KIyBDT05GSUdfTU9EVkVSU0lPTlMgaXMgbm90IHNldA0KQ09ORklHX01P
RFVMRV9TUkNWRVJTSU9OX0FMTD15DQpDT05GSUdfTU9EVUxFX1NJRz15DQoj
IENPTkZJR19NT0RVTEVfU0lHX0ZPUkNFIGlzIG5vdCBzZXQNCkNPTkZJR19N
T0RVTEVfU0lHX0FMTD15DQojIENPTkZJR19NT0RVTEVfU0lHX1NIQTEgaXMg
bm90IHNldA0KQ09ORklHX01PRFVMRV9TSUdfU0hBMjI0PXkNCiMgQ09ORklH
X01PRFVMRV9TSUdfU0hBMjU2IGlzIG5vdCBzZXQNCiMgQ09ORklHX01PRFVM
RV9TSUdfU0hBMzg0IGlzIG5vdCBzZXQNCiMgQ09ORklHX01PRFVMRV9TSUdf
U0hBNTEyIGlzIG5vdCBzZXQNCkNPTkZJR19NT0RVTEVfU0lHX0hBU0g9InNo
YTIyNCINCkNPTkZJR19CTE9DSz15DQpDT05GSUdfQkxLX0RFVl9CU0c9eQ0K
Q09ORklHX0JMS19ERVZfQlNHTElCPXkNCkNPTkZJR19CTEtfREVWX0lOVEVH
UklUWT15DQoNCiMNCiMgUGFydGl0aW9uIFR5cGVzDQojDQojIENPTkZJR19Q
QVJUSVRJT05fQURWQU5DRUQgaXMgbm90IHNldA0KQ09ORklHX01TRE9TX1BB
UlRJVElPTj15DQpDT05GSUdfRUZJX1BBUlRJVElPTj15DQpDT05GSUdfQkxP
Q0tfQ09NUEFUPXkNCg0KIw0KIyBJTyBTY2hlZHVsZXJzDQojDQpDT05GSUdf
SU9TQ0hFRF9OT09QPXkNCkNPTkZJR19JT1NDSEVEX0RFQURMSU5FPXkNCkNP
TkZJR19JT1NDSEVEX0NGUT1tDQpDT05GSUdfREVGQVVMVF9ERUFETElORT15
DQojIENPTkZJR19ERUZBVUxUX05PT1AgaXMgbm90IHNldA0KQ09ORklHX0RF
RkFVTFRfSU9TQ0hFRD0iZGVhZGxpbmUiDQpDT05GSUdfUFJFRU1QVF9OT1RJ
RklFUlM9eQ0KQ09ORklHX0FTTjE9eQ0KQ09ORklHX1VOSU5MSU5FX1NQSU5f
VU5MT0NLPXkNCkNPTkZJR19GUkVFWkVSPXkNCg0KIw0KIyBQcm9jZXNzb3Ig
dHlwZSBhbmQgZmVhdHVyZXMNCiMNCkNPTkZJR19aT05FX0RNQT15DQojIENP
TkZJR19TTVAgaXMgbm90IHNldA0KIyBDT05GSUdfWDg2X01QUEFSU0UgaXMg
bm90IHNldA0KQ09ORklHX1g4Nl9FWFRFTkRFRF9QTEFURk9STT15DQojIENP
TkZJR19YODZfSU5URUxfTFBTUyBpcyBub3Qgc2V0DQpDT05GSUdfWDg2X1NV
UFBPUlRTX01FTU9SWV9GQUlMVVJFPXkNCkNPTkZJR19TQ0hFRF9PTUlUX0ZS
QU1FX1BPSU5URVI9eQ0KIyBDT05GSUdfSFlQRVJWSVNPUl9HVUVTVCBpcyBu
b3Qgc2V0DQpDT05GSUdfTk9fQk9PVE1FTT15DQpDT05GSUdfTUVNVEVTVD15
DQojIENPTkZJR19NSzggaXMgbm90IHNldA0KIyBDT05GSUdfTVBTQyBpcyBu
b3Qgc2V0DQojIENPTkZJR19NQ09SRTIgaXMgbm90IHNldA0KIyBDT05GSUdf
TUFUT00gaXMgbm90IHNldA0KQ09ORklHX0dFTkVSSUNfQ1BVPXkNCkNPTkZJ
R19YODZfSU5URVJOT0RFX0NBQ0hFX1NISUZUPTYNCkNPTkZJR19YODZfTDFf
Q0FDSEVfU0hJRlQ9Ng0KQ09ORklHX1g4Nl9UU0M9eQ0KQ09ORklHX1g4Nl9D
TVBYQ0hHNjQ9eQ0KQ09ORklHX1g4Nl9DTU9WPXkNCkNPTkZJR19YODZfTUlO
SU1VTV9DUFVfRkFNSUxZPTY0DQpDT05GSUdfWDg2X0RFQlVHQ1RMTVNSPXkN
CiMgQ09ORklHX1BST0NFU1NPUl9TRUxFQ1QgaXMgbm90IHNldA0KQ09ORklH
X0NQVV9TVVBfSU5URUw9eQ0KQ09ORklHX0NQVV9TVVBfQU1EPXkNCkNPTkZJ
R19DUFVfU1VQX0NFTlRBVVI9eQ0KQ09ORklHX0hQRVRfVElNRVI9eQ0KIyBD
T05GSUdfRE1JIGlzIG5vdCBzZXQNCiMgQ09ORklHX0dBUlRfSU9NTVUgaXMg
bm90IHNldA0KIyBDT05GSUdfQ0FMR0FSWV9JT01NVSBpcyBub3Qgc2V0DQpD
T05GSUdfU1dJT1RMQj15DQpDT05GSUdfSU9NTVVfSEVMUEVSPXkNCkNPTkZJ
R19OUl9DUFVTPTENCiMgQ09ORklHX1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0
DQpDT05GSUdfUFJFRU1QVF9WT0xVTlRBUlk9eQ0KIyBDT05GSUdfUFJFRU1Q
VCBpcyBub3Qgc2V0DQpDT05GSUdfUFJFRU1QVF9DT1VOVD15DQpDT05GSUdf
WDg2X0xPQ0FMX0FQSUM9eQ0KQ09ORklHX1g4Nl9JT19BUElDPXkNCkNPTkZJ
R19YODZfUkVST1VURV9GT1JfQlJPS0VOX0JPT1RfSVJRUz15DQpDT05GSUdf
WDg2X01DRT15DQojIENPTkZJR19YODZfTUNFX0lOVEVMIGlzIG5vdCBzZXQN
CkNPTkZJR19YODZfTUNFX0FNRD15DQpDT05GSUdfWDg2X01DRV9USFJFU0hP
TEQ9eQ0KQ09ORklHX1g4Nl9NQ0VfSU5KRUNUPXkNCiMgQ09ORklHX0k4SyBp
cyBub3Qgc2V0DQpDT05GSUdfTUlDUk9DT0RFPW0NCiMgQ09ORklHX01JQ1JP
Q09ERV9JTlRFTCBpcyBub3Qgc2V0DQojIENPTkZJR19NSUNST0NPREVfQU1E
IGlzIG5vdCBzZXQNCkNPTkZJR19NSUNST0NPREVfT0xEX0lOVEVSRkFDRT15
DQpDT05GSUdfWDg2X01TUj1tDQojIENPTkZJR19YODZfQ1BVSUQgaXMgbm90
IHNldA0KQ09ORklHX0FSQ0hfUEhZU19BRERSX1RfNjRCSVQ9eQ0KQ09ORklH
X0FSQ0hfRE1BX0FERFJfVF82NEJJVD15DQpDT05GSUdfRElSRUNUX0dCUEFH
RVM9eQ0KQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0VOQUJMRT15DQpDT05GSUdf
QVJDSF9TUEFSU0VNRU1fREVGQVVMVD15DQpDT05GSUdfQVJDSF9TRUxFQ1Rf
TUVNT1JZX01PREVMPXkNCkNPTkZJR19BUkNIX01FTU9SWV9QUk9CRT15DQpD
T05GSUdfSUxMRUdBTF9QT0lOVEVSX1ZBTFVFPTB4ZGVhZDAwMDAwMDAwMDAw
MA0KQ09ORklHX1NFTEVDVF9NRU1PUllfTU9ERUw9eQ0KQ09ORklHX1NQQVJT
RU1FTV9NQU5VQUw9eQ0KQ09ORklHX1NQQVJTRU1FTT15DQpDT05GSUdfSEFW
RV9NRU1PUllfUFJFU0VOVD15DQpDT05GSUdfU1BBUlNFTUVNX0VYVFJFTUU9
eQ0KQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQX0VOQUJMRT15DQpDT05GSUdf
U1BBUlNFTUVNX0FMTE9DX01FTV9NQVBfVE9HRVRIRVI9eQ0KQ09ORklHX1NQ
QVJTRU1FTV9WTUVNTUFQPXkNCkNPTkZJR19IQVZFX01FTUJMT0NLPXkNCkNP
TkZJR19IQVZFX01FTUJMT0NLX05PREVfTUFQPXkNCkNPTkZJR19BUkNIX0RJ
U0NBUkRfTUVNQkxPQ0s9eQ0KQ09ORklHX01FTU9SWV9JU09MQVRJT049eQ0K
Q09ORklHX0hBVkVfQk9PVE1FTV9JTkZPX05PREU9eQ0KQ09ORklHX01FTU9S
WV9IT1RQTFVHPXkNCkNPTkZJR19NRU1PUllfSE9UUExVR19TUEFSU0U9eQ0K
Q09ORklHX01FTU9SWV9IT1RSRU1PVkU9eQ0KQ09ORklHX1BBR0VGTEFHU19F
WFRFTkRFRD15DQpDT05GSUdfU1BMSVRfUFRMT0NLX0NQVVM9OTk5OTk5DQpD
T05GSUdfQkFMTE9PTl9DT01QQUNUSU9OPXkNCkNPTkZJR19DT01QQUNUSU9O
PXkNCkNPTkZJR19NSUdSQVRJT049eQ0KQ09ORklHX1BIWVNfQUREUl9UXzY0
QklUPXkNCkNPTkZJR19aT05FX0RNQV9GTEFHPTENCiMgQ09ORklHX0JPVU5D
RSBpcyBub3Qgc2V0DQpDT05GSUdfTkVFRF9CT1VOQ0VfUE9PTD15DQpDT05G
SUdfVklSVF9UT19CVVM9eQ0KQ09ORklHX01NVV9OT1RJRklFUj15DQpDT05G
SUdfS1NNPXkNCkNPTkZJR19ERUZBVUxUX01NQVBfTUlOX0FERFI9NDA5Ng0K
Q09ORklHX0FSQ0hfU1VQUE9SVFNfTUVNT1JZX0ZBSUxVUkU9eQ0KIyBDT05G
SUdfTUVNT1JZX0ZBSUxVUkUgaXMgbm90IHNldA0KQ09ORklHX1RSQU5TUEFS
RU5UX0hVR0VQQUdFPXkNCkNPTkZJR19UUkFOU1BBUkVOVF9IVUdFUEFHRV9B
TFdBWVM9eQ0KIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0VfTUFEVklT
RSBpcyBub3Qgc2V0DQpDT05GSUdfQ1JPU1NfTUVNT1JZX0FUVEFDSD15DQpD
T05GSUdfTkVFRF9QRVJfQ1BVX0tNPXkNCiMgQ09ORklHX0NMRUFOQ0FDSEUg
aXMgbm90IHNldA0KIyBDT05GSUdfTUVNX1NPRlRfRElSVFkgaXMgbm90IHNl
dA0KQ09ORklHX1g4Nl9DSEVDS19CSU9TX0NPUlJVUFRJT049eQ0KIyBDT05G
SUdfWDg2X0JPT1RQQVJBTV9NRU1PUllfQ09SUlVQVElPTl9DSEVDSyBpcyBu
b3Qgc2V0DQpDT05GSUdfWDg2X1JFU0VSVkVfTE9XPTY0DQpDT05GSUdfTVRS
Uj15DQojIENPTkZJR19NVFJSX1NBTklUSVpFUiBpcyBub3Qgc2V0DQojIENP
TkZJR19YODZfUEFUIGlzIG5vdCBzZXQNCkNPTkZJR19BUkNIX1JBTkRPTT15
DQojIENPTkZJR19YODZfU01BUCBpcyBub3Qgc2V0DQpDT05GSUdfRUZJPXkN
CiMgQ09ORklHX0VGSV9TVFVCIGlzIG5vdCBzZXQNCkNPTkZJR19TRUNDT01Q
PXkNCiMgQ09ORklHX0NDX1NUQUNLUFJPVEVDVE9SIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0haXzEwMCBpcyBub3Qgc2V0DQpDT05GSUdfSFpfMjUwPXkNCiMg
Q09ORklHX0haXzMwMCBpcyBub3Qgc2V0DQojIENPTkZJR19IWl8xMDAwIGlz
IG5vdCBzZXQNCkNPTkZJR19IWj0yNTANCkNPTkZJR19TQ0hFRF9IUlRJQ0s9
eQ0KIyBDT05GSUdfS0VYRUMgaXMgbm90IHNldA0KQ09ORklHX0NSQVNIX0RV
TVA9eQ0KQ09ORklHX1BIWVNJQ0FMX1NUQVJUPTB4MTAwMDAwMA0KIyBDT05G
SUdfUkVMT0NBVEFCTEUgaXMgbm90IHNldA0KQ09ORklHX1BIWVNJQ0FMX0FM
SUdOPTB4MTAwMDAwMA0KQ09ORklHX0NPTVBBVF9WRFNPPXkNCkNPTkZJR19D
TURMSU5FX0JPT0w9eQ0KQ09ORklHX0NNRExJTkU9IiINCiMgQ09ORklHX0NN
RExJTkVfT1ZFUlJJREUgaXMgbm90IHNldA0KQ09ORklHX0FSQ0hfRU5BQkxF
X01FTU9SWV9IT1RQTFVHPXkNCkNPTkZJR19BUkNIX0VOQUJMRV9NRU1PUllf
SE9UUkVNT1ZFPXkNCg0KIw0KIyBQb3dlciBtYW5hZ2VtZW50IGFuZCBBQ1BJ
IG9wdGlvbnMNCiMNCkNPTkZJR19TVVNQRU5EPXkNCkNPTkZJR19TVVNQRU5E
X0ZSRUVaRVI9eQ0KQ09ORklHX1BNX1NMRUVQPXkNCiMgQ09ORklHX1BNX0FV
VE9TTEVFUCBpcyBub3Qgc2V0DQojIENPTkZJR19QTV9XQUtFTE9DS1MgaXMg
bm90IHNldA0KQ09ORklHX1BNX1JVTlRJTUU9eQ0KQ09ORklHX1BNPXkNCiMg
Q09ORklHX1BNX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19BQ1BJPXkNCkNP
TkZJR19BQ1BJX1NMRUVQPXkNCkNPTkZJR19BQ1BJX1BST0NGUz15DQpDT05G
SUdfQUNQSV9QUk9DRlNfUE9XRVI9eQ0KQ09ORklHX0FDUElfRUNfREVCVUdG
Uz1tDQojIENPTkZJR19BQ1BJX1BST0NfRVZFTlQgaXMgbm90IHNldA0KQ09O
RklHX0FDUElfQUM9eQ0KIyBDT05GSUdfQUNQSV9CQVRURVJZIGlzIG5vdCBz
ZXQNCkNPTkZJR19BQ1BJX0JVVFRPTj1tDQpDT05GSUdfQUNQSV9WSURFTz1t
DQojIENPTkZJR19BQ1BJX0ZBTiBpcyBub3Qgc2V0DQojIENPTkZJR19BQ1BJ
X0RPQ0sgaXMgbm90IHNldA0KQ09ORklHX0FDUElfSTJDPXkNCkNPTkZJR19B
Q1BJX1BST0NFU1NPUj15DQojIENPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dS
RUdBVE9SIGlzIG5vdCBzZXQNCkNPTkZJR19BQ1BJX1RIRVJNQUw9eQ0KQ09O
RklHX0FDUElfQ1VTVE9NX0RTRFRfRklMRT0iIg0KIyBDT05GSUdfQUNQSV9D
VVNUT01fRFNEVCBpcyBub3Qgc2V0DQpDT05GSUdfQUNQSV9CTEFDS0xJU1Rf
WUVBUj0wDQojIENPTkZJR19BQ1BJX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJ
R19BQ1BJX1BDSV9TTE9UPXkNCiMgQ09ORklHX1g4Nl9QTV9USU1FUiBpcyBu
b3Qgc2V0DQojIENPTkZJR19BQ1BJX0NPTlRBSU5FUiBpcyBub3Qgc2V0DQoj
IENPTkZJR19BQ1BJX0hPVFBMVUdfTUVNT1JZIGlzIG5vdCBzZXQNCkNPTkZJ
R19BQ1BJX1NCUz15DQpDT05GSUdfQUNQSV9IRUQ9eQ0KQ09ORklHX0FDUElf
Q1VTVE9NX01FVEhPRD15DQpDT05GSUdfQUNQSV9CR1JUPXkNCkNPTkZJR19B
Q1BJX0FQRUk9eQ0KQ09ORklHX0FDUElfQVBFSV9HSEVTPXkNCkNPTkZJR19B
Q1BJX0FQRUlfUENJRUFFUj15DQpDT05GSUdfQUNQSV9BUEVJX0VJTko9bQ0K
IyBDT05GSUdfQUNQSV9BUEVJX0VSU1RfREVCVUcgaXMgbm90IHNldA0KIyBD
T05GSUdfU0ZJIGlzIG5vdCBzZXQNCg0KIw0KIyBDUFUgRnJlcXVlbmN5IHNj
YWxpbmcNCiMNCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQNCkNPTkZJ
R19DUFVfSURMRT15DQpDT05GSUdfQ1BVX0lETEVfTVVMVElQTEVfRFJJVkVS
Uz15DQpDT05GSUdfQ1BVX0lETEVfR09WX0xBRERFUj15DQpDT05GSUdfQ1BV
X0lETEVfR09WX01FTlU9eQ0KIyBDT05GSUdfQVJDSF9ORUVEU19DUFVfSURM
RV9DT1VQTEVEIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lOVEVMX0lETEUgaXMg
bm90IHNldA0KDQojDQojIE1lbW9yeSBwb3dlciBzYXZpbmdzDQojDQpDT05G
SUdfSTczMDBfSURMRV9JT0FUX0NIQU5ORUw9eQ0KQ09ORklHX0k3MzAwX0lE
TEU9bQ0KDQojDQojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikNCiMNCkNPTkZJ
R19QQ0k9eQ0KQ09ORklHX1BDSV9ESVJFQ1Q9eQ0KQ09ORklHX1BDSV9NTUNP
TkZJRz15DQpDT05GSUdfUENJX0RPTUFJTlM9eQ0KQ09ORklHX1BDSV9DTkIy
MExFX1FVSVJLPXkNCkNPTkZJR19QQ0lFUE9SVEJVUz15DQpDT05GSUdfUENJ
RUFFUj15DQpDT05GSUdfUENJRV9FQ1JDPXkNCkNPTkZJR19QQ0lFQUVSX0lO
SkVDVD15DQojIENPTkZJR19QQ0lFQVNQTSBpcyBub3Qgc2V0DQpDT05GSUdf
UENJRV9QTUU9eQ0KQ09ORklHX0FSQ0hfU1VQUE9SVFNfTVNJPXkNCiMgQ09O
RklHX1BDSV9NU0kgaXMgbm90IHNldA0KQ09ORklHX1BDSV9ERUJVRz15DQpD
T05GSUdfUENJX1JFQUxMT0NfRU5BQkxFX0FVVE89eQ0KIyBDT05GSUdfUENJ
X1NUVUIgaXMgbm90IHNldA0KIyBDT05GSUdfSFRfSVJRIGlzIG5vdCBzZXQN
CkNPTkZJR19QQ0lfQVRTPXkNCkNPTkZJR19QQ0lfSU9WPXkNCiMgQ09ORklH
X1BDSV9QUkkgaXMgbm90IHNldA0KQ09ORklHX1BDSV9QQVNJRD15DQpDT05G
SUdfUENJX0lPQVBJQz1tDQpDT05GSUdfUENJX0xBQkVMPXkNCiMgQ09ORklH
X0lTQV9ETUFfQVBJIGlzIG5vdCBzZXQNCkNPTkZJR19BTURfTkI9eQ0KQ09O
RklHX1BDQ0FSRD15DQojIENPTkZJR19QQ01DSUEgaXMgbm90IHNldA0KQ09O
RklHX0NBUkRCVVM9eQ0KDQojDQojIFBDLWNhcmQgYnJpZGdlcw0KIw0KQ09O
RklHX1lFTlRBPXkNCkNPTkZJR19ZRU5UQV9PMj15DQpDT05GSUdfWUVOVEFf
UklDT0g9eQ0KIyBDT05GSUdfWUVOVEFfVEkgaXMgbm90IHNldA0KQ09ORklH
X1lFTlRBX1RPU0hJQkE9eQ0KIyBDT05GSUdfSE9UUExVR19QQ0kgaXMgbm90
IHNldA0KIyBDT05GSUdfUkFQSURJTyBpcyBub3Qgc2V0DQoNCiMNCiMgRXhl
Y3V0YWJsZSBmaWxlIGZvcm1hdHMgLyBFbXVsYXRpb25zDQojDQpDT05GSUdf
QklORk1UX0VMRj15DQpDT05GSUdfQ09NUEFUX0JJTkZNVF9FTEY9eQ0KQ09O
RklHX0FSQ0hfQklORk1UX0VMRl9SQU5ET01JWkVfUElFPXkNCiMgQ09ORklH
X0JJTkZNVF9TQ1JJUFQgaXMgbm90IHNldA0KIyBDT05GSUdfSEFWRV9BT1VU
IGlzIG5vdCBzZXQNCkNPTkZJR19CSU5GTVRfTUlTQz1tDQpDT05GSUdfQ09S
RURVTVA9eQ0KQ09ORklHX0lBMzJfRU1VTEFUSU9OPXkNCkNPTkZJR19JQTMy
X0FPVVQ9eQ0KQ09ORklHX1g4Nl9YMzI9eQ0KQ09ORklHX0NPTVBBVD15DQpD
T05GSUdfQ09NUEFUX0ZPUl9VNjRfQUxJR05NRU5UPXkNCkNPTkZJR19LRVlT
X0NPTVBBVD15DQpDT05GSUdfSEFWRV9URVhUX1BPS0VfU01QPXkNCkNPTkZJ
R19YODZfREVWX0RNQV9PUFM9eQ0KQ09ORklHX05FVD15DQpDT05GSUdfTkVU
TElOS19NTUFQPXkNCkNPTkZJR19DT01QQVRfTkVUTElOS19NRVNTQUdFUz15
DQoNCiMNCiMgTmV0d29ya2luZyBvcHRpb25zDQojDQojIENPTkZJR19QQUNL
RVQgaXMgbm90IHNldA0KQ09ORklHX1VOSVg9eQ0KQ09ORklHX1VOSVhfRElB
Rz1tDQpDT05GSUdfWEZSTT15DQpDT05GSUdfWEZSTV9BTEdPPW0NCkNPTkZJ
R19YRlJNX1NVQl9QT0xJQ1k9eQ0KQ09ORklHX1hGUk1fTUlHUkFURT15DQpD
T05GSUdfTkVUX0tFWT1tDQpDT05GSUdfTkVUX0tFWV9NSUdSQVRFPXkNCiMg
Q09ORklHX0lORVQgaXMgbm90IHNldA0KIyBDT05GSUdfTkVUV09SS19TRUNN
QVJLIGlzIG5vdCBzZXQNCiMgQ09ORklHX05FVFdPUktfUEhZX1RJTUVTVEFN
UElORyBpcyBub3Qgc2V0DQojIENPTkZJR19ORVRGSUxURVIgaXMgbm90IHNl
dA0KQ09ORklHX0FUTT1tDQojIENPTkZJR19BVE1fTEFORSBpcyBub3Qgc2V0
DQpDT05GSUdfU1RQPW0NCkNPTkZJR19CUklER0U9bQ0KQ09ORklHX0hBVkVf
TkVUX0RTQT15DQpDT05GSUdfTkVUX0RTQT15DQpDT05GSUdfTkVUX0RTQV9U
QUdfRFNBPXkNCkNPTkZJR19ORVRfRFNBX1RBR19FRFNBPXkNCiMgQ09ORklH
X1ZMQU5fODAyMVEgaXMgbm90IHNldA0KQ09ORklHX0RFQ05FVD1tDQojIENP
TkZJR19ERUNORVRfUk9VVEVSIGlzIG5vdCBzZXQNCkNPTkZJR19MTEM9bQ0K
Q09ORklHX0xMQzI9bQ0KIyBDT05GSUdfSVBYIGlzIG5vdCBzZXQNCkNPTkZJ
R19BVEFMSz1tDQpDT05GSUdfREVWX0FQUExFVEFMSz1tDQpDT05GSUdfSVBE
RFA9bQ0KIyBDT05GSUdfSVBERFBfRU5DQVAgaXMgbm90IHNldA0KQ09ORklH
X1gyNT15DQojIENPTkZJR19MQVBCIGlzIG5vdCBzZXQNCkNPTkZJR19QSE9O
RVQ9eQ0KQ09ORklHX0lFRUU4MDIxNTQ9eQ0KIyBDT05GSUdfTUFDODAyMTU0
IGlzIG5vdCBzZXQNCiMgQ09ORklHX05FVF9TQ0hFRCBpcyBub3Qgc2V0DQoj
IENPTkZJR19EQ0IgaXMgbm90IHNldA0KQ09ORklHX0ROU19SRVNPTFZFUj15
DQpDT05GSUdfQkFUTUFOX0FEVj1tDQpDT05GSUdfQkFUTUFOX0FEVl9OQz15
DQpDT05GSUdfQkFUTUFOX0FEVl9ERUJVRz15DQojIENPTkZJR19PUEVOVlNX
SVRDSCBpcyBub3Qgc2V0DQojIENPTkZJR19WU09DS0VUUyBpcyBub3Qgc2V0
DQpDT05GSUdfTkVUTElOS19ESUFHPW0NCkNPTkZJR19ORVRQUklPX0NHUk9V
UD15DQpDT05GSUdfQlFMPXkNCkNPTkZJR19CUEZfSklUPXkNCg0KIw0KIyBO
ZXR3b3JrIHRlc3RpbmcNCiMNCkNPTkZJR19ORVRfUEtUR0VOPXkNCkNPTkZJ
R19IQU1SQURJTz15DQoNCiMNCiMgUGFja2V0IFJhZGlvIHByb3RvY29scw0K
Iw0KQ09ORklHX0FYMjU9eQ0KQ09ORklHX0FYMjVfREFNQV9TTEFWRT15DQoj
IENPTkZJR19ORVRST00gaXMgbm90IHNldA0KQ09ORklHX1JPU0U9eQ0KDQoj
DQojIEFYLjI1IG5ldHdvcmsgZGV2aWNlIGRyaXZlcnMNCiMNCkNPTkZJR19C
UFFFVEhFUj1tDQpDT05GSUdfQkFZQ09NX1NFUl9GRFg9eQ0KQ09ORklHX0JB
WUNPTV9TRVJfSERYPXkNCkNPTkZJR19ZQU09eQ0KIyBDT05GSUdfQ0FOIGlz
IG5vdCBzZXQNCkNPTkZJR19JUkRBPW0NCg0KIw0KIyBJckRBIHByb3RvY29s
cw0KIw0KQ09ORklHX0lSTEFOPW0NCiMgQ09ORklHX0lSREFfVUxUUkEgaXMg
bm90IHNldA0KDQojDQojIElyREEgb3B0aW9ucw0KIw0KQ09ORklHX0lSREFf
Q0FDSEVfTEFTVF9MU0FQPXkNCkNPTkZJR19JUkRBX0ZBU1RfUlI9eQ0KIyBD
T05GSUdfSVJEQV9ERUJVRyBpcyBub3Qgc2V0DQoNCiMNCiMgSW5mcmFyZWQt
cG9ydCBkZXZpY2UgZHJpdmVycw0KIw0KDQojDQojIFNJUiBkZXZpY2UgZHJp
dmVycw0KIw0KDQojDQojIERvbmdsZSBzdXBwb3J0DQojDQpDT05GSUdfS0lO
R1NVTl9ET05HTEU9bQ0KQ09ORklHX0tTREFaWkxFX0RPTkdMRT1tDQpDT05G
SUdfS1M5NTlfRE9OR0xFPW0NCg0KIw0KIyBGSVIgZGV2aWNlIGRyaXZlcnMN
CiMNCkNPTkZJR19VU0JfSVJEQT1tDQpDT05GSUdfU0lHTUFURUxfRklSPW0N
CkNPTkZJR19WTFNJX0ZJUj1tDQpDT05GSUdfTUNTX0ZJUj1tDQpDT05GSUdf
QlQ9eQ0KQ09ORklHX0JUX1JGQ09NTT15DQojIENPTkZJR19CVF9CTkVQIGlz
IG5vdCBzZXQNCkNPTkZJR19CVF9ISURQPW0NCg0KIw0KIyBCbHVldG9vdGgg
ZGV2aWNlIGRyaXZlcnMNCiMNCkNPTkZJR19CVF9IQ0lCVFVTQj1tDQpDT05G
SUdfQlRfSENJQkNNMjAzWD1tDQpDT05GSUdfQlRfSENJQlBBMTBYPW0NCkNP
TkZJR19CVF9IQ0lCRlVTQj1tDQpDT05GSUdfQlRfSENJVkhDST15DQpDT05G
SUdfQlRfTVJWTD1tDQojIENPTkZJR19CVF9BVEgzSyBpcyBub3Qgc2V0DQpD
T05GSUdfV0lSRUxFU1M9eQ0KQ09ORklHX1dFWFRfQ09SRT15DQpDT05GSUdf
V0VYVF9QUk9DPXkNCkNPTkZJR19DRkc4MDIxMT15DQojIENPTkZJR19OTDgw
MjExX1RFU1RNT0RFIGlzIG5vdCBzZXQNCiMgQ09ORklHX0NGRzgwMjExX0RF
VkVMT1BFUl9XQVJOSU5HUyBpcyBub3Qgc2V0DQpDT05GSUdfQ0ZHODAyMTFf
UkVHX0RFQlVHPXkNCiMgQ09ORklHX0NGRzgwMjExX0NFUlRJRklDQVRJT05f
T05VUyBpcyBub3Qgc2V0DQojIENPTkZJR19DRkc4MDIxMV9ERUZBVUxUX1BT
IGlzIG5vdCBzZXQNCkNPTkZJR19DRkc4MDIxMV9ERUJVR0ZTPXkNCiMgQ09O
RklHX0NGRzgwMjExX0lOVEVSTkFMX1JFR0RCIGlzIG5vdCBzZXQNCkNPTkZJ
R19DRkc4MDIxMV9XRVhUPXkNCiMgQ09ORklHX0xJQjgwMjExIGlzIG5vdCBz
ZXQNCkNPTkZJR19NQUM4MDIxMT15DQpDT05GSUdfTUFDODAyMTFfSEFTX1JD
PXkNCkNPTkZJR19NQUM4MDIxMV9SQ19QSUQ9eQ0KIyBDT05GSUdfTUFDODAy
MTFfUkNfTUlOU1RSRUwgaXMgbm90IHNldA0KQ09ORklHX01BQzgwMjExX1JD
X0RFRkFVTFRfUElEPXkNCkNPTkZJR19NQUM4MDIxMV9SQ19ERUZBVUxUPSJw
aWQiDQpDT05GSUdfTUFDODAyMTFfTUVTSD15DQpDT05GSUdfTUFDODAyMTFf
TEVEUz15DQojIENPTkZJR19NQUM4MDIxMV9ERUJVR0ZTIGlzIG5vdCBzZXQN
CkNPTkZJR19NQUM4MDIxMV9NRVNTQUdFX1RSQUNJTkc9eQ0KQ09ORklHX01B
QzgwMjExX0RFQlVHX01FTlU9eQ0KQ09ORklHX01BQzgwMjExX05PSU5MSU5F
PXkNCiMgQ09ORklHX01BQzgwMjExX1ZFUkJPU0VfREVCVUcgaXMgbm90IHNl
dA0KIyBDT05GSUdfTUFDODAyMTFfTUxNRV9ERUJVRyBpcyBub3Qgc2V0DQoj
IENPTkZJR19NQUM4MDIxMV9TVEFfREVCVUcgaXMgbm90IHNldA0KIyBDT05G
SUdfTUFDODAyMTFfSFRfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX01BQzgw
MjExX0lCU1NfREVCVUc9eQ0KQ09ORklHX01BQzgwMjExX1BTX0RFQlVHPXkN
CiMgQ09ORklHX01BQzgwMjExX01QTF9ERUJVRyBpcyBub3Qgc2V0DQojIENP
TkZJR19NQUM4MDIxMV9NUEFUSF9ERUJVRyBpcyBub3Qgc2V0DQpDT05GSUdf
TUFDODAyMTFfTUhXTVBfREVCVUc9eQ0KIyBDT05GSUdfTUFDODAyMTFfTUVT
SF9TWU5DX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19NQUM4MDIxMV9NRVNI
X1BTX0RFQlVHPXkNCiMgQ09ORklHX01BQzgwMjExX1RETFNfREVCVUcgaXMg
bm90IHNldA0KQ09ORklHX1dJTUFYPXkNCkNPTkZJR19XSU1BWF9ERUJVR19M
RVZFTD04DQpDT05GSUdfUkZLSUxMPXkNCkNPTkZJR19SRktJTExfTEVEUz15
DQpDT05GSUdfTkVUXzlQPXkNCkNPTkZJR19ORVRfOVBfVklSVElPPW0NCiMg
Q09ORklHX05FVF85UF9ERUJVRyBpcyBub3Qgc2V0DQojIENPTkZJR19DQUlG
IGlzIG5vdCBzZXQNCkNPTkZJR19ORkM9eQ0KIyBDT05GSUdfTkZDX05DSSBp
cyBub3Qgc2V0DQpDT05GSUdfTkZDX0hDST1tDQpDT05GSUdfTkZDX1NIRExD
PXkNCg0KIw0KIyBOZWFyIEZpZWxkIENvbW11bmljYXRpb24gKE5GQykgZGV2
aWNlcw0KIw0KQ09ORklHX05GQ19QTjUzMz1tDQojIENPTkZJR19ORkNfUE41
NDQgaXMgbm90IHNldA0KIyBDT05GSUdfTkZDX01JQ1JPUkVBRCBpcyBub3Qg
c2V0DQpDT05GSUdfSEFWRV9CUEZfSklUPXkNCg0KIw0KIyBEZXZpY2UgRHJp
dmVycw0KIw0KDQojDQojIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMNCiMNCkNP
TkZJR19VRVZFTlRfSEVMUEVSX1BBVEg9IiINCkNPTkZJR19ERVZUTVBGUz15
DQojIENPTkZJR19ERVZUTVBGU19NT1VOVCBpcyBub3Qgc2V0DQojIENPTkZJ
R19TVEFOREFMT05FIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BSRVZFTlRfRklS
TVdBUkVfQlVJTEQgaXMgbm90IHNldA0KQ09ORklHX0ZXX0xPQURFUj15DQpD
T05GSUdfRklSTVdBUkVfSU5fS0VSTkVMPXkNCkNPTkZJR19FWFRSQV9GSVJN
V0FSRT0iIg0KQ09ORklHX0ZXX0xPQURFUl9VU0VSX0hFTFBFUj15DQpDT05G
SUdfREVCVUdfRFJJVkVSPXkNCkNPTkZJR19ERUJVR19ERVZSRVM9eQ0KIyBD
T05GSUdfU1lTX0hZUEVSVklTT1IgaXMgbm90IHNldA0KIyBDT05GSUdfR0VO
RVJJQ19DUFVfREVWSUNFUyBpcyBub3Qgc2V0DQpDT05GSUdfUkVHTUFQPXkN
CkNPTkZJR19SRUdNQVBfSTJDPXkNCkNPTkZJR19SRUdNQVBfTU1JTz15DQpD
T05GSUdfUkVHTUFQX0lSUT15DQpDT05GSUdfRE1BX1NIQVJFRF9CVUZGRVI9
eQ0KDQojDQojIEJ1cyBkZXZpY2VzDQojDQojIENPTkZJR19DT05ORUNUT1Ig
aXMgbm90IHNldA0KQ09ORklHX01URD15DQpDT05GSUdfTVREX1RFU1RTPW0N
CiMgQ09ORklHX01URF9SRURCT09UX1BBUlRTIGlzIG5vdCBzZXQNCkNPTkZJ
R19NVERfQ01ETElORV9QQVJUUz1tDQpDT05GSUdfTVREX0FSN19QQVJUUz1t
DQoNCiMNCiMgVXNlciBNb2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXllcnMN
CiMNCkNPTkZJR19NVERfQkxLREVWUz15DQojIENPTkZJR19NVERfQkxPQ0sg
aXMgbm90IHNldA0KQ09ORklHX01URF9CTE9DS19STz1tDQpDT05GSUdfRlRM
PW0NCkNPTkZJR19ORlRMPW0NCiMgQ09ORklHX05GVExfUlcgaXMgbm90IHNl
dA0KIyBDT05GSUdfSU5GVEwgaXMgbm90IHNldA0KQ09ORklHX1JGRF9GVEw9
bQ0KQ09ORklHX1NTRkRDPW0NCkNPTkZJR19TTV9GVEw9eQ0KIyBDT05GSUdf
TVREX09PUFMgaXMgbm90IHNldA0KDQojDQojIFJBTS9ST00vRmxhc2ggY2hp
cCBkcml2ZXJzDQojDQpDT05GSUdfTVREX0NGST15DQpDT05GSUdfTVREX0pF
REVDUFJPQkU9eQ0KQ09ORklHX01URF9HRU5fUFJPQkU9eQ0KIyBDT05GSUdf
TVREX0NGSV9BRFZfT1BUSU9OUyBpcyBub3Qgc2V0DQpDT05GSUdfTVREX01B
UF9CQU5LX1dJRFRIXzE9eQ0KQ09ORklHX01URF9NQVBfQkFOS19XSURUSF8y
PXkNCkNPTkZJR19NVERfTUFQX0JBTktfV0lEVEhfND15DQojIENPTkZJR19N
VERfTUFQX0JBTktfV0lEVEhfOCBpcyBub3Qgc2V0DQojIENPTkZJR19NVERf
TUFQX0JBTktfV0lEVEhfMTYgaXMgbm90IHNldA0KIyBDT05GSUdfTVREX01B
UF9CQU5LX1dJRFRIXzMyIGlzIG5vdCBzZXQNCkNPTkZJR19NVERfQ0ZJX0kx
PXkNCkNPTkZJR19NVERfQ0ZJX0kyPXkNCiMgQ09ORklHX01URF9DRklfSTQg
aXMgbm90IHNldA0KIyBDT05GSUdfTVREX0NGSV9JOCBpcyBub3Qgc2V0DQpD
T05GSUdfTVREX0NGSV9JTlRFTEVYVD1tDQpDT05GSUdfTVREX0NGSV9BTURT
VEQ9eQ0KQ09ORklHX01URF9DRklfU1RBQT15DQpDT05GSUdfTVREX0NGSV9V
VElMPXkNCkNPTkZJR19NVERfUkFNPXkNCiMgQ09ORklHX01URF9ST00gaXMg
bm90IHNldA0KQ09ORklHX01URF9BQlNFTlQ9eQ0KDQojDQojIE1hcHBpbmcg
ZHJpdmVycyBmb3IgY2hpcCBhY2Nlc3MNCiMNCkNPTkZJR19NVERfQ09NUExF
WF9NQVBQSU5HUz15DQpDT05GSUdfTVREX1BIWVNNQVA9eQ0KIyBDT05GSUdf
TVREX1BIWVNNQVBfQ09NUEFUIGlzIG5vdCBzZXQNCiMgQ09ORklHX01URF9T
QzUyMENEUCBpcyBub3Qgc2V0DQpDT05GSUdfTVREX05FVFNDNTIwPXkNCkNP
TkZJR19NVERfVFM1NTAwPW0NCkNPTkZJR19NVERfU0JDX0dYWD1tDQpDT05G
SUdfTVREX0FNRDc2WFJPTT1tDQpDT05GSUdfTVREX0lDSFhST009bQ0KIyBD
T05GSUdfTVREX0VTQjJST00gaXMgbm90IHNldA0KQ09ORklHX01URF9DSzgw
NFhST009bQ0KQ09ORklHX01URF9TQ0IyX0ZMQVNIPXkNCkNPTkZJR19NVERf
TkVUdGVsPW0NCiMgQ09ORklHX01URF9MNDQwR1ggaXMgbm90IHNldA0KQ09O
RklHX01URF9QQ0k9eQ0KQ09ORklHX01URF9HUElPX0FERFI9eQ0KIyBDT05G
SUdfTVREX0lOVEVMX1ZSX05PUiBpcyBub3Qgc2V0DQpDT05GSUdfTVREX1BM
QVRSQU09eQ0KIyBDT05GSUdfTVREX0xBVENIX0FERFIgaXMgbm90IHNldA0K
DQojDQojIFNlbGYtY29udGFpbmVkIE1URCBkZXZpY2UgZHJpdmVycw0KIw0K
Q09ORklHX01URF9QTUM1NTE9eQ0KQ09ORklHX01URF9QTUM1NTFfQlVHRklY
PXkNCkNPTkZJR19NVERfUE1DNTUxX0RFQlVHPXkNCkNPTkZJR19NVERfU0xS
QU09eQ0KIyBDT05GSUdfTVREX1BIUkFNIGlzIG5vdCBzZXQNCkNPTkZJR19N
VERfTVREUkFNPW0NCkNPTkZJR19NVERSQU1fVE9UQUxfU0laRT00MDk2DQpD
T05GSUdfTVREUkFNX0VSQVNFX1NJWkU9MTI4DQpDT05GSUdfTVREX0JMT0NL
Mk1URD1tDQoNCiMNCiMgRGlzay1Pbi1DaGlwIERldmljZSBEcml2ZXJzDQoj
DQojIENPTkZJR19NVERfRE9DRzMgaXMgbm90IHNldA0KQ09ORklHX01URF9O
QU5EX0VDQz15DQpDT05GSUdfTVREX05BTkRfRUNDX1NNQz15DQojIENPTkZJ
R19NVERfTkFORCBpcyBub3Qgc2V0DQpDT05GSUdfTVREX09ORU5BTkQ9bQ0K
IyBDT05GSUdfTVREX09ORU5BTkRfVkVSSUZZX1dSSVRFIGlzIG5vdCBzZXQN
CiMgQ09ORklHX01URF9PTkVOQU5EX0dFTkVSSUMgaXMgbm90IHNldA0KQ09O
RklHX01URF9PTkVOQU5EX09UUD15DQojIENPTkZJR19NVERfT05FTkFORF8y
WF9QUk9HUkFNIGlzIG5vdCBzZXQNCg0KIw0KIyBMUEREUiBmbGFzaCBtZW1v
cnkgZHJpdmVycw0KIw0KIyBDT05GSUdfTVREX0xQRERSIGlzIG5vdCBzZXQN
CkNPTkZJR19NVERfVUJJPXkNCkNPTkZJR19NVERfVUJJX1dMX1RIUkVTSE9M
RD00MDk2DQpDT05GSUdfTVREX1VCSV9CRUJfTElNSVQ9MjANCiMgQ09ORklH
X01URF9VQklfRkFTVE1BUCBpcyBub3Qgc2V0DQpDT05GSUdfTVREX1VCSV9H
TFVFQkk9bQ0KIyBDT05GSUdfUEFSUE9SVCBpcyBub3Qgc2V0DQpDT05GSUdf
UE5QPXkNCkNPTkZJR19QTlBfREVCVUdfTUVTU0FHRVM9eQ0KDQojDQojIFBy
b3RvY29scw0KIw0KQ09ORklHX1BOUEFDUEk9eQ0KIyBDT05GSUdfQkxLX0RF
ViBpcyBub3Qgc2V0DQoNCiMNCiMgTWlzYyBkZXZpY2VzDQojDQpDT05GSUdf
U0VOU09SU19MSVMzTFYwMkQ9bQ0KIyBDT05GSUdfQUQ1MjVYX0RQT1QgaXMg
bm90IHNldA0KQ09ORklHX0RVTU1ZX0lSUT1tDQojIENPTkZJR19JQk1fQVNN
IGlzIG5vdCBzZXQNCkNPTkZJR19QSEFOVE9NPW0NCkNPTkZJR19TR0lfSU9D
ND1tDQpDT05GSUdfVElGTV9DT1JFPW0NCkNPTkZJR19USUZNXzdYWDE9bQ0K
Q09ORklHX0lDUzkzMlM0MDE9eQ0KQ09ORklHX0FUTUVMX1NTQz15DQpDT05G
SUdfRU5DTE9TVVJFX1NFUlZJQ0VTPXkNCiMgQ09ORklHX0NTNTUzNV9NRkdQ
VCBpcyBub3Qgc2V0DQpDT05GSUdfSFBfSUxPPXkNCkNPTkZJR19BUERTOTgw
MkFMUz1tDQpDT05GSUdfSVNMMjkwMDM9eQ0KIyBDT05GSUdfSVNMMjkwMjAg
aXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfVFNMMjU1MD15DQojIENPTkZJ
R19TRU5TT1JTX0JIMTc4MCBpcyBub3Qgc2V0DQpDT05GSUdfU0VOU09SU19C
SDE3NzA9eQ0KIyBDT05GSUdfU0VOU09SU19BUERTOTkwWCBpcyBub3Qgc2V0
DQojIENPTkZJR19ITUM2MzUyIGlzIG5vdCBzZXQNCkNPTkZJR19EUzE2ODI9
bQ0KIyBDT05GSUdfQk1QMDg1X0kyQyBpcyBub3Qgc2V0DQpDT05GSUdfUENI
X1BIVUI9bQ0KIyBDT05GSUdfVVNCX1NXSVRDSF9GU0E5NDgwIGlzIG5vdCBz
ZXQNCkNPTkZJR19TUkFNPXkNCkNPTkZJR19DMlBPUlQ9bQ0KQ09ORklHX0My
UE9SVF9EVVJBTUFSXzIxNTA9bQ0KDQojDQojIEVFUFJPTSBzdXBwb3J0DQoj
DQojIENPTkZJR19FRVBST01fQVQyNCBpcyBub3Qgc2V0DQpDT05GSUdfRUVQ
Uk9NX0xFR0FDWT15DQojIENPTkZJR19FRVBST01fTUFYNjg3NSBpcyBub3Qg
c2V0DQpDT05GSUdfRUVQUk9NXzkzQ1g2PXkNCkNPTkZJR19DQjcxMF9DT1JF
PXkNCkNPTkZJR19DQjcxMF9ERUJVRz15DQpDT05GSUdfQ0I3MTBfREVCVUdf
QVNTVU1QVElPTlM9eQ0KDQojDQojIFRleGFzIEluc3RydW1lbnRzIHNoYXJl
ZCB0cmFuc3BvcnQgbGluZSBkaXNjaXBsaW5lDQojDQojIENPTkZJR19TRU5T
T1JTX0xJUzNfSTJDIGlzIG5vdCBzZXQNCg0KIw0KIyBBbHRlcmEgRlBHQSBm
aXJtd2FyZSBkb3dubG9hZCBtb2R1bGUNCiMNCkNPTkZJR19BTFRFUkFfU1RB
UEw9bQ0KIyBDT05GSUdfVk1XQVJFX1ZNQ0kgaXMgbm90IHNldA0KQ09ORklH
X0hBVkVfSURFPXkNCiMgQ09ORklHX0lERSBpcyBub3Qgc2V0DQoNCiMNCiMg
U0NTSSBkZXZpY2Ugc3VwcG9ydA0KIw0KQ09ORklHX1NDU0lfTU9EPXkNCkNP
TkZJR19SQUlEX0FUVFJTPW0NCkNPTkZJR19TQ1NJPXkNCkNPTkZJR19TQ1NJ
X0RNQT15DQpDT05GSUdfU0NTSV9UR1Q9eQ0KQ09ORklHX1NDU0lfTkVUTElO
Sz15DQpDT05GSUdfU0NTSV9QUk9DX0ZTPXkNCg0KIw0KIyBTQ1NJIHN1cHBv
cnQgdHlwZSAoZGlzaywgdGFwZSwgQ0QtUk9NKQ0KIw0KQ09ORklHX0JMS19E
RVZfU0Q9eQ0KIyBDT05GSUdfQ0hSX0RFVl9TVCBpcyBub3Qgc2V0DQojIENP
TkZJR19DSFJfREVWX09TU1QgaXMgbm90IHNldA0KQ09ORklHX0JMS19ERVZf
U1I9bQ0KIyBDT05GSUdfQkxLX0RFVl9TUl9WRU5ET1IgaXMgbm90IHNldA0K
IyBDT05GSUdfQ0hSX0RFVl9TRyBpcyBub3Qgc2V0DQojIENPTkZJR19DSFJf
REVWX1NDSCBpcyBub3Qgc2V0DQpDT05GSUdfU0NTSV9FTkNMT1NVUkU9eQ0K
IyBDT05GSUdfU0NTSV9NVUxUSV9MVU4gaXMgbm90IHNldA0KIyBDT05GSUdf
U0NTSV9DT05TVEFOVFMgaXMgbm90IHNldA0KIyBDT05GSUdfU0NTSV9MT0dH
SU5HIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfU0NBTl9BU1lOQyBpcyBu
b3Qgc2V0DQoNCiMNCiMgU0NTSSBUcmFuc3BvcnRzDQojDQpDT05GSUdfU0NT
SV9TUElfQVRUUlM9eQ0KQ09ORklHX1NDU0lfRkNfQVRUUlM9eQ0KQ09ORklH
X1NDU0lfRkNfVEdUX0FUVFJTPXkNCkNPTkZJR19TQ1NJX0lTQ1NJX0FUVFJT
PXkNCkNPTkZJR19TQ1NJX1NBU19BVFRSUz1tDQpDT05GSUdfU0NTSV9TQVNf
TElCU0FTPW0NCkNPTkZJR19TQ1NJX1NBU19BVEE9eQ0KQ09ORklHX1NDU0lf
U0FTX0hPU1RfU01QPXkNCkNPTkZJR19TQ1NJX1NSUF9BVFRSUz1tDQojIENP
TkZJR19TQ1NJX1NSUF9UR1RfQVRUUlMgaXMgbm90IHNldA0KQ09ORklHX1ND
U0lfTE9XTEVWRUw9eQ0KQ09ORklHX0lTQ1NJX0JPT1RfU1lTRlM9eQ0KQ09O
RklHX1NDU0lfQk5YMl9JU0NTST15DQpDT05GSUdfU0NTSV9CTlgyWF9GQ09F
PW0NCiMgQ09ORklHX0JFMklTQ1NJIGlzIG5vdCBzZXQNCiMgQ09ORklHX0JM
S19ERVZfM1dfWFhYWF9SQUlEIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lf
SFBTQSBpcyBub3Qgc2V0DQpDT05GSUdfU0NTSV8zV185WFhYPW0NCkNPTkZJ
R19TQ1NJXzNXX1NBUz15DQpDT05GSUdfU0NTSV9BQ0FSRD1tDQpDT05GSUdf
U0NTSV9BQUNSQUlEPW0NCkNPTkZJR19TQ1NJX0FJQzdYWFg9eQ0KQ09ORklH
X0FJQzdYWFhfQ01EU19QRVJfREVWSUNFPTMyDQpDT05GSUdfQUlDN1hYWF9S
RVNFVF9ERUxBWV9NUz01MDAwDQpDT05GSUdfQUlDN1hYWF9CVUlMRF9GSVJN
V0FSRT15DQojIENPTkZJR19BSUM3WFhYX0RFQlVHX0VOQUJMRSBpcyBub3Qg
c2V0DQpDT05GSUdfQUlDN1hYWF9ERUJVR19NQVNLPTANCiMgQ09ORklHX0FJ
QzdYWFhfUkVHX1BSRVRUWV9QUklOVCBpcyBub3Qgc2V0DQojIENPTkZJR19T
Q1NJX0FJQzdYWFhfT0xEIGlzIG5vdCBzZXQNCkNPTkZJR19TQ1NJX0FJQzc5
WFg9eQ0KQ09ORklHX0FJQzc5WFhfQ01EU19QRVJfREVWSUNFPTMyDQpDT05G
SUdfQUlDNzlYWF9SRVNFVF9ERUxBWV9NUz01MDAwDQpDT05GSUdfQUlDNzlY
WF9CVUlMRF9GSVJNV0FSRT15DQpDT05GSUdfQUlDNzlYWF9ERUJVR19FTkFC
TEU9eQ0KQ09ORklHX0FJQzc5WFhfREVCVUdfTUFTSz0wDQojIENPTkZJR19B
SUM3OVhYX1JFR19QUkVUVFlfUFJJTlQgaXMgbm90IHNldA0KIyBDT05GSUdf
U0NTSV9BSUM5NFhYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDU0lfTVZTQVMg
aXMgbm90IHNldA0KQ09ORklHX1NDU0lfTVZVTUk9bQ0KQ09ORklHX1NDU0lf
RFBUX0kyTz1tDQpDT05GSUdfU0NTSV9BRFZBTlNZUz15DQpDT05GSUdfU0NT
SV9BUkNNU1I9bQ0KIyBDT05GSUdfTUVHQVJBSURfTkVXR0VOIGlzIG5vdCBz
ZXQNCkNPTkZJR19NRUdBUkFJRF9MRUdBQ1k9eQ0KQ09ORklHX01FR0FSQUlE
X1NBUz15DQpDT05GSUdfU0NTSV9NUFQyU0FTPW0NCkNPTkZJR19TQ1NJX01Q
VDJTQVNfTUFYX1NHRT0xMjgNCkNPTkZJR19TQ1NJX01QVDJTQVNfTE9HR0lO
Rz15DQojIENPTkZJR19TQ1NJX01QVDNTQVMgaXMgbm90IHNldA0KQ09ORklH
X1NDU0lfVUZTSENEPXkNCkNPTkZJR19TQ1NJX1VGU0hDRF9QQ0k9eQ0KQ09O
RklHX1NDU0lfSFBUSU9QPW0NCkNPTkZJR19WTVdBUkVfUFZTQ1NJPXkNCkNP
TkZJR19MSUJGQz1tDQpDT05GSUdfTElCRkNPRT1tDQpDT05GSUdfRkNPRT1t
DQpDT05GSUdfRkNPRV9GTklDPW0NCkNPTkZJR19TQ1NJX0RNWDMxOTFEPXkN
CiMgQ09ORklHX1NDU0lfRlVUVVJFX0RPTUFJTiBpcyBub3Qgc2V0DQpDT05G
SUdfU0NTSV9JU0NJPW0NCkNPTkZJR19TQ1NJX0lQUz1tDQojIENPTkZJR19T
Q1NJX0lOSVRJTyBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX0lOSUExMDAg
aXMgbm90IHNldA0KIyBDT05GSUdfU0NTSV9TVEVYIGlzIG5vdCBzZXQNCkNP
TkZJR19TQ1NJX1NZTTUzQzhYWF8yPXkNCkNPTkZJR19TQ1NJX1NZTTUzQzhY
WF9ETUFfQUREUkVTU0lOR19NT0RFPTENCkNPTkZJR19TQ1NJX1NZTTUzQzhY
WF9ERUZBVUxUX1RBR1M9MTYNCkNPTkZJR19TQ1NJX1NZTTUzQzhYWF9NQVhf
VEFHUz02NA0KIyBDT05GSUdfU0NTSV9TWU01M0M4WFhfTU1JTyBpcyBub3Qg
c2V0DQpDT05GSUdfU0NTSV9JUFI9eQ0KIyBDT05GSUdfU0NTSV9JUFJfVFJB
Q0UgaXMgbm90IHNldA0KQ09ORklHX1NDU0lfSVBSX0RVTVA9eQ0KQ09ORklH
X1NDU0lfUUxPR0lDXzEyODA9bQ0KIyBDT05GSUdfU0NTSV9RTEFfRkMgaXMg
bm90IHNldA0KQ09ORklHX1NDU0lfUUxBX0lTQ1NJPXkNCkNPTkZJR19TQ1NJ
X0xQRkM9eQ0KIyBDT05GSUdfU0NTSV9MUEZDX0RFQlVHX0ZTIGlzIG5vdCBz
ZXQNCkNPTkZJR19TQ1NJX0RDMzk1eD15DQojIENPTkZJR19TQ1NJX0RDMzkw
VCBpcyBub3Qgc2V0DQpDT05GSUdfU0NTSV9ERUJVRz15DQpDT05GSUdfU0NT
SV9QTUNSQUlEPXkNCkNPTkZJR19TQ1NJX1BNODAwMT1tDQpDT05GSUdfU0NT
SV9TUlA9eQ0KQ09ORklHX1NDU0lfQkZBX0ZDPW0NCkNPTkZJR19TQ1NJX1ZJ
UlRJTz15DQpDT05GSUdfU0NTSV9DSEVMU0lPX0ZDT0U9bQ0KQ09ORklHX1ND
U0lfREg9eQ0KQ09ORklHX1NDU0lfREhfUkRBQz1tDQojIENPTkZJR19TQ1NJ
X0RIX0hQX1NXIGlzIG5vdCBzZXQNCkNPTkZJR19TQ1NJX0RIX0VNQz15DQoj
IENPTkZJR19TQ1NJX0RIX0FMVUEgaXMgbm90IHNldA0KQ09ORklHX1NDU0lf
T1NEX0lOSVRJQVRPUj15DQpDT05GSUdfU0NTSV9PU0RfVUxEPW0NCkNPTkZJ
R19TQ1NJX09TRF9EUFJJTlRfU0VOU0U9MQ0KIyBDT05GSUdfU0NTSV9PU0Rf
REVCVUcgaXMgbm90IHNldA0KQ09ORklHX0FUQT15DQojIENPTkZJR19BVEFf
Tk9OU1RBTkRBUkQgaXMgbm90IHNldA0KQ09ORklHX0FUQV9WRVJCT1NFX0VS
Uk9SPXkNCiMgQ09ORklHX0FUQV9BQ1BJIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1NBVEFfUE1QIGlzIG5vdCBzZXQNCg0KIw0KIyBDb250cm9sbGVycyB3aXRo
IG5vbi1TRkYgbmF0aXZlIGludGVyZmFjZQ0KIw0KIyBDT05GSUdfU0FUQV9B
SENJIGlzIG5vdCBzZXQNCkNPTkZJR19TQVRBX0FIQ0lfUExBVEZPUk09bQ0K
IyBDT05GSUdfU0FUQV9JTklDMTYyWCBpcyBub3Qgc2V0DQpDT05GSUdfU0FU
QV9BQ0FSRF9BSENJPW0NCiMgQ09ORklHX1NBVEFfU0lMMjQgaXMgbm90IHNl
dA0KIyBDT05GSUdfQVRBX1NGRiBpcyBub3Qgc2V0DQojIENPTkZJR19NRCBp
cyBub3Qgc2V0DQojIENPTkZJR19UQVJHRVRfQ09SRSBpcyBub3Qgc2V0DQpD
T05GSUdfRlVTSU9OPXkNCkNPTkZJR19GVVNJT05fU1BJPXkNCiMgQ09ORklH
X0ZVU0lPTl9GQyBpcyBub3Qgc2V0DQpDT05GSUdfRlVTSU9OX1NBUz1tDQpD
T05GSUdfRlVTSU9OX01BWF9TR0U9MTI4DQojIENPTkZJR19GVVNJT05fQ1RM
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZVU0lPTl9MT0dHSU5HIGlzIG5vdCBz
ZXQNCg0KIw0KIyBJRUVFIDEzOTQgKEZpcmVXaXJlKSBzdXBwb3J0DQojDQpD
T05GSUdfRklSRVdJUkU9eQ0KQ09ORklHX0ZJUkVXSVJFX09IQ0k9bQ0KIyBD
T05GSUdfRklSRVdJUkVfU0JQMiBpcyBub3Qgc2V0DQpDT05GSUdfRklSRVdJ
UkVfTk9TWT15DQojIENPTkZJR19JMk8gaXMgbm90IHNldA0KIyBDT05GSUdf
TUFDSU5UT1NIX0RSSVZFUlMgaXMgbm90IHNldA0KQ09ORklHX05FVERFVklD
RVM9eQ0KQ09ORklHX05FVF9DT1JFPXkNCkNPTkZJR19EVU1NWT15DQojIENP
TkZJR19FUVVBTElaRVIgaXMgbm90IHNldA0KIyBDT05GSUdfTkVUX0ZDIGlz
IG5vdCBzZXQNCkNPTkZJR19NSUk9eQ0KQ09ORklHX05FVF9URUFNPXkNCkNP
TkZJR19ORVRfVEVBTV9NT0RFX0JST0FEQ0FTVD15DQojIENPTkZJR19ORVRf
VEVBTV9NT0RFX1JPVU5EUk9CSU4gaXMgbm90IHNldA0KQ09ORklHX05FVF9U
RUFNX01PREVfUkFORE9NPW0NCkNPTkZJR19ORVRfVEVBTV9NT0RFX0FDVElW
RUJBQ0tVUD1tDQpDT05GSUdfTkVUX1RFQU1fTU9ERV9MT0FEQkFMQU5DRT1t
DQpDT05GSUdfTUFDVkxBTj15DQpDT05GSUdfTUFDVlRBUD1tDQpDT05GSUdf
TkVUQ09OU09MRT15DQpDT05GSUdfTkVUUE9MTD15DQpDT05GSUdfTkVUUE9M
TF9UUkFQPXkNCkNPTkZJR19ORVRfUE9MTF9DT05UUk9MTEVSPXkNCiMgQ09O
RklHX1RVTiBpcyBub3Qgc2V0DQpDT05GSUdfVkVUSD1tDQojIENPTkZJR19W
SVJUSU9fTkVUIGlzIG5vdCBzZXQNCiMgQ09ORklHX0FSQ05FVCBpcyBub3Qg
c2V0DQpDT05GSUdfQVRNX0RSSVZFUlM9eQ0KQ09ORklHX0FUTV9EVU1NWT1t
DQpDT05GSUdfQVRNX0xBTkFJPW0NCkNPTkZJR19BVE1fRU5JPW0NCiMgQ09O
RklHX0FUTV9FTklfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0FUTV9FTklf
VFVORV9CVVJTVD15DQojIENPTkZJR19BVE1fRU5JX0JVUlNUX1RYXzE2VyBp
cyBub3Qgc2V0DQpDT05GSUdfQVRNX0VOSV9CVVJTVF9UWF84Vz15DQojIENP
TkZJR19BVE1fRU5JX0JVUlNUX1RYXzRXIGlzIG5vdCBzZXQNCiMgQ09ORklH
X0FUTV9FTklfQlVSU1RfVFhfMlcgaXMgbm90IHNldA0KQ09ORklHX0FUTV9F
TklfQlVSU1RfUlhfMTZXPXkNCkNPTkZJR19BVE1fRU5JX0JVUlNUX1JYXzhX
PXkNCkNPTkZJR19BVE1fRU5JX0JVUlNUX1JYXzRXPXkNCiMgQ09ORklHX0FU
TV9FTklfQlVSU1RfUlhfMlcgaXMgbm90IHNldA0KIyBDT05GSUdfQVRNX0ZJ
UkVTVFJFQU0gaXMgbm90IHNldA0KQ09ORklHX0FUTV9aQVRNPW0NCkNPTkZJ
R19BVE1fWkFUTV9ERUJVRz15DQpDT05GSUdfQVRNX05JQ1NUQVI9bQ0KQ09O
RklHX0FUTV9OSUNTVEFSX1VTRV9TVU5JPXkNCkNPTkZJR19BVE1fTklDU1RB
Ul9VU0VfSURUNzcxMDU9eQ0KQ09ORklHX0FUTV9JRFQ3NzI1Mj1tDQojIENP
TkZJR19BVE1fSURUNzcyNTJfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0FU
TV9JRFQ3NzI1Ml9SQ1ZfQUxMPXkNCkNPTkZJR19BVE1fSURUNzcyNTJfVVNF
X1NVTkk9eQ0KIyBDT05GSUdfQVRNX0FNQkFTU0FET1IgaXMgbm90IHNldA0K
Q09ORklHX0FUTV9IT1JJWk9OPW0NCkNPTkZJR19BVE1fSE9SSVpPTl9ERUJV
Rz15DQpDT05GSUdfQVRNX0lBPW0NCkNPTkZJR19BVE1fSUFfREVCVUc9eQ0K
Q09ORklHX0FUTV9GT1JFMjAwRT1tDQpDT05GSUdfQVRNX0ZPUkUyMDBFX1VT
RV9UQVNLTEVUPXkNCkNPTkZJR19BVE1fRk9SRTIwMEVfVFhfUkVUUlk9MTYN
CkNPTkZJR19BVE1fRk9SRTIwMEVfREVCVUc9MA0KQ09ORklHX0FUTV9IRT1t
DQojIENPTkZJR19BVE1fSEVfVVNFX1NVTkkgaXMgbm90IHNldA0KQ09ORklH
X0FUTV9TT0xPUz1tDQoNCiMNCiMgQ0FJRiB0cmFuc3BvcnQgZHJpdmVycw0K
Iw0KQ09ORklHX1ZIT1NUX05FVD1tDQpDT05GSUdfVkhPU1RfUklORz1tDQoN
CiMNCiMgRGlzdHJpYnV0ZWQgU3dpdGNoIEFyY2hpdGVjdHVyZSBkcml2ZXJz
DQojDQpDT05GSUdfTkVUX0RTQV9NVjg4RTZYWFg9eQ0KIyBDT05GSUdfTkVU
X0RTQV9NVjg4RTYwNjAgaXMgbm90IHNldA0KQ09ORklHX05FVF9EU0FfTVY4
OEU2WFhYX05FRURfUFBVPXkNCkNPTkZJR19ORVRfRFNBX01WODhFNjEzMT15
DQpDT05GSUdfTkVUX0RTQV9NVjg4RTYxMjNfNjFfNjU9bQ0KQ09ORklHX0VU
SEVSTkVUPXkNCkNPTkZJR19NRElPPXkNCkNPTkZJR19ORVRfVkVORE9SXzND
T009eQ0KIyBDT05GSUdfVk9SVEVYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1RZ
UEhPT04gaXMgbm90IHNldA0KIyBDT05GSUdfTkVUX1ZFTkRPUl9BREFQVEVD
IGlzIG5vdCBzZXQNCiMgQ09ORklHX05FVF9WRU5ET1JfQUxURU9OIGlzIG5v
dCBzZXQNCiMgQ09ORklHX05FVF9WRU5ET1JfQU1EIGlzIG5vdCBzZXQNCiMg
Q09ORklHX05FVF9WRU5ET1JfQVRIRVJPUyBpcyBub3Qgc2V0DQpDT05GSUdf
TkVUX0NBREVOQ0U9eQ0KIyBDT05GSUdfQVJNX0FUOTFfRVRIRVIgaXMgbm90
IHNldA0KQ09ORklHX01BQ0I9eQ0KQ09ORklHX05FVF9WRU5ET1JfQlJPQURD
T009eQ0KIyBDT05GSUdfQjQ0IGlzIG5vdCBzZXQNCkNPTkZJR19CTlgyPXkN
CkNPTkZJR19DTklDPXkNCkNPTkZJR19USUdPTjM9eQ0KQ09ORklHX0JOWDJY
PXkNCkNPTkZJR19CTlgyWF9TUklPVj15DQpDT05GSUdfTkVUX1ZFTkRPUl9C
Uk9DQURFPXkNCiMgQ09ORklHX0JOQSBpcyBub3Qgc2V0DQpDT05GSUdfTkVU
X0NBTFhFREFfWEdNQUM9bQ0KQ09ORklHX05FVF9WRU5ET1JfQ0hFTFNJTz15
DQpDT05GSUdfQ0hFTFNJT19UMT15DQpDT05GSUdfQ0hFTFNJT19UMV8xRz15
DQpDT05GSUdfQ0hFTFNJT19UND1tDQojIENPTkZJR19DSEVMU0lPX1Q0VkYg
aXMgbm90IHNldA0KIyBDT05GSUdfTkVUX1ZFTkRPUl9DSVNDTyBpcyBub3Qg
c2V0DQpDT05GSUdfRE5FVD1tDQojIENPTkZJR19ORVRfVkVORE9SX0RFQyBp
cyBub3Qgc2V0DQojIENPTkZJR19ORVRfVkVORE9SX0RMSU5LIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX05FVF9WRU5ET1JfRU1VTEVYIGlzIG5vdCBzZXQNCiMg
Q09ORklHX05FVF9WRU5ET1JfRVhBUiBpcyBub3Qgc2V0DQojIENPTkZJR19O
RVRfVkVORE9SX0hQIGlzIG5vdCBzZXQNCkNPTkZJR19ORVRfVkVORE9SX0lO
VEVMPXkNCiMgQ09ORklHX0UxMDAgaXMgbm90IHNldA0KQ09ORklHX0UxMDAw
PXkNCkNPTkZJR19FMTAwMEU9eQ0KIyBDT05GSUdfSUdCIGlzIG5vdCBzZXQN
CkNPTkZJR19JR0JWRj1tDQojIENPTkZJR19JWEdCIGlzIG5vdCBzZXQNCkNP
TkZJR19JWEdCRT15DQpDT05GSUdfSVhHQkVfSFdNT049eQ0KQ09ORklHX05F
VF9WRU5ET1JfSTgyNVhYPXkNCiMgQ09ORklHX0lQMTAwMCBpcyBub3Qgc2V0
DQpDT05GSUdfSk1FPW0NCkNPTkZJR19ORVRfVkVORE9SX01BUlZFTEw9eQ0K
Q09ORklHX01WTURJTz1tDQpDT05GSUdfU0tHRT1tDQpDT05GSUdfU0tHRV9E
RUJVRz15DQpDT05GSUdfU0tHRV9HRU5FU0lTPXkNCkNPTkZJR19TS1kyPW0N
CiMgQ09ORklHX1NLWTJfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX05FVF9W
RU5ET1JfTUVMTEFOT1g9eQ0KQ09ORklHX01MWDRfRU49eQ0KQ09ORklHX01M
WDRfQ09SRT15DQojIENPTkZJR19NTFg0X0RFQlVHIGlzIG5vdCBzZXQNCkNP
TkZJR19ORVRfVkVORE9SX01JQ1JFTD15DQojIENPTkZJR19LUzg4NTFfTUxM
IGlzIG5vdCBzZXQNCkNPTkZJR19LU1o4ODRYX1BDST1tDQojIENPTkZJR19G
RUFMTlggaXMgbm90IHNldA0KIyBDT05GSUdfTkVUX1ZFTkRPUl9OQVRTRU1J
IGlzIG5vdCBzZXQNCkNPTkZJR19ORVRfVkVORE9SX05WSURJQT15DQpDT05G
SUdfRk9SQ0VERVRIPW0NCkNPTkZJR19ORVRfVkVORE9SX09LST15DQojIENP
TkZJR19QQ0hfR0JFIGlzIG5vdCBzZXQNCiMgQ09ORklHX0VUSE9DIGlzIG5v
dCBzZXQNCiMgQ09ORklHX05FVF9QQUNLRVRfRU5HSU5FIGlzIG5vdCBzZXQN
CiMgQ09ORklHX05FVF9WRU5ET1JfUUxPR0lDIGlzIG5vdCBzZXQNCiMgQ09O
RklHX05FVF9WRU5ET1JfUkVBTFRFSyBpcyBub3Qgc2V0DQpDT05GSUdfTkVU
X1ZFTkRPUl9SREM9eQ0KQ09ORklHX1I2MDQwPXkNCkNPTkZJR19ORVRfVkVO
RE9SX1NFRVE9eQ0KQ09ORklHX05FVF9WRU5ET1JfU0lMQU49eQ0KQ09ORklH
X1NDOTIwMzE9eQ0KQ09ORklHX05FVF9WRU5ET1JfU0lTPXkNCkNPTkZJR19T
SVM5MDA9eQ0KIyBDT05GSUdfU0lTMTkwIGlzIG5vdCBzZXQNCkNPTkZJR19T
RkM9eQ0KIyBDT05GSUdfU0ZDX01URCBpcyBub3Qgc2V0DQojIENPTkZJR19T
RkNfTUNESV9NT04gaXMgbm90IHNldA0KQ09ORklHX1NGQ19TUklPVj15DQpD
T05GSUdfTkVUX1ZFTkRPUl9TTVNDPXkNCkNPTkZJR19FUElDMTAwPW0NCkNP
TkZJR19TTVNDOTQyMD15DQpDT05GSUdfTkVUX1ZFTkRPUl9TVE1JQ1JPPXkN
CkNPTkZJR19TVE1NQUNfRVRIPW0NCiMgQ09ORklHX1NUTU1BQ19QTEFURk9S
TSBpcyBub3Qgc2V0DQpDT05GSUdfU1RNTUFDX1BDST15DQpDT05GSUdfU1RN
TUFDX0RFQlVHX0ZTPXkNCiMgQ09ORklHX1NUTU1BQ19EQSBpcyBub3Qgc2V0
DQojIENPTkZJR19ORVRfVkVORE9SX1NVTiBpcyBub3Qgc2V0DQpDT05GSUdf
TkVUX1ZFTkRPUl9URUhVVEk9eQ0KQ09ORklHX1RFSFVUST15DQpDT05GSUdf
TkVUX1ZFTkRPUl9UST15DQpDT05GSUdfVExBTj1tDQojIENPTkZJR19ORVRf
VkVORE9SX1ZJQSBpcyBub3Qgc2V0DQojIENPTkZJR19ORVRfVkVORE9SX1dJ
Wk5FVCBpcyBub3Qgc2V0DQpDT05GSUdfRkREST1tDQojIENPTkZJR19ERUZY
WCBpcyBub3Qgc2V0DQojIENPTkZJR19TS0ZQIGlzIG5vdCBzZXQNCkNPTkZJ
R19ORVRfU0IxMDAwPW0NCkNPTkZJR19QSFlMSUI9eQ0KDQojDQojIE1JSSBQ
SFkgZGV2aWNlIGRyaXZlcnMNCiMNCkNPTkZJR19BVDgwM1hfUEhZPXkNCkNP
TkZJR19BTURfUEhZPXkNCkNPTkZJR19NQVJWRUxMX1BIWT15DQpDT05GSUdf
REFWSUNPTV9QSFk9eQ0KQ09ORklHX1FTRU1JX1BIWT15DQpDT05GSUdfTFhU
X1BIWT15DQpDT05GSUdfQ0lDQURBX1BIWT1tDQojIENPTkZJR19WSVRFU1NF
X1BIWSBpcyBub3Qgc2V0DQpDT05GSUdfU01TQ19QSFk9eQ0KQ09ORklHX0JS
T0FEQ09NX1BIWT1tDQpDT05GSUdfQkNNODdYWF9QSFk9eQ0KQ09ORklHX0lD
UExVU19QSFk9bQ0KQ09ORklHX1JFQUxURUtfUEhZPXkNCiMgQ09ORklHX05B
VElPTkFMX1BIWSBpcyBub3Qgc2V0DQpDT05GSUdfU1RFMTBYUD15DQpDT05G
SUdfTFNJX0VUMTAxMUNfUEhZPW0NCkNPTkZJR19NSUNSRUxfUEhZPXkNCkNP
TkZJR19GSVhFRF9QSFk9eQ0KQ09ORklHX01ESU9fQklUQkFORz15DQpDT05G
SUdfTURJT19HUElPPW0NCiMgQ09ORklHX1BQUCBpcyBub3Qgc2V0DQoNCiMN
CiMgVVNCIE5ldHdvcmsgQWRhcHRlcnMNCiMNCiMgQ09ORklHX1VTQl9DQVRD
IGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfS0FXRVRIPW0NCkNPTkZJR19VU0Jf
UEVHQVNVUz1tDQpDT05GSUdfVVNCX1JUTDgxNTA9bQ0KQ09ORklHX1VTQl9V
U0JORVQ9bQ0KQ09ORklHX1VTQl9ORVRfQVg4ODE3WD1tDQpDT05GSUdfVVNC
X05FVF9BWDg4MTc5XzE3OEE9bQ0KQ09ORklHX1VTQl9ORVRfQ0RDRVRIRVI9
bQ0KIyBDT05GSUdfVVNCX05FVF9DRENfRUVNIGlzIG5vdCBzZXQNCkNPTkZJ
R19VU0JfTkVUX0NEQ19OQ009bQ0KQ09ORklHX1VTQl9ORVRfQ0RDX01CSU09
bQ0KQ09ORklHX1VTQl9ORVRfRE05NjAxPW0NCiMgQ09ORklHX1VTQl9ORVRf
U01TQzc1WFggaXMgbm90IHNldA0KQ09ORklHX1VTQl9ORVRfU01TQzk1WFg9
bQ0KQ09ORklHX1VTQl9ORVRfR0w2MjBBPW0NCiMgQ09ORklHX1VTQl9ORVRf
TkVUMTA4MCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX05FVF9QTFVTQj1tDQoj
IENPTkZJR19VU0JfTkVUX01DUzc4MzAgaXMgbm90IHNldA0KIyBDT05GSUdf
VVNCX05FVF9STkRJU19IT1NUIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfTkVU
X0NEQ19TVUJTRVQ9bQ0KIyBDT05GSUdfVVNCX0FMSV9NNTYzMiBpcyBub3Qg
c2V0DQojIENPTkZJR19VU0JfQU4yNzIwIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1VTQl9CRUxLSU4gaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX0FSTUxJTlVY
IGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9FUFNPTjI4ODggaXMgbm90IHNl
dA0KIyBDT05GSUdfVVNCX0tDMjE5MCBpcyBub3Qgc2V0DQpDT05GSUdfVVNC
X05FVF9aQVVSVVM9bQ0KQ09ORklHX1VTQl9ORVRfQ1g4MjMxMF9FVEg9bQ0K
IyBDT05GSUdfVVNCX05FVF9LQUxNSUEgaXMgbm90IHNldA0KIyBDT05GSUdf
VVNCX05FVF9RTUlfV1dBTiBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfTkVU
X0lOVDUxWDEgaXMgbm90IHNldA0KQ09ORklHX1VTQl9DRENfUEhPTkVUPW0N
CiMgQ09ORklHX1VTQl9JUEhFVEggaXMgbm90IHNldA0KIyBDT05GSUdfVVNC
X1NJRVJSQV9ORVQgaXMgbm90IHNldA0KIyBDT05GSUdfV0xBTiBpcyBub3Qg
c2V0DQoNCiMNCiMgV2lNQVggV2lyZWxlc3MgQnJvYWRiYW5kIGRldmljZXMN
CiMNCkNPTkZJR19XSU1BWF9JMjQwME09bQ0KQ09ORklHX1dJTUFYX0kyNDAw
TV9VU0I9bQ0KQ09ORklHX1dJTUFYX0kyNDAwTV9ERUJVR19MRVZFTD04DQpD
T05GSUdfV0FOPXkNCiMgQ09ORklHX0xBTk1FRElBIGlzIG5vdCBzZXQNCkNP
TkZJR19IRExDPW0NCkNPTkZJR19IRExDX1JBVz1tDQpDT05GSUdfSERMQ19S
QVdfRVRIPW0NCiMgQ09ORklHX0hETENfQ0lTQ08gaXMgbm90IHNldA0KIyBD
T05GSUdfSERMQ19GUiBpcyBub3Qgc2V0DQpDT05GSUdfSERMQ19QUFA9bQ0K
DQojDQojIFguMjUvTEFQQiBzdXBwb3J0IGlzIGRpc2FibGVkDQojDQojIENP
TkZJR19QQ0kyMDBTWU4gaXMgbm90IHNldA0KIyBDT05GSUdfV0FOWEwgaXMg
bm90IHNldA0KQ09ORklHX1BDMzAwVE9PPW0NCkNPTkZJR19GQVJTWU5DPW0N
CkNPTkZJR19EU0NDND1tDQojIENPTkZJR19EU0NDNF9QQ0lTWU5DIGlzIG5v
dCBzZXQNCkNPTkZJR19EU0NDNF9QQ0lfUlNUPXkNCiMgQ09ORklHX0RMQ0kg
aXMgbm90IHNldA0KIyBDT05GSUdfU0JOSSBpcyBub3Qgc2V0DQpDT05GSUdf
SUVFRTgwMjE1NF9EUklWRVJTPW0NCkNPTkZJR19JRUVFODAyMTU0X0ZBS0VI
QVJEPW0NCkNPTkZJR19JU0ROPXkNCiMgQ09ORklHX0lTRE5fQ0FQSSBpcyBu
b3Qgc2V0DQojIENPTkZJR19IWVNETiBpcyBub3Qgc2V0DQojIENPTkZJR19N
SVNETiBpcyBub3Qgc2V0DQoNCiMNCiMgSW5wdXQgZGV2aWNlIHN1cHBvcnQN
CiMNCkNPTkZJR19JTlBVVD1tDQpDT05GSUdfSU5QVVRfRkZfTUVNTEVTUz1t
DQpDT05GSUdfSU5QVVRfUE9MTERFVj1tDQpDT05GSUdfSU5QVVRfU1BBUlNF
S01BUD1tDQpDT05GSUdfSU5QVVRfTUFUUklYS01BUD1tDQoNCiMNCiMgVXNl
cmxhbmQgaW50ZXJmYWNlcw0KIw0KIyBDT05GSUdfSU5QVVRfTU9VU0VERVYg
aXMgbm90IHNldA0KIyBDT05GSUdfSU5QVVRfSk9ZREVWIGlzIG5vdCBzZXQN
CkNPTkZJR19JTlBVVF9FVkRFVj1tDQpDT05GSUdfSU5QVVRfRVZCVUc9bQ0K
DQojDQojIElucHV0IERldmljZSBEcml2ZXJzDQojDQpDT05GSUdfSU5QVVRf
S0VZQk9BUkQ9eQ0KQ09ORklHX0tFWUJPQVJEX0FEUDU1MjA9bQ0KQ09ORklH
X0tFWUJPQVJEX0FEUDU1ODg9bQ0KIyBDT05GSUdfS0VZQk9BUkRfQURQNTU4
OSBpcyBub3Qgc2V0DQpDT05GSUdfS0VZQk9BUkRfQVRLQkQ9bQ0KIyBDT05G
SUdfS0VZQk9BUkRfUVQxMDcwIGlzIG5vdCBzZXQNCkNPTkZJR19LRVlCT0FS
RF9RVDIxNjA9bQ0KIyBDT05GSUdfS0VZQk9BUkRfTEtLQkQgaXMgbm90IHNl
dA0KQ09ORklHX0tFWUJPQVJEX0dQSU89bQ0KIyBDT05GSUdfS0VZQk9BUkRf
R1BJT19QT0xMRUQgaXMgbm90IHNldA0KQ09ORklHX0tFWUJPQVJEX1RDQTY0
MTY9bQ0KIyBDT05GSUdfS0VZQk9BUkRfVENBODQxOCBpcyBub3Qgc2V0DQpD
T05GSUdfS0VZQk9BUkRfTUFUUklYPW0NCkNPTkZJR19LRVlCT0FSRF9MTTgz
MjM9bQ0KIyBDT05GSUdfS0VZQk9BUkRfTE04MzMzIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0tFWUJPQVJEX01BWDczNTkgaXMgbm90IHNldA0KQ09ORklHX0tF
WUJPQVJEX01DUz1tDQojIENPTkZJR19LRVlCT0FSRF9NUFIxMjEgaXMgbm90
IHNldA0KQ09ORklHX0tFWUJPQVJEX05FV1RPTj1tDQojIENPTkZJR19LRVlC
T0FSRF9PUEVOQ09SRVMgaXMgbm90IHNldA0KQ09ORklHX0tFWUJPQVJEX1NU
T1dBV0FZPW0NCiMgQ09ORklHX0tFWUJPQVJEX1NVTktCRCBpcyBub3Qgc2V0
DQpDT05GSUdfS0VZQk9BUkRfWFRLQkQ9bQ0KIyBDT05GSUdfS0VZQk9BUkRf
Q1JPU19FQyBpcyBub3Qgc2V0DQojIENPTkZJR19JTlBVVF9NT1VTRSBpcyBu
b3Qgc2V0DQpDT05GSUdfSU5QVVRfSk9ZU1RJQ0s9eQ0KQ09ORklHX0pPWVNU
SUNLX0FOQUxPRz1tDQpDT05GSUdfSk9ZU1RJQ0tfQTNEPW0NCkNPTkZJR19K
T1lTVElDS19BREk9bQ0KIyBDT05GSUdfSk9ZU1RJQ0tfQ09CUkEgaXMgbm90
IHNldA0KIyBDT05GSUdfSk9ZU1RJQ0tfR0YySyBpcyBub3Qgc2V0DQpDT05G
SUdfSk9ZU1RJQ0tfR1JJUD1tDQojIENPTkZJR19KT1lTVElDS19HUklQX01Q
IGlzIG5vdCBzZXQNCkNPTkZJR19KT1lTVElDS19HVUlMTEVNT1Q9bQ0KIyBD
T05GSUdfSk9ZU1RJQ0tfSU5URVJBQ1QgaXMgbm90IHNldA0KQ09ORklHX0pP
WVNUSUNLX1NJREVXSU5ERVI9bQ0KIyBDT05GSUdfSk9ZU1RJQ0tfVE1EQyBp
cyBub3Qgc2V0DQpDT05GSUdfSk9ZU1RJQ0tfSUZPUkNFPW0NCkNPTkZJR19K
T1lTVElDS19JRk9SQ0VfVVNCPXkNCkNPTkZJR19KT1lTVElDS19JRk9SQ0Vf
MjMyPXkNCkNPTkZJR19KT1lTVElDS19XQVJSSU9SPW0NCkNPTkZJR19KT1lT
VElDS19NQUdFTExBTj1tDQojIENPTkZJR19KT1lTVElDS19TUEFDRU9SQiBp
cyBub3Qgc2V0DQpDT05GSUdfSk9ZU1RJQ0tfU1BBQ0VCQUxMPW0NCkNPTkZJ
R19KT1lTVElDS19TVElOR0VSPW0NCkNPTkZJR19KT1lTVElDS19UV0lESk9Z
PW0NCkNPTkZJR19KT1lTVElDS19aSEVOSFVBPW0NCiMgQ09ORklHX0pPWVNU
SUNLX0FTNTAxMSBpcyBub3Qgc2V0DQpDT05GSUdfSk9ZU1RJQ0tfSk9ZRFVN
UD1tDQojIENPTkZJR19KT1lTVElDS19YUEFEIGlzIG5vdCBzZXQNCiMgQ09O
RklHX0lOUFVUX1RBQkxFVCBpcyBub3Qgc2V0DQojIENPTkZJR19JTlBVVF9U
T1VDSFNDUkVFTiBpcyBub3Qgc2V0DQpDT05GSUdfSU5QVVRfTUlTQz15DQpD
T05GSUdfSU5QVVRfODhQTTgwWF9PTktFWT1tDQpDT05GSUdfSU5QVVRfQUQ3
MTRYPW0NCkNPTkZJR19JTlBVVF9BRDcxNFhfSTJDPW0NCkNPTkZJR19JTlBV
VF9CTUExNTA9bQ0KQ09ORklHX0lOUFVUX1BDU1BLUj1tDQpDT05GSUdfSU5Q
VVRfTUMxMzc4M19QV1JCVVRUT049bQ0KQ09ORklHX0lOUFVUX01NQTg0NTA9
bQ0KQ09ORklHX0lOUFVUX01QVTMwNTA9bQ0KQ09ORklHX0lOUFVUX0FQQU5F
TD1tDQpDT05GSUdfSU5QVVRfR1AyQT1tDQojIENPTkZJR19JTlBVVF9HUElP
X1RJTFRfUE9MTEVEIGlzIG5vdCBzZXQNCkNPTkZJR19JTlBVVF9BVExBU19C
VE5TPW0NCkNPTkZJR19JTlBVVF9BVElfUkVNT1RFMj1tDQpDT05GSUdfSU5Q
VVRfS0VZU1BBTl9SRU1PVEU9bQ0KQ09ORklHX0lOUFVUX0tYVEo5PW0NCkNP
TkZJR19JTlBVVF9LWFRKOV9QT0xMRURfTU9ERT15DQojIENPTkZJR19JTlBV
VF9QT1dFUk1BVEUgaXMgbm90IHNldA0KIyBDT05GSUdfSU5QVVRfWUVBTElO
SyBpcyBub3Qgc2V0DQpDT05GSUdfSU5QVVRfQ00xMDk9bQ0KQ09ORklHX0lO
UFVUX1JFVFVfUFdSQlVUVE9OPW0NCkNPTkZJR19JTlBVVF9UV0w2MDQwX1ZJ
QlJBPW0NCkNPTkZJR19JTlBVVF9VSU5QVVQ9bQ0KIyBDT05GSUdfSU5QVVRf
UENGNTA2MzNfUE1VIGlzIG5vdCBzZXQNCkNPTkZJR19JTlBVVF9QQ0Y4NTc0
PW0NCkNPTkZJR19JTlBVVF9QV01fQkVFUEVSPW0NCiMgQ09ORklHX0lOUFVU
X0dQSU9fUk9UQVJZX0VOQ09ERVIgaXMgbm90IHNldA0KIyBDT05GSUdfSU5Q
VVRfREE5MDU1X09OS0VZIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lOUFVUX0FE
WEwzNFggaXMgbm90IHNldA0KIyBDT05GSUdfSU5QVVRfSU1TX1BDVSBpcyBu
b3Qgc2V0DQpDT05GSUdfSU5QVVRfQ01BMzAwMD1tDQojIENPTkZJR19JTlBV
VF9DTUEzMDAwX0kyQyBpcyBub3Qgc2V0DQoNCiMNCiMgSGFyZHdhcmUgSS9P
IHBvcnRzDQojDQpDT05GSUdfU0VSSU89eQ0KQ09ORklHX1NFUklPX0k4MDQy
PW0NCiMgQ09ORklHX1NFUklPX0NUODJDNzEwIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1NFUklPX1BDSVBTMiBpcyBub3Qgc2V0DQpDT05GSUdfU0VSSU9fTElC
UFMyPW0NCkNPTkZJR19TRVJJT19SQVc9eQ0KQ09ORklHX1NFUklPX0FMVEVS
QV9QUzI9eQ0KQ09ORklHX1NFUklPX1BTMk1VTFQ9eQ0KQ09ORklHX1NFUklP
X0FSQ19QUzI9eQ0KQ09ORklHX0dBTUVQT1JUPW0NCkNPTkZJR19HQU1FUE9S
VF9OUzU1OD1tDQojIENPTkZJR19HQU1FUE9SVF9MNCBpcyBub3Qgc2V0DQpD
T05GSUdfR0FNRVBPUlRfRU1VMTBLMT1tDQojIENPTkZJR19HQU1FUE9SVF9G
TTgwMSBpcyBub3Qgc2V0DQoNCiMNCiMgQ2hhcmFjdGVyIGRldmljZXMNCiMN
CiMgQ09ORklHX1RUWSBpcyBub3Qgc2V0DQpDT05GSUdfREVWS01FTT15DQoj
IENPTkZJR19JUE1JX0hBTkRMRVIgaXMgbm90IHNldA0KQ09ORklHX0hXX1JB
TkRPTT1tDQpDT05GSUdfSFdfUkFORE9NX1RJTUVSSU9NRU09bQ0KIyBDT05G
SUdfSFdfUkFORE9NX0lOVEVMIGlzIG5vdCBzZXQNCiMgQ09ORklHX0hXX1JB
TkRPTV9BTUQgaXMgbm90IHNldA0KQ09ORklHX0hXX1JBTkRPTV9WSUE9bQ0K
Q09ORklHX0hXX1JBTkRPTV9WSVJUSU89bQ0KIyBDT05GSUdfSFdfUkFORE9N
X1RQTSBpcyBub3Qgc2V0DQpDT05GSUdfTlZSQU09bQ0KIyBDT05GSUdfQVBQ
TElDT00gaXMgbm90IHNldA0KQ09ORklHX1JBV19EUklWRVI9eQ0KQ09ORklH
X01BWF9SQVdfREVWUz0yNTYNCiMgQ09ORklHX0hQRVQgaXMgbm90IHNldA0K
Q09ORklHX0hBTkdDSEVDS19USU1FUj1tDQpDT05GSUdfVENHX1RQTT1tDQpD
T05GSUdfVENHX1RJUz1tDQpDT05GSUdfVENHX1RJU19JMkNfSU5GSU5FT049
bQ0KQ09ORklHX1RDR19OU0M9bQ0KIyBDT05GSUdfVENHX0FUTUVMIGlzIG5v
dCBzZXQNCkNPTkZJR19UQ0dfSU5GSU5FT049bQ0KQ09ORklHX1RDR19TVDMz
X0kyQz1tDQpDT05GSUdfVEVMQ0xPQ0s9bQ0KQ09ORklHX0RFVlBPUlQ9eQ0K
Q09ORklHX0kyQz15DQpDT05GSUdfSTJDX0JPQVJESU5GTz15DQpDT05GSUdf
STJDX0NPTVBBVD15DQpDT05GSUdfSTJDX0NIQVJERVY9eQ0KIyBDT05GSUdf
STJDX01VWCBpcyBub3Qgc2V0DQpDT05GSUdfSTJDX0hFTFBFUl9BVVRPPXkN
CkNPTkZJR19JMkNfU01CVVM9eQ0KQ09ORklHX0kyQ19BTEdPQklUPXkNCkNP
TkZJR19JMkNfQUxHT1BDQT15DQoNCiMNCiMgSTJDIEhhcmR3YXJlIEJ1cyBz
dXBwb3J0DQojDQoNCiMNCiMgUEMgU01CdXMgaG9zdCBjb250cm9sbGVyIGRy
aXZlcnMNCiMNCkNPTkZJR19JMkNfQUxJMTUzNT1tDQojIENPTkZJR19JMkNf
QUxJMTU2MyBpcyBub3Qgc2V0DQpDT05GSUdfSTJDX0FMSTE1WDM9bQ0KQ09O
RklHX0kyQ19BTUQ3NTY9eQ0KQ09ORklHX0kyQ19BTUQ3NTZfUzQ4ODI9bQ0K
Q09ORklHX0kyQ19BTUQ4MTExPXkNCiMgQ09ORklHX0kyQ19JODAxIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0kyQ19JU0NIIGlzIG5vdCBzZXQNCiMgQ09ORklH
X0kyQ19JU01UIGlzIG5vdCBzZXQNCkNPTkZJR19JMkNfUElJWDQ9bQ0KIyBD
T05GSUdfSTJDX05GT1JDRTIgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX1NJ
UzU1OTUgaXMgbm90IHNldA0KQ09ORklHX0kyQ19TSVM2MzA9bQ0KQ09ORklH
X0kyQ19TSVM5Nlg9eQ0KQ09ORklHX0kyQ19WSUE9eQ0KQ09ORklHX0kyQ19W
SUFQUk89eQ0KDQojDQojIEFDUEkgZHJpdmVycw0KIw0KQ09ORklHX0kyQ19T
Q01JPXkNCg0KIw0KIyBJMkMgc3lzdGVtIGJ1cyBkcml2ZXJzIChtb3N0bHkg
ZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hpcCkNCiMNCkNPTkZJR19JMkNfQ0JV
U19HUElPPXkNCkNPTkZJR19JMkNfREVTSUdOV0FSRV9DT1JFPXkNCkNPTkZJ
R19JMkNfREVTSUdOV0FSRV9QQ0k9eQ0KIyBDT05GSUdfSTJDX0VHMjBUIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0kyQ19HUElPIGlzIG5vdCBzZXQNCiMgQ09O
RklHX0kyQ19JTlRFTF9NSUQgaXMgbm90IHNldA0KIyBDT05GSUdfSTJDX09D
T1JFUyBpcyBub3Qgc2V0DQpDT05GSUdfSTJDX1BDQV9QTEFURk9STT15DQoj
IENPTkZJR19JMkNfUFhBX1BDSSBpcyBub3Qgc2V0DQpDT05GSUdfSTJDX1NJ
TVRFQz15DQojIENPTkZJR19JMkNfWElMSU5YIGlzIG5vdCBzZXQNCg0KIw0K
IyBFeHRlcm5hbCBJMkMvU01CdXMgYWRhcHRlciBkcml2ZXJzDQojDQojIENP
TkZJR19JMkNfRElPTEFOX1UyQyBpcyBub3Qgc2V0DQpDT05GSUdfSTJDX1BB
UlBPUlRfTElHSFQ9eQ0KIyBDT05GSUdfSTJDX1RJTllfVVNCIGlzIG5vdCBz
ZXQNCkNPTkZJR19JMkNfVklQRVJCT0FSRD1tDQoNCiMNCiMgT3RoZXIgSTJD
L1NNQnVzIGJ1cyBkcml2ZXJzDQojDQojIENPTkZJR19JMkNfU1RVQiBpcyBu
b3Qgc2V0DQpDT05GSUdfSTJDX0RFQlVHX0NPUkU9eQ0KQ09ORklHX0kyQ19E
RUJVR19BTEdPPXkNCiMgQ09ORklHX0kyQ19ERUJVR19CVVMgaXMgbm90IHNl
dA0KIyBDT05GSUdfU1BJIGlzIG5vdCBzZXQNCg0KIw0KIyBRdWFsY29tbSBN
U00gU1NCSSBidXMgc3VwcG9ydA0KIw0KIyBDT05GSUdfU1NCSSBpcyBub3Qg
c2V0DQpDT05GSUdfSFNJPXkNCkNPTkZJR19IU0lfQk9BUkRJTkZPPXkNCg0K
Iw0KIyBIU0kgY2xpZW50cw0KIw0KIyBDT05GSUdfSFNJX0NIQVIgaXMgbm90
IHNldA0KDQojDQojIFBQUyBzdXBwb3J0DQojDQpDT05GSUdfUFBTPXkNCkNP
TkZJR19QUFNfREVCVUc9eQ0KDQojDQojIFBQUyBjbGllbnRzIHN1cHBvcnQN
CiMNCkNPTkZJR19QUFNfQ0xJRU5UX0tUSU1FUj1tDQojIENPTkZJR19QUFNf
Q0xJRU5UX0dQSU8gaXMgbm90IHNldA0KDQojDQojIFBQUyBnZW5lcmF0b3Jz
IHN1cHBvcnQNCiMNCg0KIw0KIyBQVFAgY2xvY2sgc3VwcG9ydA0KIw0KQ09O
RklHX1BUUF8xNTg4X0NMT0NLPXkNCg0KIw0KIyBFbmFibGUgUEhZTElCIGFu
ZCBORVRXT1JLX1BIWV9USU1FU1RBTVBJTkcgdG8gc2VlIHRoZSBhZGRpdGlv
bmFsIGNsb2Nrcy4NCiMNCkNPTkZJR19QVFBfMTU4OF9DTE9DS19QQ0g9bQ0K
Q09ORklHX0FSQ0hfV0FOVF9PUFRJT05BTF9HUElPTElCPXkNCkNPTkZJR19H
UElPX0RFVlJFUz15DQpDT05GSUdfR1BJT0xJQj15DQpDT05GSUdfR1BJT19B
Q1BJPXkNCiMgQ09ORklHX0RFQlVHX0dQSU8gaXMgbm90IHNldA0KIyBDT05G
SUdfR1BJT19TWVNGUyBpcyBub3Qgc2V0DQpDT05GSUdfR1BJT19HRU5FUklD
PW0NCiMgQ09ORklHX0dQSU9fREE5MDU1IGlzIG5vdCBzZXQNCkNPTkZJR19H
UElPX01BWDczMFg9eQ0KDQojDQojIE1lbW9yeSBtYXBwZWQgR1BJTyBkcml2
ZXJzOg0KIw0KQ09ORklHX0dQSU9fR0VORVJJQ19QTEFURk9STT1tDQpDT05G
SUdfR1BJT19JVDg3NjFFPXkNCiMgQ09ORklHX0dQSU9fVFM1NTAwIGlzIG5v
dCBzZXQNCkNPTkZJR19HUElPX1NDSD1tDQpDT05GSUdfR1BJT19JQ0g9bQ0K
Q09ORklHX0dQSU9fVlg4NTU9bQ0KIyBDT05GSUdfR1BJT19MWU5YUE9JTlQg
aXMgbm90IHNldA0KDQojDQojIEkyQyBHUElPIGV4cGFuZGVyczoNCiMNCkNP
TkZJR19HUElPX01BWDczMDA9eQ0KQ09ORklHX0dQSU9fTUFYNzMyWD1tDQoj
IENPTkZJR19HUElPX1BDQTk1M1ggaXMgbm90IHNldA0KIyBDT05GSUdfR1BJ
T19QQ0Y4NTdYIGlzIG5vdCBzZXQNCiMgQ09ORklHX0dQSU9fU1gxNTBYIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0dQSU9fVFdMNjA0MCBpcyBub3Qgc2V0DQoj
IENPTkZJR19HUElPX1dNODM1MCBpcyBub3Qgc2V0DQojIENPTkZJR19HUElP
X0FEUDU1MjAgaXMgbm90IHNldA0KIyBDT05GSUdfR1BJT19BRFA1NTg4IGlz
IG5vdCBzZXQNCg0KIw0KIyBQQ0kgR1BJTyBleHBhbmRlcnM6DQojDQpDT05G
SUdfR1BJT19DUzU1MzU9eQ0KIyBDT05GSUdfR1BJT19CVDhYWCBpcyBub3Qg
c2V0DQojIENPTkZJR19HUElPX0FNRDgxMTEgaXMgbm90IHNldA0KQ09ORklH
X0dQSU9fTEFOR1dFTEw9eQ0KQ09ORklHX0dQSU9fUENIPXkNCkNPTkZJR19H
UElPX01MX0lPSD1tDQojIENPTkZJR19HUElPX1RJTUJFUkRBTEUgaXMgbm90
IHNldA0KQ09ORklHX0dQSU9fUkRDMzIxWD15DQoNCiMNCiMgU1BJIEdQSU8g
ZXhwYW5kZXJzOg0KIw0KQ09ORklHX0dQSU9fTUNQMjNTMDg9eQ0KDQojDQoj
IEFDOTcgR1BJTyBleHBhbmRlcnM6DQojDQoNCiMNCiMgTU9EVUxidXMgR1BJ
TyBleHBhbmRlcnM6DQojDQpDT05GSUdfR1BJT19KQU5aX1RUTD1tDQojIENP
TkZJR19HUElPX1RQUzY1ODZYIGlzIG5vdCBzZXQNCiMgQ09ORklHX0dQSU9f
VFBTNjU5MTAgaXMgbm90IHNldA0KDQojDQojIFVTQiBHUElPIGV4cGFuZGVy
czoNCiMNCkNPTkZJR19HUElPX1ZJUEVSQk9BUkQ9bQ0KQ09ORklHX1cxPXkN
Cg0KIw0KIyAxLXdpcmUgQnVzIE1hc3RlcnMNCiMNCiMgQ09ORklHX1cxX01B
U1RFUl9NQVRST1ggaXMgbm90IHNldA0KIyBDT05GSUdfVzFfTUFTVEVSX0RT
MjQ5MCBpcyBub3Qgc2V0DQpDT05GSUdfVzFfTUFTVEVSX0RTMjQ4Mj1tDQpD
T05GSUdfVzFfTUFTVEVSX0RTMVdNPW0NCkNPTkZJR19XMV9NQVNURVJfR1BJ
Tz1tDQoNCiMNCiMgMS13aXJlIFNsYXZlcw0KIw0KQ09ORklHX1cxX1NMQVZF
X1RIRVJNPW0NCiMgQ09ORklHX1cxX1NMQVZFX1NNRU0gaXMgbm90IHNldA0K
Q09ORklHX1cxX1NMQVZFX0RTMjQwOD15DQojIENPTkZJR19XMV9TTEFWRV9E
UzI0MDhfUkVBREJBQ0sgaXMgbm90IHNldA0KIyBDT05GSUdfVzFfU0xBVkVf
RFMyNDEzIGlzIG5vdCBzZXQNCkNPTkZJR19XMV9TTEFWRV9EUzI0MjM9bQ0K
Q09ORklHX1cxX1NMQVZFX0RTMjQzMT1tDQpDT05GSUdfVzFfU0xBVkVfRFMy
NDMzPXkNCkNPTkZJR19XMV9TTEFWRV9EUzI0MzNfQ1JDPXkNCkNPTkZJR19X
MV9TTEFWRV9EUzI3NjA9bQ0KQ09ORklHX1cxX1NMQVZFX0RTMjc4MD15DQpD
T05GSUdfVzFfU0xBVkVfRFMyNzgxPXkNCkNPTkZJR19XMV9TTEFWRV9EUzI4
RTA0PW0NCiMgQ09ORklHX1cxX1NMQVZFX0JRMjcwMDAgaXMgbm90IHNldA0K
Q09ORklHX1BPV0VSX1NVUFBMWT15DQpDT05GSUdfUE9XRVJfU1VQUExZX0RF
QlVHPXkNCkNPTkZJR19QREFfUE9XRVI9bQ0KIyBDT05GSUdfR0VORVJJQ19B
RENfQkFUVEVSWSBpcyBub3Qgc2V0DQpDT05GSUdfV004MzUwX1BPV0VSPW0N
CkNPTkZJR19URVNUX1BPV0VSPW0NCkNPTkZJR19CQVRURVJZX0RTMjc2MD1t
DQpDT05GSUdfQkFUVEVSWV9EUzI3ODA9eQ0KQ09ORklHX0JBVFRFUllfRFMy
NzgxPXkNCkNPTkZJR19CQVRURVJZX0RTMjc4Mj15DQpDT05GSUdfQkFUVEVS
WV9TQlM9eQ0KIyBDT05GSUdfQkFUVEVSWV9CUTI3eDAwIGlzIG5vdCBzZXQN
CkNPTkZJR19CQVRURVJZX01BWDE3MDQwPW0NCkNPTkZJR19CQVRURVJZX01B
WDE3MDQyPW0NCiMgQ09ORklHX0NIQVJHRVJfUENGNTA2MzMgaXMgbm90IHNl
dA0KIyBDT05GSUdfQ0hBUkdFUl9NQVg4OTAzIGlzIG5vdCBzZXQNCiMgQ09O
RklHX0NIQVJHRVJfTFA4NzI3IGlzIG5vdCBzZXQNCiMgQ09ORklHX0NIQVJH
RVJfTFA4Nzg4IGlzIG5vdCBzZXQNCkNPTkZJR19DSEFSR0VSX0dQSU89bQ0K
Q09ORklHX0NIQVJHRVJfQlEyNDE1WD15DQojIENPTkZJR19DSEFSR0VSX1NN
QjM0NyBpcyBub3Qgc2V0DQojIENPTkZJR19DSEFSR0VSX1RQUzY1MDkwIGlz
IG5vdCBzZXQNCkNPTkZJR19CQVRURVJZX0dPTERGSVNIPXkNCkNPTkZJR19Q
T1dFUl9SRVNFVD15DQojIENPTkZJR19QT1dFUl9BVlMgaXMgbm90IHNldA0K
Q09ORklHX0hXTU9OPXkNCkNPTkZJR19IV01PTl9WSUQ9eQ0KIyBDT05GSUdf
SFdNT05fREVCVUdfQ0hJUCBpcyBub3Qgc2V0DQoNCiMNCiMgTmF0aXZlIGRy
aXZlcnMNCiMNCkNPTkZJR19TRU5TT1JTX0FENzQxND15DQpDT05GSUdfU0VO
U09SU19BRDc0MTg9bQ0KQ09ORklHX1NFTlNPUlNfQURNMTAyMT15DQpDT05G
SUdfU0VOU09SU19BRE0xMDI1PW0NCiMgQ09ORklHX1NFTlNPUlNfQURNMTAy
NiBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0FETTEwMjkgaXMgbm90
IHNldA0KIyBDT05GSUdfU0VOU09SU19BRE0xMDMxIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1NFTlNPUlNfQURNOTI0MCBpcyBub3Qgc2V0DQpDT05GSUdfU0VO
U09SU19BRFQ3WDEwPXkNCkNPTkZJR19TRU5TT1JTX0FEVDc0MTA9eQ0KIyBD
T05GSUdfU0VOU09SU19BRFQ3NDExIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NF
TlNPUlNfQURUNzQ2MiBpcyBub3Qgc2V0DQpDT05GSUdfU0VOU09SU19BRFQ3
NDcwPW0NCkNPTkZJR19TRU5TT1JTX0FEVDc0NzU9bQ0KQ09ORklHX1NFTlNP
UlNfQVNDNzYyMT1tDQojIENPTkZJR19TRU5TT1JTX0s4VEVNUCBpcyBub3Qg
c2V0DQpDT05GSUdfU0VOU09SU19LMTBURU1QPW0NCkNPTkZJR19TRU5TT1JT
X0ZBTTE1SF9QT1dFUj15DQpDT05GSUdfU0VOU09SU19BU0IxMDA9eQ0KQ09O
RklHX1NFTlNPUlNfQVRYUDE9eQ0KIyBDT05GSUdfU0VOU09SU19EUzYyMCBp
cyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0RTMTYyMSBpcyBub3Qgc2V0
DQojIENPTkZJR19TRU5TT1JTX0RBOTA1NSBpcyBub3Qgc2V0DQpDT05GSUdf
U0VOU09SU19JNUtfQU1CPXkNCkNPTkZJR19TRU5TT1JTX0Y3MTgwNUY9bQ0K
Q09ORklHX1NFTlNPUlNfRjcxODgyRkc9bQ0KQ09ORklHX1NFTlNPUlNfRjc1
Mzc1Uz15DQojIENPTkZJR19TRU5TT1JTX0ZTQ0hNRCBpcyBub3Qgc2V0DQpD
T05GSUdfU0VOU09SU19HNzYwQT1tDQpDT05GSUdfU0VOU09SU19HTDUxOFNN
PW0NCkNPTkZJR19TRU5TT1JTX0dMNTIwU009eQ0KQ09ORklHX1NFTlNPUlNf
R1BJT19GQU49bQ0KQ09ORklHX1NFTlNPUlNfSElINjEzMD15DQpDT05GSUdf
U0VOU09SU19DT1JFVEVNUD15DQojIENPTkZJR19TRU5TT1JTX0lJT19IV01P
TiBpcyBub3Qgc2V0DQpDT05GSUdfU0VOU09SU19JVDg3PXkNCiMgQ09ORklH
X1NFTlNPUlNfSkM0MiBpcyBub3Qgc2V0DQpDT05GSUdfU0VOU09SU19MSU5F
QUdFPXkNCiMgQ09ORklHX1NFTlNPUlNfTE02MyBpcyBub3Qgc2V0DQojIENP
TkZJR19TRU5TT1JTX0xNNzMgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNf
TE03NT1tDQpDT05GSUdfU0VOU09SU19MTTc3PXkNCiMgQ09ORklHX1NFTlNP
UlNfTE03OCBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0xNODAgaXMg
bm90IHNldA0KQ09ORklHX1NFTlNPUlNfTE04Mz1tDQojIENPTkZJR19TRU5T
T1JTX0xNODUgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfTE04Nz15DQoj
IENPTkZJR19TRU5TT1JTX0xNOTAgaXMgbm90IHNldA0KQ09ORklHX1NFTlNP
UlNfTE05Mj15DQpDT05GSUdfU0VOU09SU19MTTkzPXkNCkNPTkZJR19TRU5T
T1JTX0xUQzQxNTE9eQ0KQ09ORklHX1NFTlNPUlNfTFRDNDIxNT1tDQpDT05G
SUdfU0VOU09SU19MVEM0MjQ1PXkNCkNPTkZJR19TRU5TT1JTX0xUQzQyNjE9
bQ0KQ09ORklHX1NFTlNPUlNfTE05NTIzND15DQojIENPTkZJR19TRU5TT1JT
X0xNOTUyNDEgaXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19MTTk1MjQ1
IGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX01BWDE2MDY1PW0NCkNPTkZJ
R19TRU5TT1JTX01BWDE2MTk9eQ0KQ09ORklHX1NFTlNPUlNfTUFYMTY2OD1t
DQpDT05GSUdfU0VOU09SU19NQVgxOTc9bQ0KIyBDT05GSUdfU0VOU09SU19N
QVg2NjM5IGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX01BWDY2NDI9eQ0K
Q09ORklHX1NFTlNPUlNfTUFYNjY1MD15DQpDT05GSUdfU0VOU09SU19NQVg2
Njk3PW0NCiMgQ09ORklHX1NFTlNPUlNfTUNQMzAyMSBpcyBub3Qgc2V0DQoj
IENPTkZJR19TRU5TT1JTX05DVDY3NzUgaXMgbm90IHNldA0KQ09ORklHX1NF
TlNPUlNfTlRDX1RIRVJNSVNUT1I9bQ0KQ09ORklHX1NFTlNPUlNfUEM4NzM2
MD15DQpDT05GSUdfU0VOU09SU19QQzg3NDI3PXkNCiMgQ09ORklHX1NFTlNP
UlNfUENGODU5MSBpcyBub3Qgc2V0DQojIENPTkZJR19QTUJVUyBpcyBub3Qg
c2V0DQojIENPTkZJR19TRU5TT1JTX1NIVDE1IGlzIG5vdCBzZXQNCiMgQ09O
RklHX1NFTlNPUlNfU0hUMjEgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNf
U0lTNTU5NT1tDQpDT05GSUdfU0VOU09SU19TTU02NjU9eQ0KQ09ORklHX1NF
TlNPUlNfRE1FMTczNz15DQpDT05GSUdfU0VOU09SU19FTUMxNDAzPW0NCiMg
Q09ORklHX1NFTlNPUlNfRU1DMjEwMyBpcyBub3Qgc2V0DQpDT05GSUdfU0VO
U09SU19FTUM2VzIwMT1tDQpDT05GSUdfU0VOU09SU19TTVNDNDdNMT15DQpD
T05GSUdfU0VOU09SU19TTVNDNDdNMTkyPW0NCkNPTkZJR19TRU5TT1JTX1NN
U0M0N0IzOTc9eQ0KIyBDT05GSUdfU0VOU09SU19TQ0g1NlhYX0NPTU1PTiBp
cyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0FEUzEwMTUgaXMgbm90IHNl
dA0KQ09ORklHX1NFTlNPUlNfQURTNzgyOD15DQojIENPTkZJR19TRU5TT1JT
X0FNQzY4MjEgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfSU5BMjA5PXkN
CkNPTkZJR19TRU5TT1JTX0lOQTJYWD1tDQpDT05GSUdfU0VOU09SU19USE1D
NTA9eQ0KQ09ORklHX1NFTlNPUlNfVE1QMTAyPW0NCkNPTkZJR19TRU5TT1JT
X1RNUDQwMT1tDQojIENPTkZJR19TRU5TT1JTX1RNUDQyMSBpcyBub3Qgc2V0
DQpDT05GSUdfU0VOU09SU19WSUFfQ1BVVEVNUD1tDQojIENPTkZJR19TRU5T
T1JTX1ZJQTY4NkEgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfVlQxMjEx
PW0NCiMgQ09ORklHX1NFTlNPUlNfVlQ4MjMxIGlzIG5vdCBzZXQNCkNPTkZJ
R19TRU5TT1JTX1c4Mzc4MUQ9eQ0KQ09ORklHX1NFTlNPUlNfVzgzNzkxRD15
DQojIENPTkZJR19TRU5TT1JTX1c4Mzc5MkQgaXMgbm90IHNldA0KIyBDT05G
SUdfU0VOU09SU19XODM3OTMgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNf
VzgzNzk1PXkNCiMgQ09ORklHX1NFTlNPUlNfVzgzNzk1X0ZBTkNUUkwgaXMg
bm90IHNldA0KQ09ORklHX1NFTlNPUlNfVzgzTDc4NVRTPXkNCiMgQ09ORklH
X1NFTlNPUlNfVzgzTDc4Nk5HIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JT
X1c4MzYyN0hGPXkNCkNPTkZJR19TRU5TT1JTX1c4MzYyN0VIRj1tDQpDT05G
SUdfU0VOU09SU19XTTgzNTA9bQ0KQ09ORklHX1NFTlNPUlNfQVBQTEVTTUM9
bQ0KQ09ORklHX1NFTlNPUlNfTUMxMzc4M19BREM9bQ0KDQojDQojIEFDUEkg
ZHJpdmVycw0KIw0KIyBDT05GSUdfU0VOU09SU19BQ1BJX1BPV0VSIGlzIG5v
dCBzZXQNCkNPTkZJR19TRU5TT1JTX0FUSzAxMTA9bQ0KQ09ORklHX1RIRVJN
QUw9eQ0KQ09ORklHX1RIRVJNQUxfSFdNT049eQ0KIyBDT05GSUdfVEhFUk1B
TF9ERUZBVUxUX0dPVl9TVEVQX1dJU0UgaXMgbm90IHNldA0KQ09ORklHX1RI
RVJNQUxfREVGQVVMVF9HT1ZfRkFJUl9TSEFSRT15DQojIENPTkZJR19USEVS
TUFMX0RFRkFVTFRfR09WX1VTRVJfU1BBQ0UgaXMgbm90IHNldA0KQ09ORklH
X1RIRVJNQUxfR09WX0ZBSVJfU0hBUkU9eQ0KIyBDT05GSUdfVEhFUk1BTF9H
T1ZfU1RFUF9XSVNFIGlzIG5vdCBzZXQNCiMgQ09ORklHX1RIRVJNQUxfR09W
X1VTRVJfU1BBQ0UgaXMgbm90IHNldA0KQ09ORklHX1RIRVJNQUxfRU1VTEFU
SU9OPXkNCkNPTkZJR19JTlRFTF9QT1dFUkNMQU1QPXkNCiMgQ09ORklHX1dB
VENIRE9HIGlzIG5vdCBzZXQNCkNPTkZJR19TU0JfUE9TU0lCTEU9eQ0KDQoj
DQojIFNvbmljcyBTaWxpY29uIEJhY2twbGFuZQ0KIw0KIyBDT05GSUdfU1NC
IGlzIG5vdCBzZXQNCkNPTkZJR19CQ01BX1BPU1NJQkxFPXkNCg0KIw0KIyBC
cm9hZGNvbSBzcGVjaWZpYyBBTUJBDQojDQojIENPTkZJR19CQ01BIGlzIG5v
dCBzZXQNCg0KIw0KIyBNdWx0aWZ1bmN0aW9uIGRldmljZSBkcml2ZXJzDQoj
DQpDT05GSUdfTUZEX0NPUkU9eQ0KQ09ORklHX01GRF9DUzU1MzU9eQ0KQ09O
RklHX01GRF9BUzM3MTE9eQ0KQ09ORklHX1BNSUNfQURQNTUyMD15DQpDT05G
SUdfTUZEX0FBVDI4NzBfQ09SRT15DQpDT05GSUdfTUZEX0NST1NfRUM9bQ0K
IyBDT05GSUdfTUZEX0NST1NfRUNfSTJDIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1BNSUNfREE5MDNYIGlzIG5vdCBzZXQNCiMgQ09ORklHX01GRF9EQTkwNTJf
STJDIGlzIG5vdCBzZXQNCkNPTkZJR19NRkRfREE5MDU1PXkNCkNPTkZJR19N
RkRfTUMxMzc4Mz1tDQpDT05GSUdfTUZEX01DMTNYWFg9bQ0KQ09ORklHX01G
RF9NQzEzWFhYX0kyQz1tDQojIENPTkZJR19IVENfUEFTSUMzIGlzIG5vdCBz
ZXQNCkNPTkZJR19IVENfSTJDUExEPXkNCkNPTkZJR19MUENfSUNIPXkNCkNP
TkZJR19MUENfU0NIPXkNCkNPTkZJR19NRkRfSkFOWl9DTU9ESU89bQ0KQ09O
RklHX01GRF84OFBNODAwPXkNCiMgQ09ORklHX01GRF84OFBNODA1IGlzIG5v
dCBzZXQNCiMgQ09ORklHX01GRF84OFBNODYwWCBpcyBub3Qgc2V0DQojIENP
TkZJR19NRkRfTUFYNzc2ODYgaXMgbm90IHNldA0KQ09ORklHX01GRF9NQVg3
NzY5Mz15DQpDT05GSUdfTUZEX01BWDg5MDc9bQ0KIyBDT05GSUdfTUZEX01B
WDg5MjUgaXMgbm90IHNldA0KIyBDT05GSUdfTUZEX01BWDg5OTcgaXMgbm90
IHNldA0KQ09ORklHX01GRF9NQVg4OTk4PXkNCkNPTkZJR19NRkRfVklQRVJC
T0FSRD1tDQpDT05GSUdfTUZEX1JFVFU9bQ0KQ09ORklHX01GRF9QQ0Y1MDYz
Mz15DQojIENPTkZJR19QQ0Y1MDYzM19BREMgaXMgbm90IHNldA0KQ09ORklH
X1BDRjUwNjMzX0dQSU89eQ0KQ09ORklHX01GRF9SREMzMjFYPXkNCkNPTkZJ
R19NRkRfUlRTWF9QQ0k9eQ0KIyBDT05GSUdfTUZEX1JDNVQ1ODMgaXMgbm90
IHNldA0KQ09ORklHX01GRF9TRUNfQ09SRT15DQpDT05GSUdfTUZEX1NJNDc2
WF9DT1JFPW0NCiMgQ09ORklHX01GRF9TTTUwMSBpcyBub3Qgc2V0DQpDT05G
SUdfTUZEX1NNU0M9eQ0KQ09ORklHX0FCWDUwMF9DT1JFPXkNCiMgQ09ORklH
X0FCMzEwMF9DT1JFIGlzIG5vdCBzZXQNCiMgQ09ORklHX01GRF9TVE1QRSBp
cyBub3Qgc2V0DQpDT05GSUdfTUZEX1NZU0NPTj15DQojIENPTkZJR19NRkRf
VElfQU0zMzVYX1RTQ0FEQyBpcyBub3Qgc2V0DQpDT05GSUdfTUZEX0xQODc4
OD15DQojIENPTkZJR19NRkRfUEFMTUFTIGlzIG5vdCBzZXQNCiMgQ09ORklH
X1RQUzYxMDVYIGlzIG5vdCBzZXQNCkNPTkZJR19UUFM2NTAxMD15DQpDT05G
SUdfVFBTNjUwN1g9bQ0KQ09ORklHX01GRF9UUFM2NTA5MD15DQojIENPTkZJ
R19NRkRfVFBTNjUyMTcgaXMgbm90IHNldA0KQ09ORklHX01GRF9UUFM2NTg2
WD15DQpDT05GSUdfTUZEX1RQUzY1OTEwPXkNCkNPTkZJR19NRkRfVFBTNjU5
MTI9eQ0KIyBDT05GSUdfTUZEX1RQUzY1OTEyX0kyQyBpcyBub3Qgc2V0DQoj
IENPTkZJR19NRkRfVFBTODAwMzEgaXMgbm90IHNldA0KIyBDT05GSUdfVFdM
NDAzMF9DT1JFIGlzIG5vdCBzZXQNCkNPTkZJR19UV0w2MDQwX0NPUkU9eQ0K
Q09ORklHX01GRF9XTDEyNzNfQ09SRT15DQojIENPTkZJR19NRkRfTE0zNTMz
IGlzIG5vdCBzZXQNCkNPTkZJR19NRkRfVElNQkVSREFMRT15DQojIENPTkZJ
R19NRkRfVEMzNTg5WCBpcyBub3Qgc2V0DQojIENPTkZJR19NRkRfVE1JTyBp
cyBub3Qgc2V0DQpDT05GSUdfTUZEX1ZYODU1PW0NCiMgQ09ORklHX01GRF9B
UklaT05BX0kyQyBpcyBub3Qgc2V0DQpDT05GSUdfTUZEX1dNODQwMD15DQoj
IENPTkZJR19NRkRfV004MzFYX0kyQyBpcyBub3Qgc2V0DQpDT05GSUdfTUZE
X1dNODM1MD15DQpDT05GSUdfTUZEX1dNODM1MF9JMkM9eQ0KIyBDT05GSUdf
TUZEX1dNODk5NCBpcyBub3Qgc2V0DQojIENPTkZJR19SRUdVTEFUT1IgaXMg
bm90IHNldA0KIyBDT05GSUdfTUVESUFfU1VQUE9SVCBpcyBub3Qgc2V0DQoN
CiMNCiMgR3JhcGhpY3Mgc3VwcG9ydA0KIw0KQ09ORklHX0FHUD1tDQpDT05G
SUdfQUdQX0FNRDY0PW0NCkNPTkZJR19BR1BfSU5URUw9bQ0KQ09ORklHX0FH
UF9TSVM9bQ0KIyBDT05GSUdfQUdQX1ZJQSBpcyBub3Qgc2V0DQpDT05GSUdf
VkdBX0FSQj15DQpDT05GSUdfVkdBX0FSQl9NQVhfR1BVUz0xNg0KQ09ORklH
X1ZHQV9TV0lUQ0hFUk9PPXkNCkNPTkZJR19EUk09bQ0KQ09ORklHX0RSTV9V
U0I9bQ0KQ09ORklHX0RSTV9LTVNfSEVMUEVSPW0NCkNPTkZJR19EUk1fTE9B
RF9FRElEX0ZJUk1XQVJFPXkNCkNPTkZJR19EUk1fVFRNPW0NCg0KIw0KIyBJ
MkMgZW5jb2RlciBvciBoZWxwZXIgY2hpcHMNCiMNCkNPTkZJR19EUk1fSTJD
X0NINzAwNj1tDQpDT05GSUdfRFJNX0kyQ19TSUwxNjQ9bQ0KQ09ORklHX0RS
TV9JMkNfTlhQX1REQTk5OFg9bQ0KQ09ORklHX0RSTV9UREZYPW0NCkNPTkZJ
R19EUk1fUjEyOD1tDQojIENPTkZJR19EUk1fUkFERU9OIGlzIG5vdCBzZXQN
CkNPTkZJR19EUk1fTk9VVkVBVT1tDQpDT05GSUdfTk9VVkVBVV9ERUJVRz01
DQpDT05GSUdfTk9VVkVBVV9ERUJVR19ERUZBVUxUPTMNCkNPTkZJR19EUk1f
Tk9VVkVBVV9CQUNLTElHSFQ9eQ0KQ09ORklHX0RSTV9JODEwPW0NCkNPTkZJ
R19EUk1fSTkxNT1tDQpDT05GSUdfRFJNX0k5MTVfS01TPXkNCkNPTkZJR19E
Uk1fTUdBPW0NCkNPTkZJR19EUk1fU0lTPW0NCkNPTkZJR19EUk1fVklBPW0N
CiMgQ09ORklHX0RSTV9TQVZBR0UgaXMgbm90IHNldA0KQ09ORklHX0RSTV9W
TVdHRlg9bQ0KQ09ORklHX0RSTV9WTVdHRlhfRkJDT049eQ0KQ09ORklHX0RS
TV9HTUE1MDA9bQ0KQ09ORklHX0RSTV9HTUE2MDA9eQ0KQ09ORklHX0RSTV9H
TUEzNjAwPXkNCkNPTkZJR19EUk1fVURMPW0NCkNPTkZJR19EUk1fQVNUPW0N
CkNPTkZJR19EUk1fTUdBRzIwMD1tDQojIENPTkZJR19EUk1fQ0lSUlVTX1FF
TVUgaXMgbm90IHNldA0KIyBDT05GSUdfRFJNX1FYTCBpcyBub3Qgc2V0DQpD
T05GSUdfVkdBU1RBVEU9bQ0KQ09ORklHX1ZJREVPX09VVFBVVF9DT05UUk9M
PW0NCkNPTkZJR19IRE1JPXkNCkNPTkZJR19GQj1tDQojIENPTkZJR19GSVJN
V0FSRV9FRElEIGlzIG5vdCBzZXQNCkNPTkZJR19GQl9EREM9bQ0KIyBDT05G
SUdfRkJfQk9PVF9WRVNBX1NVUFBPUlQgaXMgbm90IHNldA0KQ09ORklHX0ZC
X0NGQl9GSUxMUkVDVD1tDQpDT05GSUdfRkJfQ0ZCX0NPUFlBUkVBPW0NCkNP
TkZJR19GQl9DRkJfSU1BR0VCTElUPW0NCiMgQ09ORklHX0ZCX0NGQl9SRVZf
UElYRUxTX0lOX0JZVEUgaXMgbm90IHNldA0KQ09ORklHX0ZCX1NZU19GSUxM
UkVDVD1tDQpDT05GSUdfRkJfU1lTX0NPUFlBUkVBPW0NCkNPTkZJR19GQl9T
WVNfSU1BR0VCTElUPW0NCiMgQ09ORklHX0ZCX0ZPUkVJR05fRU5ESUFOIGlz
IG5vdCBzZXQNCkNPTkZJR19GQl9TWVNfRk9QUz1tDQpDT05GSUdfRkJfREVG
RVJSRURfSU89eQ0KQ09ORklHX0ZCX0hFQ1VCQT1tDQpDT05GSUdfRkJfU1ZH
QUxJQj1tDQojIENPTkZJR19GQl9NQUNNT0RFUyBpcyBub3Qgc2V0DQpDT05G
SUdfRkJfQkFDS0xJR0hUPXkNCkNPTkZJR19GQl9NT0RFX0hFTFBFUlM9eQ0K
Q09ORklHX0ZCX1RJTEVCTElUVElORz15DQoNCiMNCiMgRnJhbWUgYnVmZmVy
IGhhcmR3YXJlIGRyaXZlcnMNCiMNCkNPTkZJR19GQl9DSVJSVVM9bQ0KQ09O
RklHX0ZCX1BNMj1tDQojIENPTkZJR19GQl9QTTJfRklGT19ESVNDT05ORUNU
IGlzIG5vdCBzZXQNCkNPTkZJR19GQl9DWUJFUjIwMDA9bQ0KQ09ORklHX0ZC
X0NZQkVSMjAwMF9EREM9eQ0KQ09ORklHX0ZCX0FSQz1tDQpDT05GSUdfRkJf
VkdBMTY9bQ0KQ09ORklHX0ZCX040MTE9bQ0KQ09ORklHX0ZCX0hHQT1tDQpD
T05GSUdfRkJfUzFEMTNYWFg9bQ0KQ09ORklHX0ZCX05WSURJQT1tDQpDT05G
SUdfRkJfTlZJRElBX0kyQz15DQpDT05GSUdfRkJfTlZJRElBX0RFQlVHPXkN
CkNPTkZJR19GQl9OVklESUFfQkFDS0xJR0hUPXkNCkNPTkZJR19GQl9SSVZB
PW0NCkNPTkZJR19GQl9SSVZBX0kyQz15DQpDT05GSUdfRkJfUklWQV9ERUJV
Rz15DQojIENPTkZJR19GQl9SSVZBX0JBQ0tMSUdIVCBpcyBub3Qgc2V0DQpD
T05GSUdfRkJfSTc0MD1tDQojIENPTkZJR19GQl9MRTgwNTc4IGlzIG5vdCBz
ZXQNCkNPTkZJR19GQl9JTlRFTD1tDQpDT05GSUdfRkJfSU5URUxfREVCVUc9
eQ0KIyBDT05GSUdfRkJfSU5URUxfSTJDIGlzIG5vdCBzZXQNCkNPTkZJR19G
Ql9NQVRST1g9bQ0KQ09ORklHX0ZCX01BVFJPWF9NSUxMRU5JVU09eQ0KIyBD
T05GSUdfRkJfTUFUUk9YX01ZU1RJUVVFIGlzIG5vdCBzZXQNCkNPTkZJR19G
Ql9NQVRST1hfRz15DQojIENPTkZJR19GQl9NQVRST1hfSTJDIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX0ZCX1JBREVPTiBpcyBub3Qgc2V0DQpDT05GSUdfRkJf
QVRZMTI4PW0NCiMgQ09ORklHX0ZCX0FUWTEyOF9CQUNLTElHSFQgaXMgbm90
IHNldA0KQ09ORklHX0ZCX0FUWT1tDQojIENPTkZJR19GQl9BVFlfQ1QgaXMg
bm90IHNldA0KIyBDT05GSUdfRkJfQVRZX0dYIGlzIG5vdCBzZXQNCkNPTkZJ
R19GQl9BVFlfQkFDS0xJR0hUPXkNCiMgQ09ORklHX0ZCX1MzIGlzIG5vdCBz
ZXQNCkNPTkZJR19GQl9TQVZBR0U9bQ0KQ09ORklHX0ZCX1NBVkFHRV9JMkM9
eQ0KQ09ORklHX0ZCX1NBVkFHRV9BQ0NFTD15DQpDT05GSUdfRkJfU0lTPW0N
CiMgQ09ORklHX0ZCX1NJU18zMDAgaXMgbm90IHNldA0KQ09ORklHX0ZCX1NJ
U18zMTU9eQ0KIyBDT05GSUdfRkJfVklBIGlzIG5vdCBzZXQNCkNPTkZJR19G
Ql9ORU9NQUdJQz1tDQojIENPTkZJR19GQl9LWVJPIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0ZCXzNERlggaXMgbm90IHNldA0KQ09ORklHX0ZCX1ZPT0RPTzE9
bQ0KQ09ORklHX0ZCX1ZUODYyMz1tDQpDT05GSUdfRkJfVFJJREVOVD1tDQoj
IENPTkZJR19GQl9BUksgaXMgbm90IHNldA0KIyBDT05GSUdfRkJfUE0zIGlz
IG5vdCBzZXQNCkNPTkZJR19GQl9DQVJNSU5FPW0NCkNPTkZJR19GQl9DQVJN
SU5FX0RSQU1fRVZBTD15DQojIENPTkZJR19DQVJNSU5FX0RSQU1fQ1VTVE9N
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZCX0dFT0RFIGlzIG5vdCBzZXQNCkNP
TkZJR19GQl9UTUlPPW0NCkNPTkZJR19GQl9UTUlPX0FDQ0VMTD15DQpDT05G
SUdfRkJfU01TQ1VGWD1tDQpDT05GSUdfRkJfVURMPW0NCkNPTkZJR19GQl9H
T0xERklTSD1tDQpDT05GSUdfRkJfVklSVFVBTD1tDQpDT05GSUdfRkJfTUVU
Uk9OT01FPW0NCiMgQ09ORklHX0ZCX01CODYyWFggaXMgbm90IHNldA0KQ09O
RklHX0ZCX0JST0FEU0hFRVQ9bQ0KIyBDT05GSUdfRkJfQVVPX0sxOTBYIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0VYWU5PU19WSURFTyBpcyBub3Qgc2V0DQpD
T05GSUdfQkFDS0xJR0hUX0xDRF9TVVBQT1JUPXkNCiMgQ09ORklHX0xDRF9D
TEFTU19ERVZJQ0UgaXMgbm90IHNldA0KQ09ORklHX0JBQ0tMSUdIVF9DTEFT
U19ERVZJQ0U9eQ0KIyBDT05GSUdfQkFDS0xJR0hUX0dFTkVSSUMgaXMgbm90
IHNldA0KIyBDT05GSUdfQkFDS0xJR0hUX1BXTSBpcyBub3Qgc2V0DQpDT05G
SUdfQkFDS0xJR0hUX0FQUExFPXkNCkNPTkZJR19CQUNLTElHSFRfU0FIQVJB
PXkNCkNPTkZJR19CQUNLTElHSFRfQURQNTUyMD15DQojIENPTkZJR19CQUNL
TElHSFRfQURQODg2MCBpcyBub3Qgc2V0DQpDT05GSUdfQkFDS0xJR0hUX0FE
UDg4NzA9bQ0KIyBDT05GSUdfQkFDS0xJR0hUX1BDRjUwNjMzIGlzIG5vdCBz
ZXQNCkNPTkZJR19CQUNLTElHSFRfQUFUMjg3MD15DQojIENPTkZJR19CQUNL
TElHSFRfTE0zNjMwIGlzIG5vdCBzZXQNCkNPTkZJR19CQUNLTElHSFRfTE0z
NjM5PW0NCkNPTkZJR19CQUNLTElHSFRfTFA4NTVYPXkNCkNPTkZJR19CQUNL
TElHSFRfTFA4Nzg4PW0NCiMgQ09ORklHX0JBQ0tMSUdIVF9BUzM3MTEgaXMg
bm90IHNldA0KQ09ORklHX0xPR089eQ0KIyBDT05GSUdfTE9HT19MSU5VWF9N
T05PIGlzIG5vdCBzZXQNCiMgQ09ORklHX0xPR09fTElOVVhfVkdBMTYgaXMg
bm90IHNldA0KIyBDT05GSUdfTE9HT19MSU5VWF9DTFVUMjI0IGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1NPVU5EIGlzIG5vdCBzZXQNCg0KIw0KIyBISUQgc3Vw
cG9ydA0KIw0KQ09ORklHX0hJRD1tDQojIENPTkZJR19ISURSQVcgaXMgbm90
IHNldA0KQ09ORklHX1VISUQ9bQ0KIyBDT05GSUdfSElEX0dFTkVSSUMgaXMg
bm90IHNldA0KDQojDQojIFNwZWNpYWwgSElEIGRyaXZlcnMNCiMNCiMgQ09O
RklHX0hJRF9BNFRFQ0ggaXMgbm90IHNldA0KQ09ORklHX0hJRF9BQ1JVWD1t
DQojIENPTkZJR19ISURfQUNSVVhfRkYgaXMgbm90IHNldA0KQ09ORklHX0hJ
RF9BUFBMRT1tDQojIENPTkZJR19ISURfQVBQTEVJUiBpcyBub3Qgc2V0DQpD
T05GSUdfSElEX0FVUkVBTD1tDQojIENPTkZJR19ISURfQkVMS0lOIGlzIG5v
dCBzZXQNCkNPTkZJR19ISURfQ0hFUlJZPW0NCiMgQ09ORklHX0hJRF9DSElD
T05ZIGlzIG5vdCBzZXQNCkNPTkZJR19ISURfQ1lQUkVTUz1tDQpDT05GSUdf
SElEX0RSQUdPTlJJU0U9bQ0KIyBDT05GSUdfRFJBR09OUklTRV9GRiBpcyBu
b3Qgc2V0DQpDT05GSUdfSElEX0VNU19GRj1tDQpDT05GSUdfSElEX0VMRUNP
TT1tDQpDT05GSUdfSElEX0VaS0VZPW0NCiMgQ09ORklHX0hJRF9IT0xURUsg
aXMgbm90IHNldA0KQ09ORklHX0hJRF9LRVlUT1VDSD1tDQpDT05GSUdfSElE
X0tZRT1tDQpDT05GSUdfSElEX1VDTE9HSUM9bQ0KIyBDT05GSUdfSElEX1dB
TFRPUCBpcyBub3Qgc2V0DQojIENPTkZJR19ISURfR1lSQVRJT04gaXMgbm90
IHNldA0KQ09ORklHX0hJRF9JQ0FERT1tDQpDT05GSUdfSElEX1RXSU5IQU49
bQ0KIyBDT05GSUdfSElEX0tFTlNJTkdUT04gaXMgbm90IHNldA0KQ09ORklH
X0hJRF9MQ1BPV0VSPW0NCkNPTkZJR19ISURfTEVOT1ZPX1RQS0JEPW0NCkNP
TkZJR19ISURfTE9HSVRFQ0g9bQ0KQ09ORklHX0hJRF9MT0dJVEVDSF9ESj1t
DQojIENPTkZJR19MT0dJVEVDSF9GRiBpcyBub3Qgc2V0DQojIENPTkZJR19M
T0dJUlVNQkxFUEFEMl9GRiBpcyBub3Qgc2V0DQpDT05GSUdfTE9HSUc5NDBf
RkY9eQ0KIyBDT05GSUdfTE9HSVdIRUVMU19GRiBpcyBub3Qgc2V0DQpDT05G
SUdfSElEX01BR0lDTU9VU0U9bQ0KQ09ORklHX0hJRF9NSUNST1NPRlQ9bQ0K
Q09ORklHX0hJRF9NT05URVJFWT1tDQpDT05GSUdfSElEX01VTFRJVE9VQ0g9
bQ0KQ09ORklHX0hJRF9OVFJJRz1tDQpDT05GSUdfSElEX09SVEVLPW0NCkNP
TkZJR19ISURfUEFOVEhFUkxPUkQ9bQ0KIyBDT05GSUdfUEFOVEhFUkxPUkRf
RkYgaXMgbm90IHNldA0KQ09ORklHX0hJRF9QRVRBTFlOWD1tDQojIENPTkZJ
R19ISURfUElDT0xDRCBpcyBub3Qgc2V0DQojIENPTkZJR19ISURfUFJJTUFY
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0hJRF9QUzNSRU1PVEUgaXMgbm90IHNl
dA0KQ09ORklHX0hJRF9ST0NDQVQ9bQ0KQ09ORklHX0hJRF9TQUlURUs9bQ0K
IyBDT05GSUdfSElEX1NBTVNVTkcgaXMgbm90IHNldA0KQ09ORklHX0hJRF9T
T05ZPW0NCkNPTkZJR19ISURfU1BFRURMSU5LPW0NCiMgQ09ORklHX0hJRF9T
VEVFTFNFUklFUyBpcyBub3Qgc2V0DQojIENPTkZJR19ISURfU1VOUExVUyBp
cyBub3Qgc2V0DQpDT05GSUdfSElEX0dSRUVOQVNJQT1tDQojIENPTkZJR19H
UkVFTkFTSUFfRkYgaXMgbm90IHNldA0KQ09ORklHX0hJRF9TTUFSVEpPWVBM
VVM9bQ0KQ09ORklHX1NNQVJUSk9ZUExVU19GRj15DQojIENPTkZJR19ISURf
VElWTyBpcyBub3Qgc2V0DQpDT05GSUdfSElEX1RPUFNFRUQ9bQ0KQ09ORklH
X0hJRF9USElOR009bQ0KIyBDT05GSUdfSElEX1RIUlVTVE1BU1RFUiBpcyBu
b3Qgc2V0DQpDT05GSUdfSElEX1dBQ09NPW0NCkNPTkZJR19ISURfV0lJTU9U
RT1tDQojIENPTkZJR19ISURfV0lJTU9URV9FWFQgaXMgbm90IHNldA0KQ09O
RklHX0hJRF9aRVJPUExVUz1tDQpDT05GSUdfWkVST1BMVVNfRkY9eQ0KIyBD
T05GSUdfSElEX1pZREFDUk9OIGlzIG5vdCBzZXQNCiMgQ09ORklHX0hJRF9T
RU5TT1JfSFVCIGlzIG5vdCBzZXQNCg0KIw0KIyBVU0IgSElEIHN1cHBvcnQN
CiMNCkNPTkZJR19VU0JfSElEPW0NCkNPTkZJR19ISURfUElEPXkNCkNPTkZJ
R19VU0JfSElEREVWPXkNCg0KIw0KIyBVU0IgSElEIEJvb3QgUHJvdG9jb2wg
ZHJpdmVycw0KIw0KQ09ORklHX1VTQl9LQkQ9bQ0KQ09ORklHX1VTQl9NT1VT
RT1tDQoNCiMNCiMgSTJDIEhJRCBzdXBwb3J0DQojDQpDT05GSUdfSTJDX0hJ
RD1tDQpDT05GSUdfVVNCX0FSQ0hfSEFTX09IQ0k9eQ0KQ09ORklHX1VTQl9B
UkNIX0hBU19FSENJPXkNCkNPTkZJR19VU0JfQVJDSF9IQVNfWEhDST15DQpD
T05GSUdfVVNCX1NVUFBPUlQ9eQ0KQ09ORklHX1VTQl9DT01NT049bQ0KQ09O
RklHX1VTQl9BUkNIX0hBU19IQ0Q9eQ0KQ09ORklHX1VTQj1tDQpDT05GSUdf
VVNCX0RFQlVHPXkNCkNPTkZJR19VU0JfQU5OT1VOQ0VfTkVXX0RFVklDRVM9
eQ0KDQojDQojIE1pc2NlbGxhbmVvdXMgVVNCIG9wdGlvbnMNCiMNCiMgQ09O
RklHX1VTQl9ERUZBVUxUX1BFUlNJU1QgaXMgbm90IHNldA0KIyBDT05GSUdf
VVNCX0RZTkFNSUNfTUlOT1JTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9P
VEdfV0hJVEVMSVNUIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9PVEdfQkxB
Q0tMSVNUX0hVQiBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX01PTj1tDQpDT05G
SUdfVVNCX1dVU0I9bQ0KIyBDT05GSUdfVVNCX1dVU0JfQ0JBRiBpcyBub3Qg
c2V0DQoNCiMNCiMgVVNCIEhvc3QgQ29udHJvbGxlciBEcml2ZXJzDQojDQoj
IENPTkZJR19VU0JfQzY3WDAwX0hDRCBpcyBub3Qgc2V0DQojIENPTkZJR19V
U0JfWEhDSV9IQ0QgaXMgbm90IHNldA0KQ09ORklHX1VTQl9FSENJX0hDRD1t
DQpDT05GSUdfVVNCX0VIQ0lfUk9PVF9IVUJfVFQ9eQ0KQ09ORklHX1VTQl9F
SENJX1RUX05FV1NDSEVEPXkNCkNPTkZJR19VU0JfRUhDSV9QQ0k9bQ0KIyBD
T05GSUdfVVNCX0VIQ0lfSENEX1BMQVRGT1JNIGlzIG5vdCBzZXQNCkNPTkZJ
R19VU0JfT1hVMjEwSFBfSENEPW0NCkNPTkZJR19VU0JfSVNQMTE2WF9IQ0Q9
bQ0KQ09ORklHX1VTQl9JU1AxNzYwX0hDRD1tDQpDT05GSUdfVVNCX0lTUDEz
NjJfSENEPW0NCkNPTkZJR19VU0JfT0hDSV9IQ0Q9bQ0KQ09ORklHX1VTQl9P
SENJX0hDRF9QTEFURk9STT15DQojIENPTkZJR19VU0JfT0hDSV9CSUdfRU5E
SUFOX0RFU0MgaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX09IQ0lfQklHX0VO
RElBTl9NTUlPIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfT0hDSV9MSVRUTEVf
RU5ESUFOPXkNCkNPTkZJR19VU0JfVUhDSV9IQ0Q9bQ0KIyBDT05GSUdfVVNC
X1UxMzJfSENEIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfU0w4MTFfSENEPW0N
CkNPTkZJR19VU0JfU0w4MTFfSENEX0lTTz15DQojIENPTkZJR19VU0JfUjhB
NjY1OTdfSENEIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9SRU5FU0FTX1VT
QkhTX0hDRCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1dIQ0lfSENEPW0NCiMg
Q09ORklHX1VTQl9IV0FfSENEIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9N
VVNCX0hEUkMgaXMgbm90IHNldA0KQ09ORklHX1VTQl9SRU5FU0FTX1VTQkhT
PW0NCg0KIw0KIyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMNCiMNCiMgQ09O
RklHX1VTQl9QUklOVEVSIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfV0RNPW0N
CkNPTkZJR19VU0JfVE1DPW0NCg0KIw0KIyBOT1RFOiBVU0JfU1RPUkFHRSBk
ZXBlbmRzIG9uIFNDU0kgYnV0IEJMS19ERVZfU0QgbWF5DQojDQoNCiMNCiMg
YWxzbyBiZSBuZWVkZWQ7IHNlZSBVU0JfU1RPUkFHRSBIZWxwIGZvciBtb3Jl
IGluZm8NCiMNCkNPTkZJR19VU0JfU1RPUkFHRT1tDQpDT05GSUdfVVNCX1NU
T1JBR0VfREVCVUc9eQ0KIyBDT05GSUdfVVNCX1NUT1JBR0VfUkVBTFRFSyBp
cyBub3Qgc2V0DQojIENPTkZJR19VU0JfU1RPUkFHRV9EQVRBRkFCIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1VTQl9TVE9SQUdFX0ZSRUVDT00gaXMgbm90IHNl
dA0KQ09ORklHX1VTQl9TVE9SQUdFX0lTRDIwMD1tDQpDT05GSUdfVVNCX1NU
T1JBR0VfVVNCQVQ9bQ0KQ09ORklHX1VTQl9TVE9SQUdFX1NERFIwOT1tDQpD
T05GSUdfVVNCX1NUT1JBR0VfU0REUjU1PW0NCkNPTkZJR19VU0JfU1RPUkFH
RV9KVU1QU0hPVD1tDQojIENPTkZJR19VU0JfU1RPUkFHRV9BTEFVREEgaXMg
bm90IHNldA0KQ09ORklHX1VTQl9TVE9SQUdFX09ORVRPVUNIPW0NCkNPTkZJ
R19VU0JfU1RPUkFHRV9LQVJNQT1tDQpDT05GSUdfVVNCX1NUT1JBR0VfQ1lQ
UkVTU19BVEFDQj1tDQpDT05GSUdfVVNCX1NUT1JBR0VfRU5FX1VCNjI1MD1t
DQoNCiMNCiMgVVNCIEltYWdpbmcgZGV2aWNlcw0KIw0KIyBDT05GSUdfVVNC
X01EQzgwMCBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfTUlDUk9URUsgaXMg
bm90IHNldA0KIyBDT05GSUdfVVNCX0RXQzMgaXMgbm90IHNldA0KIyBDT05G
SUdfVVNCX0NISVBJREVBIGlzIG5vdCBzZXQNCg0KIw0KIyBVU0IgcG9ydCBk
cml2ZXJzDQojDQoNCiMNCiMgVVNCIE1pc2NlbGxhbmVvdXMgZHJpdmVycw0K
Iw0KIyBDT05GSUdfVVNCX0VNSTYyIGlzIG5vdCBzZXQNCkNPTkZJR19VU0Jf
RU1JMjY9bQ0KQ09ORklHX1VTQl9BRFVUVVg9bQ0KQ09ORklHX1VTQl9TRVZT
RUc9bQ0KIyBDT05GSUdfVVNCX1JJTzUwMCBpcyBub3Qgc2V0DQpDT05GSUdf
VVNCX0xFR09UT1dFUj1tDQpDT05GSUdfVVNCX0xDRD1tDQpDT05GSUdfVVNC
X0xFRD1tDQojIENPTkZJR19VU0JfQ1lQUkVTU19DWTdDNjMgaXMgbm90IHNl
dA0KIyBDT05GSUdfVVNCX0NZVEhFUk0gaXMgbm90IHNldA0KQ09ORklHX1VT
Ql9JRE1PVVNFPW0NCkNPTkZJR19VU0JfRlRESV9FTEFOPW0NCiMgQ09ORklH
X1VTQl9BUFBMRURJU1BMQVkgaXMgbm90IHNldA0KQ09ORklHX1VTQl9TSVNV
U0JWR0E9bQ0KQ09ORklHX1VTQl9MRD1tDQojIENPTkZJR19VU0JfVFJBTkNF
VklCUkFUT1IgaXMgbm90IHNldA0KQ09ORklHX1VTQl9JT1dBUlJJT1I9bQ0K
Q09ORklHX1VTQl9URVNUPW0NCiMgQ09ORklHX1VTQl9JU0lHSFRGVyBpcyBu
b3Qgc2V0DQojIENPTkZJR19VU0JfWVVSRVggaXMgbm90IHNldA0KQ09ORklH
X1VTQl9FWlVTQl9GWDI9bQ0KQ09ORklHX1VTQl9IU0lDX1VTQjM1MDM9bQ0K
IyBDT05GSUdfVVNCX0FUTSBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfUEhZ
IGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfR0FER0VUPW0NCiMgQ09ORklHX1VT
Ql9HQURHRVRfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX1VTQl9HQURHRVRf
REVCVUdfRklMRVM9eQ0KIyBDT05GSUdfVVNCX0dBREdFVF9ERUJVR19GUyBp
cyBub3Qgc2V0DQpDT05GSUdfVVNCX0dBREdFVF9WQlVTX0RSQVc9Mg0KQ09O
RklHX1VTQl9HQURHRVRfU1RPUkFHRV9OVU1fQlVGRkVSUz0yDQoNCiMNCiMg
VVNCIFBlcmlwaGVyYWwgQ29udHJvbGxlcg0KIw0KIyBDT05GSUdfVVNCX1I4
QTY2NTk3IGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9SRU5FU0FTX1VTQkhT
X1VEQyBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1BYQTI3WD1tDQpDT05GSUdf
VVNCX01WX1VEQz1tDQojIENPTkZJR19VU0JfTVZfVTNEIGlzIG5vdCBzZXQN
CkNPTkZJR19VU0JfTTY2NTkyPW0NCkNPTkZJR19VU0JfQU1ENTUzNlVEQz1t
DQojIENPTkZJR19VU0JfTkVUMjI3MiBpcyBub3Qgc2V0DQpDT05GSUdfVVNC
X05FVDIyODA9bQ0KQ09ORklHX1VTQl9HT0tVPW0NCkNPTkZJR19VU0JfRUcy
MFQ9bQ0KIyBDT05GSUdfVVNCX0RVTU1ZX0hDRCBpcyBub3Qgc2V0DQpDT05G
SUdfVVNCX0xJQkNPTVBPU0lURT1tDQpDT05GSUdfVVNCX0ZfU1NfTEI9bQ0K
Q09ORklHX1VTQl9aRVJPPW0NCiMgQ09ORklHX1VTQl9FVEggaXMgbm90IHNl
dA0KQ09ORklHX1VTQl9HX05DTT1tDQpDT05GSUdfVVNCX0dBREdFVEZTPW0N
CkNPTkZJR19VU0JfRlVOQ1RJT05GUz1tDQpDT05GSUdfVVNCX0ZVTkNUSU9O
RlNfRVRIPXkNCkNPTkZJR19VU0JfRlVOQ1RJT05GU19STkRJUz15DQojIENP
TkZJR19VU0JfRlVOQ1RJT05GU19HRU5FUklDIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1VTQl9NQVNTX1NUT1JBR0UgaXMgbm90IHNldA0KIyBDT05GSUdfVVNC
X0dfUFJJTlRFUiBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfR19ISUQgaXMg
bm90IHNldA0KQ09ORklHX1VXQj15DQojIENPTkZJR19VV0JfSFdBIGlzIG5v
dCBzZXQNCkNPTkZJR19VV0JfV0hDST15DQojIENPTkZJR19NTUMgaXMgbm90
IHNldA0KQ09ORklHX01FTVNUSUNLPXkNCkNPTkZJR19NRU1TVElDS19ERUJV
Rz15DQoNCiMNCiMgTWVtb3J5U3RpY2sgZHJpdmVycw0KIw0KIyBDT05GSUdf
TUVNU1RJQ0tfVU5TQUZFX1JFU1VNRSBpcyBub3Qgc2V0DQpDT05GSUdfTVNQ
Uk9fQkxPQ0s9eQ0KDQojDQojIE1lbW9yeVN0aWNrIEhvc3QgQ29udHJvbGxl
ciBEcml2ZXJzDQojDQpDT05GSUdfTUVNU1RJQ0tfVElGTV9NUz1tDQpDT05G
SUdfTUVNU1RJQ0tfSk1JQ1JPTl8zOFg9bQ0KIyBDT05GSUdfTUVNU1RJQ0tf
UjU5MiBpcyBub3Qgc2V0DQpDT05GSUdfTUVNU1RJQ0tfUkVBTFRFS19QQ0k9
eQ0KQ09ORklHX05FV19MRURTPXkNCkNPTkZJR19MRURTX0NMQVNTPW0NCg0K
Iw0KIyBMRUQgZHJpdmVycw0KIw0KQ09ORklHX0xFRFNfTE0zNTMwPW0NCiMg
Q09ORklHX0xFRFNfTE0zNjQyIGlzIG5vdCBzZXQNCkNPTkZJR19MRURTX1BD
QTk1MzI9bQ0KQ09ORklHX0xFRFNfUENBOTUzMl9HUElPPXkNCkNPTkZJR19M
RURTX0dQSU89bQ0KQ09ORklHX0xFRFNfTFAzOTQ0PW0NCkNPTkZJR19MRURT
X0xQNTVYWF9DT01NT049bQ0KQ09ORklHX0xFRFNfTFA1NTIxPW0NCiMgQ09O
RklHX0xFRFNfTFA1NTIzIGlzIG5vdCBzZXQNCkNPTkZJR19MRURTX0xQNTU2
Mj1tDQpDT05GSUdfTEVEU19MUDg3ODg9bQ0KIyBDT05GSUdfTEVEU19QQ0E5
NTVYIGlzIG5vdCBzZXQNCkNPTkZJR19MRURTX1BDQTk2MzM9bQ0KQ09ORklH
X0xFRFNfV004MzUwPW0NCkNPTkZJR19MRURTX1BXTT1tDQojIENPTkZJR19M
RURTX0JEMjgwMiBpcyBub3Qgc2V0DQpDT05GSUdfTEVEU19MVDM1OTM9bQ0K
Q09ORklHX0xFRFNfQURQNTUyMD1tDQpDT05GSUdfTEVEU19ERUxMX05FVEJP
T0tTPW0NCkNPTkZJR19MRURTX01DMTM3ODM9bQ0KQ09ORklHX0xFRFNfVENB
NjUwNz1tDQojIENPTkZJR19MRURTX0xNMzU1eCBpcyBub3Qgc2V0DQpDT05G
SUdfTEVEU19PVDIwMD1tDQojIENPTkZJR19MRURTX0JMSU5LTSBpcyBub3Qg
c2V0DQoNCiMNCiMgTEVEIFRyaWdnZXJzDQojDQpDT05GSUdfTEVEU19UUklH
R0VSUz15DQpDT05GSUdfTEVEU19UUklHR0VSX1RJTUVSPXkNCkNPTkZJR19M
RURTX1RSSUdHRVJfT05FU0hPVD1tDQpDT05GSUdfTEVEU19UUklHR0VSX0hF
QVJUQkVBVD15DQpDT05GSUdfTEVEU19UUklHR0VSX0JBQ0tMSUdIVD15DQpD
T05GSUdfTEVEU19UUklHR0VSX0NQVT15DQojIENPTkZJR19MRURTX1RSSUdH
RVJfR1BJTyBpcyBub3Qgc2V0DQpDT05GSUdfTEVEU19UUklHR0VSX0RFRkFV
TFRfT049bQ0KDQojDQojIGlwdGFibGVzIHRyaWdnZXIgaXMgdW5kZXIgTmV0
ZmlsdGVyIGNvbmZpZyAoTEVEIHRhcmdldCkNCiMNCkNPTkZJR19MRURTX1RS
SUdHRVJfVFJBTlNJRU5UPW0NCiMgQ09ORklHX0xFRFNfVFJJR0dFUl9DQU1F
UkEgaXMgbm90IHNldA0KQ09ORklHX0FDQ0VTU0lCSUxJVFk9eQ0KQ09ORklH
X0lORklOSUJBTkQ9eQ0KIyBDT05GSUdfSU5GSU5JQkFORF9VU0VSX01BRCBp
cyBub3Qgc2V0DQojIENPTkZJR19JTkZJTklCQU5EX1VTRVJfQUNDRVNTIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0lORklOSUJBTkRfTVRIQ0EgaXMgbm90IHNl
dA0KQ09ORklHX0lORklOSUJBTkRfUUlCPXkNCiMgQ09ORklHX01MWDRfSU5G
SU5JQkFORCBpcyBub3Qgc2V0DQojIENPTkZJR19JTkZJTklCQU5EX09DUkRN
QSBpcyBub3Qgc2V0DQpDT05GSUdfSU5GSU5JQkFORF9TUlA9bQ0KIyBDT05G
SUdfRURBQyBpcyBub3Qgc2V0DQpDT05GSUdfUlRDX0xJQj15DQojIENPTkZJ
R19SVENfQ0xBU1MgaXMgbm90IHNldA0KIyBDT05GSUdfRE1BREVWSUNFUyBp
cyBub3Qgc2V0DQojIENPTkZJR19BVVhESVNQTEFZIGlzIG5vdCBzZXQNCkNP
TkZJR19VSU89eQ0KQ09ORklHX1VJT19DSUY9bQ0KIyBDT05GSUdfVUlPX1BE
UlYgaXMgbm90IHNldA0KIyBDT05GSUdfVUlPX1BEUlZfR0VOSVJRIGlzIG5v
dCBzZXQNCkNPTkZJR19VSU9fRE1FTV9HRU5JUlE9eQ0KQ09ORklHX1VJT19B
RUM9eQ0KIyBDT05GSUdfVUlPX1NFUkNPUzMgaXMgbm90IHNldA0KIyBDT05G
SUdfVUlPX1BDSV9HRU5FUklDIGlzIG5vdCBzZXQNCkNPTkZJR19VSU9fTkVU
WD1tDQpDT05GSUdfVklSVF9EUklWRVJTPXkNCkNPTkZJR19WSVJUSU89eQ0K
DQojDQojIFZpcnRpbyBkcml2ZXJzDQojDQpDT05GSUdfVklSVElPX1BDST15
DQpDT05GSUdfVklSVElPX0JBTExPT049eQ0KQ09ORklHX1ZJUlRJT19NTUlP
PW0NCkNPTkZJR19WSVJUSU9fTU1JT19DTURMSU5FX0RFVklDRVM9eQ0KDQoj
DQojIE1pY3Jvc29mdCBIeXBlci1WIGd1ZXN0IHN1cHBvcnQNCiMNCiMgQ09O
RklHX1NUQUdJTkcgaXMgbm90IHNldA0KQ09ORklHX1g4Nl9QTEFURk9STV9E
RVZJQ0VTPXkNCkNPTkZJR19BQ0VSX1dNST1tDQojIENPTkZJR19BQ0VSSERG
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0FTVVNfTEFQVE9QIGlzIG5vdCBzZXQN
CkNPTkZJR19ERUxMX0xBUFRPUD1tDQpDT05GSUdfREVMTF9XTUk9bQ0KQ09O
RklHX0RFTExfV01JX0FJTz1tDQpDT05GSUdfRlVKSVRTVV9MQVBUT1A9bQ0K
IyBDT05GSUdfRlVKSVRTVV9MQVBUT1BfREVCVUcgaXMgbm90IHNldA0KQ09O
RklHX0ZVSklUU1VfVEFCTEVUPW0NCkNPTkZJR19BTUlMT19SRktJTEw9eQ0K
Q09ORklHX0hQX0FDQ0VMPW0NCkNPTkZJR19IUF9XTUk9bQ0KQ09ORklHX01T
SV9MQVBUT1A9bQ0KQ09ORklHX1BBTkFTT05JQ19MQVBUT1A9bQ0KIyBDT05G
SUdfQ09NUEFMX0xBUFRPUCBpcyBub3Qgc2V0DQojIENPTkZJR19TT05ZX0xB
UFRPUCBpcyBub3Qgc2V0DQpDT05GSUdfSURFQVBBRF9MQVBUT1A9bQ0KQ09O
RklHX1RISU5LUEFEX0FDUEk9bQ0KQ09ORklHX1RISU5LUEFEX0FDUElfREVC
VUdGQUNJTElUSUVTPXkNCiMgQ09ORklHX1RISU5LUEFEX0FDUElfREVCVUcg
aXMgbm90IHNldA0KIyBDT05GSUdfVEhJTktQQURfQUNQSV9VTlNBRkVfTEVE
UyBpcyBub3Qgc2V0DQpDT05GSUdfVEhJTktQQURfQUNQSV9WSURFTz15DQoj
IENPTkZJR19USElOS1BBRF9BQ1BJX0hPVEtFWV9QT0xMIGlzIG5vdCBzZXQN
CkNPTkZJR19TRU5TT1JTX0hEQVBTPW0NCkNPTkZJR19JTlRFTF9NRU5MT1c9
eQ0KQ09ORklHX0FDUElfV01JPXkNCkNPTkZJR19NU0lfV01JPW0NCiMgQ09O
RklHX1RPUFNUQVJfTEFQVE9QIGlzIG5vdCBzZXQNCkNPTkZJR19BQ1BJX1RP
U0hJQkE9bQ0KQ09ORklHX1RPU0hJQkFfQlRfUkZLSUxMPXkNCkNPTkZJR19B
Q1BJX0NNUEM9bQ0KIyBDT05GSUdfSU5URUxfSVBTIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0lCTV9SVEwgaXMgbm90IHNldA0KIyBDT05GSUdfWE8xNV9FQk9P
SyBpcyBub3Qgc2V0DQojIENPTkZJR19TQU1TVU5HX0xBUFRPUCBpcyBub3Qg
c2V0DQpDT05GSUdfTVhNX1dNST1tDQpDT05GSUdfSU5URUxfT0FLVFJBSUw9
eQ0KQ09ORklHX1NBTVNVTkdfUTEwPW0NCkNPTkZJR19BUFBMRV9HTVVYPW0N
Cg0KIw0KIyBIYXJkd2FyZSBTcGlubG9jayBkcml2ZXJzDQojDQpDT05GSUdf
Q0xLRVZUX0k4MjUzPXkNCkNPTkZJR19JODI1M19MT0NLPXkNCkNPTkZJR19D
TEtCTERfSTgyNTM9eQ0KQ09ORklHX01BSUxCT1g9eQ0KQ09ORklHX01CT1hf
S0ZJRk9fU0laRT0yNTYNCkNPTkZJR19NQk9YX0RBVEFfU0laRT00DQpDT05G
SUdfSU9NTVVfU1VQUE9SVD15DQojIENPTkZJR19BTURfSU9NTVUgaXMgbm90
IHNldA0KDQojDQojIFJlbW90ZXByb2MgZHJpdmVycw0KIw0KQ09ORklHX1JF
TU9URVBST0M9eQ0KQ09ORklHX1NURV9NT0RFTV9SUFJPQz15DQoNCiMNCiMg
UnBtc2cgZHJpdmVycw0KIw0KIyBDT05GSUdfUE1fREVWRlJFUSBpcyBub3Qg
c2V0DQojIENPTkZJR19FWFRDT04gaXMgbm90IHNldA0KQ09ORklHX01FTU9S
WT15DQpDT05GSUdfSUlPPW0NCkNPTkZJR19JSU9fQlVGRkVSPXkNCkNPTkZJ
R19JSU9fQlVGRkVSX0NCPXkNCkNPTkZJR19JSU9fS0ZJRk9fQlVGPW0NCkNP
TkZJR19JSU9fVFJJR0dFUkVEX0JVRkZFUj1tDQpDT05GSUdfSUlPX1RSSUdH
RVI9eQ0KQ09ORklHX0lJT19DT05TVU1FUlNfUEVSX1RSSUdHRVI9Mg0KDQoj
DQojIEFjY2VsZXJvbWV0ZXJzDQojDQpDT05GSUdfSUlPX1NUX0FDQ0VMXzNB
WElTPW0NCkNPTkZJR19JSU9fU1RfQUNDRUxfSTJDXzNBWElTPW0NCg0KIw0K
IyBBbmFsb2cgdG8gZGlnaXRhbCBjb252ZXJ0ZXJzDQojDQpDT05GSUdfTFA4
Nzg4X0FEQz15DQojIENPTkZJR19NQVgxMzYzIGlzIG5vdCBzZXQNCkNPTkZJ
R19USV9BREMwODFDPW0NCiMgQ09ORklHX1ZJUEVSQk9BUkRfQURDIGlzIG5v
dCBzZXQNCg0KIw0KIyBBbXBsaWZpZXJzDQojDQoNCiMNCiMgSGlkIFNlbnNv
ciBJSU8gQ29tbW9uDQojDQpDT05GSUdfSUlPX1NUX1NFTlNPUlNfSTJDPW0N
CkNPTkZJR19JSU9fU1RfU0VOU09SU19DT1JFPW0NCg0KIw0KIyBEaWdpdGFs
IHRvIGFuYWxvZyBjb252ZXJ0ZXJzDQojDQpDT05GSUdfQUQ1MDY0PW0NCkNP
TkZJR19BRDUzODA9bQ0KIyBDT05GSUdfQUQ1NDQ2IGlzIG5vdCBzZXQNCkNP
TkZJR19NQVg1MTc9bQ0KIyBDT05GSUdfTUNQNDcyNSBpcyBub3Qgc2V0DQoN
CiMNCiMgRnJlcXVlbmN5IFN5bnRoZXNpemVycyBERFMvUExMDQojDQoNCiMN
CiMgQ2xvY2sgR2VuZXJhdG9yL0Rpc3RyaWJ1dGlvbg0KIw0KDQojDQojIFBo
YXNlLUxvY2tlZCBMb29wIChQTEwpIGZyZXF1ZW5jeSBzeW50aGVzaXplcnMN
CiMNCg0KIw0KIyBEaWdpdGFsIGd5cm9zY29wZSBzZW5zb3JzDQojDQojIENP
TkZJR19JSU9fU1RfR1lST18zQVhJUyBpcyBub3Qgc2V0DQpDT05GSUdfSVRH
MzIwMD1tDQoNCiMNCiMgSW5lcnRpYWwgbWVhc3VyZW1lbnQgdW5pdHMNCiMN
CiMgQ09ORklHX0lOVl9NUFU2MDUwX0lJTyBpcyBub3Qgc2V0DQoNCiMNCiMg
TGlnaHQgc2Vuc29ycw0KIw0KIyBDT05GSUdfQURKRF9TMzExIGlzIG5vdCBz
ZXQNCkNPTkZJR19TRU5TT1JTX1RTTDI1NjM9bQ0KQ09ORklHX1ZDTkw0MDAw
PW0NCg0KIw0KIyBNYWduZXRvbWV0ZXIgc2Vuc29ycw0KIw0KQ09ORklHX0FL
ODk3NT1tDQpDT05GSUdfSUlPX1NUX01BR05fM0FYSVM9bQ0KQ09ORklHX0lJ
T19TVF9NQUdOX0kyQ18zQVhJUz1tDQojIENPTkZJR19OVEIgaXMgbm90IHNl
dA0KIyBDT05GSUdfVk1FX0JVUyBpcyBub3Qgc2V0DQpDT05GSUdfUFdNPXkN
CiMgQ09ORklHX0lQQUNLX0JVUyBpcyBub3Qgc2V0DQpDT05GSUdfUkVTRVRf
Q09OVFJPTExFUj15DQoNCiMNCiMgRmlybXdhcmUgRHJpdmVycw0KIw0KIyBD
T05GSUdfRUREIGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZJUk1XQVJFX01FTU1B
UCBpcyBub3Qgc2V0DQojIENPTkZJR19ERUxMX1JCVSBpcyBub3Qgc2V0DQpD
T05GSUdfRENEQkFTPXkNCiMgQ09ORklHX0lTQ1NJX0lCRlRfRklORCBpcyBu
b3Qgc2V0DQpDT05GSUdfR09PR0xFX0ZJUk1XQVJFPXkNCg0KIw0KIyBHb29n
bGUgRmlybXdhcmUgRHJpdmVycw0KIw0KDQojDQojIEVGSSAoRXh0ZW5zaWJs
ZSBGaXJtd2FyZSBJbnRlcmZhY2UpIFN1cHBvcnQNCiMNCkNPTkZJR19FRklf
VkFSUz1tDQpDT05GSUdfRUZJX1ZBUlNfUFNUT1JFPW0NCkNPTkZJR19FRklf
VkFSU19QU1RPUkVfREVGQVVMVF9ESVNBQkxFPXkNCg0KIw0KIyBGaWxlIHN5
c3RlbXMNCiMNCkNPTkZJR19EQ0FDSEVfV09SRF9BQ0NFU1M9eQ0KQ09ORklH
X0VYVDJfRlM9bQ0KIyBDT05GSUdfRVhUMl9GU19YQVRUUiBpcyBub3Qgc2V0
DQojIENPTkZJR19FWFQyX0ZTX1hJUCBpcyBub3Qgc2V0DQpDT05GSUdfRVhU
M19GUz1tDQojIENPTkZJR19FWFQzX0RFRkFVTFRTX1RPX09SREVSRUQgaXMg
bm90IHNldA0KQ09ORklHX0VYVDNfRlNfWEFUVFI9eQ0KQ09ORklHX0VYVDNf
RlNfUE9TSVhfQUNMPXkNCiMgQ09ORklHX0VYVDNfRlNfU0VDVVJJVFkgaXMg
bm90IHNldA0KIyBDT05GSUdfRVhUNF9GUyBpcyBub3Qgc2V0DQpDT05GSUdf
SkJEPW0NCkNPTkZJR19KQkRfREVCVUc9eQ0KQ09ORklHX0ZTX01CQ0FDSEU9
bQ0KQ09ORklHX1JFSVNFUkZTX0ZTPXkNCkNPTkZJR19SRUlTRVJGU19DSEVD
Sz15DQpDT05GSUdfUkVJU0VSRlNfUFJPQ19JTkZPPXkNCiMgQ09ORklHX1JF
SVNFUkZTX0ZTX1hBVFRSIGlzIG5vdCBzZXQNCiMgQ09ORklHX0pGU19GUyBp
cyBub3Qgc2V0DQojIENPTkZJR19YRlNfRlMgaXMgbm90IHNldA0KIyBDT05G
SUdfR0ZTMl9GUyBpcyBub3Qgc2V0DQojIENPTkZJR19PQ0ZTMl9GUyBpcyBu
b3Qgc2V0DQpDT05GSUdfQlRSRlNfRlM9bQ0KQ09ORklHX0JUUkZTX0ZTX1BP
U0lYX0FDTD15DQpDT05GSUdfQlRSRlNfRlNfQ0hFQ0tfSU5URUdSSVRZPXkN
CkNPTkZJR19OSUxGUzJfRlM9bQ0KQ09ORklHX0ZTX1BPU0lYX0FDTD15DQoj
IENPTkZJR19GSUxFX0xPQ0tJTkcgaXMgbm90IHNldA0KQ09ORklHX0ZTTk9U
SUZZPXkNCkNPTkZJR19ETk9USUZZPXkNCiMgQ09ORklHX0lOT1RJRllfVVNF
UiBpcyBub3Qgc2V0DQojIENPTkZJR19GQU5PVElGWSBpcyBub3Qgc2V0DQpD
T05GSUdfUVVPVEE9eQ0KQ09ORklHX1FVT1RBX05FVExJTktfSU5URVJGQUNF
PXkNCkNPTkZJR19QUklOVF9RVU9UQV9XQVJOSU5HPXkNCiMgQ09ORklHX1FV
T1RBX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19RVU9UQV9UUkVFPW0NCkNP
TkZJR19RRk1UX1YxPW0NCkNPTkZJR19RRk1UX1YyPW0NCkNPTkZJR19RVU9U
QUNUTD15DQpDT05GSUdfUVVPVEFDVExfQ09NUEFUPXkNCiMgQ09ORklHX0FV
VE9GUzRfRlMgaXMgbm90IHNldA0KIyBDT05GSUdfRlVTRV9GUyBpcyBub3Qg
c2V0DQoNCiMNCiMgQ2FjaGVzDQojDQojIENPTkZJR19GU0NBQ0hFIGlzIG5v
dCBzZXQNCg0KIw0KIyBDRC1ST00vRFZEIEZpbGVzeXN0ZW1zDQojDQpDT05G
SUdfSVNPOTY2MF9GUz1tDQojIENPTkZJR19KT0xJRVQgaXMgbm90IHNldA0K
Q09ORklHX1pJU09GUz15DQpDT05GSUdfVURGX0ZTPW0NCkNPTkZJR19VREZf
TkxTPXkNCg0KIw0KIyBET1MvRkFUL05UIEZpbGVzeXN0ZW1zDQojDQpDT05G
SUdfRkFUX0ZTPXkNCkNPTkZJR19NU0RPU19GUz15DQojIENPTkZJR19WRkFU
X0ZTIGlzIG5vdCBzZXQNCkNPTkZJR19GQVRfREVGQVVMVF9DT0RFUEFHRT00
MzcNCkNPTkZJR19OVEZTX0ZTPXkNCkNPTkZJR19OVEZTX0RFQlVHPXkNCiMg
Q09ORklHX05URlNfUlcgaXMgbm90IHNldA0KDQojDQojIFBzZXVkbyBmaWxl
c3lzdGVtcw0KIw0KQ09ORklHX1BST0NfRlM9eQ0KIyBDT05GSUdfUFJPQ19L
Q09SRSBpcyBub3Qgc2V0DQpDT05GSUdfUFJPQ19WTUNPUkU9eQ0KQ09ORklH
X1BST0NfU1lTQ1RMPXkNCkNPTkZJR19QUk9DX1BBR0VfTU9OSVRPUj15DQpD
T05GSUdfU1lTRlM9eQ0KQ09ORklHX1RNUEZTPXkNCiMgQ09ORklHX1RNUEZT
X1BPU0lYX0FDTCBpcyBub3Qgc2V0DQpDT05GSUdfVE1QRlNfWEFUVFI9eQ0K
IyBDT05GSUdfSFVHRVRMQkZTIGlzIG5vdCBzZXQNCiMgQ09ORklHX0hVR0VU
TEJfUEFHRSBpcyBub3Qgc2V0DQpDT05GSUdfQ09ORklHRlNfRlM9bQ0KQ09O
RklHX01JU0NfRklMRVNZU1RFTVM9eQ0KIyBDT05GSUdfQURGU19GUyBpcyBu
b3Qgc2V0DQojIENPTkZJR19BRkZTX0ZTIGlzIG5vdCBzZXQNCkNPTkZJR19F
Q1JZUFRfRlM9bQ0KQ09ORklHX0VDUllQVF9GU19NRVNTQUdJTkc9eQ0KQ09O
RklHX0hGU19GUz15DQpDT05GSUdfSEZTUExVU19GUz15DQpDT05GSUdfQkVG
U19GUz1tDQpDT05GSUdfQkVGU19ERUJVRz15DQpDT05GSUdfQkZTX0ZTPW0N
CkNPTkZJR19FRlNfRlM9eQ0KIyBDT05GSUdfSkZGUzJfRlMgaXMgbm90IHNl
dA0KQ09ORklHX1VCSUZTX0ZTPW0NCkNPTkZJR19VQklGU19GU19BRFZBTkNF
RF9DT01QUj15DQpDT05GSUdfVUJJRlNfRlNfTFpPPXkNCkNPTkZJR19VQklG
U19GU19aTElCPXkNCkNPTkZJR19MT0dGUz15DQpDT05GSUdfQ1JBTUZTPW0N
CiMgQ09ORklHX1NRVUFTSEZTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1ZYRlNf
RlMgaXMgbm90IHNldA0KQ09ORklHX01JTklYX0ZTPW0NCkNPTkZJR19PTUZT
X0ZTPXkNCiMgQ09ORklHX0hQRlNfRlMgaXMgbm90IHNldA0KQ09ORklHX1FO
WDRGU19GUz1tDQpDT05GSUdfUU5YNkZTX0ZTPXkNCkNPTkZJR19RTlg2RlNf
REVCVUc9eQ0KQ09ORklHX1JPTUZTX0ZTPW0NCiMgQ09ORklHX1JPTUZTX0JB
Q0tFRF9CWV9CTE9DSyBpcyBub3Qgc2V0DQojIENPTkZJR19ST01GU19CQUNL
RURfQllfTVREIGlzIG5vdCBzZXQNCkNPTkZJR19ST01GU19CQUNLRURfQllf
Qk9USD15DQpDT05GSUdfUk9NRlNfT05fQkxPQ0s9eQ0KQ09ORklHX1JPTUZT
X09OX01URD15DQpDT05GSUdfUFNUT1JFPXkNCiMgQ09ORklHX1BTVE9SRV9D
T05TT0xFIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BTVE9SRV9GVFJBQ0UgaXMg
bm90IHNldA0KIyBDT05GSUdfUFNUT1JFX1JBTSBpcyBub3Qgc2V0DQpDT05G
SUdfU1lTVl9GUz1tDQpDT05GSUdfVUZTX0ZTPXkNCkNPTkZJR19VRlNfRlNf
V1JJVEU9eQ0KIyBDT05GSUdfVUZTX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJ
R19FWE9GU19GUz1tDQpDT05GSUdfRVhPRlNfREVCVUc9eQ0KIyBDT05GSUdf
RjJGU19GUyBpcyBub3Qgc2V0DQojIENPTkZJR19FRklWQVJfRlMgaXMgbm90
IHNldA0KQ09ORklHX09SRT1tDQpDT05GSUdfTkVUV09SS19GSUxFU1lTVEVN
Uz15DQpDT05GSUdfTkxTPXkNCkNPTkZJR19OTFNfREVGQVVMVD0iaXNvODg1
OS0xIg0KQ09ORklHX05MU19DT0RFUEFHRV80Mzc9eQ0KQ09ORklHX05MU19D
T0RFUEFHRV83Mzc9bQ0KQ09ORklHX05MU19DT0RFUEFHRV83NzU9bQ0KQ09O
RklHX05MU19DT0RFUEFHRV84NTA9eQ0KIyBDT05GSUdfTkxTX0NPREVQQUdF
Xzg1MiBpcyBub3Qgc2V0DQpDT05GSUdfTkxTX0NPREVQQUdFXzg1NT1tDQoj
IENPTkZJR19OTFNfQ09ERVBBR0VfODU3IGlzIG5vdCBzZXQNCkNPTkZJR19O
TFNfQ09ERVBBR0VfODYwPXkNCkNPTkZJR19OTFNfQ09ERVBBR0VfODYxPW0N
CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjIgaXMgbm90IHNldA0KQ09ORklH
X05MU19DT0RFUEFHRV84NjM9eQ0KQ09ORklHX05MU19DT0RFUEFHRV84NjQ9
eQ0KQ09ORklHX05MU19DT0RFUEFHRV84NjU9bQ0KQ09ORklHX05MU19DT0RF
UEFHRV84NjY9bQ0KQ09ORklHX05MU19DT0RFUEFHRV84Njk9eQ0KIyBDT05G
SUdfTkxTX0NPREVQQUdFXzkzNiBpcyBub3Qgc2V0DQojIENPTkZJR19OTFNf
Q09ERVBBR0VfOTUwIGlzIG5vdCBzZXQNCkNPTkZJR19OTFNfQ09ERVBBR0Vf
OTMyPXkNCiMgQ09ORklHX05MU19DT0RFUEFHRV85NDkgaXMgbm90IHNldA0K
Q09ORklHX05MU19DT0RFUEFHRV84NzQ9eQ0KQ09ORklHX05MU19JU084ODU5
Xzg9bQ0KQ09ORklHX05MU19DT0RFUEFHRV8xMjUwPXkNCkNPTkZJR19OTFNf
Q09ERVBBR0VfMTI1MT15DQojIENPTkZJR19OTFNfQVNDSUkgaXMgbm90IHNl
dA0KIyBDT05GSUdfTkxTX0lTTzg4NTlfMSBpcyBub3Qgc2V0DQojIENPTkZJ
R19OTFNfSVNPODg1OV8yIGlzIG5vdCBzZXQNCkNPTkZJR19OTFNfSVNPODg1
OV8zPXkNCiMgQ09ORklHX05MU19JU084ODU5XzQgaXMgbm90IHNldA0KQ09O
RklHX05MU19JU084ODU5XzU9eQ0KQ09ORklHX05MU19JU084ODU5XzY9eQ0K
Q09ORklHX05MU19JU084ODU5Xzc9eQ0KQ09ORklHX05MU19JU084ODU5Xzk9
eQ0KIyBDT05GSUdfTkxTX0lTTzg4NTlfMTMgaXMgbm90IHNldA0KQ09ORklH
X05MU19JU084ODU5XzE0PW0NCkNPTkZJR19OTFNfSVNPODg1OV8xNT15DQoj
IENPTkZJR19OTFNfS09JOF9SIGlzIG5vdCBzZXQNCkNPTkZJR19OTFNfS09J
OF9VPXkNCiMgQ09ORklHX05MU19NQUNfUk9NQU4gaXMgbm90IHNldA0KIyBD
T05GSUdfTkxTX01BQ19DRUxUSUMgaXMgbm90IHNldA0KQ09ORklHX05MU19N
QUNfQ0VOVEVVUk89eQ0KQ09ORklHX05MU19NQUNfQ1JPQVRJQU49eQ0KQ09O
RklHX05MU19NQUNfQ1lSSUxMSUM9eQ0KIyBDT05GSUdfTkxTX01BQ19HQUVM
SUMgaXMgbm90IHNldA0KQ09ORklHX05MU19NQUNfR1JFRUs9eQ0KQ09ORklH
X05MU19NQUNfSUNFTEFORD15DQojIENPTkZJR19OTFNfTUFDX0lOVUlUIGlz
IG5vdCBzZXQNCiMgQ09ORklHX05MU19NQUNfUk9NQU5JQU4gaXMgbm90IHNl
dA0KIyBDT05GSUdfTkxTX01BQ19UVVJLSVNIIGlzIG5vdCBzZXQNCkNPTkZJ
R19OTFNfVVRGOD15DQoNCiMNCiMgS2VybmVsIGhhY2tpbmcNCiMNCkNPTkZJ
R19UUkFDRV9JUlFGTEFHU19TVVBQT1JUPXkNCkNPTkZJR19QUklOVEtfVElN
RT15DQpDT05GSUdfREVGQVVMVF9NRVNTQUdFX0xPR0xFVkVMPTQNCiMgQ09O
RklHX0VOQUJMRV9XQVJOX0RFUFJFQ0FURUQgaXMgbm90IHNldA0KIyBDT05G
SUdfRU5BQkxFX01VU1RfQ0hFQ0sgaXMgbm90IHNldA0KQ09ORklHX0ZSQU1F
X1dBUk49MjA0OA0KQ09ORklHX01BR0lDX1NZU1JRPXkNCiMgQ09ORklHX1NU
UklQX0FTTV9TWU1TIGlzIG5vdCBzZXQNCkNPTkZJR19SRUFEQUJMRV9BU009
eQ0KQ09ORklHX1VOVVNFRF9TWU1CT0xTPXkNCkNPTkZJR19ERUJVR19GUz15
DQpDT05GSUdfSEVBREVSU19DSEVDSz15DQojIENPTkZJR19ERUJVR19TRUNU
SU9OX01JU01BVENIIGlzIG5vdCBzZXQNCkNPTkZJR19ERUJVR19LRVJORUw9
eQ0KIyBDT05GSUdfREVCVUdfU0hJUlEgaXMgbm90IHNldA0KIyBDT05GSUdf
TE9DS1VQX0RFVEVDVE9SIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BBTklDX09O
X09PUFMgaXMgbm90IHNldA0KQ09ORklHX1BBTklDX09OX09PUFNfVkFMVUU9
MA0KQ09ORklHX0RFVEVDVF9IVU5HX1RBU0s9eQ0KQ09ORklHX0RFRkFVTFRf
SFVOR19UQVNLX1RJTUVPVVQ9MTIwDQpDT05GSUdfQk9PVFBBUkFNX0hVTkdf
VEFTS19QQU5JQz15DQpDT05GSUdfQk9PVFBBUkFNX0hVTkdfVEFTS19QQU5J
Q19WQUxVRT0xDQpDT05GSUdfU0NIRURfREVCVUc9eQ0KQ09ORklHX1NDSEVE
U1RBVFM9eQ0KQ09ORklHX1RJTUVSX1NUQVRTPXkNCkNPTkZJR19ERUJVR19P
QkpFQ1RTPXkNCkNPTkZJR19ERUJVR19PQkpFQ1RTX1NFTEZURVNUPXkNCkNP
TkZJR19ERUJVR19PQkpFQ1RTX0ZSRUU9eQ0KQ09ORklHX0RFQlVHX09CSkVD
VFNfVElNRVJTPXkNCiMgQ09ORklHX0RFQlVHX09CSkVDVFNfV09SSyBpcyBu
b3Qgc2V0DQojIENPTkZJR19ERUJVR19PQkpFQ1RTX1JDVV9IRUFEIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0RFQlVHX09CSkVDVFNfUEVSQ1BVX0NPVU5URVIg
aXMgbm90IHNldA0KQ09ORklHX0RFQlVHX09CSkVDVFNfRU5BQkxFX0RFRkFV
TFQ9MQ0KQ09ORklHX1NMVUJfREVCVUdfT049eQ0KQ09ORklHX1NMVUJfU1RB
VFM9eQ0KQ09ORklHX0hBVkVfREVCVUdfS01FTUxFQUs9eQ0KIyBDT05GSUdf
REVCVUdfS01FTUxFQUsgaXMgbm90IHNldA0KQ09ORklHX0RFQlVHX1JUX01V
VEVYRVM9eQ0KQ09ORklHX0RFQlVHX1BJX0xJU1Q9eQ0KQ09ORklHX1JUX01V
VEVYX1RFU1RFUj15DQpDT05GSUdfREVCVUdfU1BJTkxPQ0s9eQ0KIyBDT05G
SUdfREVCVUdfTVVURVhFUyBpcyBub3Qgc2V0DQojIENPTkZJR19ERUJVR19M
T0NLX0FMTE9DIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BST1ZFX0xPQ0tJTkcg
aXMgbm90IHNldA0KIyBDT05GSUdfTE9DS19TVEFUIGlzIG5vdCBzZXQNCkNP
TkZJR19UUkFDRV9JUlFGTEFHUz15DQpDT05GSUdfREVCVUdfQVRPTUlDX1NM
RUVQPXkNCiMgQ09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUyBp
cyBub3Qgc2V0DQpDT05GSUdfU1RBQ0tUUkFDRT15DQojIENPTkZJR19ERUJV
R19TVEFDS19VU0FHRSBpcyBub3Qgc2V0DQpDT05GSUdfREVCVUdfS09CSkVD
VD15DQojIENPTkZJR19ERUJVR19JTkZPIGlzIG5vdCBzZXQNCiMgQ09ORklH
X0RFQlVHX1ZNIGlzIG5vdCBzZXQNCiMgQ09ORklHX0RFQlVHX1ZJUlRVQUwg
aXMgbm90IHNldA0KIyBDT05GSUdfREVCVUdfV1JJVEVDT1VOVCBpcyBub3Qg
c2V0DQpDT05GSUdfREVCVUdfTUVNT1JZX0lOSVQ9eQ0KQ09ORklHX0RFQlVH
X0xJU1Q9eQ0KIyBDT05GSUdfVEVTVF9MSVNUX1NPUlQgaXMgbm90IHNldA0K
Q09ORklHX0RFQlVHX1NHPXkNCiMgQ09ORklHX0RFQlVHX05PVElGSUVSUyBp
cyBub3Qgc2V0DQojIENPTkZJR19ERUJVR19DUkVERU5USUFMUyBpcyBub3Qg
c2V0DQpDT05GSUdfQVJDSF9XQU5UX0ZSQU1FX1BPSU5URVJTPXkNCkNPTkZJ
R19GUkFNRV9QT0lOVEVSPXkNCiMgQ09ORklHX0JPT1RfUFJJTlRLX0RFTEFZ
IGlzIG5vdCBzZXQNCg0KIw0KIyBSQ1UgRGVidWdnaW5nDQojDQpDT05GSUdf
U1BBUlNFX1JDVV9QT0lOVEVSPXkNCiMgQ09ORklHX1JDVV9UT1JUVVJFX1RF
U1QgaXMgbm90IHNldA0KIyBDT05GSUdfUkNVX1RSQUNFIGlzIG5vdCBzZXQN
CkNPTkZJR19LUFJPQkVTX1NBTklUWV9URVNUPXkNCiMgQ09ORklHX0JBQ0tU
UkFDRV9TRUxGX1RFU1QgaXMgbm90IHNldA0KQ09ORklHX0RFQlVHX0JMT0NL
X0VYVF9ERVZUPXkNCkNPTkZJR19ERUJVR19GT1JDRV9XRUFLX1BFUl9DUFU9
eQ0KIyBDT05GSUdfTEtEVE0gaXMgbm90IHNldA0KQ09ORklHX05PVElGSUVS
X0VSUk9SX0lOSkVDVElPTj1tDQpDT05GSUdfUE1fTk9USUZJRVJfRVJST1Jf
SU5KRUNUPW0NCiMgQ09ORklHX01FTU9SWV9OT1RJRklFUl9FUlJPUl9JTkpF
Q1QgaXMgbm90IHNldA0KIyBDT05GSUdfRkFVTFRfSU5KRUNUSU9OIGlzIG5v
dCBzZXQNCkNPTkZJR19MQVRFTkNZVE9QPXkNCkNPTkZJR19BUkNIX0hBU19E
RUJVR19TVFJJQ1RfVVNFUl9DT1BZX0NIRUNLUz15DQojIENPTkZJR19ERUJV
R19QQUdFQUxMT0MgaXMgbm90IHNldA0KQ09ORklHX1VTRVJfU1RBQ0tUUkFD
RV9TVVBQT1JUPXkNCkNPTkZJR19OT1BfVFJBQ0VSPXkNCkNPTkZJR19IQVZF
X0ZVTkNUSU9OX1RSQUNFUj15DQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQ
SF9UUkFDRVI9eQ0KQ09ORklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfRlBfVEVT
VD15DQpDT05GSUdfSEFWRV9GVU5DVElPTl9UUkFDRV9NQ09VTlRfVEVTVD15
DQpDT05GSUdfSEFWRV9EWU5BTUlDX0ZUUkFDRT15DQpDT05GSUdfSEFWRV9E
WU5BTUlDX0ZUUkFDRV9XSVRIX1JFR1M9eQ0KQ09ORklHX0hBVkVfRlRSQUNF
X01DT1VOVF9SRUNPUkQ9eQ0KQ09ORklHX0hBVkVfU1lTQ0FMTF9UUkFDRVBP
SU5UUz15DQpDT05GSUdfSEFWRV9GRU5UUlk9eQ0KQ09ORklHX0hBVkVfQ19S
RUNPUkRNQ09VTlQ9eQ0KQ09ORklHX1RSQUNFUl9NQVhfVFJBQ0U9eQ0KQ09O
RklHX1RSQUNFX0NMT0NLPXkNCkNPTkZJR19SSU5HX0JVRkZFUj15DQpDT05G
SUdfRVZFTlRfVFJBQ0lORz15DQpDT05GSUdfQ09OVEVYVF9TV0lUQ0hfVFJB
Q0VSPXkNCkNPTkZJR19SSU5HX0JVRkZFUl9BTExPV19TV0FQPXkNCkNPTkZJ
R19UUkFDSU5HPXkNCkNPTkZJR19HRU5FUklDX1RSQUNFUj15DQpDT05GSUdf
VFJBQ0lOR19TVVBQT1JUPXkNCkNPTkZJR19GVFJBQ0U9eQ0KQ09ORklHX0ZV
TkNUSU9OX1RSQUNFUj15DQojIENPTkZJR19GVU5DVElPTl9HUkFQSF9UUkFD
RVIgaXMgbm90IHNldA0KQ09ORklHX0lSUVNPRkZfVFJBQ0VSPXkNCiMgQ09O
RklHX1NDSEVEX1RSQUNFUiBpcyBub3Qgc2V0DQojIENPTkZJR19GVFJBQ0Vf
U1lTQ0FMTFMgaXMgbm90IHNldA0KQ09ORklHX1RSQUNFUl9TTkFQU0hPVD15
DQpDT05GSUdfVFJBQ0VSX1NOQVBTSE9UX1BFUl9DUFVfU1dBUD15DQpDT05G
SUdfVFJBQ0VfQlJBTkNIX1BST0ZJTElORz15DQojIENPTkZJR19CUkFOQ0hf
UFJPRklMRV9OT05FIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BST0ZJTEVfQU5O
T1RBVEVEX0JSQU5DSEVTIGlzIG5vdCBzZXQNCkNPTkZJR19QUk9GSUxFX0FM
TF9CUkFOQ0hFUz15DQpDT05GSUdfVFJBQ0lOR19CUkFOQ0hFUz15DQpDT05G
SUdfQlJBTkNIX1RSQUNFUj15DQojIENPTkZJR19TVEFDS19UUkFDRVIgaXMg
bm90IHNldA0KQ09ORklHX0JMS19ERVZfSU9fVFJBQ0U9eQ0KIyBDT05GSUdf
S1BST0JFX0VWRU5UIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VQUk9CRV9FVkVO
VCBpcyBub3Qgc2V0DQojIENPTkZJR19QUk9CRV9FVkVOVFMgaXMgbm90IHNl
dA0KIyBDT05GSUdfRFlOQU1JQ19GVFJBQ0UgaXMgbm90IHNldA0KIyBDT05G
SUdfRlVOQ1RJT05fUFJPRklMRVIgaXMgbm90IHNldA0KQ09ORklHX0ZUUkFD
RV9TRUxGVEVTVD15DQpDT05GSUdfRlRSQUNFX1NUQVJUVVBfVEVTVD15DQoj
IENPTkZJR19FVkVOVF9UUkFDRV9URVNUX1NZU0NBTExTIGlzIG5vdCBzZXQN
CiMgQ09ORklHX01NSU9UUkFDRSBpcyBub3Qgc2V0DQpDT05GSUdfUklOR19C
VUZGRVJfQkVOQ0hNQVJLPW0NCiMgQ09ORklHX1JJTkdfQlVGRkVSX1NUQVJU
VVBfVEVTVCBpcyBub3Qgc2V0DQpDT05GSUdfUkJUUkVFX1RFU1Q9bQ0KQ09O
RklHX0lOVEVSVkFMX1RSRUVfVEVTVD1tDQpDT05GSUdfUFJPVklERV9PSENJ
MTM5NF9ETUFfSU5JVD15DQpDT05GSUdfRklSRVdJUkVfT0hDSV9SRU1PVEVf
RE1BPXkNCkNPTkZJR19CVUlMRF9ET0NTUkM9eQ0KQ09ORklHX0RZTkFNSUNf
REVCVUc9eQ0KIyBDT05GSUdfRE1BX0FQSV9ERUJVRyBpcyBub3Qgc2V0DQpD
T05GSUdfQVRPTUlDNjRfU0VMRlRFU1Q9eQ0KQ09ORklHX1NBTVBMRVM9eQ0K
Q09ORklHX1NBTVBMRV9UUkFDRV9FVkVOVFM9bQ0KIyBDT05GSUdfU0FNUExF
X0tPQkpFQ1QgaXMgbm90IHNldA0KIyBDT05GSUdfU0FNUExFX0tQUk9CRVMg
aXMgbm90IHNldA0KQ09ORklHX1NBTVBMRV9IV19CUkVBS1BPSU5UPW0NCiMg
Q09ORklHX1NBTVBMRV9LRklGTyBpcyBub3Qgc2V0DQpDT05GSUdfU0FNUExF
X0tEQj1tDQpDT05GSUdfSEFWRV9BUkNIX0tHREI9eQ0KQ09ORklHX0tHREI9
eQ0KIyBDT05GSUdfS0dEQl9URVNUUyBpcyBub3Qgc2V0DQojIENPTkZJR19L
R0RCX0xPV19MRVZFTF9UUkFQIGlzIG5vdCBzZXQNCkNPTkZJR19LR0RCX0tE
Qj15DQpDT05GSUdfS0RCX0NPTlRJTlVFX0NBVEFTVFJPUEhJQz0wDQpDT05G
SUdfSEFWRV9BUkNIX0tNRU1DSEVDSz15DQpDT05GSUdfVEVTVF9TVFJJTkdf
SEVMUEVSUz1tDQpDT05GSUdfVEVTVF9LU1RSVE9YPW0NCiMgQ09ORklHX1NU
UklDVF9ERVZNRU0gaXMgbm90IHNldA0KQ09ORklHX1g4Nl9WRVJCT1NFX0JP
T1RVUD15DQpDT05GSUdfRUFSTFlfUFJJTlRLPXkNCiMgQ09ORklHX0VBUkxZ
X1BSSU5US19EQkdQIGlzIG5vdCBzZXQNCkNPTkZJR19ERUJVR19TVEFDS09W
RVJGTE9XPXkNCiMgQ09ORklHX1g4Nl9QVERVTVAgaXMgbm90IHNldA0KIyBD
T05GSUdfREVCVUdfUk9EQVRBIGlzIG5vdCBzZXQNCiMgQ09ORklHX0RFQlVH
X1NFVF9NT0RVTEVfUk9OWCBpcyBub3Qgc2V0DQpDT05GSUdfREVCVUdfTlhf
VEVTVD1tDQpDT05GSUdfREVCVUdfVExCRkxVU0g9eQ0KIyBDT05GSUdfSU9N
TVVfU1RSRVNTIGlzIG5vdCBzZXQNCkNPTkZJR19IQVZFX01NSU9UUkFDRV9T
VVBQT1JUPXkNCiMgQ09ORklHX1g4Nl9ERUNPREVSX1NFTEZURVNUIGlzIG5v
dCBzZXQNCkNPTkZJR19JT19ERUxBWV9UWVBFXzBYODA9MA0KQ09ORklHX0lP
X0RFTEFZX1RZUEVfMFhFRD0xDQpDT05GSUdfSU9fREVMQVlfVFlQRV9VREVM
QVk9Mg0KQ09ORklHX0lPX0RFTEFZX1RZUEVfTk9ORT0zDQojIENPTkZJR19J
T19ERUxBWV8wWDgwIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lPX0RFTEFZXzBY
RUQgaXMgbm90IHNldA0KIyBDT05GSUdfSU9fREVMQVlfVURFTEFZIGlzIG5v
dCBzZXQNCkNPTkZJR19JT19ERUxBWV9OT05FPXkNCkNPTkZJR19ERUZBVUxU
X0lPX0RFTEFZX1RZUEU9Mw0KQ09ORklHX0RFQlVHX0JPT1RfUEFSQU1TPXkN
CkNPTkZJR19DUEFfREVCVUc9eQ0KQ09ORklHX09QVElNSVpFX0lOTElOSU5H
PXkNCiMgQ09ORklHX0RFQlVHX05NSV9TRUxGVEVTVCBpcyBub3Qgc2V0DQoN
CiMNCiMgU2VjdXJpdHkgb3B0aW9ucw0KIw0KQ09ORklHX0tFWVM9eQ0KIyBD
T05GSUdfVFJVU1RFRF9LRVlTIGlzIG5vdCBzZXQNCkNPTkZJR19FTkNSWVBU
RURfS0VZUz1tDQpDT05GSUdfS0VZU19ERUJVR19QUk9DX0tFWVM9eQ0KIyBD
T05GSUdfU0VDVVJJVFlfRE1FU0dfUkVTVFJJQ1QgaXMgbm90IHNldA0KIyBD
T05GSUdfU0VDVVJJVFkgaXMgbm90IHNldA0KQ09ORklHX1NFQ1VSSVRZRlM9
eQ0KQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfREFDPXkNCkNPTkZJR19ERUZB
VUxUX1NFQ1VSSVRZPSIiDQpDT05GSUdfWE9SX0JMT0NLUz1tDQpDT05GSUdf
QVNZTkNfQ09SRT1tDQpDT05GSUdfQVNZTkNfWE9SPW0NCkNPTkZJR19DUllQ
VE89eQ0KDQojDQojIENyeXB0byBjb3JlIG9yIGhlbHBlcg0KIw0KQ09ORklH
X0NSWVBUT19BTEdBUEk9eQ0KQ09ORklHX0NSWVBUT19BTEdBUEkyPXkNCkNP
TkZJR19DUllQVE9fQUVBRD15DQpDT05GSUdfQ1JZUFRPX0FFQUQyPXkNCkNP
TkZJR19DUllQVE9fQkxLQ0lQSEVSPXkNCkNPTkZJR19DUllQVE9fQkxLQ0lQ
SEVSMj15DQpDT05GSUdfQ1JZUFRPX0hBU0g9eQ0KQ09ORklHX0NSWVBUT19I
QVNIMj15DQpDT05GSUdfQ1JZUFRPX1JORz15DQpDT05GSUdfQ1JZUFRPX1JO
RzI9eQ0KQ09ORklHX0NSWVBUT19QQ09NUD1tDQpDT05GSUdfQ1JZUFRPX1BD
T01QMj15DQpDT05GSUdfQ1JZUFRPX01BTkFHRVI9eQ0KQ09ORklHX0NSWVBU
T19NQU5BR0VSMj15DQpDT05GSUdfQ1JZUFRPX1VTRVI9bQ0KQ09ORklHX0NS
WVBUT19NQU5BR0VSX0RJU0FCTEVfVEVTVFM9eQ0KQ09ORklHX0NSWVBUT19H
RjEyOE1VTD15DQpDT05GSUdfQ1JZUFRPX05VTEw9bQ0KQ09ORklHX0NSWVBU
T19XT1JLUVVFVUU9eQ0KQ09ORklHX0NSWVBUT19DUllQVEQ9eQ0KQ09ORklH
X0NSWVBUT19BVVRIRU5DPW0NCkNPTkZJR19DUllQVE9fVEVTVD1tDQpDT05G
SUdfQ1JZUFRPX0FCTEtfSEVMUEVSX1g4Nj15DQpDT05GSUdfQ1JZUFRPX0dM
VUVfSEVMUEVSX1g4Nj15DQoNCiMNCiMgQXV0aGVudGljYXRlZCBFbmNyeXB0
aW9uIHdpdGggQXNzb2NpYXRlZCBEYXRhDQojDQpDT05GSUdfQ1JZUFRPX0ND
TT15DQpDT05GSUdfQ1JZUFRPX0dDTT1tDQpDT05GSUdfQ1JZUFRPX1NFUUlW
PXkNCg0KIw0KIyBCbG9jayBtb2Rlcw0KIw0KQ09ORklHX0NSWVBUT19DQkM9
eQ0KQ09ORklHX0NSWVBUT19DVFI9eQ0KIyBDT05GSUdfQ1JZUFRPX0NUUyBp
cyBub3Qgc2V0DQpDT05GSUdfQ1JZUFRPX0VDQj15DQpDT05GSUdfQ1JZUFRP
X0xSVz15DQpDT05GSUdfQ1JZUFRPX1BDQkM9bQ0KQ09ORklHX0NSWVBUT19Y
VFM9eQ0KDQojDQojIEhhc2ggbW9kZXMNCiMNCkNPTkZJR19DUllQVE9fQ01B
Qz15DQpDT05GSUdfQ1JZUFRPX0hNQUM9bQ0KQ09ORklHX0NSWVBUT19YQ0JD
PXkNCkNPTkZJR19DUllQVE9fVk1BQz1tDQoNCiMNCiMgRGlnZXN0DQojDQpD
T05GSUdfQ1JZUFRPX0NSQzMyQz15DQpDT05GSUdfQ1JZUFRPX0NSQzMyQ19J
TlRFTD1tDQpDT05GSUdfQ1JZUFRPX0NSQzMyPW0NCiMgQ09ORklHX0NSWVBU
T19DUkMzMl9QQ0xNVUwgaXMgbm90IHNldA0KQ09ORklHX0NSWVBUT19HSEFT
SD1tDQpDT05GSUdfQ1JZUFRPX01END15DQpDT05GSUdfQ1JZUFRPX01ENT1t
DQpDT05GSUdfQ1JZUFRPX01JQ0hBRUxfTUlDPXkNCiMgQ09ORklHX0NSWVBU
T19STUQxMjggaXMgbm90IHNldA0KQ09ORklHX0NSWVBUT19STUQxNjA9eQ0K
Q09ORklHX0NSWVBUT19STUQyNTY9bQ0KQ09ORklHX0NSWVBUT19STUQzMjA9
eQ0KQ09ORklHX0NSWVBUT19TSEExPXkNCiMgQ09ORklHX0NSWVBUT19TSEEx
X1NTU0UzIGlzIG5vdCBzZXQNCkNPTkZJR19DUllQVE9fU0hBMjU2X1NTU0Uz
PXkNCkNPTkZJR19DUllQVE9fU0hBNTEyX1NTU0UzPXkNCkNPTkZJR19DUllQ
VE9fU0hBMjU2PXkNCkNPTkZJR19DUllQVE9fU0hBNTEyPXkNCkNPTkZJR19D
UllQVE9fVEdSMTkyPW0NCkNPTkZJR19DUllQVE9fV1A1MTI9eQ0KQ09ORklH
X0NSWVBUT19HSEFTSF9DTE1VTF9OSV9JTlRFTD1tDQoNCiMNCiMgQ2lwaGVy
cw0KIw0KQ09ORklHX0NSWVBUT19BRVM9eQ0KQ09ORklHX0NSWVBUT19BRVNf
WDg2XzY0PXkNCkNPTkZJR19DUllQVE9fQUVTX05JX0lOVEVMPXkNCiMgQ09O
RklHX0NSWVBUT19BTlVCSVMgaXMgbm90IHNldA0KQ09ORklHX0NSWVBUT19B
UkM0PXkNCkNPTkZJR19DUllQVE9fQkxPV0ZJU0g9bQ0KQ09ORklHX0NSWVBU
T19CTE9XRklTSF9DT01NT049bQ0KQ09ORklHX0NSWVBUT19CTE9XRklTSF9Y
ODZfNjQ9bQ0KQ09ORklHX0NSWVBUT19CTE9XRklTSF9BVlgyX1g4Nl82ND1t
DQojIENPTkZJR19DUllQVE9fQ0FNRUxMSUEgaXMgbm90IHNldA0KQ09ORklH
X0NSWVBUT19DQU1FTExJQV9YODZfNjQ9eQ0KQ09ORklHX0NSWVBUT19DQU1F
TExJQV9BRVNOSV9BVlhfWDg2XzY0PW0NCkNPTkZJR19DUllQVE9fQ0FNRUxM
SUFfQUVTTklfQVZYMl9YODZfNjQ9bQ0KQ09ORklHX0NSWVBUT19DQVNUX0NP
TU1PTj15DQpDT05GSUdfQ1JZUFRPX0NBU1Q1PXkNCkNPTkZJR19DUllQVE9f
Q0FTVDVfQVZYX1g4Nl82ND15DQpDT05GSUdfQ1JZUFRPX0NBU1Q2PXkNCkNP
TkZJR19DUllQVE9fQ0FTVDZfQVZYX1g4Nl82ND15DQpDT05GSUdfQ1JZUFRP
X0RFUz15DQojIENPTkZJR19DUllQVE9fRkNSWVBUIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0NSWVBUT19LSEFaQUQgaXMgbm90IHNldA0KQ09ORklHX0NSWVBU
T19TQUxTQTIwPW0NCiMgQ09ORklHX0NSWVBUT19TQUxTQTIwX1g4Nl82NCBp
cyBub3Qgc2V0DQpDT05GSUdfQ1JZUFRPX1NFRUQ9bQ0KQ09ORklHX0NSWVBU
T19TRVJQRU5UPW0NCiMgQ09ORklHX0NSWVBUT19TRVJQRU5UX1NTRTJfWDg2
XzY0IGlzIG5vdCBzZXQNCkNPTkZJR19DUllQVE9fU0VSUEVOVF9BVlhfWDg2
XzY0PW0NCiMgQ09ORklHX0NSWVBUT19TRVJQRU5UX0FWWDJfWDg2XzY0IGlz
IG5vdCBzZXQNCkNPTkZJR19DUllQVE9fVEVBPW0NCiMgQ09ORklHX0NSWVBU
T19UV09GSVNIIGlzIG5vdCBzZXQNCkNPTkZJR19DUllQVE9fVFdPRklTSF9D
T01NT049eQ0KQ09ORklHX0NSWVBUT19UV09GSVNIX1g4Nl82ND15DQpDT05G
SUdfQ1JZUFRPX1RXT0ZJU0hfWDg2XzY0XzNXQVk9eQ0KQ09ORklHX0NSWVBU
T19UV09GSVNIX0FWWF9YODZfNjQ9eQ0KQ09ORklHX0NSWVBUT19UV09GSVNI
X0FWWDJfWDg2XzY0PXkNCg0KIw0KIyBDb21wcmVzc2lvbg0KIw0KQ09ORklH
X0NSWVBUT19ERUZMQVRFPW0NCkNPTkZJR19DUllQVE9fWkxJQj1tDQpDT05G
SUdfQ1JZUFRPX0xaTz15DQpDT05GSUdfQ1JZUFRPX0xaND15DQpDT05GSUdf
Q1JZUFRPX0xaNEhDPXkNCg0KIw0KIyBSYW5kb20gTnVtYmVyIEdlbmVyYXRp
b24NCiMNCkNPTkZJR19DUllQVE9fQU5TSV9DUFJORz1tDQpDT05GSUdfQ1JZ
UFRPX1VTRVJfQVBJPXkNCkNPTkZJR19DUllQVE9fVVNFUl9BUElfSEFTSD15
DQpDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX1NLQ0lQSEVSPW0NCkNPTkZJR19D
UllQVE9fSFc9eQ0KQ09ORklHX0NSWVBUT19ERVZfUEFETE9DSz15DQpDT05G
SUdfQ1JZUFRPX0RFVl9QQURMT0NLX0FFUz15DQpDT05GSUdfQ1JZUFRPX0RF
Vl9QQURMT0NLX1NIQT15DQpDT05GSUdfQVNZTU1FVFJJQ19LRVlfVFlQRT15
DQpDT05GSUdfQVNZTU1FVFJJQ19QVUJMSUNfS0VZX1NVQlRZUEU9eQ0KQ09O
RklHX1BVQkxJQ19LRVlfQUxHT19SU0E9eQ0KQ09ORklHX1g1MDlfQ0VSVElG
SUNBVEVfUEFSU0VSPXkNCkNPTkZJR19IQVZFX0tWTT15DQpDT05GSUdfSEFW
RV9LVk1fSVJRQ0hJUD15DQpDT05GSUdfSEFWRV9LVk1fSVJRX1JPVVRJTkc9
eQ0KQ09ORklHX0hBVkVfS1ZNX0VWRU5URkQ9eQ0KQ09ORklHX0tWTV9BUElD
X0FSQ0hJVEVDVFVSRT15DQpDT05GSUdfS1ZNX01NSU89eQ0KQ09ORklHX0tW
TV9BU1lOQ19QRj15DQpDT05GSUdfSEFWRV9LVk1fTVNJPXkNCkNPTkZJR19I
QVZFX0tWTV9DUFVfUkVMQVhfSU5URVJDRVBUPXkNCkNPTkZJR19WSVJUVUFM
SVpBVElPTj15DQpDT05GSUdfS1ZNPXkNCkNPTkZJR19LVk1fSU5URUw9bQ0K
Q09ORklHX0tWTV9BTUQ9eQ0KQ09ORklHX0tWTV9NTVVfQVVESVQ9eQ0KQ09O
RklHX0JJTkFSWV9QUklOVEY9eQ0KDQojDQojIExpYnJhcnkgcm91dGluZXMN
CiMNCkNPTkZJR19SQUlENl9QUT1tDQpDT05GSUdfQklUUkVWRVJTRT15DQpD
T05GSUdfR0VORVJJQ19TVFJOQ1BZX0ZST01fVVNFUj15DQpDT05GSUdfR0VO
RVJJQ19TVFJOTEVOX1VTRVI9eQ0KQ09ORklHX0dFTkVSSUNfRklORF9GSVJT
VF9CSVQ9eQ0KQ09ORklHX0dFTkVSSUNfUENJX0lPTUFQPXkNCkNPTkZJR19H
RU5FUklDX0lPTUFQPXkNCkNPTkZJR19HRU5FUklDX0lPPXkNCkNPTkZJR19D
UkNfQ0NJVFQ9eQ0KQ09ORklHX0NSQzE2PXkNCkNPTkZJR19DUkNfVDEwRElG
PXkNCkNPTkZJR19DUkNfSVRVX1Q9eQ0KQ09ORklHX0NSQzMyPXkNCkNPTkZJ
R19DUkMzMl9TRUxGVEVTVD15DQojIENPTkZJR19DUkMzMl9TTElDRUJZOCBp
cyBub3Qgc2V0DQpDT05GSUdfQ1JDMzJfU0xJQ0VCWTQ9eQ0KIyBDT05GSUdf
Q1JDMzJfU0FSV0FURSBpcyBub3Qgc2V0DQojIENPTkZJR19DUkMzMl9CSVQg
aXMgbm90IHNldA0KIyBDT05GSUdfQ1JDNyBpcyBub3Qgc2V0DQpDT05GSUdf
TElCQ1JDMzJDPXkNCiMgQ09ORklHX0NSQzggaXMgbm90IHNldA0KQ09ORklH
X1pMSUJfSU5GTEFURT15DQpDT05GSUdfWkxJQl9ERUZMQVRFPXkNCkNPTkZJ
R19MWk9fQ09NUFJFU1M9eQ0KQ09ORklHX0xaT19ERUNPTVBSRVNTPXkNCkNP
TkZJR19MWjRfQ09NUFJFU1M9eQ0KQ09ORklHX0xaNEhDX0NPTVBSRVNTPXkN
CkNPTkZJR19MWjRfREVDT01QUkVTUz15DQpDT05GSUdfWFpfREVDPW0NCkNP
TkZJR19YWl9ERUNfWDg2PXkNCkNPTkZJR19YWl9ERUNfUE9XRVJQQz15DQpD
T05GSUdfWFpfREVDX0lBNjQ9eQ0KQ09ORklHX1haX0RFQ19BUk09eQ0KQ09O
RklHX1haX0RFQ19BUk1USFVNQj15DQojIENPTkZJR19YWl9ERUNfU1BBUkMg
aXMgbm90IHNldA0KQ09ORklHX1haX0RFQ19CQ0o9eQ0KQ09ORklHX1haX0RF
Q19URVNUPW0NCkNPTkZJR19HRU5FUklDX0FMTE9DQVRPUj15DQpDT05GSUdf
QlRSRUU9eQ0KQ09ORklHX0hBU19JT01FTT15DQpDT05GSUdfSEFTX0lPUE9S
VD15DQpDT05GSUdfSEFTX0RNQT15DQpDT05GSUdfQ0hFQ0tfU0lHTkFUVVJF
PXkNCkNPTkZJR19EUUw9eQ0KQ09ORklHX05MQVRUUj15DQpDT05GSUdfQVJD
SF9IQVNfQVRPTUlDNjRfREVDX0lGX1BPU0lUSVZFPXkNCkNPTkZJR19BVkVS
QUdFPXkNCkNPTkZJR19DTFpfVEFCPXkNCkNPTkZJR19DT1JESUM9eQ0KQ09O
RklHX0REUj15DQpDT05GSUdfTVBJTElCPXkNCkNPTkZJR19PSURfUkVHSVNU
Ulk9eQ0KQ09ORklHX1VDUzJfU1RSSU5HPXkNCg==

--8323328-442319640-1367480283=:23933--
