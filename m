Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0953C2E11C7;
	Sat, 21 Mar 2026 03:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774062642; cv=none; b=KcJbkMMa9Er4vEptIXqrIBbkHj9LNSIzcfcS8etI6DB2obL8mYKMIq2OP4deoqHg1KCw39kFb8bTwLHzHapang5txWqArBak2RNZzBNbjBZ073EAS1QRTD13UiJusrDI2vHANBXnqHCyUMMKXKIl0qvlyQL3aUtQ58kFpyTndZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774062642; c=relaxed/simple;
	bh=9ttpSMrXVmjsAZdh29t/8ZQZpKMqH/4pkDkqJU2sMT4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I7gvHdGgSvnWj8lbwKG8//pdckQ3tsg+4VnPX4h1qxJHhBdA7t+X32g1SXPECiW0z4x1OIOrUwC0VMwj/7SIbQTTgEFVBHVhwWfOM/HgyJT5qO8fWXzF4JN0ZH71FfJV1/2Vgg0wOw/KlmU4a5r4LkdPCZR3nT7sq8yQ+nWpwfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p8w5rKJF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p8w5rKJF"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62L0h0uS3205498;
	Sat, 21 Mar 2026 03:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=yp2bQCIN6SdlVFDmFrc8gqOv2aBq8p8X7Vs
	VcJSkLBw=; b=p8w5rKJF2L3ysH7AK4L8F39KZLDv/hZkH0COtam5/c7QiddtzSN
	jGcijPiunywH+6qIB93UHG9I2Nx9qET6FD0TeDRNhOi5jgl5uc7D6I5GUGyucehY
	eoCgi9YrLoyyyuH1wFUFY9eKiLrzVpHDMaU61N178UXu16K1ai+Tm7TPa2m8EvJ1
	shyWjW2lCX+LsyubcwnJQKFOTazyh/1byrXDqHUcmlYDybCQbeP/OhCbGsbmW3YR
	re/+LzHk8Yb2QVXRQKT+s083D/Pi3i2+06sCApK3Ms8LVmMiT7u4GjoPpQpLRWjp
	ge8vQYC1zkqLiryKIWR4HQ74GKWYKCQ0ppg==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1h1e060a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:24 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62L3ANL0030418;
	Sat, 21 Mar 2026 03:10:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4d0spy9ct6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:23 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62L3ANoG030412;
	Sat, 21 Mar 2026 03:10:23 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 62L3AN4R030411
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:23 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 2BFD65A8; Fri, 20 Mar 2026 20:10:23 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org (open list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC support:Keyword:mediatek)
Subject: [PATCH v4 00/12] scsi: ufs: Add TX Equalization support for UFS 5.0
Date: Fri, 20 Mar 2026 20:10:09 -0700
Message-Id: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: RNredeJEGjGm8QlhkrYS2LnDtxA4skVW
X-Authority-Analysis: v=2.4 cv=epXSD4pX c=1 sm=1 tr=0 ts=69be0c20 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=ZyePWOR3t2h397M-7AgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDAyMyBTYWx0ZWRfXyPBvO1sSeNc5
 nguI2X8AL8zttmShSVaGvr6iCSyuHZ1VoXIxxSHtDupVcuu5G8UyU5RAuK5yc+FlpWyfTIGPJTw
 /WDQo1Z5w3mdUolQumUnEknJ2Ja3V0MmU4LIdfuupsX79x/gTifY/h6+GJl3KzcTqG5wQuWDy5J
 9gpw1Emnh3IZe8ldFPEgUNA1rqYYYXDDCoRCCYVyUwiU8cvo2VUwyPWCEIwpVXXvNdDhNUKkmgg
 l+WkwU3TnHufSNESw3KpHmb6C43QBhVEYsq/gXhn1UApwF3eErZtV+LB5bTGV+vhhTHtYHNZT8R
 TtgoQlxe1YnAv9pW9GAXTLVSHYB1ryOs/J11hrvMfz80KRFBL8uu50ef7L/iftaSF1la/FL/zyz
 F4wj81JrL9Irxw2gZBUY+I+b9f/YegWmDRUC93vTYFN+KOycyGsSgAA0WGoCFkZzcax46zqS9ZV
 O4tZ2En5rIIbhGKyyZg==
X-Proofpoint-GUID: RNredeJEGjGm8QlhkrYS2LnDtxA4skVW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_01,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210023

Hi,

The UFS v5.0 and UFSHCI v5.0 standards have published, introducing support
for HS-G6 (46.6 Gbps per lane) through the new UniPro V3.0 interconnect
layer and M-PHY V6.0 physical layer specifications. To achieve reliable
operation at these higher speeds, UniPro V3.0 introduces TX Equalization
and Pre-Coding mechanisms that are essential for signal integrity.

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
- use_txeq_presets: Use only the 8 standaird presets (default: false)
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

# cat /sys/kernel/debug/ufshcd/*ufshcd*/tx_eq_hs_gear6/device_tx_eqtr_record
Device TX EQTR record summary -
Target Power Mode: HS-G6, Rate-B
Most recent record index: 2
Most recent record timestamp: 219573378 us

