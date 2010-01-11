From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 0/2] bfa: Debugfs support for Brocade HBA driver.
Date: Mon, 11 Jan 2010 15:55:47 -0800
Message-ID: <1263254147-18396-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:11934 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0ALAA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2010 19:00:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, xmzhang@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

Hi James,

The following patch set supports the creation of BFA debugfs node through
which the Brocade HBA driver's debug information is exposed to the user space.

Please apply this patch after our previous patch on Nov 30 2009.

http://marc.info/?l=linux-scsi&m=125954507020239&w=2


Patch Set Details:

[PATCH 1/2]: Files to support BFA debugfs node creation, node query and node deletion.

[PATCH 2/2]: Changes to existing source repository to support BFA debugfs node operations.

 drivers/scsi/bfa/Makefile            |    2 +-
 drivers/scsi/bfa/bfad.c              |   53 ++++-
 drivers/scsi/bfa/bfad_debugfs.c      |  543 ++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_debugfs.h      |   56 ++++
 drivers/scsi/bfa/bfad_drv.h          |    9 +-
 drivers/scsi/bfa/include/bfa_dbcmd.h |   98 ++++++
 6 files changed, 758 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/bfa/bfad_debugfs.c
 create mode 100644 drivers/scsi/bfa/bfad_debugfs.h
 create mode 100644 drivers/scsi/bfa/include/bfa_dbcmd.h

Thanks in advance,

Krishna Chaitanya Gudipati.
