From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Pull Request for 3.10-rc (FCoE)
Date: Tue, 21 May 2013 17:45:13 +0000
Message-ID: <519BB2A8.5090504@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65360 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab3EURpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 May 2013 13:45:15 -0400
Content-Language: en-US
Content-ID: <6FF7CBB5B3891E4AA75DCD28A1A5CC26@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

   Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe.git 
tags/for-3.10-rc

for you to fetch changes up to f4aaea6d5106f6092a80a648b5a12d31b6cb3335:

   MAINTAINERS: Fix fcoe mailing list (2013-05-10 10:19:25 -0700)

----------------------------------------------------------------
3.10 fixes

----------------------------------------------------------------
Krishna Mohan (1):
       libfcoe: Fix Conflicting FCFs issue in the fabric

Mark Rustad (1):
       libfc: Correct check for initiator role

Neil Horman (2):
       libfc: extend ex_lock to protect all of fc_seq_send
       MAINTAINERS: Fix fcoe mailing list

  MAINTAINERS                   |    2 +-
  drivers/scsi/fcoe/fcoe_ctlr.c |   15 +++++----------
  drivers/scsi/libfc/fc_exch.c  |   37 ++++++++++++++++++++++++-------------
  drivers/scsi/libfc/fc_rport.c |    2 +-
  4 files changed, 31 insertions(+), 25 deletions(-)

