Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFE282488;
	Sat, 28 Sep 2024 22:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727561330; cv=none; b=U2a9eViNqdzMT9+ZpwnYzeHRhx7JzLMotvtq2ejbGgpXXJ6NckxW58x/7X79vwKo/f/Ia5IoXkS+A2xSko/KjPtvg5Zvoph4g9RPKP5UtVjqzxRjgfnAP3iRZsUJejCfkJ7sSWS8l780jfs+iyI2eM7OrcJG+QOd5riW20Mih3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727561330; c=relaxed/simple;
	bh=t2EuzwMZ2VvEOXuRdiOq5zJBUKziuub94VLUxzKl4i8=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=fy96G4vOW3FlzpSltpdTSHJgFzslYsEI3QvgGspJ7Aq3ogjDcRblB8KynlGgnSny8z4OGSF/tt454SvJCNvpeUsu2ifTdopTXSkpfHBJ/eJgBbAtxtvbfkihNy3nSCfuLsUKyE47+Up0sC3TrHsXeIkfI2j6/GCgPD4tqLOYkHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=UuZyH7J2; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=UuZyH7J2; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="UuZyH7J2";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="UuZyH7J2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1727561327;
	bh=t2EuzwMZ2VvEOXuRdiOq5zJBUKziuub94VLUxzKl4i8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=UuZyH7J22hLTHMb/jMWsZfLKNFuLb2nSSf+fZMGMMqYvKLQxWEI2/Spk4FncUyg3U
	 dzlHAGyJVTyQx8srgWlaVfoTLVayevyVIM39BXDH5d/XTu8NaQ8zUvlNl+/9VEdaoO
	 f8/BFHKJqWZ78SGyXVjjeAUKuUGGL+I6Fh1MGhjI=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id BD9E51287323;
	Sat, 28 Sep 2024 18:08:47 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id Ej5XocrkNbyz; Sat, 28 Sep 2024 18:08:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1727561327;
	bh=t2EuzwMZ2VvEOXuRdiOq5zJBUKziuub94VLUxzKl4i8=;
	h=Message-ID:Subject:From:To:Date:From;
	b=UuZyH7J22hLTHMb/jMWsZfLKNFuLb2nSSf+fZMGMMqYvKLQxWEI2/Spk4FncUyg3U
	 dzlHAGyJVTyQx8srgWlaVfoTLVayevyVIM39BXDH5d/XTu8NaQ8zUvlNl+/9VEdaoO
	 f8/BFHKJqWZ78SGyXVjjeAUKuUGGL+I6Fh1MGhjI=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::db7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 219B012872CD;
	Sat, 28 Sep 2024 18:08:47 -0400 (EDT)
Message-ID: <0ea39075394be14ba8c809daa308a16d9330c639.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI final updates for the 6.11+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 28 Sep 2024 18:08:45 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

These are mostly minor updates.  There are two drivers (lpfc and
mpi3mr) which missed the initial pull and a core change to retry a
start/stop unit which affect suspend/resume.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Bart Van Assche (1):
      scsi: sd: Retry START STOP UNIT commands

Brian King (1):
      scsi: ibmvfc: Add max_sectors module parameter

Chen Ni (1):
      scsi: pmcraid: Convert comma to semicolon

Christophe JAILLET (2):
      scsi: scsi_debug: Remove a useless memset()
      scsi: libcxgbi: Remove an unused field in struct cxgbi_device

Colin Ian King (7):
      scsi: mpt3sas: Remove trailing space after \n newline
      scsi: lpfc: Remove trailing space after \n newline
      scsi: qedf: Remove trailing space after \n newline
      scsi: hisi_sas: Remove trailing space after \n newline
      scsi: megaraid_sas: Remove trailing space after \n newline
      scsi: pm8001: Remove trailing space after \n newline
      scsi: zalon: Remove trailing space after \n newline

Daniel Wagner (1):
      scsi: pm8001: Do not overwrite PCI queue mapping

Hongbo Li (1):
      scsi: sd: Remove duplicate included header file linux/bio-integrity.h

Justin Tee (8):
      scsi: lpfc: Update lpfc version to 14.4.0.5
      scsi: lpfc: Support loopback tests with VMID enabled
      scsi: lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to KERN_WARNING
      scsi: lpfc: Ensure DA_ID handling completion before deleting an NPIV instance
      scsi: lpfc: Fix kref imbalance on fabric ndlps from dev_loss_tmo handler
      scsi: lpfc: Restrict support for 32 byte CDBs to specific HBAs
      scsi: lpfc: Update phba link state conditional before sending CMF_SYNC_WQE
      scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()

Manish Pandey (1):
      scsi: ufs: qcom: Update MODE_MAX cfg_bw value

Martin Wilck (1):
      scsi: sd: Fix off-by-one error in sd_read_block_characteristics()

Rafael Rocha (1):
      scsi: st: Fix input/output error on empty drive reset

Ranjan Kumar (5):
      scsi: mpi3mr: Update driver version to 8.12.0.0.50
      scsi: mpi3mr: Improve wait logic while controller transitions to READY state
      scsi: mpi3mr: Update MPI Headers to revision 34
      scsi: mpi3mr: Use firmware-provided timestamp update interval
      scsi: mpi3mr: Enhance the Enable Controller retry logic

Tomas Henzl (1):
      scsi: mpi3mr: A performance fix

Yan Zhen (1):
      scsi: fusion: mptctl: Use min() macro

And the diffstat:

 drivers/message/fusion/mptctl.c           |   2 +-
 drivers/scsi/cxgbi/libcxgbi.h             |   3 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |   2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |  21 ++++-
 drivers/scsi/ibmvscsi/ibmvfc.h            |   2 +-
 drivers/scsi/lpfc/lpfc_bsg.c              |   3 +
 drivers/scsi/lpfc/lpfc_ct.c               |  22 +++--
 drivers/scsi/lpfc/lpfc_disc.h             |   7 ++
 drivers/scsi/lpfc/lpfc_els.c              | 132 ++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c          |  10 +--
 drivers/scsi/lpfc/lpfc_hw.h               |  21 +++++
 drivers/scsi/lpfc/lpfc_hw4.h              |   3 +
 drivers/scsi/lpfc/lpfc_init.c             |  32 ++++++--
 drivers/scsi/lpfc/lpfc_scsi.c             |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c              |  52 ++++++++++--
 drivers/scsi/lpfc/lpfc_version.h          |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c            |  43 ++++++++--
 drivers/scsi/megaraid/megaraid_sas_base.c |   2 +-
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  35 +++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  13 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       |   8 ++
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |   4 +-
 drivers/scsi/mpi3mr/mpi3mr.h              |  10 ++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           |  79 ++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.c       |   5 +-
 drivers/scsi/pm8001/pm8001_init.c         |   6 +-
 drivers/scsi/pm8001/pm80xx_hwi.c          |   2 +-
 drivers/scsi/pmcraid.c                    |   2 +-
 drivers/scsi/qedf/qedf_io.c               |   2 +-
 drivers/scsi/scsi_debug.c                 |   1 -
 drivers/scsi/sd.c                         |  32 +++++++-
 drivers/scsi/st.c                         |   5 +-
 drivers/scsi/zalon.c                      |   2 +-
 drivers/ufs/host/ufs-qcom.c               |   2 +-
 34 files changed, 415 insertions(+), 154 deletions(-)

James



