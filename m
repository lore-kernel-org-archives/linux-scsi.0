From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 0/9] lpfc: Update to revision 11.1.0.0
Date: Thu, 31 Mar 2016 14:12:26 -0700
Message-ID: <56fd92ba.q8o0e/zYqq77h4PH%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36581 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907AbcCaVMa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 17:12:30 -0400
Received: by mail-pa0-f43.google.com with SMTP id tt10so74174709pab.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2016 14:12:30 -0700 (PDT)
Received: from flash (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id 17sm15520212pfs.40.2016.03.31.14.12.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Mar 2016 14:12:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.1.0.00

The patches were cut against scsi-misc

James Smart (9):
  Correct LOGO handling during login
  Fix DMA faults observed upon plugging loopback connector
  Fix crash when unregistering default rpi.
  Utilize embedded CDB logic to minimize IO latency
  Fix Device discovery failures during switch reboot test.
  Add support for SmartSAN 2.0
  Fix interaction between fdmi_on and enable_SmartSAN
  Update modified file copyrights
  Update driver version to 11.1.0.0

 drivers/scsi/lpfc/lpfc.h           |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  26 ++----
 drivers/scsi/lpfc/lpfc_ct.c        |   6 +-
 drivers/scsi/lpfc/lpfc_els.c       | 176 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   5 +-
 drivers/scsi/lpfc/lpfc_hw.h        |  75 ++++++++++++++--
 drivers/scsi/lpfc/lpfc_hw4.h       |  29 +++++-
 drivers/scsi/lpfc/lpfc_init.c      |  27 ++++--
 drivers/scsi/lpfc/lpfc_mbox.c      |  12 +--
 drivers/scsi/lpfc/lpfc_nportdisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 131 +++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   5 +-
 13 files changed, 430 insertions(+), 76 deletions(-)

-- 
2.5.0

