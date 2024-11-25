Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1A1AF0CA;
	Mon, 25 Nov 2024 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544988; cv=none; b=SzhaBHl2A0BWbxV0d3VmJveFDWnilB5hUEVUhhqkXZYwomR2coVeBHmd6KxRggkB7vUwGmZtzMW5WlRW5WI+f2VIsO1vZa7dlwsRGUVE8+5ndLbNF5LrEgyvcHCLHI7uRtW91Ev4efahg7tq7gU7pIxcRVm/6kXLEjX9J0PWtMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544988; c=relaxed/simple;
	bh=8dD38Q33weSCjeylsuPeI6k9fYXRjg+hAjT1t3CxDRk=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=DXfAOYiHBGHmcV8qVchscV0NfYTBd9YEi1Qt3o5xb8jL9zJTaT3LMumzsZI81XmmpROy7W6XK3blGgS4zScARutOHFyHky3NeJ4DA6LRc9vNFS0rsREUMzJHKPCi9k85NgGeOipr2shFyiY6wQkRU4T5ZJKRL3UarLrSPdKBl84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=HoK48TOA; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=HoK48TOA; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HoK48TOA";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HoK48TOA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1732544984;
	bh=8dD38Q33weSCjeylsuPeI6k9fYXRjg+hAjT1t3CxDRk=;
	h=Message-ID:Subject:From:To:Date:From;
	b=HoK48TOAdyR1P3JId9PCQOLVM2xVUjoRlVHQTTMnU67iJLrvauX7i3E7tbk4fFp8B
	 aIRY1FtwR+3m4UppzorB1NnLcDim8EHch28eJVSmMz9cL5yW07U+HRUxoVY3mDzkj/
	 rpZO1EqsSSqG3szg+L4LvnjBIde/mUHPfFqu8vJc=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id E81251287992;
	Mon, 25 Nov 2024 09:29:44 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id qwECFATBSF7b; Mon, 25 Nov 2024 09:29:44 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1732544984;
	bh=8dD38Q33weSCjeylsuPeI6k9fYXRjg+hAjT1t3CxDRk=;
	h=Message-ID:Subject:From:To:Date:From;
	b=HoK48TOAdyR1P3JId9PCQOLVM2xVUjoRlVHQTTMnU67iJLrvauX7i3E7tbk4fFp8B
	 aIRY1FtwR+3m4UppzorB1NnLcDim8EHch28eJVSmMz9cL5yW07U+HRUxoVY3mDzkj/
	 rpZO1EqsSSqG3szg+L4LvnjBIde/mUHPfFqu8vJc=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5E1761287986;
	Mon, 25 Nov 2024 09:29:44 -0500 (EST)
