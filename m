From: madhu.iyengar@qlogic.com
Subject: [PATCH 0/4] qla2xxx: Patches for 2.6.39-rcx
Date: Fri,  6 May 2011 17:30:06 -0700
Message-ID: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32828 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753912Ab1EGAnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please apply these patches. Thanks.

Andrew Vasquez (1):
  qla2xxx: Properly set the dsd_list_len for dsd_chaining in cmd type
    6.

Arun Easi (2):
  qla2xxx: Fix hang during driver unload when vport is active.
  qla2xxx: Fix vport delete hang when logins are outstanding.

Saurav Kashyap (1):
  qla2xxx: Fix virtual port failing to login after chip reset.

 drivers/scsi/qla2xxx/qla_attr.c |    5 +++--
 drivers/scsi/qla2xxx/qla_fw.h   |    3 +--
 drivers/scsi/qla2xxx/qla_nx.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |   32 +++++++++++++++++++-------------
 4 files changed, 25 insertions(+), 19 deletions(-)

