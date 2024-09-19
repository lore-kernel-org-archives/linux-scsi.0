Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296B05588B;
	Thu, 19 Sep 2024 08:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726733917; cv=none; b=mSt7lgbxaYUiv76/fKQZmzX/wq9/0SN42aC4oGPnrBE33s5oEoQOLbOX4+PSAa2u0+axfCqJLQkSBHKJvZv+y+WKOo/r0HPI5lLB9RaNFBfEAOpRJ26FHGFdRusmjK+Dq7yJnnEQENJsFvug9QJiG5c864A2nNl5dHRdeGDmlyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726733917; c=relaxed/simple;
	bh=xeIVER5Aak4ykzzD1etJNGp9Hr8aEpXPMYioKA2HlH0=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=E+Gck90Zp2LyGJhPAaDRpDYfFC2AlWWknqbsyiYWdbzwhOtbTJGTftk8Z9yZ4Z3Dm1cKWWKyYBqcP7mXSuK2tkwSxwoNg5oKvp2vs/JgA8pik2PQ+EAnujg2BZztMFzS/m0SrPTAGI2PzbJBfrYrPMDFrhxvG5Tc8w0zKiBFUVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ijLI7xUs; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ijLI7xUs; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ijLI7xUs";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ijLI7xUs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1726733912;
	bh=xeIVER5Aak4ykzzD1etJNGp9Hr8aEpXPMYioKA2HlH0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=ijLI7xUspcWgHoDh2OcLACl5nZoZ2DN53f8who8jdUczWXuMS4lMAl9FXf4mLstGp
	 /nhmMU3bu2Ci228FdP7S0Pjt17YqSCVkeR7ku450H1NXE7VmKm4IutcuV6OYAbyxtR
	 za0HhPA5L/acimGA6O/IynbbmNUs85bZJPqAV9DU=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id E690C1286340;
	Thu, 19 Sep 2024 04:18:32 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id 4nhFf95FBx7m; Thu, 19 Sep 2024 04:18:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1726733912;
	bh=xeIVER5Aak4ykzzD1etJNGp9Hr8aEpXPMYioKA2HlH0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=ijLI7xUspcWgHoDh2OcLACl5nZoZ2DN53f8who8jdUczWXuMS4lMAl9FXf4mLstGp
	 /nhmMU3bu2Ci228FdP7S0Pjt17YqSCVkeR7ku450H1NXE7VmKm4IutcuV6OYAbyxtR
	 za0HhPA5L/acimGA6O/IynbbmNUs85bZJPqAV9DU=
