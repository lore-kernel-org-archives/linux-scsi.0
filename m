From: <kgudipat@brocade.com>
Subject: [PATCH 0/3] bfa: Modify LUN masking feature implementation, bug fixes.
Date: Tue, 20 Dec 2011 18:54:21 -0800
Message-ID: <1324436061-17084-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:47487 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719Ab1LUD2g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 22:28:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch-set includes a bug fix and modifies BFA LUN Masking

feature implementation to use SCSI slave callouts rather than modifying SCSI commands

response payload, based on the review comments received.

	I have compiled & tested the code against your scsi-misc and linux-next.

Thanks,
Krishna C Gudipati.

Krishna Gudipati (3):
  bfa: Fix possible NULL pointer dereference in lunmask add/delete.
  bfa: Revert back the current LUN Masking Implementation.
  bfa: Implement LUN Masking feature using the SCSI Slave Callouts.

 drivers/scsi/bfa/bfa_defs_svc.h |    7 +-
 drivers/scsi/bfa/bfa_fc.h       |  155 ---------------
 drivers/scsi/bfa/bfa_fcpim.c    |  416 +--------------------------------------
 drivers/scsi/bfa/bfa_fcpim.h    |    7 -
 drivers/scsi/bfa/bfa_svc.h      |    5 -
 drivers/scsi/bfa/bfad.c         |    2 +
 drivers/scsi/bfa/bfad_attr.c    |    2 +-
 drivers/scsi/bfa/bfad_bsg.c     |   27 +++-
 drivers/scsi/bfa/bfad_drv.h     |    2 +
 drivers/scsi/bfa/bfad_im.c      |   56 ++++++
 drivers/scsi/bfa/bfad_im.h      |   27 +++
 11 files changed, 118 insertions(+), 588 deletions(-)

-- 
1.7.3.rc1

