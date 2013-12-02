From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/7] lpfc 8.3.44: Update lpfc to revision 8.3.44
Date: Mon, 2 Dec 2013 12:48:07 -0500
Message-ID: <1386006487.11046.8.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:40814 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3LBRsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2013 12:48:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.44

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





