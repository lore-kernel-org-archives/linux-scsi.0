Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7CD37BE72;
	Fri, 12 Jun 2026 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781287779; cv=none; b=Z1KuRx5QQrD6Zxob1lMvxqUlBS9wovADFcVz3OPquJ4QH5UrpJAi0jWgdqpdm3p8/B4xo4mm4dU6S1WoGxlQsAJBx9D8Xr7q9qE17Syq8ymM3yX3fr5S0rk4zBM0/Cmzlrr+XQEbxEsCeriJam3CRuNbiPEuKpiKwHMZO5OISTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781287779; c=relaxed/simple;
	bh=FfcfuOnPc14OX0/pcsd3BbLni0OMb03vTGboYizkhmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PE1CAFvkrR8VXBt7wKTBhEaEa1gkYnKc3aHORkfAPaPx/dbk8nE2KC1AoqZAp2fDLJADIQvU6UQwtKdml6VkMzpcS9+sxbWv4G4E8C+XxxfGZSTWS/O31sXmyyVL1q7CC+8JxRsnZ6IHGwvMJyTlPbMYT/E7wPMbll9u9LjFc0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=gxWa7PYa; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="gxWa7PYa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=5539; q=dns/txt;
  s=iport01; t=1781287777; x=1782497377;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=95nNYWnpmLOyXsMlnS60Xn++styLF/QL0gaNeo67rO0=;
  b=gxWa7PYauD1KvGqRWJIpq9zS4GHkvBWiu2OYzy/HdNIfoDfID3mc947N
   pqbNhpsmcfyyLShfvJaqqcLB37/fpS1LZ5dZ+ZXTVyihIsaskj7lmMDr3
   +M0WB3NZ/BPyryqxIGRnR4RKgc+rkokFa6NyDu47OI05Jr3jOSd3Rl9cq
   1jTFevDOum804iwS0WBpgkqewZfH7veizsTXf4dRa0onS3D1SsXcsSlbO
   QVE+DTzHVOwStz8qBjXO8CHsq1oqP0x9gYcbWXisT0ypWkbqyv8aydC6G
   KUJ6QIMj5+TOUtiNjI8dBeunleSi7/KbWQ+AFSDCaG3dCaa0GRkZBEpAb
   g==;
X-CSE-ConnectionGUID: hovbiI40SCiH10ZBP3qfTw==
X-CSE-MsgGUID: o5jDtnmtRqeG2ls20WN+GA==
X-IPAS-Result: =?us-ascii?q?A0BVAwBmSixq/4v/Ja1aHgEBCxIMggULhClDGZRagiGBF?=
 =?us-ascii?q?p0IgX4PAQEBD1EEAQGFBo1FAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBA?=
 =?us-ascii?q?QECAQcFgQ4ThlyGXTYBRoRSgnQDtVGCLIEB3kOBchWBOI1edBuEYScVBoFJR?=
 =?us-ascii?q?IEVgnOCSIJJhm0EgiJ6EoVQY4pESIEeA1ksAVUTDQoLBwWBZgM1EioVbjIdg?=
 =?us-ascii?q?SM+F4EMGwcFgUqBK2qBA4UNIx8DOX+BdIEoZ2kVMDWBAQERHQMLGA1IESw3F?=
 =?us-ascii?q?BsEPm4HjjpSGQcBVywLBww6LgQCL3gWAR6TLwMRki2LeJUXhCehWxozqmyZC?=
 =?us-ascii?q?KNyGIU4gWg8gVkzGggbFYMjUhkPji0Wy2AnbwIHAgcOAwuRaQEmB4FOAQE?=
IronPort-Data: A9a23:JqJWP68yWIyN9BAAigc2DrUDZn+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 zQdDDyAOv+LZGKje9wjPtmxpx9QvMOGmtZjSQQ+qHtEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4muyyHjEAX9gWAsbDtOs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2k2OpMS+8crWVpl9
 NxBcAInVkuaid6plefTpulE3qzPLeHxN48Z/3UlxjbDALN+G9bIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZOEwn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FbIuOJoPWFJ8F9qqej
 mWb/UjlBBQGDsWS5mCB6Sj0ucmMsgquDer+E5X9rJaGmma7xGERAjUSVF2msb+4gEv4UNVaQ
 2QR8zAyrK507EG3Q8PmUhuQp2SNtRoRHdFXFoUS4Q2Eya3M5BuxHGUITjddLtchsaceRzkn0
 FKGn9LBHzFjsLSJD3ma89+8tz6sNDIOBXUPaS8NUU0O5NyLiIU/kxTER9BLC7Oug5v+HjSY6
 zSLqjUuwrYel8gG042l8l3dxTGhvJ7ESkgy/Aq/dmak6B5pIZWufI2A91fW97BDIZyfQ13Hu
 2IL8/Vy98gUBp2L0SjIS+IXEfTxvbCOMSbXhhhkGJxJGymRxkNPtLt4uFlWTHqF+O5dEdM1S
 Cc/YT9s2aI=
IronPort-HdrOrdr: A9a23:MLlR/qu9Ix6igpumtpGPpXtx7skDqNV00zEX/kB9WHVpmwKj+/
 xG+85rtyMc5wx+ZJhNo7q90cq7MBDhHPxOgLX5VI3KNGLbUQCTQ72Kg7GO/xTQXwXj6+9Q0r
 pheaBiBNC1MUJ3lq/BkWyF+q4boOWvweSPmfrUyWtrQEVBbqFt6Bo8NyOge3cGIDWvwfECZf
 yhDg0tnUvGRUgq
X-Talos-CUID: =?us-ascii?q?9a23=3A0B1rB2hDuX6wupYmHMltHRPy1zJucnrDxnbxfxe?=
 =?us-ascii?q?DImdJEeWnY2fL4a1YjJ87?=
X-Talos-MUID: 9a23:KE93QgZmVWT9S+BTsGLuqC1kMdtS+qmBUkQWy805nYqrHHkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="493474928"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:09:31 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 9B6DE18000222;
	Fri, 12 Jun 2026 18:09:29 +0000 (GMT)
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
Subject: [PATCH v4 00/13] Introduce functionality for NVMe initiator
Date: Fri, 12 Jun 2026 11:09:05 -0700
Message-ID: <20260612180918.8554-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.127.244];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.127.244, [10.188.127.244]
X-Outbound-Node: rcdn-l-core-02.cisco.com

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
 drivers/scsi/fnic/fdls_disc.c    |  959 +++++++------
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
 drivers/scsi/fnic/fnic_nvme.c    | 2185 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  209 +++
 drivers/scsi/fnic/fnic_res.c     |   31 +-
 drivers/scsi/fnic/fnic_res.h     |   32 +-
 drivers/scsi/fnic/fnic_scsi.c    |  249 ++--
 drivers/scsi/fnic/fnic_stats.h   |   28 +
 drivers/scsi/fnic/fnic_trace.c   |    3 +-
 drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
 21 files changed, 3800 insertions(+), 777 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h

-- 
2.47.1

