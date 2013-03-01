From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/11] lpfc 8.3.38: Update lpfc to revision 8.3.38
Date: Fri, 1 Mar 2013 16:34:59 -0500
Message-ID: <1362173699.8283.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41627 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3CAVg1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:36:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.38

The patches for 8.3.38 contain:

- Fixed NMI watch dog panic's when resetting the hba.
- Fixed degraded performance after cable pulls
- Fixed bsg timeout handling issues that would result in crashes
- Fixed deadlock condition in FCF round robin handling
- Fixed async FCF modified event to in-use FCF failure to trigger recovery
- Fixed OXID reuse issue.
- Fixed PT2PT bring up problem for FC SLI4.
- Fixed circular locking dependency and inconsistent lock state issues
- Fix default value for lpfc_enable_rrq.
- Fixed potential mis-interpretation of READ_TOPOLOGY reserved fields
- Update lpfc version for 8.3.38 driver release


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





