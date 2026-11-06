Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938386;
	b=rcaHxNWstk5kuyT6rZyRKs5lPEAFwBqhSFS9DFxTeJv9wmiISlR1GBxlQ/OoapdYwk3S
	 YnuU0Tytoeh76g8MDezN6xVA0fe8sD/7pEQ2JVdjQ3pUuNrtUDL68UyLSYAW9PqChHC8m
	 HX1Pl3nzhN36VCCP5jYpvuVT/GGhxbLfNH8ZH1EIo3qEZB5uoQ0SG8TZmV9J1dpRfEG7L
	 eDMtU26SHjNs96zK4JR+bBtsyT3VocBUv+1HgjNwnckt2fVyD1AcurKh51yxVSxYVCrF+
	 9kkhRibz84pzCLtUWw2efKlpykZCDfCz34n0lhDMioII5bXa1v9TYBMLr5er/hCITeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938386;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=ttPqSqQ4A3qth8ttFkhDBII3Z3A8F6zNRi3Af3HTrLw=;
	b=q7M7J62+llB2HHq16ZVlzh/2Bcs/K7vvH/fKOxC9aNzoAmnCns+ULgg6Tw/iosjH5g8J
	 wXrn99v6dDwWqGf7BvGfj+5E960sq59PpWRYZ2PBkHrF6yajtHR5G0jRdEOWI7aM7ha2k
	 RlTcUUUIy3xUlhym5+aR4DYr01Z+Mn13M/MT6D67F7oZ9TjdS6WfXGSlFtPzgCZLnyCnN
	 8MCN9mbGnPavgQwwWq0AmcID6eF1giuWo/nfFSjKacXx1UDldOvnMvP8I1PIMJp/aT1Ng
	 JxWcbcCEVyEInNY78feFyGYzEsqeDDhzKp7EqCYc+3rzWm4EL1RH5L2j6Js96seKRMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C097606A329
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 04:13:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C097606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261106041302epoutp025a2e7a91e819feb957e69fc5ff160ab2~lWXQ2g_j40572005720epoutp02O
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 04:13:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261106041302epoutp025a2e7a91e819feb957e69fc5ff160ab2~lWXQ2g_j40572005720epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793938382;
	bh=ttPqSqQ4A3qth8ttFkhDBII3Z3A8F6zNRi3Af3HTrLw=;
	h=From:To:Cc:Subject:Date:References:From;
	b=DOlBkclsqW1fOrYbgfsTvQgA+aGdu2nxyuUjL2GUa9k9cjMCNdCuzkJK/rgvMywlr
	 kvQPLiACbRlWKNMTMe4++vH8Gri1okMd39uAEwYZkpY5LC+3HdorsN65WZK2HT4rlo
	 XRngCmBb6I9iqV2zRIcxk72fJUG8IojFe2yzVb18=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261106041301epcas2p468419a911d542be0f771d032e5ab9184~lWXQQz0rT2377823778epcas2p4h;
	Fri,  6 Nov 2026 04:13:01 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.204]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jLQl11zZyz2SSKg; Fri,  6 Nov
	2026 04:13:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20261106041300epcas2p4a1028afe27a91c8d6167d422c8be1fb1~lWXPa4AJv2372023720epcas2p4f;
	Fri,  6 Nov 2026 04:13:00 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106041300epsmtip112735194fbad1b6e6dae14409a1e7c23~lWXPUTMJs2786727867epsmtip1N;
	Fri,  6 Nov 2026 04:13:00 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v7 0/2] scsi: ufs: fix the abort path of device management
 commands in MCQ mode
Date: Fri,  6 Nov 2026 13:12:45 +0900
Message-ID: <cover.1793938245.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261106041300epcas2p4a1028afe27a91c8d6167d422c8be1fb1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261106041300epcas2p4a1028afe27a91c8d6167d422c8be1fb1
References: <CGME20261106041300epcas2p4a1028afe27a91c8d6167d422c8be1fb1@epcas2p4.samsung.com>

This series fixes how a timed-out device management command (query, NOP)
is aborted in MCQ mode.

Patch 1 makes ufshcd_try_to_abort_task() skip the task management path
for device management commands and clear them with ufshcd_clear_cmd()
directly. ufshcd_mcq_abort() sends these commands to
the QUERY TASK / ABORT TASK path, which is meant for SCSI I/O commands.
With this change, the SDB path in ufshcd_abort() no longer needs
its own branch for reserved requests, so that branch is removed.

