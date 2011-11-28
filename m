From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 0/6] ata port runtime power management support
Date: Mon, 28 Nov 2011 09:15:44 +0800
Message-ID: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

This is the v4 patches to add ata port runtime pm support.
Applied on top of v3.2-rc2.

Jeff, any comment on the ata patches?
James, any comment on the scsi patches?

v1:
https://lkml.org/lkml/2011/11/2/23

v2:
https://lkml.org/lkml/2011/11/10/71
Acked-by: Tejun Heo <tj@kernel.org>
Kay Sievers reviewed sysfs change

v3:
https://lkml.org/lkml/2011/11/23/37

Changes in v4:
- check SCSI device runtime PM status in system PM (Alan Stern, Tejun Heo)

Changes in v3:
- runtime resume scsi device before system suspend (Alan Stern)
- check runtime status in sd_shutdown

Thanks for any comment,
Lin Ming

