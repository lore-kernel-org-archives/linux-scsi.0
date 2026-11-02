Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793598804;
	b=a8zmCy/rjzAwswKz4n7RNFZhH3DuDUbEFsgulILGaiIEJfv7U+S5qXjtPzOR4I0DsN5H
	 DM0rAth3S7t/km/IPcn0tKG9CDjxGExzXz+tLaNI6RnOwHwZQWshlTCnimm2YQirUZjSY
	 S4gQsJrw5JAtkX0r3O0wShk06xC7Ng1/ADwzJKMH6TmrnB3UmMg5Uv6Z+D8OTl8cgn0T9
	 6UahPjV+hTBocWWmsUofVAqp4yo3Q8XPDeZ98u37/V8hJXg+8xnPbspJNb+Ohk8ebekQ0
	 v9Aj3xeW2Jre9SFCl1hzXYsgWR2cxp8M//b1iCyWfT7OpyF71jPzNm/VZw72GOvVQKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793598804;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:X-CPGSPASS:cpgsPolicy:
	 X-CFilter-Loop:X-CMS-RootMailID:References;
	bh=Z7VOfdGlq/tsCeMOtC2n9BnTqm/JFSdUYGKJP6RCeBo=;
	b=gb/VdRPWgd7pu4dO10mop0eYmkDc3cnPknKAm9YqYdzB7AbZf5RKsSOYEo0bw6bB/Ysl
	 gNBkhGmLhdkeGJBho+rdU7JV+7P2/L3Jor4GYWdRIdPodXV8Mh9n5AP+bC9W5cR7HGHmt
	 G7EyypOfOD6paKuH0NnsrtRzcQKJRIVjbKXHRQUkGz656lstIKD3ONFFiH4niyz0BVvI4
	 8u5Gzupk6E+KqKY4v3uktLNVrjY26cXK+lCZ3Rh8XVECzyYPax6NxDzo2tKRDyyvU/PXH
	 9IeSu27H0Mq2ZkQ5fF1X1yyxvjpsaicxC8/qzzq1b5yAPP3Wd1VIab/6VZ/d6xWqgZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=opBW3e7b;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEC2606A332
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 05:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEEC2606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=opBW3e7b
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261102055314epoutp01272314a4bbd27655417f9f2658894a85~kJJngO8HW2622726227epoutp01t
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 05:53:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261102055314epoutp01272314a4bbd27655417f9f2658894a85~kJJngO8HW2622726227epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793598794;
	bh=Z7VOfdGlq/tsCeMOtC2n9BnTqm/JFSdUYGKJP6RCeBo=;
	h=From:To:Cc:Subject:Date:References:From;
	b=opBW3e7bzHmRE2ZzbOc3KQ10qwv4NmjJRYGUVk8ylM8JEQSOgsZBLkLn0+duMYfxj
	 iA8Jw3PRAFg9veWaE4YTehiTs8Vb9/uaw0d81HRMQaZ/t4gHBq3+1aiQSubVrJoAwe
	 oiSX/HfAFWuHYhFcrOh3wWoLfdrips5urGaZIENE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261102055314epcas2p3a6521855070a25e6afb4e8cff7ccc699~kJJnBzYxv1401114011epcas2p30;
	Mon,  2 Nov 2026 05:53:14 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.207]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jJ18V0t0dz6B9mC; Mon,  2 Nov
	2026 05:53:14 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20261102055313epcas2p236ca7854da996b968f37931db6e5258b~kJJmQnarW1991319913epcas2p2i;
	Mon,  2 Nov 2026 05:53:13 +0000 (GMT)
Received: from apsw.samsungds.net (unknown [12.80.211.160]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261102055313epsmtip2dfa5bb0ac1ebb60a5ab009d134f0d171~kJJmJrZB10957509575epsmtip2s;
	Mon,  2 Nov 2026 05:53:13 +0000 (GMT)
From: Kiwoong Kim <kwmad.kim@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	bvanassche@acm.org, kwangwon.min@samsung.com, hy50.seo@samsung.com,
	cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com, Kiwoong Kim
	<kwmad.kim@samsung.com>
Subject: [PATCH v4 0/2] ufs: fix the abort path of device management
 commands in MCQ mode
Date: Mon,  2 Nov 2026 14:52:56 +0900
Message-ID: <cover.1793598099.git.kwmad.kim@samsung.com>
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
X-CMS-MailID: 20261102055313epcas2p236ca7854da996b968f37931db6e5258b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261102055313epcas2p236ca7854da996b968f37931db6e5258b
References: <CGME20261102055313epcas2p236ca7854da996b968f37931db6e5258b@epcas2p2.samsung.com>

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

 drivers/ufs/core/ufs-mcq.c | 21 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c  |  4 ++++
 2 files changed, 25 insertions(+)

-- 
2.43.0

