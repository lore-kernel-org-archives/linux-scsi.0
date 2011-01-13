From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL 0/3] target: resync to latest scsi-post-merge .38
Date: Thu, 13 Jan 2011 12:34:32 -0800
Message-ID: <1294950872-12218-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32265 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933611Ab1AMUeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2011 15:34:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

This is a quick resync from my last two target 'GIT PULL' requests against
the very latest LIO target code commit in scsi-post-merge-2.6.git:

   commit 7d2087a1820b104f3af526f1390f0fb673373e54
   Author: Nicholas Bellinger <nab@linux-iscsi.org>
   Date:   Fri Dec 17 11:11:26 2010 -0800

       [SCSI] target: Add LIO target core v4.0.0-rc6

Please pull from 'for-jejb' rebased against the above commmit here:

    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-jejb

Note that for target_fabric_make_lun() strict_strtoul conversion (from
PULL #2 yesterday) you will need to fix the obvious local scope variable
definition newline conflict (a bug in git..?).  Also please make sure
to carry the jlbec ACK'ed configfs kbuild change as well.

Please let me know if you have any questions,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  target: Add missing core_scsi3_put_pr_reg() for explict REGISTER key
    change
  target: Convert target_fabric_make_lun to strict_strtoul
  configfs: change depends -> select SYSFS

 drivers/target/target_core_fabric_configfs.c |   13 +++++--------
 drivers/target/target_core_pr.c              |    1 +
 fs/configfs/Kconfig                          |   14 +++++++-------
 3 files changed, 13 insertions(+), 15 deletions(-)

-- 
1.7.3.5

