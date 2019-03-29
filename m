From: Colin King <colin.king@canonical.com>
Subject: [PATCH 0/2][V2] scsi: pm8001: clean up code and fix spelling mistakes
Date: Fri, 29 Mar 2019 23:44:21 +0000
Message-ID: <20190329234423.5611-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

This is a re-working of an earlier patch; this version splits the
original patch into two parts, one for the code clean up and the
other to fix spelling mistakes.

Colin Ian King (2):
  scsi: pm8001: clean up structurally dead code when PM8001_USE_MSIX is
    defined
  scsi: pm8001: fix spelling mistake, interupt -> interrupt

 drivers/scsi/pm8001/pm8001_hwi.c  | 11 ++++++-----
 drivers/scsi/pm8001/pm8001_init.c |  4 ++--
 drivers/scsi/pm8001/pm8001_sas.h  |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 11 ++++++-----
 4 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.20.1
