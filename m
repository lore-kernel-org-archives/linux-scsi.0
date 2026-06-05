Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD232EC081;
	Fri,  5 Jun 2026 23:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703220; cv=none; b=HXyljO+BpO1ywfgeDEDGd6l9LcKiPRvCIH3KvxzFVVCquDsgB6sLbQ+JE2QxYh/GVVqJjYPz7cntNalyge36/uIVODL2t0XI+mr9EnZAdNNTx/o0qWXhE395pfnj1YD4SbYdUpcNOIHc4AV/dkGK6WEOQPGa/Rmn8QrA4J19KTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703220; c=relaxed/simple;
	bh=5k2IgsVahKUOcXhSsg3Nl8KGyGTXscUPat2OxGmqxzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ig6D1HMnf6TD3tUk4CS4a54IfOnQ0HmK78ypRKm4v/kSMgxwM0ki+3SXfZ7BKhHvuLw0PjsDkl4G9GSYAk4UF2iEPT9twfdD3j+2SVlBCGyZC/9Zu1IElIJQDFAY9sN/5tb9gQJuAI+aUgUMVIwQoaYFB97nJ3s8Wbyg5b4A4kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=RpDKC0qm; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="RpDKC0qm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4829; q=dns/txt;
  s=iport01; t=1780703219; x=1781912819;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2R8BwgHmi/PpSiQSdXL+IrO0YeSdjQcQ5waJJ5imKOY=;
  b=RpDKC0qmWpMIdhJljpiT3Qoo8hh8xG7sN1pd8V95wOxrey+FsG58Q+p5
   N/L+VQDPH8q3qKdOcZbA+cxLL+J/OLwtFydzHrpgOI9UpHAvK3F6w2lXa
   r8DaU/TZUj05IoJr1HtwTc7d2qRuHZmNMv74CaJAWyZ+N4cmPw9PkOi5Y
   336l5zTmKBtvagAUyJYcz5lZ7IL0p2lY6TsNhi+D8QERz8U39Pp6QbSF+
   MbLMD+6nOhDvzsFeCGmtxALcSIxJ/ToPWoayPdHWx6471t2C7lHMor9QE
   eV+O6NIxbcVPJh0kOl98rTyCFZ7W5CKZN0u6aSv8VfGv+/koq32s4x1dT
   Q==;
X-CSE-ConnectionGUID: HWTpz9zTQMWkYpbfmSf/fA==
X-CSE-MsgGUID: tFUd70GIQQa/a9HHtmIdTA==
X-IPAS-Result: =?us-ascii?q?A0BVAwATXiNq/5P/Ja1aHgEBCxIMggULhClDGZRagiGBF?=
 =?us-ascii?q?p0IgX4PAQEBD1EEAQGFBo01AiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThlyGXTYBRoRSgnQDtAyCLIEB3kKBchWBOI1ddBuEYCcVBoFJR?=
 =?us-ascii?q?IEVgnKCSIJJhmwEgiJ6EoV8imBIgR4DWSwBVRMNCgsHBYFmAzUSKhVuMh2BI?=
 =?us-ascii?q?z4XgQsbBwWBSoFJaoEEhRIjHwM5gReBfIEoZ2kVMToXAwsYDUgRLDcUGwQ+b?=
 =?us-ascii?q?geOaxkHAVc3B0YuBi94FgEeky8DEZIti3eVF4QmoVsaM6prmQajcBiFOIFoP?=
 =?us-ascii?q?IFZMxoIGxWDI1IZD44tFsg8J28CBwIHDgMLkWkBJgeBTgEB?=
IronPort-Data: A9a23:spQc2qBDuyMkKRVW/8/iw5YqxClBgxIJ4kV8jS/XYbTApGwg1jQEm
 GdLW2nVbP/YZGKnfY0iOoSx8EtVucKEzNRhOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jX2thh
 fuo+5eBYAH9hmYtWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE48pSFFNnL7Eh39l0MHlE+
 /kjJncDR0XW7w626OrTpuhEnM8vKozveYgYoHwllGmfBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGYwBPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FAujuK9bYaMKrRmQ+1JsHuU+
 Trp3l3AC1YTZfy/1T+k/k6F07qncSTTHdh6+KeD3vxngle7wm0VFQ1QVFG+5/K+jyaWXttFN
 00SvDIjsaUo70GtZt7nVha8rTiPuRt0c9NcGu498AaQ4rDZ7waQGi4PSTspQN4juck7Sjwr/
 kWEk9PgGXpkt7j9YWiQ6LqOthuoNCQVJHNEbigBJSMB78Tlq4g1pgnSVdslG6mw5vXxGDft0
 3WJoTI4irE7k8EGzeO48ErBjjbqoYLGJiYx5wPKTie+5Rh4TJCqapbu6lXB6/tEaoGDQTG8U
 GMsgcOS6qUKSJqKjiHIGb1LF7Cy7PHDOzrZ6bJyI6QcG/2W0ybLVehtDPtWfS+F7u5slefVX
 XLu
IronPort-HdrOrdr: A9a23:NtDJqaD4GGScpQLlHely55DYdb4zR+YMi2TDGXocdfUzSL37qy
 nAppomPHPP4gr5O0tQ+uxoWpPgfZq0z/ccirX5Vo3MYOCJggaVBbAnxZf+wjHmBi31/vNQ2O
 NdaaRkYeeAaGSS9fyb3CCIV/A93dKA7Kekwc3az3trUEVWTpsI1XYcNu5eeXcGIjWvwvECZf
 2h2vY=
