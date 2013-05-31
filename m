From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/17] lpfc 8.3.40: Update lpfc to revision 8.3.40
Date: Fri, 31 May 2013 17:02:51 -0400
Message-ID: <1370034171.17258.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:21339 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3EaVJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:09:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.40

The patches for 8.3.40 contain:

- Fix lpfc_used_cpu to be more dynamic
- Fixed crash during FCoE failover testing.
- Fix BlockGuard error checking
- Fixed system panic during handling unsolicited receive buffer error condition
- Fix inconsistent list removal causes crash.
- Fix starting reference tag when calculating BG error
- Fixed list corruption when lpfc_drain_tx runs.
- Fixed some logging message fields
- Fixed a missing return code in a logging message
- Fix to allow OCM to report FEC status
- Clarified the behavior of the lpfc_max_luns module parameter
- Fixed FCoE connection list vlan identifier and add FCF list debug
- Fixed system panic due to unsafe walking and deleting linked list
- Fixed issue mailbox wait routine failed to issue dump memory mbox command
- Fixed a race condition between SLI host and port failed FCF rediscovery
- Update Copyrights to 2013 for 8.3.38, 8.3.39, and 8.3.40 modifications
- Update lpfc version to driver version 8.3.40


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





