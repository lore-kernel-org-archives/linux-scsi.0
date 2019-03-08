From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: [PATCH 0/3] scsi: ufs: runtime pm fixes
Date: Fri,  8 Mar 2019 14:00:50 +0530
Message-ID: <20190308083053.30631-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, alim.akhtar@samsung.com, pedrom.Sousa@synopsys.com
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

These are some runtime pm fixes I stumbled upon while
working on adding support for controlling multiple
power domains (needed on qualcomm sdm845 platforms)
in the ufshcd-pltfrm driver.

Rajendra Nayak (3):
  scsi: ufs: Fix runtime pm handling in ufshcd-pltfrm
  scsi: ufs: Add error checks for pm_runtime_get_sync()
  scsi: ufs: qcom: Remove unnecessary runtime pm calls

 drivers/scsi/ufs/ufs-qcom.c      | 2 --
 drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +++
 drivers/scsi/ufs/ufshcd.c        | 5 ++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
