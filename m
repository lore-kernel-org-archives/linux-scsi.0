From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/8] lpfc 8.3.45: Update lpfc to revision 8.3.45
Date: Thu, 20 Feb 2014 09:56:11 -0500
Message-ID: <1392908171.31081.12.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:8731 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaBTO4O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 09:56:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.45

The patches for 8.3.45 contain:

- Added dport mailbox pass through support.
- Incorporated support of a low-latency io path
- Incorporate changes to use reason in change_queue_depth function.
- Fix sysfs buffer overrun in read of lpfc_fcp_cpu_map for 128 CPUs.
- Fixed missing initialization for task management IOCBs
- Fixed driver error messages after firmware download
- Fixed crash during driver unload.
- Update lpfc version to driver version 8.3.45


The patches were cut against scsi.git, branch "misc" with the
prior lpfc 8.3.44 patchset applied.

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





