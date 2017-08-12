From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 0/6] constify pci_error_handlers structures
Date: Sat, 12 Aug 2017 07:44:28 +0200
Message-ID: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These pci_error_handlers structures are only stored in the err_handler
field of a pci_driver structure, and this field is declared as const.  Thus
the pci_error_handlers structures can be const too.

Done with the help of Coccinelle.

---

 drivers/misc/genwqe/card_base.c      |    2 +-
 drivers/scsi/aacraid/linit.c         |    2 +-
 drivers/scsi/be2iscsi/be_main.c      |    2 +-
 drivers/scsi/bfa/bfad.c              |    2 +-
 drivers/scsi/csiostor/csio_init.c    |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)
