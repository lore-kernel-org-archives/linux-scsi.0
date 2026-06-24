Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5010380FC7;
	Wed, 24 Jun 2026 04:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276296; cv=none; b=LLGRlJdfqCuToPZPX4ZEXgJegtS4hKbSMpbmq1ahasA52v1XNASRXxzdsvJLsHb1iVMePDcMtvwt3Pe8KQ48pSPIphn2tgzFU+bdoTvyrV3pLsf1X1utl2XF0nkivvMPbyWlt3E2vyuwSkEcKmSt5BxiGHdPbKpQJyaAX5HUe2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276296; c=relaxed/simple;
	bh=5icdoDaXY2x193jPlSYRll36w0SzJq2oN3/c8GsfbEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T1hooC1nDrr92itQnWMkpZrRRzRBBjQSGZP88b/0yxoV18zzOd/eTbZSHHwbJ8jtA44gfdUfFmXEkoMY+SaZBNFzfpUtim08TN9W5ktm9ZiFHsRO4RG0LIPDT3Rg2JjtiAIcEthjB/L5NXgllvGydV7NE16D/9lagrLyB019za4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Mp29ZotY; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Mp29ZotY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=6269; q=dns/txt;
  s=iport01; t=1782276294; x=1783485894;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K7grOhFHQvso1DWUA3H9SEKR6TuymodY5EtcBEh6ThY=;
  b=Mp29ZotYAbXCDF98oyrGtJU9aZRaG+VhhGCwmu64CrOmYrq7Um8rWJVN
   zbxP4lwpCojUnxIC3Wf+TDlN6ZYGVv9NUNYMnGqmB+hph0RbVOtY7MphZ
   J02eMPcXGMk3nLXDDyD7n0zXYUAAHUPVHhMB2fhjkFAGmVk+hK5VacRYi
   N/4XFoecvBa3AqKXGtn7XQc/ZANiABBN/OTW4hq+ht54NxzvphxHysg+x
   pmBYDGs9XRgQXE8GflVrWT899Aue2tKIJgX2jCrC58TOIi0WvynCjgi0W
   bxRquy7Ec0tam4whNrGn7xt98qoVAchWwOCoTQOx3oWgvVZVNkUqJWGrF
   w==;
X-CSE-ConnectionGUID: 9Xk8cxhRS5mZtLmFFj+0RQ==
X-CSE-MsgGUID: fH2w/jYWSMGA1fvZgSp5qw==
X-IPAS-Result: =?us-ascii?q?A0A5AADmXjtq/4//Ja1aHQEBAQEJARIBBQUBgXwIAQsBh?=
 =?us-ascii?q?ChDGY0jhzeCIYEWkDeMURSBag8BAQEPUQQBAYUGjUwCJjQJDgECBAMCAwEBA?=
 =?us-ascii?q?QEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZdNgFGhFKCdAOyOYIsgQHeQ4FyF?=
 =?us-ascii?q?YE4AY1ddBuEYScVBoFJRIEVgnOCSIJJD4ZeBIIiehKCSIEEgU9jiwRIgR4DW?=
 =?us-ascii?q?SwBVRMNCgsHBYFmAzUSKhVuMh2BIz4XgQwbBwWBHYFugQSFAiMfAzl/gT+BJ?=
 =?us-ascii?q?GRmFTA1gQEBER8KgTUDCxgNSBEsNxQbBD5uB45OUhkHARVCLAsHDB0dLgQCL?=
 =?us-ascii?q?3gWAR6TCx0HAxGSLYE1ikOVF4QnoVsaM6psmQijchgPhSmBaDyBWTMaCBsVg?=
 =?us-ascii?q?yNSGQ+OLRbSOidvAgcCBw4DC5FpASYHgU4BAQ?=
IronPort-Data: A9a23:HDKxE6vcugsX0sQbLc5Nesi94efnVLBfMUV32f8akzHdYApBsoF/q
 tZmKTqFa66IMTD0Ld5zb4q18xkFsMXQmIJiSlFu+yBhESsWgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs/zZ80s11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIwq9Z0UWpe9
 cYjdTU/cjSGqcy0g+qBc7w57igjBJGD0II3oHpsy3TdSP0hW52GG/uM7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtMYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDbHZUMzhbA9
 goq+Uz3IksFc96u9gGg3Vv1iPH9khjjBZsNQejQGvlCxQf7KnYoIB8bV1GTpfi/l174Wthab
 UcT/0IGqKEo6E2tCMHwQxCiu3OClhkGUtFUHqsx7wTl4qPY6gWeHm8ZZiRMZNwvqIk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLQstlG6ezpsboAjy2y
 DePxAA6hrMOnYsI2r+98FTvnT2hvN7KQxQz6wGRWXiqhit9ZYi4d8mz4kPaxehPIZzfTVSbu
 nUA3c+E44gz4YqljieBRqAJWbqu/fvAaGOail90FJ5n/DOok5K+Qb1tDPhFDB8BGq45lfXBO
 ic/ZSs5CEdvAUaX
