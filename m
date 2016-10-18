From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 0/7] ufs-qcom: phy/hcd: Clean up qcom-ufs phy and ufs-qcom hcd
Date: Tue, 18 Oct 2016 10:18:58 +0530
Message-ID: <1476766145-27583-1-git-send-email-vivek.gautam@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

These patches cleanup the ufs phy driver to an extent.
Subsequent patches will target to clean the phy_init() of
these qcom-ufs phy drivers in order to get rid of a number of
exported APIs that phy drivers expose for ufs-qcom hcd driver
to use.

These patches are based on linux-phy next branch, and have been
tested with on db820c hardware with integration branch -
'integration-linux-qcomlt' of qualcomm linaro lt tree [1].

[1] https://git.linaro.org/landing-teams/working/qualcomm/kernel.git

Vivek Gautam (6):
  phy: qcom-ufs: Remove unnecessary BUG_ON
  phy: qcom-ufs: Use devm sibling of kstrdup for regulator names
  phy: qcom-ufs-qmp-xx: Discard remove callback for drivers.
  phy: qcom-ufs: Cleanup clock and regulator initialization
  phy: qcom-ufs-qmp-xx: Move clock and regulator init out of phy init
  ufs-qcom: phy/hcd: Refactoring phy clock handling

Yaniv Gardi (1):
  phy: qcom-ufs: remove failure when rx/tx_iface_clk are absence

 drivers/phy/phy-qcom-ufs-i.h        |   6 +-
 drivers/phy/phy-qcom-ufs-qmp-14nm.c |  66 ++++++++------------
 drivers/phy/phy-qcom-ufs-qmp-20nm.c |  60 +++++++------------
 drivers/phy/phy-qcom-ufs.c          | 116 +++++++++++++++++-------------------
 drivers/scsi/ufs/ufs-qcom.c         |  15 -----
 5 files changed, 101 insertions(+), 162 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
