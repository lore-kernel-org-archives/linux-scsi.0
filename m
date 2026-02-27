Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA1C42DFEB;
	Fri, 27 Feb 2026 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208513; cv=none; b=XARrpIXbLFpXb/AkeEO8LQth2c5cy4INXa5l+HQoYB7s8Jx+mAu2tXmHsaabTKQ1mO3vLUUK7YpyDNah0U/ItwFl26kT02zasCvOfTbWed44WXB8+gRZ1M92D00u8LQIxBDAkB3MG2BQbxzPFiLwO3UgxLlZVSu3XZMnp0POQ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208513; c=relaxed/simple;
	bh=HbbaVRtOWYWtVXWHUubdiS5hY5T1c8nqhmwHVFd5qeI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mJJorfqjo+EvTnzwE3SR4HW5shIxts3RmXJRGk2f1kfsgM+5cSfdjrURo/33Vnh0Hy6cdsQmY/VAF8RABdwgXqDsEX/r3oFfh6ez4jI3ax5yENqj7eEESTuurIcmNTTXVlDn5sB0UTxaH4dU+2w33MDA2CGDD76bBLZMAKtfBrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bfvFMeKd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bfvFMeKd"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REaRGp4030873;
	Fri, 27 Feb 2026 16:08:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=EJrpQhdCOoRte/zJtlYXaNBE8fWqDiq/wvN
	e1P3Th94=; b=bfvFMeKdb2icMQxHceT/U3bJoPqwRnFympuOsdZA9fbgQ8eN5iO
	7xXfRNztt5XwDNji04+lAJCGKZVIVttd1s5THUiT0m0iVHl5H/4EjA5zYNgJ9/Bz
	jac1Ei+EaICM4mhT+jw8keZnMfYJyr7oY79U6AEKZ1sinWPgP4ZTj6XuUK6qYTiv
	o5M1X6icMFlC22oI9nEihaUPbW8BkUJt3EN8LBR1yEOQK6Rq+VIQE09Wjal1b7nu
	UUNKBKl/Kspl1dCGSlpJ8O9bUUbsvNQv/uNX6KBGb7SyMWICHiqV/laD0QvrvWtU
	RZAbymGI+LeHFGRo1a4xYEb3EjmM6hFEMZQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cju4r41xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:12 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RG8BCa010861;
	Fri, 27 Feb 2026 16:08:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cjx30h5tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:11 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61RG8B0A010847;
	Fri, 27 Feb 2026 16:08:11 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 61RG8BBa010843
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:11 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 1FC4D5A0; Fri, 27 Feb 2026 08:08:11 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH 00/11] scsi: ufs: Add TX Equalization support for UFS 5.0
Date: Fri, 27 Feb 2026 08:07:57 -0800
Message-Id: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0NCBTYWx0ZWRfXyKJPTRg3lAOB
 RMFEZFJ02CG/HEexnm6wGKqtDFGgc5rE2n9q0dHNN1rbh5BsZLO9FNf/GHTPJLQByfYMMWWo+bp
 PlfkIzSRQCfXEcaoB6iXtzXnpVA3QJlLDKM9eCHo6syLUxOUoL/gwLq+DpKmZGVnfS8bp2Wowkm
 kdF4/C1SHisd8i/N62tiOdunAA7TcunduUqhtgZlgnuHEhZUlO1FTgSEGed85D0Zj418AS2NV0k
 bb1thlF8asoM0Y7h91mjiNxH/Ejifr8wU9EBOmTNcpxTdkHLYSxJs7/q8OTR530XdL76A+XroXF
 0CiE9V6US3h8xbnSP6PWi/Rk6hA3A8xnMLRVta1UIXC6CyzSHLlcT6pfC1Ic9xUJj7WKGoIM7uh
 Rl17t+2XYlrc3I/RNeDAYkimKmgZQnij7WJ03oHgRoaYe0Oem560EipvAKOJyL075q6pQYw+QUZ
 r0CSzsHC7beJWbbSxlw==
