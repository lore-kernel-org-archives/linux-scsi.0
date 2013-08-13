From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 0/3] scsi: ufs: Add support for clock and regulator initializaiton
Date: Tue, 13 Aug 2013 16:30:17 +0530
Message-ID: <1376391620-13840-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

UFS HCI specificaiton allows the hardware vendors to have vendor specific
configurations using a dedicated register space. Most of these register
configurations are unique to each controller. The generic UFSHCD exports
a set of useful vendor operations that can be used to configure the host
controller. In addition, the vendor specific operations can also be used
to control the power supply of controller and Uni-Pro h/w blocks.

This patchset adds support for vendor specific initialization, regulator
and clock initialization based on device-tree properties.

Sujit Reddy Thumma (3):
  scsi: ufs: Allow vendor specific initialization
  scsi: ufs: Add regulator enable support
  scsi: ufs: Add clock initialization support

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   31 ++
 drivers/scsi/ufs/ufs.h                             |   23 +
 drivers/scsi/ufs/ufshcd-pci.c                      |    8 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  176 ++++++++-
 drivers/scsi/ufs/ufshcd.c                          |  433 ++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |   55 +++-
 6 files changed, 689 insertions(+), 37 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
