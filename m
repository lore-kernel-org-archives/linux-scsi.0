From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
Date: Fri, 16 Feb 2018 14:01:03 +0200
Message-ID: <1518782464-28847-1-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michal Potomski <michalx.potomski@intel.com>, Szymon Mielczarek <szymonx.mielczarek@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi

Michał Potomski has previously sent a patch for this, but this patch is
slightly different, based on the latest ufs-sysfs changes, it also takes
care to restore auto-hibernate during resume, and otherwise avoids updating
the register if the device is runtime suspended.  Also a default value of
150ms is set.


Adrian Hunter (1):
      scsi: ufs: Add support for Auto-Hibernate Idle Timer

 Documentation/ABI/testing/sysfs-driver-ufs | 15 ++++++
 drivers/scsi/ufs/ufs-sysfs.c               | 77 ++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                  | 26 ++++++++++
 drivers/scsi/ufs/ufshcd.h                  |  3 ++
 drivers/scsi/ufs/ufshci.h                  |  7 +++
 5 files changed, 128 insertions(+)


Regards
Adrian
