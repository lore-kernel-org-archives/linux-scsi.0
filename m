Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A578412B94;
	Thu, 18 Jul 2024 21:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721336452; cv=none; b=ViF7Zv1V2Hog8D3rMkTv5egHJj1LSQj81OrJBjqN5TiSbmleIpbEIhS/bnF/B+PB0WNqJ6PAFCU2FQ++Nvl6nNGEXIDknvIWp1pA+tf42MTd23ExskqE+xduxmtFw3lMy3Uiw6nqIwzKlf1xtP0dlK2v+BLojq9yxbE09SoX28Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721336452; c=relaxed/simple;
	bh=KY05MccZUIJDV+lvcNDZwh2noM+K9Gvqo8y6cn2+OPM=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=AU7efFwQy2S2VnKe6dr7Oe+LzqfifYH4ZxHqQySUTJ927E/o+c8o5ed5Z47qfLljo5rHl4Dc4YdcUk0cQBvS093UwojYYGnBWUfK/ewqAVSNimCsZ5jdcQ7QwdEEvxV9p4nK+IJe8c3mqW5/JHOSPfF0xth8VRWxdSu+A8HViPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=DRku0V6U; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=DRku0V6U; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="DRku0V6U";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="DRku0V6U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1721336449;
	bh=KY05MccZUIJDV+lvcNDZwh2noM+K9Gvqo8y6cn2+OPM=;
	h=Message-ID:Subject:From:To:Date:From;
	b=DRku0V6UC1iVuDePTbi6LAzbs99fZIWro/z5XqXpTHju3bwbJ2wa8MK0iyNKvkgty
	 59yfiUd67m7m7exFOy/W/XTghOSyhEbCahfo1stB9813jwVEpOO3ggnVGHxPmNGMO/
	 J4lm8m6zZcwuCuz0lDDD2jbVpqKyMgwytgR+JGeE=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id E24771286268;
	Thu, 18 Jul 2024 17:00:49 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id UYCbke5Ip2BE; Thu, 18 Jul 2024 17:00:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1721336449;
	bh=KY05MccZUIJDV+lvcNDZwh2noM+K9Gvqo8y6cn2+OPM=;
	h=Message-ID:Subject:From:To:Date:From;
	b=DRku0V6UC1iVuDePTbi6LAzbs99fZIWro/z5XqXpTHju3bwbJ2wa8MK0iyNKvkgty
	 59yfiUd67m7m7exFOy/W/XTghOSyhEbCahfo1stB9813jwVEpOO3ggnVGHxPmNGMO/
	 J4lm8m6zZcwuCuz0lDDD2jbVpqKyMgwytgR+JGeE=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::db7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3FD621285D88;
	Thu, 18 Jul 2024 17:00:49 -0400 (EDT)
Message-ID: <553d4e0924cc47e41ca799c19c666761c5de6023.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.10+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jul 2024 17:00:47 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updates to the usual drivers (ufs, lpfc, qla2xxx, mpi3mr) plus some
misc small fixes. The only core changes are to both bsg and scsi to
pass in the device instead of setting it afterwards as q->queuedata, so
no functional change.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Add support for Intel Panther Lake

Avri Altman (3):
      scsi: ufs: sysfs: Make max_number_of_rtt read-write
      scsi: ufs: core: Maximum RTT supported by the host driver
      scsi: ufs: core: Allow RTT negotiation

Bart Van Assche (15):
      scsi: ufs: mcq: Make .get_hba_mac() optional
      scsi: ufs: mcq: Inline ufshcd_mcq_vops_get_hba_mac()
      scsi: ufs: mcq: Move the ufshcd_mcq_enable() call
      scsi: ufs: mcq: Move the "hba->mcq_enabled = true" assignment
      scsi: ufs: core: Inline is_mcq_enabled()
      scsi: ufs: core: Initialize hba->reserved_slot earlier
      scsi: ufs: core: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
      scsi: ufs: core: Remove two constants
      scsi: ufs: core: Initialize struct uic_command once
      scsi: ufs: core: Declare functions once
      scsi: core: Fix an incorrect comment
      scsi: powertec: Declare local function static
      scsi: eesox: Declare local function static
      scsi: cumana: Declare local function static
      scsi: acornscsi: Declare local functions static

