Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010B1E487;
	Tue, 14 May 2024 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715710011; cv=none; b=cCkchIJ7H1ZezptW0AkpqBm4Hp27Clmnuc0RxRmoZkzSIqsE+FinChzmQrtZ9KubCTmegu0bSSYOK1fXHB2DVyV2jBse0uCz0l+JvPDJUzI4Kcp4JA6fMyu056Z/y/aXiarDiOUDQg8mPqBRI7eGhqRBz8G7dbxV/yi3kGdP8Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715710011; c=relaxed/simple;
	bh=vMf8boYaOpoXVg5mkZ7fYP/wZqkr+XPYr5BpgNif5C0=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=o2iH9A+iK4+GWIdOELlFpb942H3ArwK1InjIbcd9jciOAyDOmQ5HwgAtToidQJuYdPehDrQiZS7M6neYharLXk+rMLj5kFhhXTnHFe3LTxqx2OGMEuvcV5MIF6bSjWH+FI0Vx0Anj9ZFgO7+Xq2zjM8WWPolgbyCB1nNhAWZWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=GGxSG9Dk; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=J3UQtc4h; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="GGxSG9Dk";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="J3UQtc4h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1715710007;
	bh=vMf8boYaOpoXVg5mkZ7fYP/wZqkr+XPYr5BpgNif5C0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=GGxSG9DkpPY+yzMEMIsRL8rw0WiVXHWeI/E9ftqitXBLE3w+QRRqTpMTsOp/L2pF8
	 Dh0djFtM5WL1TYDPT5toSRN5gTK96CFKsU8lFiWNcbbPV6GAeaBA4EZ3+k66f3I9LK
	 7uqxkvTnpDENxtCoXjbOLHoY1tOeY92vndt6xGS0=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5C0491286FF7;
	Tue, 14 May 2024 14:06:47 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id q0UwrgNgNRhM; Tue, 14 May 2024 14:06:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1715710006;
	bh=vMf8boYaOpoXVg5mkZ7fYP/wZqkr+XPYr5BpgNif5C0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=J3UQtc4h/LVihsyfYxdIZ8ZyZWF2Qbiw19KYaj8frX8fy++zo+S+yqq0kK3JHlWC6
	 8d6npDBMYKRqtNEXFxvbjwp8twjL/rJpXglHLSYE/xRxgJ+Z45Mc2ieuyWgNwZSzfw
	 UyyihfWg45S4ayJov1Yitc9hn7SDkbRXNm1AxIKs=