X-Proofpoint-GUID: ibfUSS6Km65TSfdTOttW-QylCDXF8Bki
X-Authority-Analysis: v=2.4 cv=KZzfcAYD c=1 sm=1 tr=0 ts=69a1c16c cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=yxO-sryqdY87dfIgdzYA:9
X-Proofpoint-ORIG-GUID: ibfUSS6Km65TSfdTOttW-QylCDXF8Bki
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602270144

Hi,

The UFS 5.0 standard was published today, introducing support for HS-G6
(23.2 Gbps per lane) through the new UniPro V3.0 interconnect layer and
M-PHY V6.0 physical layer specifications. To achieve reliable operation
at these higher speeds, UniPro V3.0 introduces TX Equalization and
Pre-Coding mechanisms that are essential for signal integrity.

This patch series implements TX Equalization support in the UFS core
driver as specified in UFSHCI v5.0, along with the necessary vendor
operations and a reference implementation for Qualcomm UFS host
controllers.

Background
==========

TX Equalization is a signal conditioning technique that compensates for
channel impairments at high data rates (HS-G4 through HS-G6). It works
by adjusting two key parameters:

- PreShoot: Pre-emphasis applied before the main signal transition
- DeEmphasis: De-emphasis applied after the main signal transition

UniPro V3.0 defines TX Equalization Training (EQTR) procedure to
automatically discover optimal TX Equalization settings. The EQTR
procedure:

1. Starts from the most reliable link state (HS-G1)
2. Iterates through all possible PreShoot and DeEmphasis combinations
3. Evaluates signal quality using Figure of Merit (FOM) measurements
4. Selects the best settings for both host and device TX lanes

For HS-G6, Pre-Coding is also introduced to further improve signal
quality. Pre-Coding must be enabled on both transmitter and receiver
when the RX_FOM indicates it is required.

Implementation Overview
=======================

The implementation follows the UFSHCI v5.0 specification and consists of:

Core Infrastructure (Patches 1-6):
- New vops callback negotiate_pwr_mode() to allow vendors to negotiate
  power mode parameters before applying TX Equalization settings
- Support for HS-G6 gear enumeration
- Complete TX EQTR procedure implementation in ufs-txeq.c
- Debugfs interface for TX Equalization parameter inspection and manual
  retraining
- Module parameters for adaptive TX Equalization control

Qualcomm Implementation (Patches 7-11):
- PHY-specific configurations for TX EQTR procedure
- Vendor-specific FOM measurement support
- TX Equalization settings application
- Enable TX Equalization for HW version 0x7 and onwards

The implementation is designed to be vendor-agnostic, with platform-
specific details handled through the vops callbacks. Other vendors can
add support by implementing the three new vops:

- tx_eqtr_notify(): Called before/after TX EQTR for vendor setup
- apply_tx_eqtr_settings(): Apply vendor-specific PHY configurations
- get_rx_fom(): Retrieve vendor-specific FOM measurements if needed

Module Parameters
=================

The implementation provides several module parameters for flexibility:

- use_adaptive_txeq: Enable/disable adaptive TX Equalization (default: false)
- adaptive_txeq_gear: Minimum gear for adaptive TX EQ (default: HS-G6)
- use_txeq_presets: Use only the 8 standard presets (default: true)
- txeq_presets_selected[]: Select specific presets for EQTR

Testing
=======

This patch series has been tested on Qualcomm platforms with UFS 5.0
devices, validating:

- Successful TX EQTR completion for HS-G6
- Proper FOM evaluation and optimal settings selection
- Pre-Coding enablement for HS-G6
- Power mode changes with TX Equalization settings applied
- Report of TX Equalization settings via debugfs entries
- Report of TX EQTR histories via debug entries (see next section)
- Re-training TX Equalization via debugfs entry