Received: from [10.131.5.2] (unknown [83.68.141.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 874471281CC7;
	Thu, 19 Sep 2024 04:18:31 -0400 (EDT)
Message-ID: <99f009993832aed11f0f05c669eb25d7678a9a19.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI updates for the 6.11+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 19 Sep 2024 10:18:28 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Updates to the usual drivers (ufs, smartpqi, NCR5380, mac_scsi, lpfc,
mpi3mr).  There are no user visible core changes and a whole series of
minor updates and fixes.  The largest core change is probably the
simplification of the workqueue allocation path.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Avri Altman (3):
      scsi: ufs: Move UFS trace events to private header
      scsi: ufs: Add HCI capabilities sysfs group
      scsi: ufs: Prepare to add HCI capabilities sysfs

Bao D. Nguyen (2):
      scsi: ufs: core: Remove ufshcd_urgent_bkops()
      scsi: ufs: core: Support Updating UIC Command Timeout

Bart Van Assche (18):
      scsi: core: Simplify an alloc_workqueue() invocation
      scsi: ufs: Simplify alloc*_workqueue() invocation
      scsi: stex: Simplify an alloc_ordered_workqueue() invocation
      scsi: scsi_transport_fc: Simplify alloc_workqueue() invocations
      scsi: snic: Simplify alloc_workqueue() invocations
      scsi: qedi: Simplify an alloc_workqueue() invocation
      scsi: qedf: Simplify alloc_workqueue() invocations
      scsi: myrs: Simplify an alloc_ordered_workqueue() invocation
      scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
      scsi: mpt3sas: Simplify an alloc_ordered_workqueue() invocation
      scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
      scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
      scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
      scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation
      scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
      scsi: be2iscsi: Simplify an alloc_workqueue() invocation
      scsi: mptfusion: Simplify the alloc*_workqueue() invocations
      scsi: Expand all create*_workqueue() invocations

Christophe JAILLET (2):
      scsi: bnx2fc: Remove some unused fields in struct bnx2fc_rport
      scsi: qla2xxx: Remove the unused 'del_list_entry' field in struct fc_port

Dan Carpenter (2):
      scsi: elx: libefc: Fix potential use after free in efc_nport_vport_del()
      scsi: ufs: ufshcd-pltfrm: Signedness bug in ufshcd_parse_clock_info()

David Strahan (2):
      scsi: smartpqi: add new controller PCI IDs
      scsi: smartpqi: Add new controller PCI IDs

Don Brace (3):
      scsi: smartpqi: update driver version to 2.1.30-031
      scsi: smartpqi: fix volume size updates
      scsi: smartpqi: Update driver version to 2.1.28-025

Finn Thain (11):
      scsi: NCR5380: Clean up indentation
      scsi: NCR5380: Remove obsolete comment
      scsi: NCR5380: Remove redundant result calculation from NCR5380_transfer_pio()
      scsi: NCR5380: Drop redundant member from struct NCR5380_cmd
      scsi: NCR5380: Handle BSY signal loss during information transfer phases
      scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
      scsi: mac_scsi: Enable scatter/gather by default
      scsi: NCR5380: Check for phase match during PDMA fixup
      scsi: mac_scsi: Disallow bus errors during PDMA send
      scsi: mac_scsi: Refactor polling loop
      scsi: mac_scsi: Revise printk(KERN_DEBUG ...) messages

Gaosheng Cui (1):
      scsi: core: Remove obsoleted declaration for scsi_driverbyte_string()

Gilbert Wu (1):
      scsi: smartpqi: revert propagate-the-multipath-failure-to-SML-quickly

John Garry (2):
      scsi: block: Don't check REQ_ATOMIC for reads
      scsi: sd: Don't check if a write for REQ_ATOMIC

Justin Tee (8):
      scsi: lpfc: Copyright updates for 14.4.0.4 patches
      scsi: lpfc: Update lpfc version to 14.4.0.4
      scsi: lpfc: Update PRLO handling in direct attached topology
      scsi: lpfc: Fix unsolicited FLOGI kref imbalance when in direct attached topology
      scsi: lpfc: Fix unintentional double clearing of vmid_flag
      scsi: lpfc: Validate hdwq pointers before dereferencing in reset/errata paths
      scsi: lpfc: Remove redundant vport assignment when building an abort request
      scsi: lpfc: Change diagnostic log flag during receipt of unknown ELS cmds

Kees Cook (17):
      scsi: aacraid: struct {user,}sgmap{,64,raw}: Replace 1-element arrays with flexible arrays
      scsi: aacraid: Rearrange order of struct aac_srb_unit
      scsi: message: fusion: struct _CONFIG_PAGE_IOC_4: Replace 1-element array with flexible array
      scsi: message: fusion: struct _CONFIG_PAGE_IOC_3: Replace 1-element array with flexible array
      scsi: message: fusion: struct _CONFIG_PAGE_IOC_2: Replace 1-element array with flexible array
      scsi: message: fusion: struct _CONFIG_PAGE_RAID_PHYS_DISK_1: Replace 1-element array with flexible array
      scsi: message: fusion: struct _CONFIG_PAGE_SAS_IO_UNIT_0: Replace 1-element array with flexible array
      scsi: message: fusion: struct _RAID_VOL0_SETTINGS: Replace 1-element array with flexible array
      scsi: ipr: Replace 1-element arrays with flexible arrays
      scsi: aacraid: struct aac_ciss_phys_luns_resp: Replace 1-element array with flexible array
      scsi: aacraid: union aac_init: Replace 1-element array with flexible array
      scsi: megaraid_sas: struct MR_HOST_DEVICE_LIST: Replace 1-element array with flexible array
      scsi: megaraid_sas: struct MR_LD_VF_MAP: Replace 1-element arrays with flexible arrays
      scsi: mpi3mr: struct mpi3_sas_io_unit_page1: Replace 1-element array with flexible array
      scsi: mpi3mr: struct mpi3_sas_io_unit_page0: Replace 1-element array with flexible array
      scsi: mpi3mr: struct mpi3_event_data_pcie_topology_change_list: Replace 1-element array with flexible array
      scsi: mpi3mr: struct mpi3_event_data_sas_topology_change_list: Replace 1-element array with flexible array

Kevin Barnett (2):
      scsi: smartpqi: Improve handling of multipath failover
      scsi: smartpqi: Improve accuracy/performance of raid-bypass-counter

Mahesh Rajashekhara (2):
      scsi: smartpqi: add counter for parity write stream requests
      scsi: smartpqi: correct stream detection

Murthy Bhat (2):
      scsi: smartpqi: fix rare system hang during LUN reset
      scsi: smartpqi: Add fw log to kdump

Pedro Falcato (1):
      scsi: snic: Avoid creating two slab caches with the same name

Ranjan Kumar (3):
      scsi: mpi3mr: Driver version update to 8.10.0.5.50
      scsi: mpi3mr: Update consumer index of reply queues after every 100 replies
      scsi: mpi3mr: Return complete ioc_status for ioctl commands

Rob Herring (Arm) (2):
      scsi: ufs: ufshcd-pltfrm: Use of_property_count_u32_elems() to get property length
      scsi: ufs: ufshcd-pltfrm: Use of_property_present()

Yue Haibing (2):
      scsi: bnx2i: Remove unused declarations
      scsi: target: Remove unused declarations

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs         |  27 ++
 block/blk-core.c                                   |   1 +
 drivers/message/fusion/lsi/mpi_cnfg.h              |  60 +--
 drivers/message/fusion/mptbase.c                   |  10 +-
 drivers/message/fusion/mptbase.h                   |   3 -
 drivers/message/fusion/mptfc.c                     |   7 +-
 drivers/scsi/NCR5380.c                             | 233 +++++-----
 drivers/scsi/NCR5380.h                             |  20 +-
 drivers/scsi/aacraid/aachba.c                      |  28 +-
 drivers/scsi/aacraid/aacraid.h                     |  21 +-
 drivers/scsi/aacraid/commctrl.c                    |   4 +-
 drivers/scsi/aacraid/comminit.c                    |   3 +-
 drivers/scsi/aacraid/commsup.c                     |   5 +-
 drivers/scsi/aacraid/src.c                         |   2 +-
 drivers/scsi/be2iscsi/be_main.c                    |   6 +-
 drivers/scsi/bfa/bfad_im.c                         |   5 +-
 drivers/scsi/bfa/bfad_im.h                         |   1 -
 drivers/scsi/bnx2fc/bnx2fc.h                       |   6 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   4 +-
 drivers/scsi/bnx2i/bnx2i.h                         |  11 -
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   3 +-
 drivers/scsi/elx/efct/efct_lio.c                   |   3 +-
 drivers/scsi/elx/libefc/efc_nport.c                |   2 +-
 drivers/scsi/esas2r/esas2r.h                       |   1 -
 drivers/scsi/esas2r/esas2r_init.c                  |   5 +-
 drivers/scsi/fcoe/fcoe_sysfs.c                     |  18 +-
 drivers/scsi/fnic/fnic_main.c                      |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   3 +-
 drivers/scsi/hosts.c                               |   9 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |   5 +-
 drivers/scsi/ipr.h                                 |   4 +-
 drivers/scsi/libfc/fc_exch.c                       |   3 +-
 drivers/scsi/libfc/fc_rport.c                      |   3 +-
 drivers/scsi/libsas/sas_init.c                     |   4 +-
 drivers/scsi/lpfc/lpfc.h                           |  12 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  79 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  14 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  22 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  13 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_vmid.c                      |   3 +-
 drivers/scsi/mac_scsi.c                            | 170 +++----
 drivers/scsi/megaraid/megaraid_sas.h               |   6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   4 +-
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h               |  10 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |  10 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   7 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  36 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   4 +-
 drivers/scsi/myrb.c                                |   5 +-
 drivers/scsi/myrb.h                                |   1 -
 drivers/scsi/myrs.c                                |   5 +-
 drivers/scsi/myrs.h                                |   1 -
 drivers/scsi/qedf/qedf_main.c                      |  20 +-
 drivers/scsi/qedi/qedi_main.c                      |   8 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   1 -
 drivers/scsi/qla2xxx/qla_os.c                      |   6 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/scsi_transport_fc.c                   |  11 +-
 drivers/scsi/sd.c                                  |   2 +-
 drivers/scsi/smartpqi/smartpqi.h                   |  39 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 496 +++++++++++++++------
 drivers/scsi/smartpqi/smartpqi_sis.c               |  60 +++
 drivers/scsi/smartpqi/smartpqi_sis.h               |   3 +
 drivers/scsi/snic/snic_main.c                      |  10 +-
 drivers/scsi/stex.c                                |   6 +-
 drivers/scsi/sun3_scsi.c                           |   2 +-
 drivers/scsi/vmw_pvscsi.c                          |   3 +-
 drivers/target/iscsi/iscsi_target.h                |   2 -
 drivers/target/iscsi/iscsi_target_login.h          |   1 -
 drivers/target/iscsi/iscsi_target_nego.h           |   2 -
 drivers/target/iscsi/iscsi_target_tpg.h            |   5 -
 drivers/target/iscsi/iscsi_target_util.h           |   5 -
 drivers/ufs/core/ufs-sysfs.c                       |  91 +++-
 .../events/ufs.h => drivers/ufs/core/ufs_trace.h   |   6 +
 drivers/ufs/core/ufshcd.c                          |  85 ++--
 drivers/ufs/host/ufshcd-pltfrm.c                   |  14 +-
 include/scsi/fcoe_sysfs.h                          |   2 -
 include/scsi/scsi_dbg.h                            |   7 -
 include/scsi/scsi_host.h                           |   1 -
 include/scsi/scsi_transport_fc.h                   |   6 -
 include/ufs/ufs.h                                  |   4 +-
 include/ufs/ufshci.h                               |   5 +-
 87 files changed, 1098 insertions(+), 762 deletions(-)
 rename include/trace/events/ufs.h => drivers/ufs/core/ufs_trace.h (98%)

Regards,

James
