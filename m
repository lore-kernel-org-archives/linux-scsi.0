From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH 0/3] ata port runtime power management support
Date: Wed,  2 Nov 2011 14:21:37 +0800
Message-ID: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi, all

These 3 patches add ata port runtime pm support, which is done through scsi layer.
scsi host runtime pm mechanism is already there(scsi_pm.c).
These patches add hooks for ata port.

Lin Ming (3):
      scsi: fix potential dead lock for host runtime pm
      scsi: add hooks for host runtime power management
      ata: implement ata port runtime pm hooks

 drivers/ata/libata-core.c |   96 +++++++++++++++++++++++++++++---------------
 drivers/scsi/scsi_error.c |    4 +-
 drivers/scsi/scsi_pm.c    |   45 +++++++++++++++++++-
 drivers/scsi/scsi_priv.h  |    2 +
 include/linux/libata.h    |    7 +++
 include/scsi/scsi_host.h  |    8 ++++
 6 files changed, 125 insertions(+), 37 deletions(-)

Thanks for any comment.
Lin Ming
