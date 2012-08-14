From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/12] lpfc 8.3.34: Update lpfc to revision 8.3.34
Date: Tue, 14 Aug 2012 14:25:12 -0400
Message-ID: <1344968712.4432.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:26686 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2HNSZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:25:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.34

The patches for 8.3.34 contain:

- Add LOGO support after ABTS compliance
- Add SLI-4 V1 Capacity and Resource Descriptor support
- Fix number of IO channels to match CPUs
- Fix parameter field in CQE to mask for LOCAL_REJECT status
- Simplify BlockGuard lpfc_printf_vlog messages
- Correct typecasts for snprintf messages
- Streamline fcp underrun message printing
- Add XRI to abort handler timeout log message
- Adjust IO Channels to 1 when INTx
- Correct lock handling to eliminate reset escalation on I/O abort
- Fixed leaking memory from pci dma pool
- Update lpfc version for 8.3.34 driver release


The patches were cut against scsi.git, branch "misc", and with the
prior 8.3.33 patche set applied.

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





