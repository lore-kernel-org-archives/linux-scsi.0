From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V2 0/9] ufs patch siries
Date: Tue, 14 May 2013 10:08:39 +0300
Message-ID: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3ENHJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 03:09:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>

This patch series clusters the latest version of all the UFS patches in the
SCSI mailing list. It gives a stable functional base line for the UFS driver.

It includes the following versions:
> [PATCH V5] scsi: ufs: add support for query requests
> [PATCH 1/2] Documentation: devicetree: Add DT bindings for UFS host
> controller
> [PATCH 2/2] scsi: ufs: Fix the response UPIU length setting
> [PATCH v4 1/6] scsi: ufs: wrap the i/o access operations
> [PATCH v4 2/6] scsi: ufs: amend interrupt configuration
> [PATCH v4 3/6] scsi: ufs: fix interrupt status clears
> [PATCH v4 4/6] scsi: ufs: rework link start-up process
> [PATCH V5 1/1] scsi: ufs: Add support for sending NOP OUT UPIU
> [PATCH V4] scsi: ufs: Set fDeviceInit flag to initiate device
> initialization

But does not include:
> [PATCH v4 5/6] scsi: ufs: add dme configuration primit
> [PATCH v4 6/6] scsi: ufs: add dme control primitives

-- 
V2:
- Add query requst support patch which was ommited from the merge window

Dolev Raviv (9):
  scsi: ufs: add support for query requests
  Documentation: devicetree: Add DT bindings for UFS host controller
  scsi: ufs: Fix the response UPIU length setting
  scsi: ufs: wrap the i/o access operations
  scsi: ufs: amend interrupt configuration
  scsi: ufs: fix interrupt status clears
  scsi: ufs: rework link start-up process
  scsi: ufs: Add support for sending NOP OUT UPIU
  scsi: ufs: Set fDeviceInit flag to initiate device initialization

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   16 +
 drivers/scsi/ufs/ufs.h                             |  132 ++-
 drivers/scsi/ufs/ufshcd.c                          | 1172 +++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h                          |   47 +-
 drivers/scsi/ufs/ufshci.h                          |    7 +-
 5 files changed, 1101 insertions(+), 273 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt

-- 
1.7.6

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
