Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839437;
	b=dyGzT8HWB0ma/KJTixIK2jnfkUSGgczG+6bkfYAihIJ0vKRn/wvrj2Xtgw88++WG1LEF
	 rmC4oKcZ5LhIi0Mdz1z8yOhyiMqPdmVHIvxKLadTnF8NVE57GeLfCKh/zMkQ/PCTK1wrv
	 YHpAxdCNU7CJsR76TX2/epgRSF+tO+Yswe6TARQ1S1xZbuL7npgawJoxx/vnM+yc3OUvI
	 8SP9qJsr8jmNDZ9yNvIvDhQcMuVGLtnVcvFNSC60BuOM8ST9GRZlrZhG8ASVjM6hNvskb
	 wGYxSZCm7aHa7Hduu29KDpl0Io4HVeWoRbr0gbekYKwPoUA8KPWD/pbIfIGcvseJ/4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839437;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=lMXJ+/muzDU83uHxeSJNtnzH7dJqEI3daaJL/TB7jNA=;
	b=AY+e+8mSzcIRogWqErpHNL/ctL2DcHZWWmiVluOHrkbKKLHUU0sFZ/5PuiWlUpZT0IbB
	 Vng68F8hIjCn4A+WHlbRJC7YBNeZ8b0eom/chqHTXkYSEEFRYDgFdgNPknASzjH7fHZYp
	 QLY6/MbxJ2/MPFiSGGp294YfQQNtIzjppPDxJyWT49keSR4Mw9wjbgzogtvMA3xEq8TCu
	 vuOHAenHEpKAObtqcvz0Xl5OvxkDEUYHQbxQJpqGPLSCrisf9ndiFa/lVYaMdsu/oz0d3
	 zJA8aHWNAWG8BkFiqqqX35AjZ4SFWRrDF/LdMrG43qs9iah36eWGsx0vvAOtQDt3OSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=DfA3o6uQ;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EBC606A328
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:43:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34EBC606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=DfA3o6uQ
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261105004352epoutp030f11b4bd881388d4da3ade37fdffd061~k-3W3DF3f0353003530epoutp03y
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 00:43:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261105004352epoutp030f11b4bd881388d4da3ade37fdffd061~k-3W3DF3f0353003530epoutp03y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793839432;
	bh=lMXJ+/muzDU83uHxeSJNtnzH7dJqEI3daaJL/TB7jNA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=DfA3o6uQJHS+RY8PVtrcY5JYtDYlLy23nbRH4QMH9pspkmhs8Y9cwmygzeTDXvtZn
	 vUEPx34JnwKyv3nd5sR63oPDvc9GU98kpI4U1QhD73CkLvrpfsNnwqx2qPijJC57C9
	 nGZouJdZkhZCOIbOz2X5scvAMD+Z6VU7k0iWpLJA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105004351epcas2p10dbd92a419bc558f532be34411696942~k-3WNJ-di3009630096epcas2p1j;
	Thu,  5 Nov 2026 00:43:51 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.205]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKk8754dgz6B9mJ; Thu,  5 Nov
	2026 00:43:51 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20261105004351epcas2p19e657481834dc8493d926f10cff77d03~k-3VVTxBQ2090420904epcas2p13;
	Thu,  5 Nov 2026 00:43:51 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261105004350epsmtip2b619f40258ed37e22a67ad6a6d6681a6~k-3VOjFto0753407534epsmtip27;
	Thu,  5 Nov 2026 00:43:50 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v6 0/2] ufs: fix the abort path of device management
 commands in MCQ mode
Date: Thu,  5 Nov 2026 09:43:31 +0900
Message-ID: <20261105004333.1097899-1-kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261105004351epcas2p19e657481834dc8493d926f10cff77d03
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261105004351epcas2p19e657481834dc8493d926f10cff77d03
References: <CGME20261105004351epcas2p19e657481834dc8493d926f10cff77d03@epcas2p1.samsung.com>

This series fixes how a timed-out device management command (query, NOP)
is aborted in MCQ mode.

Patch 1 makes ufshcd_try_to_abort_task() skip the task management path
for device management commands and clear them with ufshcd_clear_cmd()
directly, as the single doorbell path in ufshcd_abort() already does.
Since the conversion to scsi_get_internal_cmd(), ufshcd_mcq_abort() sends
these commands to the QUERY TASK / ABORT TASK path, which is meant for
SCSI I/O commands.

Patch 2 makes ufshcd_mcq_sq_cleanup() wait for the OCS of a device
management command to be updated after SQ cleanup. UFSHCI does not
specify the order between the OCS update and the SQ_CUS update. Without
the wait, a late completion of the cleaned-up query can race with the
retry of that query, which leaves the host with two query contexts and
raises IS.UTPES.

Patch 2 depends on patch 1. Without patch 1, ufshcd_mcq_sq_cleanup() is
reached for a device management command only if the ABORT TASK TMF
succeeds.

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
  ufs: core: skip ABORT TASK for device management commands
  ufs: mcq: poll OCS after sq cleanup for device management commands

 drivers/ufs/core/ufs-mcq.c | 29 +++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c  |  4 ++++
 2 files changed, 33 insertions(+)

-- 
2.43.0

