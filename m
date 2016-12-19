From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 00/11] lpfc: Update driver to version 11.2.0.4
Date: Mon, 19 Dec 2016 14:35:22 -0800
Message-ID: <585860aa.qbce3rpiDS7g3FJW%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:49927 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933056AbcLSWf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:35:28 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 9091A2803ED
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.2.0.4

The patches were cut against 12/17 scsi.git tree, misc branch

-- james


James Smart (11):
  Clear the VendorVersion in the PLOGI/PLOGI ACC payload
  Correct error in setting OS Driver Version with FW
  Deprecate lpfc_soft_wwn parameter
  Correct issue leading to opps during link reset
  Correct host name in symbolic_name field
  FCoE VPort enable-disable does not bring up the VPort
  Fix Xlane dynamic LUN set for LUN priority.
  Deprecate lpfc_prot_sg_seg_cnt parameter
  Correct oops on vport port resets
  Add missing memory barrier
  lpfc version change to 11.2.0.4

 drivers/scsi/lpfc/lpfc.h         |   5 -
 drivers/scsi/lpfc/lpfc_attr.c    | 266 +++++----------------------------------
 drivers/scsi/lpfc/lpfc_crtn.h    |   7 +-
 drivers/scsi/lpfc/lpfc_els.c     |   6 +
 drivers/scsi/lpfc/lpfc_hw.h      |   6 +
 drivers/scsi/lpfc/lpfc_init.c    |  16 +--
 drivers/scsi/lpfc/lpfc_scsi.c    |  18 ++-
 drivers/scsi/lpfc/lpfc_sli.c     |  12 +-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c   |   8 ++
 10 files changed, 80 insertions(+), 266 deletions(-)

-- 
2.5.0


