Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA49311973;
	Wed, 27 May 2026 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911424; cv=none; b=BPUZTMbMo2PI5KWzh3eGweXHnGzzUS0BAjjnwTN9b2N+MqmCuDBq0Y6EFAq3fMqu7yayqxm1BwnjtT6p8FB6pb5yVDRxBL9kjC/eHz0nbk/zUzwEdAA9JYeShz/p71RSqYNQt9RwgMwX1jnFyeoMtbuxOSYiaXXpxHJWJ1ZWa8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911424; c=relaxed/simple;
	bh=ZkYvCLgaXOu/8SNWd32vgrh/tVHgiqiH7avNBS0obV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OtumpKTI7kCH3CqVuyFNda+zezV1tdLMpKdc8HkZVTg/85YLcv2jG38WJCDBqXMSFrKvHVX4ZwDjrr9CUIfGqubKUZTVC4yAEni2f/mVdyRWPsAEsU6JTTKZ/mcPihOMuQx6MrSnsiVqu8BAqhx5az+Mj68ZBa7H810p6Vh1lVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ipqHBbTW; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ipqHBbTW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4458; q=dns/txt;
  s=iport01; t=1779911422; x=1781121022;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rgQOK6nQjSpLbEgOH1bhDkCKNpk0EtCMJ7LdoLt34pQ=;
  b=ipqHBbTWwfw9NTDo1oWuVdNVZGPo/mqLp3KI44O7dweUusq7DRJngQOd
   O10xxSc8hB7urY0rIpLXJgLdHJxj85RVDGYYpCtL3bAXvfDmflzTzCESD
   elRVA2wFn+m5nON9Zjit27UcUKzkF768RQWQPrQogYp1tI/9ew/i3Ctp6
   twar0j3fw0/t6z6xSS+ELyOWNLi97+nN8yXRrP2WJBoZg0EWG5n37ZxZO
   gL+vGwZbes6AIglMJcLYuji03iFjCjz1NUh7BoW3vqvhh0f1vJ62/K2dP
   VmE3+QEVjDUz+5YPBxeaTcK5MrHZaOmqV4UoTlDlrubYuuI4ouQYYA2RX
   Q==;
X-CSE-ConnectionGUID: UTI8IWqcTI6pCt1z0Vkgpw==
X-CSE-MsgGUID: xYZHqLLTRk+lbVmfGjfGrA==
X-IPAS-Result: =?us-ascii?q?A0BfBADGShdq/5P/Ja1aglmEJ0MZlFqCIYEWnQiBfg8BA?=
 =?us-ascii?q?QEPUQQBAYUGjTQCJjYHDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZdNgFGhFKCdAO0UIIsgQHeQYFwFYE4jVx0G4RgJxUGgUlEgRWCcoJIi?=
 =?us-ascii?q?TUEgiJ6EoYRiQBIgR4DWSwBVRMNCgsHBYFmAzUSKhVuMh2BIz4XgQsbBwWBS?=
 =?us-ascii?q?3ZyaoEFhRgjJgNOgS2Bf10DCxgNSBEsNxQbBD5uB40vGQcBVzcHdAYveBYBH?=
 =?us-ascii?q?pMvAxGSLYt3lReEJqFbGjOqa5kGo3CFUIFvCyqBWTMaCBsVgyNSGQ+OLRbOY?=
 =?us-ascii?q?CdvAgcCBw4DC5NlAQE?=
IronPort-Data: A9a23:cDfg/qDiNIjfHxVW/8/iw5YqxClBgxIJ4kV8jS/XYbTApDgggWEBm
 msWCm7TOvuKYmv2LdklbdnlpEtQ7JTWz4BiOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jX2thh
 fuo+5eBYAL/hGYuWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE/slPXGAJJIYk27hvKn0X5
 6QmKz8VcUXW7w626OrTpuhEnM8vKozveYgYoHwllGmfBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGYwBPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FAhjuiybYWIKrRmQ+1Fr3S4v
 0biw176QRUQCtmR5jiL3WiF07qncSTTHdh6+KeD3vxngle7wm0VFQ1QVFG+5/K+jyaWXttFN
 00SvDIjsaUo70GtZt7nVha8rTiPuRt0c9NcGu498AaQ4rDZ7waQGi4PSTspQN4juck7Sjwr/
 kWEk9PgGXpkt7j9YWiQ6LqOthuoNCQVJHNEbigBJSMB78Tlq4g1pgnSVdslG6mw5vXxGDft0
 3WJoTI4irE7k8EGzeO48ErBjjbqoYLGJiYx5wPKTie+5Rh4TJCqapbu6lXB6/tEaoGDQTG8U
 GMsgcOS6qUKSJqKjiHIGb1LF7Cy7PHDOzrZ6bJyI6QcG/2W0ybLVehtDPtWdC+F7u5slefVX
 XLu
IronPort-HdrOrdr: A9a23:kzTKP6q4n3VVb3qTsF34/ckaV5r1eYIsimQD101hICG9vPb1qy
 nIpoV46faaslgssR0b8+xoW5PwIk80l6QV3WB5B97LNzUO01HGEGgN1+bf6gylMzHi9+JbyK
 dre7VzBZnNF1Rg5PyKhTVQa+xB/PC3tIa1mOzZ03BhCStua61m8kNFLzzzKDwTeOGDbqBJcq
 Z1IaF81l2dRUg=
X-Talos-CUID: 9a23:LsFcI2EkS3qmvGsIqmJayG9EO/88eUH8km/7PxaqUVhqR6WKHAo=
X-Talos-MUID: 9a23:TeTvuAgv+z6Ov0c47GT99cMpJPZaw72KLHw3ktYCsfeBOwNyNRiHpWHi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="486875758"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:50:15 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 7619C18000A51;
	Wed, 27 May 2026 19:50:14 +0000 (GMT)
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
Subject: [PATCH v2 00/13] Introduce functionality for NVMe initiator
Date: Wed, 27 May 2026 12:49:47 -0700
Message-ID: <20260527195000.8444-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.14.55];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.14.55, [10.188.14.55]
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
 drivers/scsi/fnic/fdls_disc.c    |  953 ++++++++------
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
 drivers/scsi/fnic/fnic_nvme.c    | 2079 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  138 ++
 drivers/scsi/fnic/fnic_res.c     |   31 +-
 drivers/scsi/fnic/fnic_res.h     |   32 +-
 drivers/scsi/fnic/fnic_scsi.c    |  249 ++--
 drivers/scsi/fnic/fnic_stats.h   |   28 +
 drivers/scsi/fnic/fnic_trace.c   |    5 +-
 drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
 21 files changed, 3618 insertions(+), 778 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h

-- 
2.47.1

