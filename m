From: <kgudipat@brocade.com>
Subject: [PATCH 0/6] bfa: Update bfa driver to version 2.3.2.3
Date: Mon, 13 Dec 2010 16:15:33 -0800
Message-ID: <1292285733-5640-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:35598 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756947Ab0LNAQO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 19:16:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Hi James,

	The following patch set updates the Brocade BFA driver to v2.3.2.3.

	I have compiled & tested the code against your scsi-misc (2.6.37-rc5-0.7-default).

	Please note that these patches need to be applied after the patch-set submitted
	
	by Maggie Zhang.

	http://marc.info/?l=linux-scsi&m=129195103301803&w=2

Thanks,
Krishna C Gudipati.

Krishna Gudipati (6):
  bfa: IOC fwtrace save logic & state machine fixes.
  bfa: Store port configuration in flash for persistency.
  bfa: IOC auto recovery fix.
  bfa: direct attach mode fix.
  bfa: io tag handling and minor bug fix.
  bfa: Update the driver version to 2.3.2.3

 drivers/scsi/bfa/bfa_fcpim.c     |    8 +-
 drivers/scsi/bfa/bfa_fcpim.h     |   22 +-
 drivers/scsi/bfa/bfa_fcs.h       |    1 +
 drivers/scsi/bfa/bfa_fcs_lport.c |   11 +-
 drivers/scsi/bfa/bfa_ioc.c       |  427 +++++++++++++++++++++++++-------------
 drivers/scsi/bfa/bfa_ioc.h       |   19 ++-
 drivers/scsi/bfa/bfa_ioc_cb.c    |   95 ++++++++-
 drivers/scsi/bfa/bfa_ioc_ct.c    |  101 +++++++++-
 drivers/scsi/bfa/bfa_svc.c       |  124 +++++++++++-
 drivers/scsi/bfa/bfa_svc.h       |    2 +
 drivers/scsi/bfa/bfad_drv.h      |    2 +-
 drivers/scsi/bfa/bfad_im.c       |    2 +-
 drivers/scsi/bfa/bfi_cbreg.h     |    1 +
 drivers/scsi/bfa/bfi_ctreg.h     |   41 +++--
 drivers/scsi/bfa/bfi_ms.h        |   14 +-
 15 files changed, 683 insertions(+), 187 deletions(-)

-- 
1.7.3.rc1

