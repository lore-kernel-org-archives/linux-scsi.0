Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785772;
	b=xCAt05W6gPVPQ0h3xpnd1xRMbZyHYxF3G7BzL2sxEM0LljxyWCBplbnjkvsLY4e7vFL+
	 fZ1ZcmIERfS+1yQyUNIltiJQ5hhPoKqKSvjLtUHQcFQIxpYQcjQsR4qHQiDovSdgzurhe
	 MdxnS7ZJQziWGiMlI07RKeX+VWkfG6EtGV7OAY+oqezd96N+WibwToyKAZIFnviUZbUhP
	 gT3OxUkP7Qx3ogclVXkIIuLgXKkW9aEzeoM/ZO2RXVdiI+gSAr+gZLDrEPBORwjSUf8WH
	 Wkkh6P0v9BzUOSkCvRu08bBqAuDE2gdKNXzrE0LZjz+HAL7zjHLOM3zC/ow2ArRSX+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785772;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=V5+9lPLxcbB6HS72R7yHHf/aIkQQXwAa5F2YdjVWI1s=;
	b=RqXLFJpqWs0/Me1VyoZ/fChkbq69r0iBqwMOxiHkmgKNaBBk5bPU0QeCVgL/Qw4BUWob
	 lBDCvf6VYaAlTcDdp3HirickFrawoV7TfeanaGFzGxIg0AKY844GbbRkcYk5oMqa2sICJ
	 lRil3VZMPTN3d7tVnt3lFlsZeInuZyLf3JW1wDWDX/4a03hChNCv9/91Q49l+nguekley
	 o4FnNpPbyw0SJVuD3pv/c1u6Woue1yS0Gyi0IUogkVXNjnNQYJ0f7WM63VohTQWMX1PIZ
	 je00D/DYQEF7IdJlcKwi5CrAbkMQQlPAAwEcZ1fyK8ulNrSzSqrVxvzOHVxGmp+QNpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=UQbnQhi1;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EA3606A335
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 09:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3EA3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=UQbnQhi1
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261104094923epoutp02dc65158d388af9b03f0f2644be5f4870~kzqXggyz62050920509epoutp02Q
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 09:49:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261104094923epoutp02dc65158d388af9b03f0f2644be5f4870~kzqXggyz62050920509epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793785763;
	bh=V5+9lPLxcbB6HS72R7yHHf/aIkQQXwAa5F2YdjVWI1s=;
	h=From:To:Cc:Subject:Date:References:From;
	b=UQbnQhi1EbPqddrXf8LmT5R4rExPYlvGpOAe7F4RQG/cWUynbUsQTppHpDQApWd+7
	 rexJYUA1NdUtZzw7m+lu8BujdYcjQAiUEtN6VrRKiooGshv4GZ/U7sFAPprPcAGzTl
	 1eYuJxwJswjWzLtwiOzkgwnVtiS+8vH5P8mZtKkk=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261104094922epcas2p2626a497f18ca8bd46105001758db9eb9~kzqXB8KdG0604706047epcas2p2R;
	Wed,  4 Nov 2026 09:49:22 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.210]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jKLJ253jGz6B9m7; Wed,  4 Nov
	2026 09:49:22 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261104094922epcas2p275e9b663a40b1a6f86f208f11e21ae64~kzqWXLkpu0383403834epcas2p24;
	Wed,  4 Nov 2026 09:49:22 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261104094922epsmtip1457c7e75f56a7d418b1dbd739accd372~kzqWRTGgq3232832328epsmtip1u;
	Wed,  4 Nov 2026 09:49:22 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v5 0/2] ufs: fix the abort path of device management
 commands in MCQ mode
Date: Wed,  4 Nov 2026 18:49:12 +0900
Message-ID: <20261104094914.180788-1-kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261104094922epcas2p275e9b663a40b1a6f86f208f11e21ae64
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261104094922epcas2p275e9b663a40b1a6f86f208f11e21ae64
References: <CGME20261104094922epcas2p275e9b663a40b1a6f86f208f11e21ae64@epcas2p2.samsung.com>

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

 drivers/ufs/core/ufs-mcq.c | 18 ++++++++++++++++++
 drivers/ufs/core/ufshcd.c  |  4 ++++
 2 files changed, 22 insertions(+)

-- 
2.43.0

