Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162D1368D4F;
	Fri, 24 Jul 2026 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915386; cv=none; b=TEJe1PsIZpumnRmZZ/7ohDrWCv4gGPif8/epqhEC3OlPNeJcBEEqObn0QDDmOhhJ2fsA58OkzZJyAO09gEBROTRYTc1tMH0jmX1cEeRQmhC3+gExGnh8ze8ZxObFCyeW9Ul0M1McTIliMhShsr6SrwB/JXX7F4TF5dtgwfqjSTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915386; c=relaxed/simple;
	bh=QN9j08wMKx+KbOhvkRbSWVC6kZmSRJHwotNWfmgFUD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hK/00s+TV8RWm95xkjYvHNdPIjf3GNeuyi2I0wvltvuCt1ALAhM/+8r5amAWczdh6uX+lxTT7SHP0CauNXu5jmu3BaQS86rBXpjY2TdTCY5SFkPW8Br4h3C6KRkf+Gz3dz5K+6990Acv9EDvKjw669AoWehTOegKzEilcl/AdOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=alNpBy43; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="alNpBy43"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7033; q=dns/txt;
  s=iport01; t=1784915384; x=1786124984;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HhGOYYnuavCrQcHesDE1DWIbi8aF40Mfni16SL9b9ok=;
  b=alNpBy43t9Rvboi5d7p3WK1J8FfavFzzH5LvsuHmcqBvgsqsgaL5NMqD
   Z3QUBROw+tj/MTG0UBY1SkUILx6Yr2XXo4yYWtgtIfgwVREA2HnzP7ug6
   BUUyHti3sY95/8e6EltYOzMuV1gEC2yT3KKyLcNmJpTDILtAhtLef3EIe
   ENtTfWm4qEnDDdpRq1Rk2oeZODCvUfLISg+DVXmqJ6TS1Tafsb149Vonz
   0AIeXPU/x5KsoqUCLWX4LZyWp9g8HOxo5e7X6aP/JWzWy9f19ldW9aszM
   071syDzRDQOce3aXNY93LXUY1g50Yavv7m31kwQlGJ78H7V2IuEKvIa/i
   A==;
X-CSE-ConnectionGUID: Xhs+W72SQAixUwcLvxLKlw==
X-CSE-MsgGUID: zoQsoTojSYC9vWCGp5tFOg==
X-IPAS-Result: =?us-ascii?q?A0BWAwBwpGNq/5AQJK1aHgEBCxIMggULhClDGZRZgiGBF?=
 =?us-ascii?q?pA3jFEUgWoPAQEBD1EEAQGFBY1iAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBA?=
 =?us-ascii?q?QUBAQECAQcFgQ4ThlyGXTYBRoRSgnUDwkmCLIEB3kWBchWBOI1fdRuEYScVB?=
 =?us-ascii?q?oFJRIEVgnOCSIJJD4ZeBIIiehKCSE2BTmKMeEiBHgNZLAFVEw0KCwcFgWYDN?=
 =?us-ascii?q?RIqFW4yHYEjPheBDBsHBYEdgSx5hFgjHwM5f4EvdUp3LWkBEheBJoNLAoFHA?=
 =?us-ascii?q?wsYDUgRLDcUGQQ+bgePZVIZBwEGDxsnLAsHDB0dLgQCL3gWAR6TCx0HAxGQD?=
 =?us-ascii?q?IIhgTWKQ5UXhCehWxozqmyZCKNyGA+FKoFoPIFZMxoIGxWDI1IZD44tFtI5J?=
 =?us-ascii?q?28BAQcCBw4DC4FokAEBJgeBTwEB?=
