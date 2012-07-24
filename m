From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 0/7] Fix for ZPODD
Date: Tue, 24 Jul 2012 17:37:38 +0800
Message-ID: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

V2:
Bug fix for V1;
Use scsi_autopm_* in sr driver instead of pm_runtime_*;

V1:
Here are some patches to make ZPODD easier to use for end users and
a fix for using ZPODD with system suspend.

Aaron Lu (7):
  scsi: sr: fix for sr suspend and resume
  scsi: pm: use autosuspend if device supports it
  scsi: sr: use scsi layer autopm in sr driver
  scsi: sr: runtime pm when ODD is open/closed
  scsi: sr: block events when runtime suspended
  scsi: pm: use runtime resume callback if available
  block: genhd: add an interface to set disk's poll interval

 block/genhd.c          | 25 ++++++++++++++++------
 drivers/scsi/scsi_pm.c | 22 +++++++++++++------
 drivers/scsi/sr.c      | 57 ++++++++++++++++++++++++++++++++------------------
 include/linux/genhd.h  |  1 +
 4 files changed, 73 insertions(+), 32 deletions(-)

-- 
1.7.11.3