X-Talos-CUID: 9a23:1pBCDm5hLBUuVPOxEtss1HEoAtJ0YEHk6UjTEleyB2NSRvqbYArF
X-Talos-MUID: =?us-ascii?q?9a23=3AJafbLA1UgbyQro6yFRGpDJWi8jUj/4qTBB9VvrQ?=
 =?us-ascii?q?/gsDDPH1QGyuYrTiLa9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="476285418"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:45:50 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 02F5F18000A55;
	Fri,  5 Jun 2026 23:45:48 +0000 (GMT)
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
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v3 00/13] Introduce functionality for NVMe initiator
Date: Fri,  5 Jun 2026 16:45:25 -0700
Message-ID: <20260605234538.7950-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.102.68];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.102.68, [10.188.102.68]
X-Outbound-Node: rcdn-l-core-10.cisco.com

Hi Martin, reviewers,

This series adds functionality for NVMe initiator to the fnic driver.

The changes enable the fnic driver to act as an NVMe initiator over
Fibre Channel (FC-NVMe), allowing the host to discover and communicate
with NVMe targets using the existing fnic infrastructure. The patches
prepare the driver for full FC-NVMe initiator operation while
maintaining existing SCSI/FC functionality.

These are some of the salient patches:

o. Make fnic debug logging usable by SCSI and NVMe initiator roles.
o. Use fnic instance numbers for non-SCSI-facing identifiers.
o. Decode firmware roles for FCP, NVMe, and unsupported targets.
o. Advertise NVMe initiator service parameters during FC discovery.
o. Add FDLS role handling for NVMe initiator discovery flows.
o. Add the NVMe/FC transport path and port registration.
o. Route completions, resets, and LS frames by initiator role.
o. Add NVMe LS timeouts, statistics, and debugfs state reporting.

Even though the patches have been made into a series, some patches are
heavier than others. But, every effort has been made to keep the
purpose of each patch as a single-purpose, and to compile cleanly.
All the individual patches compile cleanly. The compiler used is GCC
14.2.

This patch set has been tested as a whole. Therefore, the tested-by
fields have been added only to one patch in the set.
I've refrained from adding tested-by to most of the patches, so as to
not mislead the reviewer/reader.

A brief note on the unit tests:

o. Configure multipathing, and run link flaps on single link. IOs drop
   briefly, but pick up as expected.
o. Configure multipathing, and run link flaps on two links, with a 30
   second delay in between. IOs drop briefly, but pick up as expected.
o. Repeat the above tests with 1 queue and 64 queues.
o. Perform tests with Netapp and Pure targets.

All tests were successful.

This set of patches was reviewed before submitting upstream,
and the following review comments were incorporated.

Incorporate review comments from Hannes Reinecke:

Decode target roles explicitly and report unsupported roles.
Remove the empty line before the FLOGI completion else block.
Add a short comment for the NVMe ERSP completion case.

Incorporate review comments from Lee Duncan:

Replace the NVMe LS OXID switch with a direct frame-type check.
Rename the NVMe frame helper to follow fnic function naming style.
Convert the NVMe opcode stats helper to a switch statement.
Share NVMe completion stats accounting and compute duration once.

Changes between v1 and v2:
	Incorporate review comments from Marco Crivellari:
		Explicitly use WQ_PERCPU for the fnic completion workqueue.

Changes between v2 and v3:
	Fix issues reported by kernel bot.
	Add the active OXID to the tport timeout debug print.
	Guard NVMe I/O and LS request debug logs when tport is NULL.
	Validate ERSP response length before copying the response.
	Validate LS response frame and payload lengths before copying.
	Limit nvmef_info debugfs output to the allocated buffer.

Thanks,
Karan

Karan Tilak Kumar (13):
  scsi: fnic: Make debug logging protocol independent
  scsi: fnic: Use fnic_num for non-SCSI identifiers
  scsi: fnic: Decode firmware role configuration
  scsi: fnic: Advertise NVMe initiator service parameters
  scsi: fnic: Add FDLS role handling for NVMe initiators
  scsi: fnic: Add the NVMe/FC transport path
  scsi: fnic: Route completions and resets by initiator role
  scsi: fnic: Handle NVMe LS frames in FDLS
  scsi: fnic: Send NVMe LS requests through FDLS
  scsi: fnic: Abort timed-out NVMe LS requests
  scsi: fnic: Track NVMe transport statistics
  scsi: fnic: Expose NVMe transport state in debugfs
  scsi: fnic: Bump up version number

 drivers/scsi/fnic/Makefile       |    1 +
 drivers/scsi/fnic/fcpio.h        |   35 +
 drivers/scsi/fnic/fdls_disc.c    |  953 +++++++------
 drivers/scsi/fnic/fdls_fc.h      |   12 +
 drivers/scsi/fnic/fip.c          |  117 +-
 drivers/scsi/fnic/fip.h          |    2 +-
 drivers/scsi/fnic/fnic.h         |  104 +-
 drivers/scsi/fnic/fnic_debugfs.c |  101 +-
 drivers/scsi/fnic/fnic_fcs.c     |  196 +--
 drivers/scsi/fnic/fnic_fdls.h    |   48 +-
 drivers/scsi/fnic/fnic_io.h      |   23 +-
 drivers/scsi/fnic/fnic_isr.c     |   28 +-
 drivers/scsi/fnic/fnic_main.c    |  212 ++-
 drivers/scsi/fnic/fnic_nvme.c    | 2129 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  207 +++
 drivers/scsi/fnic/fnic_res.c     |   31 +-
 drivers/scsi/fnic/fnic_res.h     |   32 +-
 drivers/scsi/fnic/fnic_scsi.c    |  249 ++--
 drivers/scsi/fnic/fnic_stats.h   |   28 +
 drivers/scsi/fnic/fnic_trace.c   |    5 +-
 drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
 21 files changed, 3737 insertions(+), 778 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h

-- 
2.47.1

