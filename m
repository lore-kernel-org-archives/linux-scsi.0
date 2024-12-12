Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FA98837;
	Thu, 12 Dec 2024 02:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969021; cv=none; b=Jnqemi8OZAfqZVjY/7gCZ7yDx5H7Haj5UFlQoXRvlfIVeSwx3WRS8Ew5qP03nqnS5EE9P5DZdgXaGlh0sZ2Lgvn2dx2pVDOOBjkznS5MqR4Ul/ltDq9jZTu7UBPf4x9No03hNyloSYbY0vRT1IQL3lvaEZtkHp9aWyV3zdybORw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969021; c=relaxed/simple;
	bh=S0lWGYjQ/3lew7L7+OCK2dxxtyKvrlPSfSkPOXxTNf4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=raEviKQXqksmbwHCQizI59Qm2Is4cXvUgDsCpjAgnkJ8fLaVpZuAvXuNi923lIIsXYg+5FR01mfuBZHwZrG/3+Rb0ziLU1YI0VttBToZcjXlXkpGtPHm2UmrxmYcyq4b8c5fhab4yGy79G7JuteTSxg8IAjMsoN+oPpIVgUIyi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=FkfvRBUX; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="FkfvRBUX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8908; q=dns/txt; s=iport;
  t=1733969019; x=1735178619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CfLGEkRajjEGnc+mdj8GF+RxsbjZCxcvoomF0VCDaAw=;
  b=FkfvRBUXXE2PNtmGAUWCdmKCo48QDRTjZ1uKySILgtSe2hFaXDd/hjsO
   ZV4RcxyKDlZHIfwkWOmvbEawyYBu8rC/uFsSpmzAQp3psjXyv2MHN9i3l
   RCmntdL1w0hiI+wQ5qTizxBCTouhOZm9IRUV9cQV3wl0HDkM+SEZ6tVTH
   I=;
X-CSE-ConnectionGUID: MX9XVcEZQAy4GrskToQkSQ==
X-CSE-MsgGUID: JFyx30ZVT3mn1gm62mU0QA==
X-IPAS-Result: =?us-ascii?q?A0B2AwAdQ1pn/5T/Ja1aglyCHC+BT0MZlnKBFp0FgX4PA?=
 =?us-ascii?q?QEBD0QEAQGFB4ptAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4YIhl0rCwFGSQGDL1iCZQOvGoF5M4EB3jOBbYFIjUpwhHcnFQaBS?=
 =?us-ascii?q?USBFYJyB4JBgzkChXoEgjxMghuDeZ0ASIEhA1khARABVRMNCgsHBYF1AzkMC?=
 =?us-ascii?q?zEVg2BGPYJJaUk3Ag0CNoIkfIJNhRmEaWMvAwMDA4M5hiSCGYFfQAMLGA1IE?=
 =?us-ascii?q?Sw3FBsGPm4Hn2QOgQ4BIisuK0g6DggfBQY4kkIdB0ePP4IggTSfToQkmh6HJ?=
 =?us-ascii?q?hozhASNBZlImHujXDE3hGaBZzyBWTMaCBsVgyNRGQ+OLRbEBiVuAgcLAQEDC?=
 =?us-ascii?q?Y9UgXsBAQ?=
IronPort-Data: A9a23:4eVsHKs/aiHJgQS2W7irIQ5tEufnVEdfMUV32f8akzHdYApBsoF/q
 tZmKTvSPquNazD0KtxxPdm2/UpQvMCAm9JkQVRrqHpkFiJGgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav656yEhjclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuGYjdJ5xYuajhIsvja8Usy1BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw39YmMV9F2
 M4hASFRQQqYhN6x+bGAc7w57igjBJGD0II3oHpsy3TdSP0hW52GGvyM7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtHYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUobbGJgKzhvB+
 Aoq+UzbLAAKb4St9wbe93T1ieqRxybGALs7QejQGvlCxQf7KnYoIB8bV1GTpfi/l174Wthab
 UcT/0IGqKEo6E2tCMHwQxCiu3OClhkGUtFUHqsx7wTl4q7V5RuJQ2sJVDhMbPQ4u8IsAz8nz
 FmEm5XuHzMHmLmUT2+Ns6yftjKaJycYNykBaDUCQA9D5MPsyLzflTrVRdplVarwhdrvFHSpm
 naBrTM1gPMYistjO7iHwG0rSgmE/vDhJjPZLC2LNo55xmuVvLKYWrE=
IronPort-HdrOrdr: A9a23:Qigqp6iK2qbLu8WppmSNjsDx4nBQXukji2hC6mlwRA09TyVXra
 yTdZMgpH3JYVkqNk3I9errBEDiewK+yXcW2+gs1N6ZNWGMhILCFu5fBOXZrgHIKmnX6vNd2a
 B8c6J3FdH8SWRhgd2S2njcLz9Z+rm6GGTCv5a485+rJjsaD51d0w==