IronPort-HdrOrdr: A9a23:b7ieAanpkRjpN3vLnrpaQtcncjfpDfLy3DAbv31ZSRFFG/FwWf
 rDoB19726XtN9/Yh8dcLy7UpVoIkmslqKdg7NxAV7KZmCP01dAR7sM0WKN+VDdMhy73vJB1K
 tmbqh1AMD9ABxHl8rgiTPIdurIuOPmzImYwcHD0nxqUQZmL4tk7wt/F0KnN3cefngjOXL8f6
 DsgPauYFGbCBMqUvg=
X-Talos-CUID: =?us-ascii?q?9a23=3AjU7m/GgzIE7Fd4+vext4PulbcTJuI03enHzAI3W?=
 =?us-ascii?q?DVGNbVJmQZ3GSu/teqp87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AABSmtgzQUh9J4ry8UfKju0G4WTOaqKqOUl9Kk6Q?=
 =?us-ascii?q?5gOyrHHV+JQWStyzqW5Byfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="490818808"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:43:46 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id D7021180003A1;
	Wed, 24 Jun 2026 04:43:44 +0000 (GMT)
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
Subject: [PATCH v5 00/13] Introduce functionality for NVMe initiator
Date: Tue, 23 Jun 2026 21:43:21 -0700
Message-ID: <20260624044334.3079-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.122.232];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.122.232, [10.188.122.232]
X-Outbound-Node: rcdn-l-core-06.cisco.com

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

Changes between v3 and v4:
	Incorporate review comments from Sashiko:
		Keep role strings private and const.
		Clear NVMe SGL DMA address on map failure.
		Drop fnic lock around NVMe tport registration.
		Unlink unregistered NVMe tports before freeing them.
		Clear NVMe unload completion pointer on exit.
		Take fnic lock before NVMe tport cleanup tag lookup.
		Clear NVMe tport delete completion pointer on unregister failure.
		Arm NVMe LS request timer before exposing the request.
		Free LS ABTS frame when send fails.
		Reuse NVMe LS request cleanup for abort failure.
		Decrement NVMe completion wait queue counter when draining completions.
		Preserve jiffies wrap when computing NVMe abort stats.

Changes between v4 and v5:
	Incorporate review comments from Sashiko:
		Set NVMe wait timestamp before queueing completions
		Use async timer delete for NVMe LS responses
		Complete failed NVMe ITMF aborts
		Track NVMe SGL DMA mapping state
		Detach NVMe LS cleanup before callbacks
		Defer NVMe table frees until cleanup
		Lock NVMe tport IO termination lookup
		Count NVMe ERSP completions as firmware completions
		Gate NVMe completions by initiator role
		Check cleaned buffers before dereferencing them
		Drain OXID reclaim state on reset
		Avoid NVMe LS request send races
		Arm NVMe LS abort timer after send succeeds
		Clean up NVMe debugfs on probe errors
	Clarify that FC-NVMe PRLI must not set Establish Image Pair.

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
 drivers/scsi/fnic/fdls_disc.c    |  969 +++++++------
 drivers/scsi/fnic/fdls_fc.h      |    7 +
 drivers/scsi/fnic/fip.c          |  117 +-
 drivers/scsi/fnic/fip.h          |    2 +-
 drivers/scsi/fnic/fnic.h         |  104 +-
 drivers/scsi/fnic/fnic_debugfs.c |   99 +-
 drivers/scsi/fnic/fnic_fcs.c     |  199 +--
 drivers/scsi/fnic/fnic_fdls.h    |   48 +-
 drivers/scsi/fnic/fnic_io.h      |   24 +-
 drivers/scsi/fnic/fnic_isr.c     |   28 +-
 drivers/scsi/fnic/fnic_main.c    |  211 ++-
 drivers/scsi/fnic/fnic_nvme.c    | 2202 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  209 +++
 drivers/scsi/fnic/fnic_res.c     |   31 +-
 drivers/scsi/fnic/fnic_res.h     |   32 +-
 drivers/scsi/fnic/fnic_scsi.c    |  251 ++--
 drivers/scsi/fnic/fnic_stats.h   |   28 +
 drivers/scsi/fnic/fnic_trace.c   |    3 +-
 drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
 21 files changed, 3824 insertions(+), 778 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h

-- 
2.47.1

