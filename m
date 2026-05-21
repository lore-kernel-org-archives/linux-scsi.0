Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DCA38947E;
	Thu, 21 May 2026 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386783; cv=none; b=Pbq7K7tc4VYsIbZq9OootV8sapXAgsI6VXydeuM9yRrFB8Mx/dpBceBmSpa6YLeHEPFLK9x2oYdBftcNrYx1YAFXbzKwLrfzWmrgQf0pzsu3nsA5ZoT/Q/9mXC5TWLmDmzUDgvnHQcQGilyMbizpN1sM7r/sE2oJxJdJSTW+psc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386783; c=relaxed/simple;
	bh=brE8zviLRgbk88iAmkn3KqXUwvs5cR73GECkaII2rZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nyaNDgxOg+GksL+r7HwCVnMpAj4IeQSfmSJlvhiuFG0bh1cD3vLVG7y9QXmXHBux0RsvNgMIhcKqVBYnH2EqwipW6kDAdUmKWph5PkOh3OQ9T7MOx5i9JCTxBHxerMNASipJ8JGFP1GtHei26CaiHBxz4rcilY+TiSWPEFn86vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=RmLBBERz; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="RmLBBERz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4313; q=dns/txt;
  s=iport01; t=1779386781; x=1780596381;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QyPt9LBX7nQQh/wgVho531p2v97mk9+evKjEyAKcC24=;
  b=RmLBBERzwv2akRRvsC0Ikdzeep/mst3BmChfjjHEJjyTKXPMYiT2Z04/
   zaD1pNX5j1ViALwcvlNjPctnADkMkE9rxEh18PYKgviayVA3qco/curg0
   AMNYRC9uHlRZjpRgJhNF3fNd82Vnn5YFDWMKMqU6yCv3htkOlO/NZZITW
   fsE0HPJcb+mvcij5qai7ohN6gBebfQ6B388f6T07UMclEZiEKV2n7Pwqc
   zmfDmOZu3f/dZFVmsNmKDTslqXEk1PlQvo4gNTB0pbhLcutvEQd8qGX6I
   Xp//ICeNIuavZtUh1slDN2zd9U5U0SAZl9zUFugnbqCRNd75+VgJE9pAl
   g==;
X-CSE-ConnectionGUID: Puehc78zQ1aCDD31Al2clg==
X-CSE-MsgGUID: CXXnZltpTySxVz2sNxrs0A==
X-IPAS-Result: =?us-ascii?q?A0ATBACkSA9q/5L/Ja1aglmEJ0MZlFqCIYEWnQiBfw8BA?=
 =?us-ascii?q?QEPUQQBAYUGjTQCJjUIDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBD?=
 =?us-ascii?q?hOGXIZdNgFGhFKCdAO0KIIsgQHeQYFwFYE4jVx0G4RgJxUGgUlEgRWCcoJIi?=
 =?us-ascii?q?TUEgiJ6EoY2iGZIgR4DWSwBVRMNCgsHBYFmAzUSKhVuMh2BIz4XgQsbBwWBS?=
 =?us-ascii?q?4E3cmqBBIRXeCMsA06BLYFrAwsYDUgRLDcUGwQ+bgeNNRkHAVc3B3QGL3gWA?=
 =?us-ascii?q?R6TLwMRki2Ld5UXhCahWBozqmqZBaNwhVCBaQE6gVkzGggbFYMjUhkPji0Wy?=
 =?us-ascii?q?x4nbwIHAgcOAwuTZQEB?=
IronPort-Data: A9a23:PsZOeK8YIBJnWp9hrTf4DrUDeH+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 2IcWmDXP//bY2L3L9BzOtnl80wBvpCHyNFqTQNrpHpEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4muyyHjEAX9gWAsbzhNs/7rRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kOIIAY8bknE1gX/
 Nc0BGtURxTZjOa5lefTpulE3qzPLeHxN48Z/3UlxjbDALN+ENbIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZP0Mn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FbIqOKoXRGJwO9qqej
 kn2z2LLBg0CCM2k2QSXqGmKlvXUxQquDer+E5X9rJaGmma7ymUVThYfT0O2p+W0kGa6WtRWM
 UtS/TAhxYAw+U6hZt38WQCo5n+Ou1gXXN84O+gz8h2MzOzM7hqUHHMJSBZGctUtsMJwTjsvv
 neAk9rqAiRorZWPRH6d/6vSpjS3UQAXKGIEaCAETCMf7tXjqZ11hRXKJv55HbC4lMbdAzz8w
 zmW6iM5gt07icIW0a6y+3jcnimh4JPOS2Yd4gTRQ3Lg7Q5jYoOhT5Kn5EKd7vtaKoudCF6bs
 xAsn8mY8fBLFpqWlQSTT+gXWrKk/fCINHvbm1EHInU63y6m93jmecVb5ytzYR84dM0FYjTuJ
 kTUvGu9+aNuAZdjVocvC6rZNijg5fGI+QjNPhwMUudzXw==
IronPort-HdrOrdr: A9a23:ZRXoiqmZtpn8TtntCAb/I41cGEPpDfLy3DAbv31ZSRFFG/FwWf
 rDoB19726XtN9/Yh8dcLy7UpVoIkmslqKdg7NxAV7KZmCP01dAR7sM0WKN+VDdMhy73vJB1K
 tmbqh1AMD9ABxHl8rgiTPIdurIuOPmzImYwcHD0nxqUQZmL4tk7wt/F0KnN3cefngjOXL8f6
 DsgPauYFGbCBMqUvg=
X-Talos-CUID: =?us-ascii?q?9a23=3AL3e2hmo1RTYC5fsXencAbsfmUfg4f33WkyfCGha?=
 =?us-ascii?q?xIkpFE+S8TQWb/Kwxxg=3D=3D?=
X-Talos-MUID: 9a23:Ux++owvDlByTvPpPW82nrwFSMvVs/7ySGXsdr4dcoO+ULzcoEmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="483813513"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:05:12 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id 6A0CA18000233;
	Thu, 21 May 2026 18:05:10 +0000 (GMT)
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
	dan.carpenter@linaro.org,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 00/13] Introduce functionality for NVMe initiator
Date: Thu, 21 May 2026 11:04:45 -0700
Message-ID: <20260521180458.5448-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.18.181];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.18.181, [10.188.18.181]
X-Outbound-Node: rcdn-l-core-09.cisco.com

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
 drivers/scsi/fnic/fnic_main.c    |  211 ++-
 drivers/scsi/fnic/fnic_nvme.c    | 2079 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  138 ++
 drivers/scsi/fnic/fnic_res.c     |   31 +-
 drivers/scsi/fnic/fnic_res.h     |   32 +-
 drivers/scsi/fnic/fnic_scsi.c    |  249 ++--
 drivers/scsi/fnic/fnic_stats.h   |   28 +
 drivers/scsi/fnic/fnic_trace.c   |    5 +-
 drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
 21 files changed, 3617 insertions(+), 778 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h

-- 
2.47.1