IronPort-Data: A9a23:FN8lV6ti7VAkv+zJj7znju94vOfnVLFfMUV32f8akzHdYApBsoF/q
 tZmKWqOaP/YNGWhKd90PI7lpkkBu5LUyYBrQFZuri8wECsVgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZTdJ5xYuajhKs/3Z9Eo21BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIwyuZsQl4Rr
 8chATEdUw+Io/ym5JG/Vbw57igjBJGD0II3s3Vky3TdSP0hW52GG/qM7t5D1zB2jcdLdRrcT
 5NGMnw0MlKZPVsWZgt/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JYzUGJsJwhjHz
 o7A13b+OwodCNud8guuo2yTrcDXwD/Vf41HQdVU8dYv2jV/3Fc7ChAUX3O/oP+kmgi/UdcZI
 EsRkgIrpLIu9UrtVtThUgejrXisuQQVUN5dVeY97Wmlw6bd4AGBAXUsVDNNaNU68sQxQFQC1
 FqEmd7mBT1HqrCZSXuBsLyTqFuaIyULIHUZTTUJQQsM/5/op4RbphbDU9BoGaidlcDuFHf7x
 DXihCw/gagDyM0GzaO2+XjZjD+24JvEVAg44kPQRG3Nxgd4YpO1Ipej8lnz8/lNNsCaQ0OHs
 XxCnNKRhN3iFrmEkCiLBeFIF7az6rPdb3vXgEVkGN8q8DHFF2OfQL28KQpWfC9BWvvosxewC
 KMPkWu9PKNuAUY=
IronPort-HdrOrdr: A9a23:UpGUc6CxJrFeU87lHely55DYdb4zR+YMi2TDGXocdfUzSL37qy
 nAppomPHPP4gr5O0tQ+uxoWpPgfZq0z/ccirX5Vo3MYOCJggaVBbAnxZf+wjHmBi31/vNQ2O
 NdaaRkYeeAaGSS9fyb3CCIV/A93dKA7Kekwc3az3trUEVWTpsI1XYcNu5eeXcGIjWvwvECZf
 2h2vY=
X-Talos-CUID: 9a23:jaI8HmBQIFBMKnP6Exln7w0rRZoeS1Tc3ErPKGumGUJKTKLAHA==
X-Talos-MUID: 9a23:ak0vpQkuZ2+TQGtrOP2idnpwM/5z5JipCns8usQYhOKrLXFsFRCS2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="786564467"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:48:36 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 5E35A180001CB;
	Fri, 24 Jul 2026 17:48:30 +0000 (GMT)
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
Subject: [PATCH v6 00/13] Introduce functionality for NVMe initiator
Date: Fri, 24 Jul 2026 10:47:58 -0700
Message-ID: <20260724174811.5118-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.189.81];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.189.81, [10.189.189.81]
X-Outbound-Node: alln-l-core-07.cisco.com

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

Changes between v5 and v6:
	Synchronize the tport retry timer before remote-port delete completes.
	Avoid requeueing FDLS tport delete from the NVMe remote-port callback.
	Drop the unnecessary else after the tport delete timeout return.
	Name the tport cleanup retry limit instead of using a literal.
	Publish can-free before completion and set cleanup-pending on timeout.
	Incorporate review comments from Sashiko:
		Flush NVMe completions after copy WQ cleanup
		Reset NVMe SGL state before each I/O
		Claim tport I/O before aborting it
		Synchronize LS response timer before done
		Preserve LS requests during abort start
		Drain LS requests on rport unregister failure
		Defer tport free after rport timeout
		Avoid extra PCI device reference for lport

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
 drivers/scsi/fnic/fdls_disc.c    |  978 +++++++------
 drivers/scsi/fnic/fdls_fc.h      |    7 +
 drivers/scsi/fnic/fip.c          |  117 +-
 drivers/scsi/fnic/fip.h          |    2 +-
 drivers/scsi/fnic/fnic.h         |  104 +-
 drivers/scsi/fnic/fnic_debugfs.c |   99 +-
 drivers/scsi/fnic/fnic_fcs.c     |  199 +--
 drivers/scsi/fnic/fnic_fdls.h    |   48 +-
 drivers/scsi/fnic/fnic_io.h      |   24 +-
 drivers/scsi/fnic/fnic_isr.c     |   28 +-
 drivers/scsi/fnic/fnic_main.c    |  214 ++-
 drivers/scsi/fnic/fnic_nvme.c    | 2268 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  214 +++
 drivers/scsi/fnic/fnic_res.c     |   31 +-
 drivers/scsi/fnic/fnic_res.h     |   32 +-
 drivers/scsi/fnic/fnic_scsi.c    |  251 ++--
 drivers/scsi/fnic/fnic_stats.h   |   28 +
 drivers/scsi/fnic/fnic_trace.c   |    3 +-
 drivers/scsi/fnic/vnic_devcmd.h  |    2 +-
 21 files changed, 3906 insertions(+), 779 deletions(-)
 create mode 100644 drivers/scsi/fnic/fnic_nvme.c
 create mode 100644 drivers/scsi/fnic/fnic_nvme.h

-- 
2.47.1

