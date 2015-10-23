From: Punit Vara <punitvara@gmail.com>
Subject: [PATCH 0/2] Fix warning by coccicheck
Date: Sat, 24 Oct 2015 01:33:51 +0530
Message-ID: <1445630633-14209-1-git-send-email-punitvara@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Punit Vara (2):
  scsi: lpfc: Use kzalloc instead of kmalloc
  scsi: remove useless casting value returned by kmalloc to structure

 drivers/scsi/hpsa.c          | 3 +--
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.5.3
