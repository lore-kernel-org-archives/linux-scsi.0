From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/8] [Target_Core_Mod/LIO-Target] v3.0 updates and bugfixes
Date: Sat, 20 Dec 2008 14:58:51 -0800
Message-ID: <1229813931.4560.191.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:35267 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751824AbYLTW7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 17:59:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

Just a few updates and bugfixes for the generic engine and LIO-Target as
LIO-Target is being brought online using the v3.0 generic target core
infrastructure.  They are made against against lio-core-2.6.git/master
and tested on v2.6.28-rc7.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

 drivers/lio-core/iscsi_target.c           |   22 +++--
 drivers/lio-core/iscsi_target_configfs.c  |    2 -
 drivers/lio-core/iscsi_target_login.c     |    5 +-
 drivers/lio-core/iscsi_target_tpg.c       |   43 -----------
 drivers/lio-core/iscsi_target_tpg.h       |    2 -
 drivers/lio-core/target_core_fabric_ops.h |    5 -
 drivers/lio-core/target_core_tpg.c        |  115 +++++++++++++++--------------
 drivers/lio-core/target_core_transport.c  |   19 +----
 drivers/lio-core/target_core_transport.h  |    3 +-
 9 files changed, 78 insertions(+), 138 deletions(-)

[PATCH 1/8] [Target_Core_Mod]: Add EXPORT_SYMBOL() to transport_release_cmd_to_pool()
[PATCH 2/8] [LIO-Target]: Properly release se_cmd_t w/ CHECK_CONDITION exception during iSCSI session recovery
[PATCH 3/8] [Target_Core_Mod/LIO-Target]: Rename and update usage of transport_allocate_session()
[PATCH 4/8] [Target_Core_Mod]: Add transport_free_session()
[PATCH 5/8] [LIO-Target]: Add transport_free_session() in iscsi_target_login_thread() exception path
[PATCH 6/8] [Target_Core_Mod]: Reenable core_tpg_del_initiator_node_acl() and core_tpg_set_initiator_node_queue_depth()
[PATCH 7/8] [LIO-Target/ConfigFS]: Add lio_tpg_shutdown_session() and lio_tpg_close_session()
[PATCH 8/8] [LIO-Target]: Fix leakage of ISCSI_INIT_LOGOUT_CMND for CLOSESESSION or same CID CLOSECONNECTION cases

--nab

