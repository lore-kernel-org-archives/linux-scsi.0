From: Jan Kotas <jank@cadence.com>
Subject: [PATCH 0/2] scsi: ufs-cdns: Add M31 PHY init
Date: Wed, 27 Mar 2019 14:44:03 +0000
Message-ID: <20190327144405.5716-1-jank@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jan Kotas <jank@cadence.com>
List-Id: linux-scsi@vger.kernel.org

This patchset adds additional initialization required by
M31 PHY when used with Cadence UFS Host Controller.

Jan Kotas (2):
  dt-bindings: scsi: ufs-cdns: Update Cadence UFS compatibility list
  scsi: ufs-cdns: Add support for UFSHCI with M31 PHY

 .../devicetree/bindings/ufs/cdns,ufshc.txt         |  5 +-
 drivers/scsi/ufs/cdns-pltfrm.c                     | 77 +++++++++++++++++++---
 2 files changed, 70 insertions(+), 12 deletions(-)

-- 
2.15.0
