From: <kgudipat@brocade.com>
Subject: [PATCH 0/4] bfa: Driver bug fixes
Date: Mon, 9 Apr 2012 18:39:50 -0700
Message-ID: <1334021990-23931-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56818 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab2DJBkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Apr 2012 21:40:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch set includes the following BFA driver bug fixes:
		1) Fix to avoid crash during module unload if max vports are created.
		2) Fix to remove unsupported adapter models from model description.
		3) Fix to have the Logical port online / offline event logging in sync.
		4) Updates the MAINTAINERS file to add me to list too.

	I have compiled & tested the code against your scsi-misc and
	linux-next (3.4.0-rc1).

Thanks,
Krishna C Gudipati.

Krishna Gudipati (4):
  bfa: Fix to defer vport delete handler invocation till firmware logo
    response.
  bfa: sysfs model description fix.
  bfa: Fix bfa logging for Logical port state change notification
  bfa: Update the MAINTAINERS file.

 MAINTAINERS                      |    1 +
 drivers/scsi/bfa/bfa_fcs.h       |    3 ---
 drivers/scsi/bfa/bfa_fcs_lport.c |   32 +++++++++++++++++---------------
 drivers/scsi/bfa/bfad.c          |   17 -----------------
 drivers/scsi/bfa/bfad_attr.c     |   20 +++-----------------
 5 files changed, 21 insertions(+), 52 deletions(-)

-- 
1.7.3.rc1

