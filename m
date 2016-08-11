From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 00/14] lpfc: Update driver to version 11.2.0.2
Date: Thu, 11 Aug 2016 11:35:47 -0700
Message-ID: <57acc583.bvyPEYW7hH0ghiab%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:36461 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbcHKSfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:51 -0400
Received: by mail-qt0-f169.google.com with SMTP id 52so2101389qtq.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:50 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id c26sm2242783qte.1.2016.08.11.11.35.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.2.0.00

The patches were cut against scsi-misc

James Smart (14):
  Double WQ element count to keep iops up
  Fix sg_reset on SCSI device causing kernel crash
  Set driver environment data on adapter
  Make lpfc_prot_mask and lpfc_prot_guard per hba parameters
  Code clean up for lpfc_iocb_cnt parameter
  Code cleanup for lpfc_enable_rrq parameter
  Code cleanup for lpfc_aer_support parameter
  Code cleanup for lpfc_topology parameter
  Code cleanup for lpfc_max_scsicmpl_time parameter
  Code cleanup for lpfc_sriov_nr_virtfn parameter
  Fix crash on adapter reinit
  Revise strings with full lpfc parameter name
  Fix lost target in pt-to-pt connect
  lpfc version change to 11.2.0.2

 drivers/scsi/lpfc/lpfc.h         |   2 +
 drivers/scsi/lpfc/lpfc_attr.c    | 153 ++++++++++-----------------------------
 drivers/scsi/lpfc/lpfc_crtn.h    |   2 -
 drivers/scsi/lpfc/lpfc_els.c     |   2 +-
 drivers/scsi/lpfc/lpfc_hw4.h     |  12 +++
 drivers/scsi/lpfc/lpfc_init.c    |  30 ++++----
 drivers/scsi/lpfc/lpfc_mem.c     |   6 +-
 drivers/scsi/lpfc/lpfc_scsi.c    |  18 +++--
 drivers/scsi/lpfc/lpfc_sli.c     |  29 ++++++++
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 10 files changed, 116 insertions(+), 140 deletions(-)

-- 
2.5.0

