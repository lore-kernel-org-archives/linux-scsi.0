From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 00/13] use setup_timer() helper function.
Date: Fri, 22 Sep 2017 15:21:32 +0530
Message-ID: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34074 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdIVJvz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:51:55 -0400
Received: by mail-pf0-f195.google.com with SMTP id g65so270027pfe.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:51:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

This series uses setup_timer() helper function. The series
addresses the files under drivers/scsi/*.

Allen Pais (13):
  scsi: sym53c8xx: use setup_timer() helper.
  scsi: qla2xxx: use setup_timer() helper.
  scsi: esas2r: use setup_timer() helper.
  scsi: bnx2i: use setup_timer() helper.
  scsi: arcmsr: use setup_timer() helper.
  scsi: be2iscsi: use setup_timer() helper.
  scsi: qla4xxx: use setup_timer() helper.
  scsi: ncr53c8xx: use setup_timer() helper.
  scsi: arm: fas216: use setup_timer() helper.
  scsi: libiscsi: use setup_timer() helper.
  scsi: dc395x: use setup_timer() helper.
  scsi: qla2xxx: use setup_timer() helper.
  scsi: bfa: use setup_timer() helper.

 drivers/scsi/arcmsr/arcmsr_hba.c    | 10 ++++------
 drivers/scsi/arm/fas216.c           |  4 +---
 drivers/scsi/be2iscsi/be_main.c     |  5 ++---
 drivers/scsi/bfa/bfad.c             |  4 +---
 drivers/scsi/bnx2i/bnx2i_iscsi.c    | 14 +++++---------
 drivers/scsi/dc395x.c               |  4 +---
 drivers/scsi/esas2r/esas2r_main.c   |  4 +---
 drivers/scsi/libiscsi.c             |  5 ++---
 drivers/scsi/ncr53c8xx.c            |  4 +---
 drivers/scsi/qla2xxx/qla_inline.h   |  5 ++---
 drivers/scsi/qla2xxx/qla_os.c       |  5 ++---
 drivers/scsi/qla4xxx/ql4_os.c       |  5 ++---
 drivers/scsi/sym53c8xx_2/sym_glue.c |  4 +---
 13 files changed, 25 insertions(+), 48 deletions(-)

-- 
2.7.4