TX Lane 0 FOM - PreShoot\DeEmphasis
\       0        1        2        3        4        5        6        7
0      50       70       65        -        -        -        -        x
1       x        x        x        x        x        x        x        x
2     100       90       70        -        -        -        -        x
3       x        x        x        x        x        x        x        x
4      95       90        -        -        -        -        -        x
5       -        -        -        -        -        -        -        x
6       x        x        x        x        x        x        x        x
7       x        x        x        x        x        x        x        x

TX Lane 1 FOM - PreShoot\DeEmphasis
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
Patches 5-7: Debugfs support for TX Equalization
Patches 8-12: Qualcomm vendor implementation

Next
====

One more series has been developed to enhance TX Equalization support,
which will be submitted for review after this series is accepted:

- Provide board specific (static) TX Equalization settings from DTS
- Parse static TX Equalization settings from DTS if provided
- Apply static TX Equalization settings if use_adaptive_txeq is disabled
- Add support for UFS v5.0 attributes qTxEQGnSettings & wTxEQGnSettingsExt
- Enable persistent storage and retrieval of optimal TX Equalization settings

v3 -> v4:
1. Incorporated comments from Bart and Peter.
2. In patch 1, removed redundant checks on dev_req_params
3. In patch 1, moved error prints out of vops negotiate_pwr_mode()
4. In patch 1, removed vops implemenation ufs_versal2_negotiate_pwr_mode(),
   sprd_ufs_negotiate_pwr_mode() and ufs_intel_lkf_negotiate_pwr_mode() as
   they are simply doing memcpy().
5. In patch 3, initialize UFS_HS_GEAR_MAX as UFS_HS_G6. 
6. In patch 4, adjusted places where UFS_HS_GEAR_MAX is used.
7. In patch 4, defined inline func ufs_hs_rate_to_str() instead of macro.
8. In patch 4, changed default value of use_txeq_presets to 'false'.
8. In patch 4, optimized ufshcd_tx_eq_params and ufshcd_tx_eq_settings.
9. In patch 4, optimized memory usage of ufshcd_tx_eq_params.
10. In patch 5, updated places which use fields in ufshcd_tx_eq_params.
11. In patch 7, used 'retrain' instead of 'refresh'.
12. In patch 10, introduced a few macros.

v2 -> v3:
1. Incorporated comments from Bart, Bean and Mani.
2. In patch 4, made ufshcd_config_pwr_mode() ignore TX EQTR error.
3. Added patch 6 to introduce helpers to pause/resume command processing.
4. In patch 7, changed debugfs entry to 'tx_eq_ctrl' and used 'refresh'
   as input to trigger TX Equalization refreshing.
5. In patch 7, renamed ufshcd_retrain_tx_eq() to ufshcd_refresh_tx_eq().
6. Fixed typos and coding style issues.

v1 -> v2:
1. Incorporated Bart's comments.
2. Fixed typos and coding style issues.
3. Added enum ufshcd_pmc_policy and use enum instead of boolen parameter.
4. Updated TX Equalization debugfs entries structure.
5. Extracted ufshcd_pause/resume_command_processing() in ufshcd.c.
6. Updated sequence in Qualcomm's vops get_rx_fom() implementation.

Can Guo (12):
  scsi: ufs: core: Introduce a new ufshcd vops negotiate_pwr_mode()
  scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a
    parameter
  scsi: ufs: core: Add UFS_HS_G6 and UFS_HS_GEAR_MAX to enum
    ufs_hs_gear_tag
  scsi: ufs: core: Add support for TX Equalization
  scsi: ufs: core: Add debugfs entries for TX Equalization params
  scsi: ufs: core: Add helpers to pause and resume command processing
  scsi: ufs: core: Add support to retrain TX Equalization via debugfs
  scsi: ufs: ufs-qcom: Fixup PAM-4 TX L0_L1_L2_L3 adaptation pattern
    length
  scsi: ufs: ufs-qcom: Implement vops tx_eqtr_notify()
  scsi: ufs: ufs-qcom: Implement vops get_rx_fom()
  scsi: ufs: ufs-qcom: Implement vops apply_tx_eqtr_settings()
  scsi: ufs: ufs-qcom: Enable TX Equalization

 drivers/ufs/core/Makefile          |    2 +-
 drivers/ufs/core/ufs-debugfs.c     |  290 +++++++
 drivers/ufs/core/ufs-txeq.c        | 1303 ++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h     |   59 +-
 drivers/ufs/core/ufshcd.c          |  192 +++-
 drivers/ufs/host/ufs-amd-versal2.c |    3 -
 drivers/ufs/host/ufs-exynos.c      |   34 +-
 drivers/ufs/host/ufs-hisi.c        |   23 +-
 drivers/ufs/host/ufs-mediatek.c    |   40 +-
 drivers/ufs/host/ufs-qcom.c        |  591 ++++++++++++-
 drivers/ufs/host/ufs-qcom.h        |   42 +
 drivers/ufs/host/ufs-sprd.c        |    3 -
 drivers/ufs/host/ufshcd-pci.c      |    7 +-
 include/ufs/ufshcd.h               |  174 +++-
 include/ufs/unipro.h               |  141 ++-
 15 files changed, 2789 insertions(+), 115 deletions(-)
 create mode 100644 drivers/ufs/core/ufs-txeq.c

-- 
2.34.1

