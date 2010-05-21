From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 0/2] bfa: Fix system crash and add sysfs debug support.
Date: Fri, 21 May 2010 14:33:10 -0700
Message-ID: <1274477590-2754-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:45447 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab0EUVzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2010 17:55:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, rvadivel@brocade.com, vravindr@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patchset fixes a system crash seen while reading sysfs fc_host statistics;

the fix is to initialize the port data structure during driver attach.

We also added sysfs support to obtain debug info from BFA, such as firmware trace, driver trace

and the capability to read/write to the registers.

	Can you please include these patches in your scsi-misc tree?


Krishna Gudipati (2):
  bfa: fix system crash when reading sysfs fc_host statistics
  bfa: Add sysfs support to obtain debug info.

 drivers/scsi/bfa/bfa_core.c  |   22 +++
 drivers/scsi/bfa/bfad.c      |   10 +
 drivers/scsi/bfa/bfad_attr.c |  387 +++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bfa/bfad_drv.h  |    8 +-
 4 files changed, 423 insertions(+), 4 deletions(-)

Thanks,
Krishna Chaitanya Gudipati.
