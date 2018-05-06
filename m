From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 0/4] Add required changes to ufshcd to support exynos ufs
 hci
Date: Sun, 06 May 2018 15:44:14 +0530
Message-ID: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
References: <CGME20180506102636epcas2p3432b71e5c867f6cfec16cf2a8c74b0e2@epcas2p3.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, vinholikatti@gmail.com, olof@lixom.net, alim.akhtar@samsung.com
List-Id: linux-scsi@vger.kernel.org

Hi All

These patches are part of a larger patch series [1] which attempts upstreaming
EXYNOS UFS driver support. There was not much activities after v5 of that
series. In between I saw there were other teams in Samsung tried upstreaming
the same, but that has not really gone anywhere.
I have taken this task again and here is another attempt to upstream exynos-ufs
driver support. I have divided the patches into two series, one which adds
required infra in the ufshcd core needed by exynos-ufs driver and other part
will have actual exynos-ufs driver. Splitting this has a advantage of less
reviewing over head.

I am floating these as a new patch set.

[1] https://www.spinics.net/lists/linux-scsi/msg90292.html

These patches are based on mainline v4.17-rc3.

Alim Akhtar (4):
  scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr
  scsi: ufs: add quirk not to allow reset of interrupt aggregation
  scsi: ufs: add quirk to enable host controller without hce
  scsi: ufs: make ufshcd_config_pwr_mode of non-static func

 drivers/scsi/ufs/ufshcd.c | 104 ++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |  18 ++++++++
 2 files changed, 114 insertions(+), 8 deletions(-)

-- 
2.7.4