X-Talos-CUID: =?us-ascii?q?9a23=3AIbkIbmnnILMKwL+C3Y5wUNEzStXXOVjtnUfuKGK?=
 =?us-ascii?q?KME94FJKPUlys/5pnqPM7zg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AaagzlA4QMevLe4+P2SSial5TxoxKzbW+Uxg/r6l?=
 =?us-ascii?q?dvs/dOikuYTKg1A2eF9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,227,1728950400"; 
   d="scan'208";a="295578516"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Dec 2024 02:03:32 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id E685818000265;
	Thu, 12 Dec 2024 02:03:29 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v7 00/15] Introduce support for Fabric Discovery and... 
Date: Wed, 11 Dec 2024 18:02:57 -0800
Message-ID: <20241212020312.4786-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-11.cisco.com

...Login Services

Hi Martin, reviewers,

This cover letter describes the feature: add support for Fabric
Discovery and Login Services (FDLS) to fnic driver.

This functionality is needed to support port channel RSCN (PC-RSCN)
handling and serves as a base to create FC-NVME initiators
(planned later), and eCPU handling (planned later).

It is used to discover the fabric and target ports associated with the
fabric.
It will then login to the target ports that are zoned to it.
The driver uses the tport structure presented by FDLS.

Port channel RSCN is a Cisco vendor specific RSCN
event. It is applicable only to Cisco UCS fabrics.

In cases where the eCPU in the UCS VIC (Unified Computing Services
Virtual Interface Card) hangs, a fabric log out is sent to the fabric.
Upon successful log out from the fabric, the IO path is failed over
to a new path.

Generally from a feature perspective, the code is divided into adding
support for this functionality initially. Then, code has been added to
modify the IO path and interfaces. Finally, support for port channel
RSCN handling has been added.

Here are the headers of some of the salient patches:

o add headers and definitions for FDLS
o add support for fabric based solicited requests and responses
o add support for target based solicited requests and responses
o add support for unsolicited requests and responses
o add support for FDMI
o add support for FIP
o add functionality in fnic to support FDLS
o modify IO path to use FDLS and tport
o modify fnic interfaces to use FDLS
o add support to handle port channel RSCN

Even though the patches have been made into a series, some patches are
heavier than others. But, every effort has been made to keep the
purpose of each patch as a single-purpose, and to compile cleanly.
All the individual patches compile cleanly. The compiler used is
GCC 13.3. Some function calls have been coded as placeholders with
appropriate comments to avoid compiler warnings.

This patchset has been tested as a whole. Therefore, the tested-by
fields have been added only to one patch in the set.
I've refrained from adding tested-by to most of the patches,
so as to not mislead the reviewer/reader.

A brief note on the unit tests:

o. Perform zone in zone out testing in a loop: remove a target
port from the zone, add it to the zone in a loop. 1000+ iterations
of this test have been successful.
o. Configure multipathing, and run link flaps on single link.
IOs drop briefly, but pick up as expected.
o. Configure multipathing, and run link flaps on two links, with a
30 second delay in between. IOs drop briefly, but pick up as expected.
o. Module load/unload test.
o. Repeat the above tests with 1 queue and 64 queues.
All tests were successful.

Please consider this patch series for the next merge window.

Changes between v1 and v2:
	Replace pr_err with printk.
	Replace simultaneous use of fc_tport_abts_s and tport_abts with
    just tport_abts.
	Incorporate review comments by Hannes:
		Replace pr_info with dev_info.
		Replace pr_err with dev_err.
		Restore usage of tagset iterators.
		Replace fnic_del_tport_timer_sync macro calls with function
		calls.
		Use the correct kernel-doc format.
		Replace definitions with standard definitions from
		fc_els.h.
		Replace htonll() with get_unaligned_be64().
		Use standard definitions from scsi_transport_fc.h for
		port speeds.
		Refactor definitions in struct fnic to avoid cache holes.
		Replace memcmp with not equal to operator.
		Fix indentation.
		Replace fnic_del_fabric_timer_sync macro calls to function
		calls.
		Rename fc_abts_s to fc_tport_abts_s.
		Modify fc_tport_abts_s to be a global frame.
		Rename variable pfc_abts to tport_abts.
		Modify functions with returns in the middle to if else
		clauses.
		Remove double newline.
		Fix indentation in fnic_send_frame.
		Add fnic_del_fabric_timer_sync as an inline function.
		Add fnic_del_tport_timer_sync as an inline function.
		Modify fc_abts_s variable name to fc_fabric_abts_s.
		Modify fc_fabric_abts_s to be a global frame.
		Rename pfc_abts to fabric_abts.
		Remove redundant patch description.
		Replace htonll() with get_unaligned_be64().
		Replace raw values with macro names.
		Remove fnic_del_fabric_timer_sync macro.
		Remove fnic_del_tport_timer_sync macro.
		Add fnic_del_fabric_timer_sync function declaration.
		Add fnic_del_tport_timer_sync function declaration.
		Move FDMI function declaration.
		Modify patch heading and description appropriately.
	Incorporate review comments from John:
		Remove unreferenced variable.
		Use standard definitions of true and false.
		Replace if else clauses with switch statement.
		Use kzalloc instead of kmalloc.
		Modify fnic_send_fcoe_frame to not send a return value.
		Replace int return value with void.
	Fix warning from kernel test robot:
		Remove version.h

