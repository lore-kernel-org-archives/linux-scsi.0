From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v6 0/2] Clean up UFSHC driver
Date: Wed, 27 Feb 2019 11:39:43 +0100
Message-ID: <dac49928-1346-21dc-f0dd-4773272f78cd@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Hannes Reinecke <hare@suse.de>, Kyuho Choi <kyuho.choi@sk.com>, Martin Petersen <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

This mini-series removes the "disable-VCCQ-power-rail-for-some-Flash-chips"
quirk, and cleans up after the dust settles.

Differences between v5 and v6:
- Reword patch 1 commit message (per Martin)
- Collect tags

Marc Gonzalez (2):
  Revert "scsi: ufs: disable vccq if it's not needed by UFS device"
  scsi: ufs: Remove unused device quirks

 drivers/scsi/ufs/ufs.h        |  1 -
 drivers/scsi/ufs/ufs_quirks.h | 29 ----------------
 drivers/scsi/ufs/ufshcd.c     | 63 +++--------------------------------
 3 files changed, 4 insertions(+), 89 deletions(-)

-- 
2.17.1
