From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/22] lpfc 8.3.39: Update lpfc to revision 8.3.39
Date: Wed, 17 Apr 2013 20:14:22 -0400
Message-ID: <1366244062.1513.0.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15632 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934878Ab3DRAOZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:14:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 8.3.39

The patches for 8.3.39 contain:

- 
- Fixed VPI allocation issues after firmware dump is performed
- Fixed BlockGuard error reporting
- Remove driver dependency on HZ
- Fixed pt2pt and loop discovery problems on topology changes.
- Fix driver issues with large lpfc_sg_seg_cnt values
- Fix driver issues with large s/g lists for BlockGuard
- Doorbell formation information logged in dual-chute mode WQ and RQ setup
- Fix driver issues with SCSI Host reset
- Fix lpfc_fcp_look_ahead module parameter
- Fixed crash when processing bsg's sg list with high memory pages
- Reduced spinlock contention on SCSI buffer list
- Fixed BlockGuard to take advantage of rdprotect/wrprotect info when available
- Fixed deadlock between hbalock and nlp_lock use.
- Fixed bad book keeping in posting els sgls to port
- Fixed not returning FAILED status when SCSI invoking host reset handler
  failed
- Fixed system panic during EEH recovery due to midlayer acting on
  outstanding I/O
- Fixed iocb flags not being reset for scsi commands.
- Fixed driver vector mapping to CPU affinity
- Add log message when completes with clean address bit set to zero
- Reduced tmo value set to FLOGI WQE for quick recovery from FLOGI sequence
  timeout
- Fixed driver handling of CLEAR_LA with NPIV enabled causing SID=0 frames out
- Update lpfc version for 8.3.39 driver release


The patches were cut against scsi.git, branch "misc".

-- james s


Signed-off-by: James Smart <james.smart@emulex.com>