Changes between v2 and v3:
    Incorporate review comments from Hannes:
        Replace redundant structure definitions with standard
        definitions.
		Replace static OXIDs with pool-based OXIDs for fabric.
		Replace static OXIDs with pool-based OXIDs for targets.
		Remove multiple endian macro copies.
		Modify locking as applicable.
	Incorporate review comments from John:
		Replace GFP_ATOMIC with GFP_KERNEL where applicable.
	Replace fnic->host with fnic->lport->host in some patches to
	prevent compilation errors.
	Fix issues found by kernel test robot.
	Refactor fnic_std_ba_acc definition to fix compilation warning.
	Refactor fnic_fdls_remove_tport to fix null pointer exception.
	Modify scsi_unload to fix null pointer exception during fnic_remove.

Changes between v3 and v4:
	Fix kernel test robot warnings.
	Rebase code to 6.12/scsi-queue.

Changes between v4 and v5:
	Remove unnecessary tabs from the bottom of fip.h.
	Incorporate review comments from Martin:
		Remove newline at the end of files.
		Modify attribution appropriately.
		Refactor call to fnic_fdls_start_flogi.
		Refactor call to fdls_get_tgt_oxid_pool.
		Modify fnic_get_stats to suppress compiler warning.

Changes between v5 and v6:
	Rebase to 6.14/scsi-queue.
    Incorporate review comments from Martin:
        Remove GCC 13.3 warnings.
    Incorporate review comments from Hannes:
		Refactor function definitions to top of file.
		Modify OXID allocation and reclaim design.
		Allocate OXID from a mempool.
		Allocate frames from a mempool.
		Modify frame initialization.
		Modify frame send by avoiding memcpy in hot path.
		Add comments.
		Replace tag walk with scsi_host_busy_iter.
		Replace custom definitions with standard definitions.
		Split FDMI patch into PCI patch and FDMI patch.
		Refactor FDMI macros into fnic_main.c.
		Replace FDMI custom definition with standard definition.

Changes between v6 and v7:
	Fix test robot warnings.

Thanks and regards,
Karan

Karan Tilak Kumar (15):
  scsi: fnic: Replace shost_printk with dev_info/dev_err
  scsi: fnic: Add headers and definitions for FDLS
  scsi: fnic: Add support for fabric based solicited requests and
    responses
  scsi: fnic: Add support for target based solicited requests and
    responses
  scsi: fnic: Add support for unsolicited requests and responses
  scsi: fnic: Add Cisco hardware model names
  scsi: fnic: Add and integrate support for FDMI
  scsi: fnic: Add and integrate support for FIP
  scsi: fnic: Add functionality in fnic to support FDLS
  scsi: fnic: Modify IO path to use FDLS
  scsi: fnic: Modify fnic interfaces to use FDLS
  scsi: fnic: Add stats and related functionality
  scsi: fnic: Code cleanup
  scsi: fnic: Add support to handle port channel RSCN
  scsi: fnic: Increment driver version

 drivers/scsi/fnic/Makefile                |    5 +-
 drivers/scsi/fnic/fdls_disc.c             | 5019 +++++++++++++++++++++
 drivers/scsi/fnic/fdls_fc.h               |  253 ++
 drivers/scsi/fnic/fip.c                   | 1008 +++++
 drivers/scsi/fnic/fip.h                   |  157 +
 drivers/scsi/fnic/fnic.h                  |  290 +-
 drivers/scsi/fnic/fnic_attrs.c            |   12 +-
 drivers/scsi/fnic/fnic_debugfs.c          |   30 +-
 drivers/scsi/fnic/fnic_fcs.c              | 1743 +++----
 drivers/scsi/fnic/fnic_fdls.h             |  434 ++
 drivers/scsi/fnic/fnic_fip.h              |   48 -
 drivers/scsi/fnic/fnic_io.h               |   14 +-
 drivers/scsi/fnic/fnic_isr.c              |   28 +-
 drivers/scsi/fnic/fnic_main.c             |  731 +--
 drivers/scsi/fnic/fnic_pci_subsys_devid.c |  131 +
 drivers/scsi/fnic/fnic_res.c              |   77 +-
 drivers/scsi/fnic/fnic_scsi.c             | 1161 +++--
 drivers/scsi/fnic/fnic_stats.h            |   49 +-
 drivers/scsi/fnic/fnic_trace.c            |   81 +-
 19 files changed, 9340 insertions(+), 1931 deletions(-)
 create mode 100644 drivers/scsi/fnic/fdls_disc.c
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fip.c
 create mode 100644 drivers/scsi/fnic/fip.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h
 delete mode 100644 drivers/scsi/fnic/fnic_fip.h
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

-- 
2.47.0

