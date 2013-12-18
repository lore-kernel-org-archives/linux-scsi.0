From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7 V2] lpfc 8.3.44: Update lpfc to revision 8.3.44
Date: Tue, 17 Dec 2013 20:28:43 -0500
Message-ID: <1387330123.1011.8.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41161 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LRB2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 20:28:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.44

This is Version 2- with a revised patch1 to address checkpatch warnings

The patches for 8.3.44 contain:

- Fixed IO hang when in msi mode.
- Fixed stopped FCF discovery on failed FCF record read. 
- Fix Crash in lpfc_els_timeout_handler
- Fix kernel panics from corrupted ndlp list.
- Fixed incorrect allocation of iDiags directories/files in debugfs
- Fixed unassigned variable in ELS timeout message
- Update lpfc version to driver version 8.3.44


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>




