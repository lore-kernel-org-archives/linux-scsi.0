From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/21] lpfc 8.3.33: Update lpfc to revision 8.3.33
Date: Fri, 3 Aug 2012 12:32:28 -0400
Message-ID: <1344011548.6110.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44769 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2HCQce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:32:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.33

The patches for 8.3.33 contain:

- When doing loopback testing, set the diag valid bit
- Enable attachment to OCe14000 adapters 
- Fix bug with rrq_pool not being destroyed during driver removal.
- Fix error of not reiniting mbx cmd before reissue
- Check data transfer amount on write commands
- Fix scsi_eh escalation panic by checking the proper return status
- Fix error when remote port switches address
- Add debugfs interface to display SLI queue information
- Convert to no SCSI host lock in queuecommand
- Formally separate lpfc_sli_ring SLI-3 and SLI-4 variantions
- Misc changes to optimize critical path
- Parallelize SLI-4 Q distribution
- Add Interrupts per second stats via debugfs
- Tie parallel I/O queues into separate MSIX vectors
- Allow per-hba interrupt rate tuning
- Change Naming convention for SLI4 Interrupt vector
- Make I/O to hw queue distribution algorithm a module parameter
- Add lpfc_fcp_look_ahead module parameter
- Fixed debugfs queInfo to include queue stats
- Fixed incomplete list of SLI4 commands with extended timeout value
- Update lpfc version for 8.3.33 driver release


The patches were cut against scsi.git, branch "misc"

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





