Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599D5212F87;
	Fri,  6 Dec 2024 21:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733519419; cv=none; b=OYy0hiKYit7vgTkm+/rjeamSYjBVn0q71U4ASbbJx+kU19ET2awOD6G8pWVn/1+6+o6lIZtvTsP7o5w2LtUPThyxkU1+hKBG4DtheiPpcZNE5r6MsREAcZ+kLl/zcODpCWImIpOIpT4Tp0NXIAElEVOJRkOhVqD29M4BdLuSPx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733519419; c=relaxed/simple;
	bh=vcgDZ0oSmql7uhsB+iwfZurwuZPYS4+9GO8QL+pfcYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ASXPtYq68NfYWd/iSnhs3XfHxa1JK8rQGii/Kbt3X571D1P1eP38YfrEIMrhZnfxy9JDYiqjupfx+M7Oszr8i51291rQqOs7z+Oedpl1YTriMgku4u5gO4LDCjc0zYt9tk35TshMhPexHS812gJ31EQ7h2vWG1ZXSvwPjo42mtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=f2t0w+94; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="f2t0w+94"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8851; q=dns/txt; s=iport;
  t=1733519417; x=1734729017;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vA/8CXH2/SH9IS7wtOylGa20PgDkYh8lgYvbnfid8UU=;
  b=f2t0w+941NWWNBJP/6edzLmRP5KqudI3fK+Id++YyFBpkBMfccv2RHH/
   AF2Cj9cAyt4ff4FpVJ8OlGjKCs2mP2idA1dRTEekaukF56LKzu42Y1whg
   NZPVIaPA9fONTB40/DioOWyHr6lyGSYX2EuhCk6f9VyJXGDJB5m6JYo1m
   8=;
X-CSE-ConnectionGUID: fkMUhUfxShW76ZGA2iubyQ==
X-CSE-MsgGUID: ekvbH+orRfmJtQSAQG4IDA==
X-IPAS-Result: =?us-ascii?q?A0BaAwBwZ1Nn/4//Ja1aHgEBCxIMgggLghwvgU9DGZZyg?=
 =?us-ascii?q?RadBYF+DwEBAQ9EBAEBhQeKagImNAkOAQIEAQEBAQMCAwEBAQEBAQEBAQEBC?=
 =?us-ascii?q?wEBBQEBAQIBBwWBDhOGCIZdKwsBRkkBgy9YgmUDsX2BeTOBAd4zgW2BSI1Kc?=
 =?us-ascii?q?IR3JxUGgUlEgRWCcgeCQYM5AoV6BII8hQASJU1Gg3ODep0dSIEhA1khARABV?=
 =?us-ascii?q?RMNCgsHBYF2A4JNeiuBC4EXOoF+gRNKhQxGPYJKaUs3Ag0CNoIkfYJNhRmEa?=
 =?us-ascii?q?WMvAwMDA4M8hiWCNEADCxgNSBEsNxQbBj5uB6VXDoEOASIrLitIOg4IHwUGO?=
 =?us-ascii?q?JJCHQdHjz6CIIE0n02EJJoehyYaM4QEjQWZSJh7o1wxN4RmgWc8gVkzGggbF?=
 =?us-ascii?q?YMjURkPji0WwiMlbgIHCwEBAwmTPoF7AQE?=
IronPort-Data: A9a23:5pAw3ajFas8Z3JzZ1udpg6liX161cREKZh0ujC45NGQN5FlHY01je
 htvXWmAPP3YZ2GkftgnYNiy9ksPvZLcz4BlSQZu/ns2EStjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOCn9SQkvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSFULOZ82QsaD5Nsfrd8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqUW+cNKAVxA5
 ccYF29TXD+q3eOryqOCH7wEasQLdKEHPasFsX1miDWcBvE8TNWbHePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgx/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9II3RHp4FxBrIz
 o7A12n6HBs6d9uF8zSA0G6Vvcb2sn/adKtHQdVU8dYv2jV/3Fc7ChAUX3O/oP+kmgi/UdcZI
 EsRkgIrpLIu9UrtVtThUgejrXisuQQVUN5dVeY97WmlzqvS/hbcBWUeSDNFQMIpudVwRjEw0
 FKN2dTzClRHtLyTVGLY7byPrBusNiUPa2wPfykJSU0C+daLnW0opgjEQtAmFOu+icf4XGmuh
 TuLtyM5wb4UiKbnypmGwLwOuBr0zrChc+L/zl+/sr6Nhu+hWLOYWg==
IronPort-HdrOrdr: A9a23:awF3fa4e4nRp8Yu6NQPXwPvXdLJyesId70hD6qm+c3Bom6uj5q
 KTdZsguyMc5Ax6ZJhCo6HiBEDjexLhHPdOiOF7AV7IZmbbUQWTQb1K3M/L3yDgFyri9uRUyK
 tsN5RlBMaYNykesS+D2mmF+xJK+qjhzEhu7t2uq0tQcQ==
X-Talos-CUID: 9a23:W5iPuWBhtoRXabv6Eydk0XMUJ841SX3ikyniDGbiCHtjWYTAHA==
X-Talos-MUID: 9a23:rYQaXgp55yPgcR6Sse4ezzxhKs1IoKO0Mk4Is4k/gOC9GnBRFx7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,214,1728950400"; 
   d="scan'208";a="293338248"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 06 Dec 2024 21:09:06 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id 8987918000263;
	Fri,  6 Dec 2024 21:09:05 +0000 (GMT)
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
Subject: [PATCH v6 00/15] Introduce support for Fabric Discovery and...
Date: Fri,  6 Dec 2024 13:08:37 -0800
Message-ID: <20241206210852.3251-1-kartilak@cisco.com>
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
X-Outbound-Node: rcdn-l-core-06.cisco.com

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
 drivers/scsi/fnic/fnic_fcs.c              | 1745 +++----
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
 19 files changed, 9342 insertions(+), 1931 deletions(-)
 create mode 100644 drivers/scsi/fnic/fdls_disc.c
 create mode 100644 drivers/scsi/fnic/fdls_fc.h
 create mode 100644 drivers/scsi/fnic/fip.c
 create mode 100644 drivers/scsi/fnic/fip.h
 create mode 100644 drivers/scsi/fnic/fnic_fdls.h
 delete mode 100644 drivers/scsi/fnic/fnic_fip.h
 create mode 100644 drivers/scsi/fnic/fnic_pci_subsys_devid.c

-- 
2.47.0

