From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH-v0 0/2] These patches were missed in the last update.
Date: Fri, 21 Apr 2017 11:42:24 -0700
Message-ID: <1492800146-24218-1-git-send-email-dick.kennedy@broadcom.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vreg.kernel.org
Cc: martin.petersen@orcale.com, jthumshirn@suse.de, emilne@redhat.com, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

The two patches included in the update should have been part of the 
11.2.0.12 update that was sent yesterday. They are both critical
fixes.
The Panic on BFS has been seen in the field on PPC systems.
The memory coruption is seen when using the cli to start NVME-I.

The patches were cut against the linux-block tree, for-4.12/block branch
with the 11.2.0.12 patch set applied, and are intended to be pulled in
through that tree rather than the scsi trees.

Dick Kennedy (2):
  Fix panic on BFS configuration.
  Fix memory corruption of the lpfc_ncmd->list pointers

 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c |  7 +++++++
 drivers/scsi/lpfc/lpfc_nvme.c | 17 +++++++++++------
 drivers/scsi/lpfc/lpfc_nvme.h |  4 ++++
 drivers/scsi/lpfc/lpfc_sli.c  |  2 +-
 5 files changed, 24 insertions(+), 7 deletions(-)

-- 
2.1.0
