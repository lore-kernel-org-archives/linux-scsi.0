From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target patches for .39 scsi-misc
Date: Thu, 24 Feb 2011 17:14:48 -0800
Message-ID: <1298596488-1661-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.bullet.mail.ne1.yahoo.com ([98.138.90.69]:25584 "HELO
	nm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755279Ab1BYBOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2011 20:14:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

Here are the remaining non critical bugfixes and improvements originally
slated for .38, but which have been queued as .39 misc items upon your
request.

These patches have already been posted a number of times to linux-scsi,
so to reduce the extra noise I am sending an PULL request for these
minor changes.  This tree is against .38-rc6, and please apply to
scsi-misc for .39 from here:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-misc

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Christoph Hellwig (1):
  target: remove EXTRA_CFLAGS

Dan Carpenter (2):
  target: fix dubious one-bit signed bitfield
  target: Convert rd_build_device_space() to use errno

Fubo Chen (3):
  target: Remove unnecessary hba_dev_list walk + release from
    core_delete_hba
  target: Minor sparse warning fixes and annotations
  target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py

Jesper Juhl (2):
  target/file: Fix memory leak in fd_set_configfs_dev_params().
  target: Avoid mem leak and needless work in transport_generic_get_mem

Nicholas Bellinger (9):
  target/iblock: Fix memory leak in iblock_set_configfs_dev_params
  target: Fix memory leaks in
    target_core_dev_pr_store_attr_res_aptpl_metadata
  target: tcm_mod_builder.py generated Makefile cleanups
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Remove unnecessary se_clear_dev_ports legacy code
  target: Remove spurious double cast from structure macro accessors
  target: Convert TMR REQ/RSP definitions to target namespace
  target core v4.0.0-rc7
  target: Fix bogus return in transport_add_device_to_core_hba failure
    path

Roland Dreier (1):
  target: Fix memory leak on error path

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

