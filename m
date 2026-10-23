Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750576;
	b=OmWufzGWMxzYfmGSux2KrwdleNyI461/J0EkAEWb2UPNO/O05+KwxHSLGAMpsYXOZ29+
	 0VAqScQA5i/uZlRvyI+O+HKpeRXntwO2nH1VpbvHkJ8R4mbXJOSrTfLzxpr1RlDaj6rV1
	 xyfvjxxrvlln2uBIVv+Yb4jweXcD5SPlJwpDrA2z2vjwjDisDkkAKPlY3y6Cdvdl94xiZ
	 up8dsO4gMfkxucmn362CPQeHpr7FXHi02rFjgg4yCXele4M39whikcM62lMjDQ3fgmDi0
	 KubyZUW1LHFuoD1OBpjYkcAC+Xb/hSDxkAAKUmA0vnCpFys9EkCujxEclr+mLfJmuyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750576;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=oZYkaf1ngEGmbQzEOHLs7AF9Y8Pn7vQgsUdmZ0rXb6c=;
	b=NxJCFoXD43czJpiE8VfUThSflyjq17PcKVJSe9bpy0oAb/N6gU7bJvvy25YOoDuPzQH8
	 AxpZohP3skMGwHgYxyBGBOAl9Q4vwGp8PxhEzyk9dSZbIr2PFsmiM0V0VWHFAqHaagjaq
	 6XL1h/gMkk4C4OwBjdJ6RaD3A1xOJPuNB6HhQJizG+yGvNK5rX0sjksE39NLvexbXWUdz
	 9/TQZj/ve79OFvIMzD4rKwgpbKw1sNO2R5LRkUhsq5zpqjm9R4nyHyHwK2y+7obliU9kf
	 fnoyFlMoyOB+tBhwWKtYzMUy86fX5JCFvI7Bhw16E9kRwKUGe/L70hSLetDya9tMg2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=KNUBlHPE;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8645B606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8645B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=KNUBlHPE
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAE7i43757731;
	Fri, 23 Oct 2026 03:16:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=oZYkaf1ngEGmbQzEOHLs7AF
	9Y8Pn7vQgsUdmZ0rXb6c=; b=KNUBlHPEVyTDWRXNLrP0hkJn9vA30mGyFl59/Uk
	XQOv66aZwbc9uPRve9QOGpXvi5L5jGBuZc5caGw0HiW7SpW6YYnr7mjEMyR5rA58
	8DKUj0+MNZ+Rhdy73pbA/vV9PyZTMJb8lqr3VQuGhH+158hMCoVGBFkht/+R9IYY
	RwBZQQMQ7IpeB2OlxFeHsMpyal+/MSx+ztO7JQ1o/pdy32VCWOiCw434/qCKtEXM
	vyQeY50v25LA3lZE/gtvVLI+UuiES9i82+HosDWoX6rEH5w+dax/56etXp0qvaFd
	eK7Ge6q1qLwk2B3//FvqnR0HkydLTCL1qB+3rJtN40ShkLQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfmdtn9vu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:11 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 12E793F7069;
	Fri, 23 Oct 2026 03:16:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 00/13] scsi: qla2xxx: Misc. Bug fixes
Date: Fri, 23 Oct 2026 15:45:47 +0530
Message-ID: <20261023101600.1431179-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
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
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX4RkRQnoryf6f
 RDZ2YNThkT0ksSDOoqc6pSPw7xU9vptKIWC43ToL3nPrRAHp0UGvfLBTIUtBuPn4VZU5s2IMnyT
 pKsQ9tk9MUH1BstkZJ1kUo/8S8fRO9k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXxIo7oXpkxvaf
 E7Qjn9eFUokj8VezNA81UWxwjqXaN5yDpmImBKW4Kl84TeXFrBbVYRDTb8Vv7ZcJdh+XegU8POn
 NuW+JtR6h2NQRMyj5xQyw0GcFiOSrs47vr/7pMMSpaPAlhLwAO82Uk56ioMkit86GddqwwfJH9X
 65fHOC+2V8P9KNgUA5WYt9sfrtfdE+wRkr7veGe68PeibMO2p3jylXaAmfEGkGrzhfeZ/DMBvA8
 5JMRuqRHej+E5cmNjqyjBPW/uQKE8YGRL6v6RkCRMId2hY8qfFI3Ug4IHd1Wytd4yXtVJdwxjHH
 bRpXZZfLWKVWFzCpabilaxytKjVWyXvc6Uq+y7OUMoYIQ4Zk8ekFzcJ0T4e0rrflnG9s3w60lRP
 tctjM/fon7lhgxYiP48A094kRtPi9r0w+wvqjTo/37PSBN/oq/XgrhtPVXyXDBFfU7/rl22Q0oq
 dUUkiEnmpR/XVbRhERA==
X-Proofpoint-GUID: YnjJC8fW2iqvk68fOPJ-Rj6iloG8o40m
X-Proofpoint-ORIG-GUID: YnjJC8fW2iqvk68fOPJ-Rj6iloG8o40m
X-Authority-Analysis: v=2.4 cv=PalqFShd c=1 sm=1 tr=0 ts=6adb33eb cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=OhmfIpVFAqNssJYpP_EA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

This series collects bug fixes and updates for the qla2xxx driver,
addressing crashes, hard lockups, and races observed during virtual
port (NPIV) teardown, async fabric scan, and BUS reset, along with
29xx-specific async event handling.

Changes in v2:
- Drop "scsi: qla2xxx: Yield work_lock in fabric scan path".
- Base vport delete (patch 08) returns -ENODEV instead of 0, so
  fc_vport_terminate() does not free the fc_vport when the driver did
  not tear the port down.
- vport DPC (patch 10) skips a vport when VPORT_DELETE is set.
  delete_progress is set only after disable, session deletion, and
  NVMe teardown.

Manish Rangankar (4):
  scsi: qla2xxx: Wait for session deletion before full-login LIP
  scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap
  scsi: qla2xxx: Skip vport DPC processing during vport deletion
  scsi: qla2xxx: Add validation check for base vport index during delete

Nilesh Javali (9):
  scsi: qla2xxx: Update MAINTAINERS with new FC storage alias
  scsi: qla2xxx: Update few AENs for 29xx handling
  Revert "scsi: qla2xxx: Validate BSG request_len before reading
    vendor_cmd[]"
  scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list
  scsi: qla2xxx: Validate vport before deletion
  scsi: qla2xxx: Fix use-after-free races during vport deletion
  scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC
  scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters
  scsi: qla2xxx: Update version to 12.00.00.2610b1

 MAINTAINERS                        |  2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |  6 ++++
 drivers/scsi/qla2xxx/qla_bsg.c     | 57 +++---------------------------
 drivers/scsi/qla2xxx/qla_def.h     |  1 -
 drivers/scsi/qla2xxx/qla_gs.c      | 28 ++++++++++++---
 drivers/scsi/qla2xxx/qla_init.c    | 40 ++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c     | 16 +++++----
 drivers/scsi/qla2xxx/qla_mid.c     | 34 +++++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c      | 32 ++++++++++-------
 drivers/scsi/qla2xxx/qla_version.h |  4 +--
 10 files changed, 123 insertions(+), 97 deletions(-)

base-commit: 12e67eb89eb2b9516685c744d3f7de0a2d1bd701
-- 
2.52.0