Message-ID: <ce97f69d630945de4e5ac8e35be98d9720fc50ff.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.12+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2024 09:29:42 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updates to the usual drivers (ufs, lpfc, hisi_sas, st). Amazingly
enough, no core changes with the biggest set of driver changes being
ufs (which conflicted with it's own fixes a bit, hence the merges) and
the rest being minor fixes and updates. 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Avri Altman (6):
      scsi: ufs: core: Remove redundant host_lock calls around UTRLCLR.
      scsi: ufs: core: Remove redundant host_lock calls around UTMRLCLR
      scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR
      scsi: ufs: core: Use ufshcd_wait_for_register() in HCE init
      scsi: ufs: core: Zero utp_upiu_req at the beginning of each command
      scsi: ufs: core: Do not open code read_poll_timeout

Baolin Liu (1):
      scsi: target: Fix incorrect function name in pscsi_create_type_disk()

Bart Van Assche (25):
      scsi: ufs: core: Restore SM8650 support
      scsi: sg: Enable runtime power management
      scsi: ufs: core: Move code out of an if-statement
      scsi: ufs: core: Move the MCQ scsi_add_host() call
      scsi: ufs: core: Remove code that is no longer needed
      scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
      scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
      scsi: ufs: core: Move the ufshcd_device_init() calls
      scsi: ufs: core: Convert a comment into an explicit check
      scsi: ufs: core: Introduce ufshcd_process_probe_result()
      scsi: ufs: core: Call ufshcd_add_scsi_host() later
      scsi: ufs: core: Introduce ufshcd_post_device_init()
      scsi: ufs: core: Introduce ufshcd_add_scsi_host()
      scsi: ufs: core: Improve ufshcd_mcq_sq_cleanup()
      scsi: ufs: core: Simplify ufshcd_err_handling_prepare()
      scsi: ufs: core: Simplify ufshcd_exception_event_handler()
      scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
      scsi: ufs: core: Remove goto statements from ufshcd_try_to_abort_task()
      scsi: ufs: core: Move the ufshcd_mcq_enable_esi() definition
      scsi: ufs: core: Make DMA mask configuration more flexible
      scsi: mptfusion: Remove #ifndef __GENKSYMS__ / #endif
      scsi: ufs: core: Always initialize the UIC done completion
      scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze
      scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
      scsi: ufs: core: Improve the struct ufs_hba documentation

Dr. David Alan Gilbert (8):
      scsi: esas2r: Remove unused esas2r_build_cli_req()
      scsi: bfa: Remove unused misc code
      scsi: bfa: Remove unused bfa_fcs code
      scsi: bfa: Remove unused bfa_ioc code
      scsi: bfa: Remove unused bfa_svc code
      scsi: bfa: Remove unused bfa_core code
      scsi: aic7xxx: Remove unused aic7770_find_device()
      scsi: aacraid: Remove unused aac_check_health()

Ed Tsai (1):
      scsi: ufs: ufs-mediatek: Configure individual LU queue flags

Geert Uytterhoeven (1):
      scsi: sun3: Mark driver struct with __refdata to prevent section mismatch

Igor Pylypiv (2):
      scsi: pm8001: Increase request sg length to support 4MiB requests
      scsi: pm8001: Initialize devices in pm8001_alloc_dev()

Justin Tee (11):
      scsi: lpfc: Copyright updates for 14.4.0.6 patches
      scsi: lpfc: Update lpfc version to 14.4.0.6
      scsi: lpfc: Change lpfc_nodelist nlp_flag member into a bitmask
      scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure
      scsi: lpfc: Prevent NDLP reference count underflow in dev_loss_tmo callback
      scsi: lpfc: Add cleanup of nvmels_wq after HBA reset
      scsi: lpfc: Check SLI_ACTIVE flag in FDMI cmpl before submitting follow up FDMI
      scsi: lpfc: Update lpfc_els_flush_cmd() to check for SLI_ACTIVE before BSG flag
      scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths
      scsi: lpfc: Check devloss callbk done flag for potential stale NDLP ptrs
      scsi: lpfc: Modify CGN warning signal calculation based on EDC response

Kai Mäkisara (3):
      scsi: st: New session only when Unit Attention for new tape
      scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset
      scsi: st: Don't modify unknown block number in MTIOCGET

Liao Chen (1):
      scsi: qedf: Remove dead code

Liu Jing (1):
      scsi: bfa: Fix cacography in bfi.h file

Manish Pandey (1):
      scsi: ufs: ufs-qcom: Add fixup_dev_quirks vops

Peter Griffin (12):
      scsi: MAINTAINERS: Update UFS Exynos entry
      scsi: ufs: exynos: gs101: Enable clock gating with hibern8
      scsi: ufs: exynos: Fix hibern8 notify callbacks
      scsi: ufs: exynos: Set ACG to be controlled by UFS_ACG_DISABLE
      scsi: ufs: exynos: Enable write line unique transactions on gs101
      scsi: ufs: exynos: Add gs101_ufs_drv_init() hook and enable WriteBooster
      scsi: ufs: exynos: remove tx_dif_p_nsec from exynosauto_ufs_drv_init()
      scsi: ufs: exynos: gs101: Remove unused phy attribute fields
      scsi: ufs: exynos: Add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR check
      scsi: ufs: exynos: gs101: Remove EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL
      scsi: ufs: exynos: Add check inside exynos_ufs_config_smu()
      scsi: ufs: exynos: Allow UFS Gear 4

Philipp Stanner (1):
      scsi: ufs: Replace deprecated PCI functions

SEO HOYOUNG (1):
      scsi: ufs: core: check asymmetric connected lanes

Salomon Dushimirimana (1):
      scsi: pm8001: Use module param to set pcs event log severity

Tudor Ambarus (2):
      scsi: ufs: exynos: Remove superfluous function parameter
      scsi: ufs: exynos: Remove empty drv_init method

Uwe Kleine-König (1):
      scsi: Switch back to struct platform_driver::remove()

Xin Liu (1):
      scsi: ufs: ufs: qcom: dt-bindings: Document the QCS8300 UFS Controller

Xingui Yang (3):
      scsi: hisi_sas: Update v3 hw STP_LINK_TIMER setting
      scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec
      scsi: hisi_sas: Update disk locked timeout to 7 seconds

Ye Bin (1):
      scsi: bfa: Fix use-after-free in bfad_im_module_exit()

Yihang Li (10):
      scsi: hisi_sas: Add latest_dump for the debugfs dump
      scsi: hisi_sas: Create all dump files during debugfs initialization
      scsi: hisi_sas: Default enable interrupt coalescing
      scsi: hisi_sas: Add cond_resched() for no forced preemption model
      scsi: hisi_sas: Check usage count only when the runtime PM status is RPM_SUSPENDING
      scsi: hisi_sas: Reset PHY again if phyup timeout
      scsi: hisi_sas: Enable all PHYs that are not disabled by user during controller reset
      scsi: hisi_sas: Add firmware information check
      scsi: hisi_sas: Create trigger_dump at the end of the debugfs initialization
      scsi: hisi_sas: Adjust priority of registering and exiting debugfs for security

Zeng Heng (1):
      scsi: fusion: Remove unused variable 'rc'

Zhen Lei (2):
      scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
      scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()

And the diffstat:

 .../devicetree/bindings/ufs/qcom,ufs.yaml          |   2 +
 MAINTAINERS                                        |   2 +
 drivers/message/fusion/mptlan.h                    |   3 -
 drivers/message/fusion/mptsas.c                    |   4 +-
 drivers/scsi/a3000.c                               |   6 +-
 drivers/scsi/a4000t.c                              |   6 +-
 drivers/scsi/aacraid/aacraid.h                     |   1 -
 drivers/scsi/aacraid/commsup.c                     | 121 -----
 drivers/scsi/aic7xxx/aic7770.c                     |  15 -
 drivers/scsi/aic7xxx/aic7xxx.h                     |   2 -
 drivers/scsi/atari_scsi.c                          |   2 +-
 drivers/scsi/bfa/bfa.h                             |  10 -
 drivers/scsi/bfa/bfa_core.c                        |  35 --
 drivers/scsi/bfa/bfa_defs_fcs.h                    |  22 -
 drivers/scsi/bfa/bfa_fcpim.c                       |   9 -
 drivers/scsi/bfa/bfa_fcpim.h                       |   1 -
 drivers/scsi/bfa/bfa_fcs.h                         |  12 -
 drivers/scsi/bfa/bfa_fcs_lport.c                   | 142 -----
 drivers/scsi/bfa/bfa_fcs_rport.c                   |  36 --
 drivers/scsi/bfa/bfa_ioc.c                         |  21 -
 drivers/scsi/bfa/bfa_ioc.h                         |   2 -
 drivers/scsi/bfa/bfa_modules.h                     |   1 -
 drivers/scsi/bfa/bfa_svc.c                         |  72 ---
 drivers/scsi/bfa/bfa_svc.h                         |   5 -
 drivers/scsi/bfa/bfad.c                            |  23 +-
 drivers/scsi/bfa/bfad_drv.h                        |   1 -
 drivers/scsi/bfa/bfi.h                             |   2 +-
 drivers/scsi/bvme6000_scsi.c                       |   2 +-
 drivers/scsi/esas2r/esas2r.h                       |   4 -
 drivers/scsi/esas2r/esas2r_vda.c                   |  17 -
 drivers/scsi/hisi_sas/hisi_sas.h                   |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  31 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  20 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  20 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 187 +++++--
 drivers/scsi/jazz_esp.c                            |   2 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   6 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   5 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |  39 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   4 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |  62 +--
 drivers/scsi/lpfc/lpfc_els.c                       | 459 +++++++----------
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 311 +++++------
 drivers/scsi/lpfc/lpfc_init.c                      |  61 +--
 drivers/scsi/lpfc/lpfc_nportdisc.c                 | 329 +++++-------
 drivers/scsi/lpfc/lpfc_nvme.c                      |  60 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   8 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 125 ++---
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   6 +-
 drivers/scsi/mac_esp.c                             |   2 +-
 drivers/scsi/mac_scsi.c                            |   2 +-
 drivers/scsi/mvme16x_scsi.c                        |   2 +-
 drivers/scsi/pm8001/pm8001_defs.h                  |   7 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   8 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |  17 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   2 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   3 +-
 drivers/scsi/qedf/qedf_main.c                      |   6 +-
 drivers/scsi/qedi/qedi_main.c                      |   1 +
 drivers/scsi/qlogicpti.c                           |   2 +-
 drivers/scsi/sg.c                                  |   9 +-
 drivers/scsi/sgiwd93.c                             |   2 +-
 drivers/scsi/sni_53c710.c                          |   2 +-
 drivers/scsi/st.c                                  |  36 +-
 drivers/scsi/sun3_scsi.c                           |  10 +-
 drivers/scsi/sun3x_esp.c                           |   2 +-
 drivers/scsi/sun_esp.c                             |   2 +-
 drivers/target/target_core_pscsi.c                 |   2 +-
 drivers/ufs/core/ufs-mcq.c                         |  30 +-
 drivers/ufs/core/ufshcd.c                          | 571 +++++++++++----------
 drivers/ufs/host/tc-dwc-g210-pci.c                 |   8 +-
 drivers/ufs/host/ufs-exynos.c                      | 136 ++---
 drivers/ufs/host/ufs-exynos.h                      |   2 +-
 drivers/ufs/host/ufs-mediatek.c                    |  10 +
 drivers/ufs/host/ufs-qcom.c                        |  26 +-
 drivers/ufs/host/ufs-renesas.c                     |   9 +-
 drivers/ufs/host/ufshcd-pci.c                      |   8 +-
 include/ufs/ufshcd.h                               |  21 +-
 80 files changed, 1407 insertions(+), 1852 deletions(-)

Regards,

James


