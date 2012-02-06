From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Mon,  6 Feb 2012 15:32:23 +0800
Message-ID: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-scsi@vger.kernel.org

SSD becomes more and more popular, this makes it possible to put disk into
low power state more often.  And request based runtime PM for scsi disk is
more useful than open/close based one because disk is normally mounted at
most time.

One known issue, because SCSI TEST_UNIT_READY will be put into request
queue every 2 seconds by default, this makes it hard for disk to sleep.
Maybe we can implement check_events callback in some other way?

[RFC 1/5] pm, runtime, Add resume notifier
[RFC 2/5] scsi, pm, rename scsi_autopm_get/put_xxx to
[RFC 3/5] scsi, pm, add pm_runtime_get/put in scsi request
[RFC 4/5] scsi, pm, use autosuspend for scsi runtime PM
[RFC 5/5] scsi, sd, pm, request based runtime PM support

Best Regards,
Huang Ying
