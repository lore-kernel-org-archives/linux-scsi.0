From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 00/14] target patches for .39 scsi-misc (v2)
Date: Fri, 25 Feb 2011 11:49:52 -0800
Message-ID: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.54]:39584 "HELO
	nm6-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTuM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

Here are the remaining non critical bugfixes and improvements originally
slated for .38, but which have been queued as .39 misc items upon your
request.  These patches have been further squashed down from the original
for-39-misc.

This series is against .38-rc6, and is also available directly from git (with
whitespace=fix) from here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-misc-v2

Please review and merge for 39-misc,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Christoph Hellwig (1):
  target: remove EXTRA_CFLAGS

Dan Carpenter (2):
  target: Minor sparse warning fixes and annotations
  target: Convert rd_build_device_space() to use errno

Fubo Chen (2):
  target: Remove unnecessary hba_dev_list walk and se_clear_dev_ports
    legacy code
  target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py

Jesper Juhl (2):
  target: Fix match_strdup() memory leaks
  target: Avoid mem leak and needless work in transport_generic_get_mem

Nicholas Bellinger (6):
  target: tcm_mod_builder.py generated Makefile cleanups
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Remove spurious double cast from structure macro accessors
  target: Convert TMR REQ/RSP definitions to target namespace
  target: Fix bogus return in transport_add_device_to_core_hba failure
    path
  target core v4.0.0-rc7-ml

Roland Dreier (1):
  target: Fix memory leak on error path in pscsi_alloc_task

 Documentation/target/tcm_mod_builder.py |   18 +++++-----
 drivers/target/Makefile                 |    1 -
 drivers/target/target_core_configfs.c   |   37 ++++++++++++++++++++--
 drivers/target/target_core_device.c     |   40 ++----------------------
 drivers/target/target_core_fabric_lib.c |    1 +
 drivers/target/target_core_file.c       |   26 ++++++++++++---
 drivers/target/target_core_hba.c        |   15 +--------
 drivers/target/target_core_iblock.c     |   28 ++++++++++------
 drivers/target/target_core_pscsi.c      |   22 ++++++++-----
 drivers/target/target_core_rd.c         |   15 +++++----
 drivers/target/target_core_rd.h         |    2 -
 drivers/target/target_core_transport.c  |   37 +++++++++------------
 include/target/target_core_base.h       |   38 +++++++++++-----------
 include/target/target_core_fabric_ops.h |    2 +-
 include/target/target_core_tmr.h        |   52 +++++++++++++------------------
 include/target/target_core_transport.h  |    4 ++
 16 files changed, 170 insertions(+), 168 deletions(-)

-- 
1.7.4.1

