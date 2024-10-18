Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86EA2022F5;
	Fri, 18 Oct 2024 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268134; cv=none; b=NRxqA05EgqzoNt6dQlQ2jSgUgAa/kMSLt220IVor65zipXNkErh6ugHS38rPcfWJiUX0VxVx1MTX4AEgsa6tzNF59WzkncQmbAaGDBQ5+wY3/C9CrRX6EXg35LIJ6zG6/ixZdg1gJ60HLpszKmLT0bnYnMG2b7UPHmdJ8WogQZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268134; c=relaxed/simple;
	bh=Sjsrv+tCvF8WkU+wjKa70nfms++9d7ZX4fXQd5KFJxU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=akrIJ61WGm7quaoiiAuYu0RNZ9f0gDK1MNrJ5SA+3BvHTOnniBjnKTTnVG+MIsN1oYv5OV+bBWE4k6UGTrD9aASGVhEJd8iVZT0qsbqv0KaW4LsEyrnbgYhT/rEneoSx8G6rlLsty2rfOMAX+btRS/fmGsgqy0bPqEZxqi32AZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=YvWfzQDk; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="YvWfzQDk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8167; q=dns/txt; s=iport;
  t=1729268132; x=1730477732;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XN8Ug8Q5MrmrjulIGnRXD0RJ30DPSeE3sWstwX9UCG4=;
  b=YvWfzQDkrgJRJ6wvsnDIMwIRG2KEzRW2cCHzUp0WHbGibRkd4K9BWgr+
   ztmLjSgh2cLRWWPMKLqnqIJ3mj3Jrg+tQbS3v+54pOur4EWjUZjvIP6s3
   LidTbXGelGsVKYzglT1BrJ4jjwkGLnIqmem12ZKaeCKQTpeu0ebWYNNQj
   U=;
X-CSE-ConnectionGUID: QoP5CklJTQum49MAogaCjQ==
X-CSE-MsgGUID: a0vvhw1TRjGsAs8Yqungtw==
X-IPAS-Result: =?us-ascii?q?A0BaAwAziBJn/5D/Ja1aH4I5ghwvgU9DGZZygRadAYF+D?=
 =?us-ascii?q?wEBAQ9EBAEBhQeKJQImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQ0BAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThgiGXSsLAUZJAYMvWIJlA7ADgXkzgQHeM4FsgUiNRnCEdycVBoFJR?=
 =?us-ascii?q?IEVgnIHgkGDOQKFegSGf4djFnCCDw6CEAqDR4E8hDcWJU1miAqRQEiBIQNZI?=
 =?us-ascii?q?QIBEAFVEw0KCwkFiTWBEIIWKYFrgQiDCIUlgWcJYYhHgQctgRGBHzqCA4E2S?=
 =?us-ascii?q?oU3Rz+CT2pONwINAjeCJIEAglGFUjZAAwsYDUgRLDUUGwY+bgevZw6BDyIrL?=
 =?us-ascii?q?itIOg4IHwUGOJI9HQcCRY8ugiCBNJ9KhCSaGoclGjOEBY0BmUaYd6NUMTWEZ?=
 =?us-ascii?q?oFnPIFZMxoIGxWDI1EZD44tFsseJm0CBwsBAQMJjCiBewEB?=
IronPort-Data: A9a23:TI5ZyK0Ffj2//UyX5PbD5cJwkn2cJEfYwER7XKvMYLTBsI5bpzQAn
 DAZXGmPPvyPZWfwKI93btm19hwD6J/WmNYxTAto3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ1yEzmG4E/0YtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU4
 Lsen+WFYAX5gmYtYjpJg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGNUYOYKYb/sRLOHxLq
 a09ATcCZzuBvrfjqF67YrEEasULNsLnOsYb/3pn1zycValgSpHYSKKM7thdtNsyrpkRRrCFO
 IxDNGcpNUicC/FMEg9/5JYWn+6ymnj7ej5wo1OOrq1x6G/WpOB0+OKzb4CMJ4XWHa25mG6R/
 nzY/3ugPisYG8e20mq062+qifPQyHaTtIU6UefQGuRRqF+exGY7DBwQSEv9oPO8zEW5Xrp3L
 kUO5iso67A/6EGxVdT7dxqiqXWAs1gXXN84O+k77hydj6nZ+QCUAkAaQTNbLt8rrsk7QXotz
 FDht9foAyF/9aaeUnO16LiZt3WxNDITIGtEYjULJTbp+PH5q401yxaKRdF5Hevt0Zv+GCr7x
 HaBqy1Wa6gvsPPnHp6TpTjv6w9AbLCQJuLpzm07hl6Y0z4=
