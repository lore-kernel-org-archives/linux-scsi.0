From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 0/2] esas2r: Replace semaphores with mutexes
Date: Thu,  8 Jun 2017 15:37:29 +0530
Message-ID: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Rajendra <rnayak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These are a set of patches which removes semaphores from esas2r.
These are part of a bigger effort to eliminate unwanted semaphores
from the linux kernel.

Binoy Jayan (2):
  scsi: esas2r: Replace semaphore fm_api_semaphore with mutex
  scsi: esas2r: Replace semaphore fs_api_semaphore with mutex

 drivers/scsi/esas2r/esas2r.h       |  4 ++--
 drivers/scsi/esas2r/esas2r_init.c  |  4 ++--
 drivers/scsi/esas2r/esas2r_ioctl.c | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
Binoy Jayan
