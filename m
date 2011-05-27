From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm_fc: Review cleanups and LUN_RESET bugfix
Date: Fri, 27 May 2011 14:41:00 -0700
Message-ID: <1306532463-28193-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:32440
	"HELO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752499Ab1E0VlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 17:41:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kiran Patil <kiran.patil@intel.com>, Open-FCoE devel <devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Christoph,

The following is short cleanup series for tcm_fc based upon your feedback
this morning, and includes the outstanding LUN_RESET bugfix patch that
did not make it in with the initial merge.

Kiran needs to review and test the second patch, but I think the conversion
if pretty obvious.

These patches have been pushed in lio-core-2.6.git/master on .40-rc0,
and this series applies on top of the latest linux-2.6.git/HEAD.

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm_fc: Makefile cleanups
  tcm_fc: Convert to wake_up_process and schedule_timeout_interruptible
  tcm_fc: Fix ft_send_tm bug and drop ft_lookup_cmd_lun usage

 drivers/target/tcm_fc/Makefile   |   17 +++----------
 drivers/target/tcm_fc/tcm_fc.h   |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c  |   46 ++++++++++----------------------------
 drivers/target/tcm_fc/tfc_conf.c |    4 +-
 4 files changed, 19 insertions(+), 50 deletions(-)

-- 
1.7.5.3