Patch 2 makes ufshcd_mcq_sq_cleanup() wait for the OCS of a device
management command to be updated after SQ cleanup. UFSHCI does not
specify the order between the OCS update and the SQ_CUS update. Without
the wait, a late completion of the cleaned-up query can complete the
retry of that query too early, which leaves the host controller with two
query contexts and raises IS.UTPES. Each iteration of the wait reaps the
CQ directly, so the wait does not depend on interrupt delivery.

Patch 2 depends on patch 1. Without patch 1, ufshcd_mcq_sq_cleanup() is
reached for a device management command only if the ABORT TASK TMF
succeeds.

Changes since v6:
- Patch 1: Remove the reserved-request branch from ufshcd_abort(), since
  ufshcd_try_to_abort_task() now handles device management commands. (Bart)
- Patch 1: Update the kernel-doc of ufshcd_try_to_abort_task() and add
  a Closes: tag for the report. (Bart)
- Patch 2: Reap the CQ with ufshcd_mcq_poll_cqe_lock() in each iteration
  of the OCS poll, as ufshcd_clear_lu_cmds() does after
  ufshcd_clear_cmd(). This removes the dependency on interrupt delivery.
  The OCS is still read under hwq->cq_lock, because the interrupt handler
  can reap the CQE between the reap and the read. Rename
  ufshcd_mcq_read_ocs() to ufshcd_mcq_poll_ocs(). (Bart)
- Patch 2: Rework the commit message. Explain how the problem applies to
  the current code and how it affects the retry, quote UFSHCI on the CQE
  posted after a successful cleanup, and explain the CQ reaping.
- Add the "scsi:" prefix to the subjects.

Link: https://lore.kernel.org/linux-scsi/20261105004333.1097899-1-kwmad.kim@samsung.com/

Changes since v5:
- Read the OCS under hwq->cq_lock again, as in v4. Without the lock,
  ufshcd_mcq_sq_cleanup() can observe the OCS update and return while
  ufshcd_compl_one_cqe() has not yet called scsi_done(). A retry that
  reuses the reserved request can then be completed by that pending
  scsi_done() call (Sashiko).
- Explain the need for cq_lock in a comment and in the patch 2 commit
  message.

Link: https://lore.kernel.org/linux-scsi/20261104094914.180788-1-kwmad.kim@samsung.com/

Changes since v4:
- Read the OCS in ufshcd_mcq_sq_cleanup() with READ_ONCE() directly and
  drop the cq_lock and the ufshcd_mcq_read_ocs() helper, per review. (Bart)
- Report an error when the OCS poll times out. (Bart)

Link: https://lore.kernel.org/linux-scsi/cover.1793598099.git.kwmad.kim@samsung.com/

Changes since v3:
- Split the v3 patch into two patches: the abort path fix and
  the OCS poll after SQ cleanup (Bean Huo).
- Explain in patch 1 that the problem is only reachable since the
  scsi_get_internal_cmd() conversion and add the corresponding Fixes tag,
  per review.
- Add a Fixes tag to patch 2. (Bean Huo)
- Fix the step numbering of the timeline in the patch 2 commit message.

Link: https://lore.kernel.org/linux-scsi/20261030111045.982094-1-kwmad.kim@samsung.com/

Changes since v2:
- Use read_poll_timeout() for the OCS poll in ufshcd_mcq_sq_cleanup().
  The open-coded loop did not re-read the OCS after the timeout, so it
  could return a false -ETIMEDOUT if the OCS was updated while sleeping
  in the last iteration (Sashiko).

Link: https://lore.kernel.org/linux-scsi/20261030093645.790159-1-kwmad.kim@samsung.com/

Changes since v1:
- Limit the OCS poll in ufshcd_mcq_sq_cleanup() to device management
  commands. ufshcd_compl_one_cqe() copies the OCS from the CQE into the
  UTRD only for them, so for SCSI commands the poll always ran for
  MCQ_POLL_US and then failed with -ETIMEDOUT (Sashiko).
- Return -ETIMEDOUT only if OCS is still OCS_INVALID_COMMAND_STATUS
  after the poll. OCS_ABORTED, which the host controller reports for
  the cleaned-up request, is no longer treated as a cleanup failure
  (Sashiko).
- Update the commit message to match.

Link: https://lore.kernel.org/linux-scsi/20261030083311.602909-1-kwmad.kim@samsung.com/

Kiwoong Kim (2):
  scsi: ufs: core: skip ABORT TASK for device management commands
  scsi: ufs: mcq: poll OCS after sq cleanup for device management
    commands

 drivers/ufs/core/ufs-mcq.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c  | 23 ++++++++++++++---------
 2 files changed, 48 insertions(+), 9 deletions(-)

-- 
2.43.0

