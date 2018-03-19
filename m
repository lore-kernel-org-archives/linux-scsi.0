From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 0/1] scsi: ufs: Add support for Auto-Hibernate Idle Timer
Date: Mon, 19 Mar 2018 10:01:17 +0200
Message-ID: <1521446478-12656-1-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Alim Akhtar <alim.akhtar@samsung.com>, Alex Lemberg <Alex.Lemberg@sandisk.com>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi

Here is V2, now re-based on top of patch "scsi: ufs: sysfs:reworking of the
rpm_lvl and spm_lvl entries".

Michał Potomski has previously sent a patch for Auto-Hibernate, but this
patch is slightly different, based on the latest ufs-sysfs changes, it also
takes care to restore auto-hibernate during resume, and otherwise avoids
updating the register if the device is runtime suspended.  Also a default
value of 150ms is set.


Changes in V2:

	Re-based on top of (yet to be applied) patch "scsi: ufs: sysfs:
	reworking of the rpm_lvl and spm_lvl entries"


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
