Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578223;
	b=AAKfuls2yo74FFHSPtLIFRIN9Q+zt5+F5pkExs2rsrVRJc9IJZf7A4tknnctyAjJd0JV
	 fGErLJiSjmEHXGtpRgYrttjCzk38FJYnKv49vGaWVrB2FfuzbfE3JcamBanOkjLr1WgXY
	 7Av9cabty7lSw6wKLVjh0tvTDC8X166VsEnIGIznPoD4P+RmFTKZJRscUwqT/F/HKOhMr
	 PmguDy1c+kklRNFBvOd4uCW822SPYBsMbFAL8VT7er4rLw5D/jBKzqF4oprYGIbkKP09V
	 IbpdeeclpNksKIfovcEWDeUTzRHZXpxEhA8M4zPsNjccCKK3ZC2XqUnLb7hr7r+v9Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578223;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=uvL3Vk2KR66kYFy2Kzts3vEUwvAKDb5OrA/AwuhoJmg=;
	b=B+k3kUmaBAG+6OZkj28mfqaRDqJ+1F+jmu6hYSZVTsAlbhQHQOjS0iW+lGswJCVjcshP
	 i0xaOwJeHUSsgoffj2WQ0yX8P7j/rU1zs8CntxSfoXHj1TFVlmtK7S4gQijYiqvSAw8C+
	 MeeqS2csIR179xZAT9NW7V13zEvMjYHr/ZKooCs0oXjc1tB29ZEgR9bPAeWulaCJ8MoYN
	 xlqpITGgVIfRX2YfpPRXEGMQjUSQwDLLIXMxJEBc2C3ACubEshM6a4wW6gGenlHiA/7/S
	 7+T9G15BO/vnXgVvoA7EctJUn8PJvE3yV4TIYiGtGDbsTaGMQTTac/u9xCo/trqRMFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=Q2kmTaem;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231F5606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 231F5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=Q2kmTaem
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5fXx1763790;
	Wed, 21 Oct 2026 03:23:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=uvL3Vk2KR66kYFy2Kzts3vE
	UwvAKDb5OrA/AwuhoJmg=; b=Q2kmTaem30IoUfdE58QBWFWBQKh12+6tLvLD636
	eZE2aIAQy8TtL9eNxGT4wZfS+vbRHkOHm9QoyyL1xuNPZqXoKqyc5C7fABwiddre
	pIqSp9dn+gdu3/I8r4x/MqEkGR5diNw8p1Z3OmEMGFn1H3KzH2x5+zHApFsavKDz
	+cfU/EEaOP9fyCh1xra2T8qh6I/vJ5j5Lzt9zeKxCitvL8Ga+aAghURp1UPMZoYd
	DcOTpa5K/KedCiq/uczV9XU2p9IWZzU2gB1cOj26T7lbcxWBxyGTJPS/3IDUtoUX
	LIk64gdNSCtxPZDXb1RFKDXpLy8oZhkRcx0PATcPs7V9PuA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hepyxh2ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:39 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:38 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6593C3F709E;
	Wed, 21 Oct 2026 03:23:35 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 00/14] scsi: qla2xxx: Misc. Bug fixes
Date: Wed, 21 Oct 2026 15:52:56 +0530
Message-ID: <20261021102310.3854868-1-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: NIC77hZveJCQqeLafR_EAFaLje0gKS2Z
X-Proofpoint-GUID: NIC77hZveJCQqeLafR_EAFaLje0gKS2Z
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX6lIl7UOkvsVL
 Ntmh8FML9s36/NrHRtPSIYISLTaF7r2Cb5JQOONw8mXzMJUIzElkiEdxsNdPm23D7p/hHMQNmWC
 lb+QxPBb88kHidZauMFB0wq2VFe4Qv8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX/GOI+tIqImMR
 hdbpWC59PoEkpnX6NVMcPg/sfRTVM9RoynKs9V3oqOAZ6PJHGwQy7djbMAYtM+KVytKtIN+7VbS
 Uso1IZI04j6JdVkgo3j7vCwLKcOrUvQ6WbBabogDnX4wrjg2ook200p9lMoitmFD5/CRQjAIg6H
 DMfWvqwVAHZ2ixmq4YSWzZZ7LBO+iGMgxN1935ROhbSv6ucBjFWEmacfTGvrw3BU8xDp+5+M8mE
 zKsSLelA50sZus7uiOTNSAoIYFGZk9iaT8VlcPD49qFw+ZhjjkmwdXoOq0Sj8LOMLxoYaS92vFn
 X+ka59gpyR6yz1aKUlaw9YTTEqygGzzHQHbMe5rrTept7gmv7YI1stYKJTsOJMkFmF2wVDvitTH
 95ZPVf2gB3CATYdaLjTSAhzl/a+Sfxx2GVshDsUNYEUZU7PVembS8IbcD0hs5YDw6JMhaR+VkyU
 f32Jb3FxaTrHVosXM7g==
X-Authority-Analysis: v=2.4 cv=Jq9kP84C c=1 sm=1 tr=0 ts=6ad892ab cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=ye7acEmimiDIhefqCmkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

This series collects bug fixes and updates for the qla2xxx driver,
addressing crashes, hard lockups, and races observed during virtual
port (NPIV) teardown, async fabric scan, and BUS reset, along with
29xx-specific async event handling.

Manish Rangankar (4):
  scsi: qla2xxx: Wait for session deletion before full-login LIP
  scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap
  scsi: qla2xxx: Skip vport DPC processing during vport deletion
  scsi: qla2xxx: Add validation check for base vport index during delete

Nilesh Javali (10):
  scsi: qla2xxx: Update MAINTAINERS with new FC storage alias
  scsi: qla2xxx: Update few AENs for 29xx handling
  Revert "scsi: qla2xxx: Validate BSG request_len before reading
    vendor_cmd[]"
  scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list
  scsi: qla2xxx: Validate vport before deletion
  scsi: qla2xxx: Fix use-after-free races during vport deletion
  scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC
  scsi: qla2xxx: Yield work_lock in fabric scan path
  scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters
  scsi: qla2xxx: Update version to 12.00.00.2610b1

 MAINTAINERS                        |  2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |  6 ++++
 drivers/scsi/qla2xxx/qla_bsg.c     | 57 +++---------------------------
 drivers/scsi/qla2xxx/qla_def.h     |  1 -
 drivers/scsi/qla2xxx/qla_gs.c      | 32 ++++++++++++++---
 drivers/scsi/qla2xxx/qla_init.c    | 40 ++++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c     | 16 +++++----
 drivers/scsi/qla2xxx/qla_mid.c     | 33 ++++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c      | 32 ++++++++++-------
 drivers/scsi/qla2xxx/qla_version.h |  4 +--
 10 files changed, 125 insertions(+), 98 deletions(-)


base-commit: 12e67eb89eb2b9516685c744d3f7de0a2d1bd701
-- 
2.52.0