IronPort-HdrOrdr: A9a23:HbH6I62kACvBwHOyi7UNNwqjBIEkLtp133Aq2lEZdPWaSKClfq
 eV7ZYmPHDP5gr5NEtLpTniAtjifZq/z/9ICOAqVN/IYOCMggSVxe9ZgLfK8nnJBzD++ulB1a
 1pbqRyTOHrAUMSt7ee3ODBKbYdKB3tytHOuQ8YpE0dKT1XVw==
X-Talos-CUID: 9a23:lG6rdWAe0eLkElH6ExBgzBM/GcQHTkTAySuBBma/Bm9CSoTAHA==
X-Talos-MUID: 9a23:L0zfgAmL+MABmHFnt/ZodnprbNl247v3NHoPvo4voJm1LDF2NCuC2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,214,1725321600"; 
   d="scan'208";a="267215140"
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Oct 2024 16:14:23 +0000
Received: from fedora.cisco.com (unknown [10.24.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPSA id 3572618000229;
	Fri, 18 Oct 2024 16:14:21 +0000 (GMT)
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
Subject: [PATCH v5 00/14] Introduce support for Fabric Discovery and... 
Date: Fri, 18 Oct 2024 09:13:55 -0700
Message-ID: <20241018161409.4442-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.40.136, [10.24.40.136]
X-Outbound-Node: rcdn-l-core-07.cisco.com

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
All the individual patches compile cleanly. There are some unused
function warnings, but since the function calls happen in later
patches, those warnings go away. Some functions are written as 
placeholders for earlier patches that indicate some warnings. However,
those warnings get fixed in later patches.

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

Thanks and regards,
Karan


Karan Tilak Kumar (14):
  scsi: fnic: Replace shost_printk with dev_info/dev_err
  scsi: fnic: Add headers and definitions for FDLS
  scsi: fnic: Add support for fabric based solicited requests and
    responses
  scsi: fnic: Add support for target based solicited requests and
    responses
  scsi: fnic: Add support for unsolicited requests and responses
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
 drivers/scsi/fnic/fdls_disc.c             | 4505 +++++++++++++++++++++
 drivers/scsi/fnic/fdls_fc.h               |  381 ++
 drivers/scsi/fnic/fip.c                   |  876 ++++
 drivers/scsi/fnic/fip.h                   |  345 ++
 drivers/scsi/fnic/fnic.h                  |  217 +-
 drivers/scsi/fnic/fnic_attrs.c            |   12 +-
 drivers/scsi/fnic/fnic_debugfs.c          |   30 +-
 drivers/scsi/fnic/fnic_fcs.c              | 1768 ++++----
 drivers/scsi/fnic/fnic_fdls.h             |  431 ++
 drivers/scsi/fnic/fnic_io.h               |   14 +-
 drivers/scsi/fnic/fnic_isr.c              |   28 +-
 drivers/scsi/fnic/fnic_main.c             |  674 +--
 drivers/scsi/fnic/fnic_pci_subsys_devid.c |  131 +
 drivers/scsi/fnic/fnic_res.c              |   77 +-
 drivers/scsi/fnic/fnic_scsi.c             | 1168 ++++--
 drivers/scsi/fnic/fnic_stats.h            |   49 +-
 drivers/scsi/fnic/fnic_trace.c            |   83 +-
 18 files changed, 8917 insertions(+), 1877 deletions(-)
 create mode 100644 drivers/scsi/fnic/fdls_disc.c
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fip.c
 create mode 100644 drivers/scsi/fnic/fip.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

-- 
2.31.1