Chen Ni (1):
      scsi: qla2xxx: Convert comma to semicolon

Dr. David Alan Gilbert (1):
      scsi: qla2xxx: Remove unused struct 'scsi_dif_tuple'

Eric Biggers (6):
      scsi: ufs: exynos: Add support for Flash Memory Protector (FMP)
      scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
      scsi: ufs: core: Add fill_crypto_prdt variant op
      scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
      scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
      scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE

Huai-Yuan Liu (1):
      scsi: lpfc: Fix a possible null pointer dereference

Igor Pylypiv (1):
      scsi: pm80xx: Set phy->enable_completion only when we wait for it

Jeff Johnson (2):
      scsi: ufs: qcom: Add missing MODULE_DESCRIPTION() macro
      scsi: Add missing MODULE_DESCRIPTION() macros

John Garry (2):
      scsi: bsg: Pass dev to blk_mq_alloc_queue()
      scsi: core: Pass sdev to blk_mq_alloc_queue()

Justin Tee (8):
      scsi: lpfc: Update lpfc version to 14.4.0.3
      scsi: lpfc: Revise lpfc_prep_embed_io routine with proper endian macro usages
      scsi: lpfc: Fix incorrect request len mbox field when setting trunking via sysfs
      scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
      scsi: lpfc: Fix handling of fully recovered fabric node in dev_loss callbk
      scsi: lpfc: Relax PRLI issue conditions after GID_FT response
      scsi: lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE state
      scsi: lpfc: Cancel ELS WQE instead of issuing abort when SLI port is inactive

Kyoungrul Kim (1):
      scsi: ufs: core: Remove SCSI host only if added

Manish Rangankar (1):
      scsi: qla2xxx: During vport delete send async logout explicitly

Minwoo Im (4):
      scsi: ufs: mcq: Prevent no I/O queue case for MCQ
      scsi: ufs: pci: Add support MCQ for QEMU-based UFS
      scsi: ufs: mcq: Convert MCQ_CFG_n to an inline function
      scsi: ufs: mcq: Fix missing argument 'hba' in MCQ_OPR_OFFSET_n

Nilesh Javali (2):
      scsi: qla2xxx: Update version to 10.02.09.300-k
      scsi: qla2xxx: validate nvme_local_port correctly

Quinn Tran (4):
      scsi: qla2xxx: Use QP lock to search for bsg
      scsi: qla2xxx: Reduce fabric scan duplicate code
      scsi: qla2xxx: Fix flash read failure
      scsi: qla2xxx: Unable to act on RSCN for port online

Ram Prakash Gupta (2):
      scsi: ufs: qcom: Enable suspending clk scaling on no request
      scsi: ufs: core: Suspend clk scaling on no request

Ranjan Kumar (4):
      scsi: mpi3mr: Update driver version to 8.9.1.0.50
      scsi: mpi3mr: Add ioctl support for HDB
      scsi: mpi3mr: Trigger support
      scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers

Saurav Kashyap (1):
      scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds

Shreyas Deodhar (3):
      scsi: qla2xxx: Fix optrom version displayed in FDMI
      scsi: qla2xxx: Complete command early within lock
      scsi: qla2xxx: Fix for possible memory corruption

Sumit Saxena (3):
      scsi: mpi3mr: Driver version update
      scsi: mpi3mr: Prevent PCI writes from driver during PCI error recovery
      scsi: mpi3mr: Support PCI Error Recovery callback handlers

Terrence Adams (1):
      scsi: pm8001: Update log level when reading config table

Tomas Henzl (1):
      scsi: mpi3mr: Correct a test in mpi3mr_sas_port_add()

