From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/11] lpfc 8.3.37: Update lpfc to revision 8.3.37
Date: Thu, 3 Jan 2013 15:42:55 -0500
Message-ID: <1357245775.2628.14.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:50061 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3ACUsl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:48:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.37

The patches for 8.3.37 contain:

- Provided support for change_queue_type method in scsi_host_template
- Fixed not properly handle ELS_REC received on the unsolicited receive queue
- Fixed exhausted retry for plogi to nameserver.
- Removed use of NOP mailboxes for interrupt verification in pci_probe_one_s4
- Fixed no-context ABTS received on unsolicited receive queue failed with BA_RJT
- Fix potential memory corruption bug
- Fixed processing stale ndlp state when the node is marked for deferred removal
- Provide support for FCoE protocol dual-chute (ULP) operation
- Fixed system crash due to SLI Port provisioning of invalid resource count
- Fixed infinite loop in lpfc_sli4_fcf_rr_next_index_get.
- Update lpfc version for 8.3.37 driver release


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