Received: from [172.21.4.27] (unknown [50.204.89.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4B8131286DC9;
	Tue, 14 May 2024 14:06:45 -0400 (EDT)
Message-ID: <b34d2038bb6af20946d7ad4cb456cbca0a896cff.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.9+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Tue, 14 May 2024 12:06:41 -0600
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updates to the usual drivers (ufs, lpfc, qla2xxx, mpi3mr, libsas).  The
major update (which causes a conflict with block, see below) is
Christoph removing the queue limits and their associated block helpers.
The remaining patches are assorted minor fixes and deprecated function
updates plus a bit of constification.

Note we have a fairly obvious conflict with the block tree: the SCSI
tree is based on a version where blk_queue_required_elevator_features()
still existed (removed in block) and our tree removes an adjacent
function, blk_queue_can_use_dma_map_merging(), leading git to flag the
adjacent removals as a conflict.  The fixup is fairly simple (just
remove everything).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alice Chao (1):
      scsi: ufs: mediatek: Support rtff in PM flow

Andrew Donnellan (1):
      scsi: MAINTAINERS: Make cxlflash obsolete

Andrew Halaney (11):
      scsi: ufs: core: Remove unnecessary wmb() prior to writing run/stop regs
      scsi: ufs: core: Remove unnecessary wmb() after ringing doorbell
      scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL
      scsi: ufs: core: Perform read back after disabling interrupts
      scsi: ufs: core: Perform read back after writing UTP_TASK_REQ_LIST_BASE_H
      scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV
      scsi: ufs: qcom: Perform read back after writing CGC enable
      scsi: ufs: qcom: Perform read back after writing unipro mode
      scsi: ufs: qcom: Remove unnecessary mb() after writing testbus config
      scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US
      scsi: ufs: qcom: Perform read back after writing reset bit

Andy Shevchenko (1):
      scsi: core: Don't use "proxy" headers

Arnd Bergmann (1):
      scsi: cxlflash: Fix function pointer cast warnings

Avri Altman (5):
      scsi: ufs: Remove support for old UFSHCI versions
      scsi: ufs: Reuse compose_devman_upiu
      scsi: ufs: Reuse compose_dev_cmd
      scsi: ufs: core: Reuse exec_dev_cmd
      scsi: ufs: core: Reuse device management locking code

Bart Van Assche (3):
      scsi: ufs: core: mcq: Fix ufshcd_mcq_sqe_search()
      scsi: core: Improve the code for showing commands in debugfs
      scsi: core: Introduce scsi_cmd_list_info()

Bikash Hazarika (1):
      scsi: qla2xxx: Update manufacturer detail

Bui Quang Minh (2):
      scsi: qedf: Ensure the copied buf is NUL terminated
      scsi: bfa: Ensure the copied buf is NUL terminated

Christoph Hellwig (24):
      scsi: block: Remove now unused queue limits helpers
      scsi: uas: Switch to using ->device_configure to configure queue limits
      scsi: mpi3mr: Switch to using ->device_configure
      scsi: mpi3mr: Switch to using ->device_configure
      scsi: libata: Switch to using ->device_configure
      scsi: pata_macio: Switch to using ->device_configure
      scsi: sata_nv: Switch to using ->device_configure
      scsi: usb-storage: Switch to using ->device_configure
      scsi: pmcraid: Switch to using ->device_configure
      scsi: ipr: Switch to using ->device_configure
      scsi: hptiop: Switch to using ->device_configure
      scsi: sbp2: Switch to using ->device_configure
      scsi: mpt3sas: Switch to using ->device_configure
      scsi: megaraid_sas: Switch to using ->device_configure
      scsi: core: Add a device_configure method to the host template
      scsi: core: Use the atomic queue limits API in scsi_add_lun()
      scsi: ufs: ufs-exynos: Move setting the the DMA alignment to the init method
      scsi: core: Add a dma_alignment field to the host and host template
      scsi: core: Add a no_highmem flag to struct Scsi_Host
      scsi: scsi_transport_fc: Add a max_bsg_segments field to struct fc_function_template
      scsi: core: Initialize scsi midlayer limits before allocating the queue
      scsi: mpi3mr: Pass queue_limits to bsg_setup_queue()
      scsi: bsg: Pass queue_limits to bsg_setup_queue()
      scsi: block: Add a helper to cancel atomic queue limit updates

Colin Ian King (3):
      scsi: bnx2fc: Remove redundant assignment to variable 'i'
      scsi: FlashPoint: Remove redundant assignment to pointer currTar_Info
      scsi: target: iscsi: Remove unused variable xfer_len

Damien Le Moal (1):
      scsi: libsas: Fix declaration of ncq priority attributes

Dmitry Baryshkov (1):
      scsi: ufs: qcom: Provide default cycles_in_1us value

Dr. David Alan Gilbert (2):
      scsi: target: Remove unused list 'device_list'
      scsi: iscsi: Remove unused list 'connlist_err'

Himanshu Madhani (1):
      scsi: qla2xxx: Fix debugfs output for fw_resource_count

Igor Pylypiv (7):
      scsi: isci: Add libsas SATA sysfs attributes group
      scsi: aic94xx: Add libsas SATA sysfs attributes group
      scsi: hisi_sas: Add libsas SATA sysfs attributes group
      scsi: mvsas: Add libsas SATA sysfs attributes group
      scsi: pm80xx: Add libsas SATA sysfs attributes group
      scsi: libsas: Define NCQ Priority sysfs attributes for SATA devices
      scsi: ata: libata-sata: Factor out NCQ Priority configuration helpers

John Garry (6):
      scsi: isci: Use LIBSAS_SHT_BASE
      scsi: mvsas: Use LIBSAS_SHT_BASE
      scsi: aic94xx: Use LIBSAS_SHT_BASE
      scsi: hisi_sas: Use LIBSAS_SHT_BASE_NO_SLAVE_INIT
      scsi: pm8001: Use LIBSAS_SHT_BASE
      scsi: libsas: Add LIBSAS_SHT_BASE

John Meneghini (1):
      scsi: qedf: Make qedf_execute_tmf() non-preemptible

Justin Stitt (7):
      scsi: wd33c93: Replace deprecated strncpy() with strscpy()
      scsi: smartpqi: Replace deprecated strncpy() with strscpy()
      scsi: devinfo: Replace strncpy() and manual pad
      scsi: qla4xxx: Replace deprecated strncpy() with strscpy()
      scsi: qedf: Replace deprecated strncpy() with strscpy()
      scsi: mpt3sas: Replace deprecated strncpy() with strscpy()
      scsi: mpi3mr: Replace deprecated strncpy() with assignments

Justin Tee (20):
      scsi: lpfc: Copyright updates for 14.4.0.2 patches
      scsi: lpfc: Update lpfc version to 14.4.0.2
      scsi: lpfc: Add support for 32 byte CDBs
      scsi: lpfc: Change lpfc_hba hba_flag member into a bitmask
      scsi: lpfc: Introduce rrq_list_lock to protect active_rrq_list
      scsi: lpfc: Clear deferred RSCN processing flag when driver is unloading
      scsi: lpfc: Update logging of protection type for T10 DIF I/O
      scsi: lpfc: Change default logging level for unsolicited CT MIB commands
      scsi: lpfc: Copyright updates for 14.4.0.1 patches
      scsi: lpfc: Update lpfc version to 14.4.0.1
      scsi: lpfc: Define types in a union for generic void *context3 ptr
      scsi: lpfc: Define lpfc_dmabuf type for ctx_buf ptr
      scsi: lpfc: Define lpfc_nodelist type for ctx_ndlp ptr
      scsi: lpfc: Use a dedicated lock for ras_fwlog state
      scsi: lpfc: Release hbalock before calling lpfc_worker_wake_up()
      scsi: lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port()
      scsi: lpfc: Update lpfc_ramp_down_queue_handler() logic
      scsi: lpfc: Remove IRQF_ONESHOT flag from threaded IRQ handling
      scsi: lpfc: Move NPIV's transport unregistration to after resource clean up
      scsi: lpfc: Remove unnecessary log message in queuecommand path

Krzysztof Kozlowski (9):
      scsi: ufs: mediatek: Fix module autoloading
      scsi: ufs: core: Drop driver owner initialization
      scsi: st: Drop driver owner initialization
      scsi: sr: Drop driver owner initialization
      scsi: ses: Drop driver owner initialization
      scsi: sd: Drop driver owner initialization
      scsi: core: Store owner from modules with scsi_register_driver()
      scsi: qla2xxx: Drop driver owner assignment
      scsi: csiostor: Drop driver owner assignment

Li Zhijian (1):
      scsi: snic: Convert sprintf() family to sysfs_emit() family

Manish Rangankar (1):
      scsi: qedi: Fix crash while reading debugfs attribute

Manivannan Sadhasivam (1):
      scsi: ufs: qcom: Add sanity checks for gear/lane values during ICC scaling

Muhammad Usama Anjum (2):
      scsi: lpfc: Correct size for cmdwqe/rspwqe for memset()
      scsi: lpfc: Correct size for wqe for memset()

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.09.200-k

Peter Griffin (6):
      scsi: ufs: exynos: Add support for Tensor gs101 SoC
      scsi: ufs: exynos: Add some pa_dbg_ register offsets into drvdata
      scsi: ufs: exynos: Allow max frequencies up to 267Mhz
      scsi: ufs: exynos: Add EXYNOS_UFS_OPT_TIMER_TICK_SELECT option
      scsi: ufs: exynos: Add EXYNOS_UFS_OPT_UFSPR_SECURE option
      scsi: ufs: dt-bindings: exynos: Add gs101 compatible

Peter Wang (4):
      scsi: ufs: mediatek: Support mphy reset
      scsi: ufs: mediatek: TX skew fix
      scsi: ufs: mediatek: Fix vsx/vccqx control logic
      scsi: ufs: core: Add config_scsi_dev vops comment

Po-Wen Kao (3):
      scsi: ufs: mediatek: Rename host power control API
      scsi: ufs: mediatek: UFS mtk sip command reconstruct
      scsi: ufs: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ

Prasad Pandit (3):
      scsi: aic7xxx: Indent kconfig help text
      scsi: qla2xxx: Indent help text
      scsi: megaraid: Indent Kconfig option help text

Quinn Tran (6):
      scsi: qla2xxx: Delay I/O Abort on PCI error
      scsi: qla2xxx: Fix command flush on cable pull
      scsi: qla2xxx: NVME|FCP prefer flag not being honored
      scsi: qla2xxx: Split FCE|EFT trace control
      scsi: qla2xxx: Fix N2N stuck connection
      scsi: qla2xxx: Prevent command send on chip reset

Randy Dunlap (11):
      scsi: mpi3mr: Fix some kernel-doc warnings in scsi_bsg_mpi3mr.h
      scsi: ufs: bsg: Fix all kernel-doc warnings
      scsi: libfc: Add some kernel-doc comments
      scsi: scsi_transport_srp: Fix a couple of kernel-doc warnings
      scsi: scsi_transport_fc: Add kernel-doc for function return
      scsi: core: Add function return kernel-doc for 2 functions
      scsi: libfcoe: Fix a slew of kernel-doc warnings
      scsi: iser: Fix @read_stag kernel-doc warning
      scsi: core: Add kernel-doc for scsi_msg_to_host_byte()
      scsi: documentation: Clean up overview
      scsi: documentation: Clean up scsi_mid_low_api.rst

Ranjan Kumar (7):
      scsi: mpi3mr: Driver version update to 8.8.1.0.50
      scsi: mpi3mr: Update MPI Headers to revision 31
      scsi: mpi3mr: Debug ability improvements
      scsi: mpi3mr: Set the WriteSame Divert Capability in the IOCInit MPI Request
      scsi: mpi3mr: Clear ioctl blocking flag for an unresponsive controller
      scsi: mpi3mr: Set MPI request flags appropriately
      scsi: mpi3mr: Block devices are not removed even when VDs are offlined

Ricardo B. Marliere (5):
      scsi: st: Make st_sysfs_class constant
      scsi: ch: Make ch_sysfs_class constant
      scsi: cxlflash: Make cxlflash_class constant
      scsi: pmcraid: Make pmcraid_class constant
      scsi: sg: Make sg_sysfs_class constant

Rohit Ner (1):
      scsi: ufs: core: Fix MCQ MAC configuration

SEO HOYOUNG (1):
      scsi: ufs: core: Changing the status to check inflight

Saurav Kashyap (3):
      scsi: qla2xxx: Change debug message during driver unload
      scsi: qla2xxx: Fix double free of fcport
      scsi: qla2xxx: Fix double free of the ha->vp_map pointer

Tomas Henzl (1):
      scsi: mpi3mr: Sanitise num_phys

Uwe Kleine-König (4):
      scsi: mac_scsi: Mark driver struct with __refdata to prevent section mismatch
      scsi: atari_scsi: Mark driver struct with __refdata to prevent section mismatch
      scsi: a4000t: Mark driver struct with __refdata to prevent section mismatch
      scsi: a3000: Mark driver struct with __refdata to prevent section mismatch

Will McVicker (1):
      scsi: ufs: exynos: Support module autoloading

Xingui Yang (6):
      scsi: libsas: Fix the failure of adding phy with zero-address to port
      scsi: libsas: Set port when ex_phy is added or deleted
      scsi: libsas: Move sas_add_parent_port() to sas_expander.c
      scsi: libsas: Add helper for port add ex_phy
      scsi: libsas: Fix disk not being scanned in after being removed
      scsi: libsas: Add a helper sas_get_sas_addr_and_dev_type()

Yuri Karpov (1):
      scsi: hpsa: Fix allocation size for Scsi_Host private data

And the diffstat:

 .../bindings/ufs/samsung,exynos-ufs.yaml           |  38 ++-
 Documentation/driver-api/scsi.rst                  |  15 +-
 Documentation/scsi/scsi_mid_low_api.rst            |  22 +-
 MAINTAINERS                                        |   3 +-
 block/blk-settings.c                               | 245 --------------
 block/bsg-lib.c                                    |   6 +-
 drivers/ata/ahci.h                                 |   2 +-
 drivers/ata/libata-sata.c                          | 171 +++++++---
 drivers/ata/libata-scsi.c                          |  19 +-
 drivers/ata/libata.h                               |   3 +-
 drivers/ata/pata_macio.c                           |  11 +-
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/ata/sata_nv.c                              |  24 +-
 drivers/ata/sata_sil24.c                           |   2 +-
 drivers/firewire/sbp2.c                            |  13 +-
 drivers/message/fusion/mptfc.c                     |   1 +
 drivers/message/fusion/mptsas.c                    |   1 +
 drivers/message/fusion/mptscsih.c                  |   2 -
 drivers/message/fusion/mptspi.c                    |   1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   2 +-
 drivers/s390/block/dasd_eckd.c                     |   6 +-
 drivers/scsi/FlashPoint.c                          |   1 -
 drivers/scsi/Kconfig                               |   4 +-
 drivers/scsi/a3000.c                               |   8 +-
 drivers/scsi/a4000t.c                              |   8 +-
 drivers/scsi/aha152x.c                             |   8 +-
 drivers/scsi/aic7xxx/Kconfig.aic79xx               |  75 ++---
 drivers/scsi/aic7xxx/Kconfig.aic7xxx               |  97 +++---
 drivers/scsi/aic94xx/aic94xx_init.c                |  29 +-
 drivers/scsi/atari_scsi.c                          |   8 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   4 +-
 drivers/scsi/ch.c                                  |  20 +-
 drivers/scsi/csiostor/csio_init.c                  |   3 -
 drivers/scsi/cxlflash/lunmgt.c                     |   6 +-
 drivers/scsi/cxlflash/main.c                       |  35 +-
 drivers/scsi/cxlflash/superpipe.c                  |  40 ++-
 drivers/scsi/cxlflash/superpipe.h                  |  11 +-
 drivers/scsi/cxlflash/vlun.c                       |   9 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   7 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  20 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  26 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  31 +-
 drivers/scsi/hosts.c                               |   6 +
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/hptiop.c                              |   8 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   5 +-
 drivers/scsi/imm.c                                 |  12 +-
 drivers/scsi/ipr.c                                 |  10 +-
 drivers/scsi/isci/init.c                           |  29 +-
 drivers/scsi/iscsi_tcp.c                           |   2 +-
 drivers/scsi/libsas/sas_ata.c                      |  84 +++++
 drivers/scsi/libsas/sas_expander.c                 |  89 +++--
 drivers/scsi/libsas/sas_internal.h                 |  15 -
 drivers/scsi/libsas/sas_scsi_host.c                |   7 +-
 drivers/scsi/lpfc/lpfc.h                           |  64 ++--
 drivers/scsi/lpfc/lpfc_attr.c                      |  35 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  43 +--
 drivers/scsi/lpfc/lpfc_ct.c                        |  24 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  12 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  88 ++---
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 166 +++++----
 drivers/scsi/lpfc/lpfc_hw4.h                       |   8 +
 drivers/scsi/lpfc/lpfc_init.c                      | 132 ++++----
 drivers/scsi/lpfc/lpfc_mbox.c                      |  30 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  75 +++--
 drivers/scsi/lpfc/lpfc_nvme.c                      |  31 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  11 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  94 +++---
 drivers/scsi/lpfc/lpfc_scsi.h                      |  32 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 315 +++++++++---------
 drivers/scsi/lpfc/lpfc_sli.h                       |  30 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   7 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |  10 +-
 drivers/scsi/mac_scsi.c                            |   8 +-
 drivers/scsi/megaraid/Kconfig.megaraid             | 113 ++++---
 drivers/scsi/megaraid/megaraid_sas.h               |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  29 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   3 +-
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h               |   3 +
 drivers/scsi/mpi3mr/mpi/mpi30_image.h              |  20 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |  20 +-
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h          |   2 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |  15 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  33 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  42 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  86 ++---
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |  10 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  18 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |  18 +-
 drivers/scsi/mvsas/mv_init.c                       |  26 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   5 +
 drivers/scsi/pm8001/pm8001_init.c                  |  21 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 +
 drivers/scsi/pmcraid.c                             |  31 +-
 drivers/scsi/ppa.c                                 |   8 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   2 +-
 drivers/scsi/qedf/qedf_io.c                        |   6 +-
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/qedi/qedi_debugfs.c                   |  12 +-
 drivers/scsi/qla2xxx/Kconfig                       |  42 +--
 drivers/scsi/qla2xxx/qla_attr.c                    |  14 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 128 +++----
 drivers/scsi/qla2xxx/qla_iocb.c                    |  68 ++--
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  12 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  10 +
 drivers/scsi/qla2xxx/qla_version.h                 |   4 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |  17 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |  14 +-
 drivers/scsi/scsi_debugfs.c                        |  56 ++--
 drivers/scsi/scsi_devinfo.c                        |  18 +-
 drivers/scsi/scsi_lib.c                            |  40 +--
 drivers/scsi/scsi_scan.c                           |  74 +++--
 drivers/scsi/scsi_sysfs.c                          |   5 +-
 drivers/scsi/scsi_transport_fc.c                   |  15 +-
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/scsi_transport_sas.c                  |   4 +-
 drivers/scsi/sd.c                                  |   1 -
 drivers/scsi/ses.c                                 |   1 -
 drivers/scsi/sg.c                                  |  18 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   5 +-
 drivers/scsi/snic/snic_attrs.c                     |  11 +-
 drivers/scsi/sr.c                                  |   1 -
 drivers/scsi/st.c                                  |   5 +-
 drivers/scsi/wd33c93.c                             |   4 +-
 drivers/staging/rts5208/rtsx.c                     |  24 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |   3 +-
 drivers/target/target_core_device.c                |   1 -
 drivers/ufs/core/ufs-mcq.c                         |   5 +-
 drivers/ufs/core/ufs_bsg.c                         |   3 +-
 drivers/ufs/core/ufshcd.c                          | 370 +++++----------------
 drivers/ufs/host/cdns-pltfrm.c                     |   2 +-
 drivers/ufs/host/ufs-exynos.c                      | 205 ++++++++++--
 drivers/ufs/host/ufs-exynos.h                      |  24 +-
 drivers/ufs/host/ufs-mediatek-sip.h                |  94 ++++++
 drivers/ufs/host/ufs-mediatek.c                    | 131 +++++++-
 drivers/ufs/host/ufs-mediatek.h                    |  90 +----
 drivers/ufs/host/ufs-qcom.c                        |  31 +-
 drivers/ufs/host/ufs-qcom.h                        |  12 +-
 drivers/usb/image/microtek.c                       |   8 +-
 drivers/usb/storage/scsiglue.c                     |  57 ++--
 drivers/usb/storage/uas.c                          |  29 +-
 drivers/usb/storage/usb.c                          |  10 +
 include/linux/blkdev.h                             |  26 +-
 include/linux/bsg-lib.h                            |   3 +-
 include/linux/libata.h                             |  16 +-
 include/linux/mmc/host.h                           |   4 +-
 include/scsi/iser.h                                |   2 +-
 include/scsi/libfc.h                               |  18 +-
 include/scsi/libfcoe.h                             |  25 +-
 include/scsi/libsas.h                              |  32 +-
 include/scsi/sas_ata.h                             |   6 +
 include/scsi/scsi.h                                |  12 +-
 include/scsi/scsi_cmnd.h                           |   2 +
 include/scsi/scsi_driver.h                         |   4 +-
 include/scsi/scsi_host.h                           |   9 +
 include/scsi/scsi_transport.h                      |   2 +-
 include/scsi/scsi_transport_fc.h                   |   6 +-
 include/scsi/scsi_transport_srp.h                  |   4 +-
 include/uapi/scsi/scsi_bsg_mpi3mr.h                |   8 +-
 include/uapi/scsi/scsi_bsg_ufs.h                   |   4 +-
 include/ufs/ufshcd.h                               |   4 +-
 include/ufs/ufshci.h                               |  13 +-
 170 files changed, 2567 insertions(+), 2376 deletions(-)
 create mode 100644 drivers/ufs/host/ufs-mediatek-sip.h

James