Zhongqiu Han (1):
      scsi: aha152x: Use DECLARE_COMPLETION_ONSTACK for non-constant completion

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs |   14 +-
 block/bsg-lib.c                            |    3 +-
 drivers/scsi/BusLogic.c                    |    1 +
 drivers/scsi/advansys.c                    |    1 +
 drivers/scsi/aha152x.c                     |    2 +-
 drivers/scsi/aha1542.c                     |    2 +
 drivers/scsi/aha1740.c                     |    1 +
 drivers/scsi/arm/acornscsi.c               |    9 +-
 drivers/scsi/arm/cumana_2.c                |    2 +-
 drivers/scsi/arm/eesox.c                   |    2 +-
 drivers/scsi/arm/powertec.c                |    2 +-
 drivers/scsi/atari_scsi.c                  |    1 +
 drivers/scsi/atp870u.c                     |    2 +
 drivers/scsi/elx/efct/efct_driver.c        |    1 +
 drivers/scsi/g_NCR5380.c                   |    1 +
 drivers/scsi/imm.c                         |    1 +
 drivers/scsi/isci/init.c                   |    1 +
 drivers/scsi/lpfc/lpfc_attr.c              |   10 +-
 drivers/scsi/lpfc/lpfc_ct.c                |   16 +-
 drivers/scsi/lpfc/lpfc_els.c               |   19 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c           |   10 +-
 drivers/scsi/lpfc/lpfc_sli.c               |   43 +-
 drivers/scsi/lpfc/lpfc_version.h           |    2 +-
 drivers/scsi/mac_scsi.c                    |    1 +
 drivers/scsi/mpi3mr/mpi/mpi30_tool.h       |   44 ++
 drivers/scsi/mpi3mr/mpi3mr.h               |  140 +++-
 drivers/scsi/mpi3mr/mpi3mr_app.c           | 1090 +++++++++++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c            |  294 +++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c            |  361 ++++++++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c     |   43 +-
 drivers/scsi/pcmcia/aha152x_stub.c         |    1 +
 drivers/scsi/pm8001/pm8001_sas.c           |    4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c           |    6 +-
 drivers/scsi/ppa.c                         |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c             |   98 ++-
 drivers/scsi/qla2xxx/qla_def.h             |   17 +-
 drivers/scsi/qla2xxx/qla_gbl.h             |    6 +-
 drivers/scsi/qla2xxx/qla_gs.c              |  467 ++++++------
 drivers/scsi/qla2xxx/qla_init.c            |   94 ++-
 drivers/scsi/qla2xxx/qla_inline.h          |    8 +
 drivers/scsi/qla2xxx/qla_isr.c             |    6 -
 drivers/scsi/qla2xxx/qla_mid.c             |    2 +-
 drivers/scsi/qla2xxx/qla_nvme.c            |    5 +-
 drivers/scsi/qla2xxx/qla_os.c              |   19 +-
 drivers/scsi/qla2xxx/qla_sup.c             |  108 ++-
 drivers/scsi/qla2xxx/qla_version.h         |    4 +-
 drivers/scsi/scsi_common.c                 |    1 +
 drivers/scsi/scsi_devinfo.c                |   11 +-
 drivers/scsi/scsi_scan.c                   |    3 +-
 drivers/scsi/sun3_scsi.c                   |    1 +
 drivers/ufs/core/ufs-mcq.c                 |   89 ++-
 drivers/ufs/core/ufs-sysfs.c               |   73 +-
 drivers/ufs/core/ufshcd-crypto.c           |   34 +-
 drivers/ufs/core/ufshcd-crypto.h           |   36 +
 drivers/ufs/core/ufshcd-priv.h             |   15 +-
 drivers/ufs/core/ufshcd.c                  |  163 +++--
 drivers/ufs/host/ufs-exynos.c              |  240 +++++-
 drivers/ufs/host/ufs-mediatek.c            |    7 +-
 drivers/ufs/host/ufs-mediatek.h            |    3 +
 drivers/ufs/host/ufs-qcom.c                |    3 +
 drivers/ufs/host/ufshcd-pci.c              |   49 +-
 include/uapi/scsi/scsi_bsg_mpi3mr.h        |    3 +-
 include/ufs/ufs.h                          |    2 +
 include/ufs/ufshcd.h                       |   54 +-
 include/ufs/ufshci.h                       |    4 +-
 65 files changed, 3141 insertions(+), 615 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_tool.h

James