Example of TX EQTR history
==========================

# cat /sys/kernel/debug/ufshcd/*ufshcd*/device_tx_eqtr_record
Device TX EQTR record summary -
Target Power Mode: HS-G6, Rate-B
Number of records: 1
Last record timestamp: 11643252 us

TX Lane 0: PreShoot\DeEmphasis
\       0        1        2        3        4        5        6        7
0      50       70       65        -        -        -        -        x
1       x        x        x        x        x        x        x        x
2     100       90       70        -        -        -        -        x
3       x        x        x        x        x        x        x        x
4      95       90        -        -        -        -        -        x
5       -        -        -        -        -        -        -        x
6       x        x        x        x        x        x        x        x
7       x        x        x        x        x        x        x        x

TX Lane 1: PreShoot\DeEmphasis
\       0        1        2        3        4        5        6        7
0      50       70       60        -        -        -        -        x
1       x        x        x        x        x        x        x        x
2     100       80       65        -        -        -        -        x
3       x        x        x        x        x        x        x        x
4      95       85        -        -        -        -        -        x
5       -        -        -        -        -        -        -        x
6       x        x        x        x        x        x        x        x
7       x        x        x        x        x        x        x        x

Patch Structure
===============

Patches 1-3: Preparatory changes for power mode negotiation and HS-G6
Patch 4: Core TX Equalization and EQTR implementation
Patches 5-6: Debugfs support for TX Equalization
Patches 7-11: Qualcomm vendor implementation

Next
====

One more series has been developed to enhance TX Equalization support,
which will be submitted for review after this series is accepted:

- Provide board specific (static) TX Equalization settings from DTS
- Parse static TX Equalization settings from DTS if provided
- Apply static TX Equalization settings if use_adaptive_txeq is disabled
- Add support for UFS v5.0 attributes qTxEQGnSettings & wTxEQGnSettingsExt
- Enable persistent storage and retrieval of optimal TX Equalization settings

Can Guo (11):
  scsi: ufs: core: Introduce a new ufshcd vops negotiate_pwr_mode()
  scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a
    parameter
  scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum
    ufs_hs_gear_tag
  scsi: ufs: core: Add support for TX Equalization
  scsi: ufs: core: Add debugfs entries for TX Equalization params
  scsi: ufs: core: Add support to retrain TX Equalization via debugfs
  scsi: ufs: ufs-qcom: Fixup PAM-4 TX L0_L1_L2_L3 adaptation pattern
    length
  scsi: ufs: ufs-qcom: Implement vops tx_eqtr_notify()
  scsi: ufs: ufs-qcom: Implement vops get_rx_fom()
  scsi: ufs: ufs-qcom: Implement vops apply_tx_eqtr_settings()
  scsi: ufs: ufs-qcom: Enable TX Equalization

 drivers/ufs/core/Makefile          |    2 +-
 drivers/ufs/core/ufs-debugfs.c     |  238 ++++++
 drivers/ufs/core/ufs-txeq.c        | 1265 ++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h     |   59 +-
 drivers/ufs/core/ufshcd.c          |  117 ++-
 drivers/ufs/host/ufs-amd-versal2.c |   13 +-
 drivers/ufs/host/ufs-exynos.c      |   44 +-
 drivers/ufs/host/ufs-hisi.c        |   32 +-
 drivers/ufs/host/ufs-mediatek.c    |   46 +-
 drivers/ufs/host/ufs-qcom.c        |  620 +++++++++++++-
 drivers/ufs/host/ufs-qcom.h        |   44 +
 drivers/ufs/host/ufs-sprd.c        |   13 +-
 drivers/ufs/host/ufshcd-pci.c      |   16 +-
 include/ufs/ufshcd.h               |  136 ++-
 include/ufs/unipro.h               |  266 ++++--
 15 files changed, 2729 insertions(+), 182 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-txeq.c

-- 
2.34.1

