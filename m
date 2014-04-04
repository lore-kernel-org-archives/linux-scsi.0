From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/11] lpfc 10.2.8000.0: Update lpfc to revision 10.2.8000.0
Date: Fri, 4 Apr 2014 13:51:12 -0400
Message-ID: <1396633872.1924.13.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:41567 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaDDRvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 13:51:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc to revision 10.2.8000.0

Note: we've revised our version number string...

This patch set updates the lpfc driver to revision 10.2.8000.0

The patches for 10.2.8000.0 contain:
- Fix dynamic transitions of FirstBurst from on to off
- Fix locking for lpfc_hba_down_post
- Fix locking for postbufq when freeing
- Fixed kernel panic in lpfc_abort_handler
- Fix SLI4 s abort loop to process all FCP rings and under ring_lock
- Fix FW dump using sysfs
- Convert runtime references to old xlane cfg param to fof cfg param
- Fixed locking for scsi task management commands.
- Update Copyright on changed files. 
- Update Copyright on changed files from 8.3.45 patches
- Update lpfc version to driver version 10.2.8000.0


The patches were cut against scsi.git, branch "misc" 

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





