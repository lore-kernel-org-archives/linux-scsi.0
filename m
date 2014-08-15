From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Final round of SCSI updates for the 3.16+ merge window
Date: Fri, 15 Aug 2014 12:38:55 -0700
Message-ID: <1408131535.11617.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Just a note, we do have a couple of bug fixes coming under separate
cover, but they don't have to be part of the merge window

This is a small set of updates which missed the first pull.  It's more
msix updates, some iscsi and qla4xxx fixes, we also have some string
null termination fixes a return value fix and a couple of pm8001
firmware fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alexander Gordeev (2):
      qla4xxx: Use pci_enable_msix_exact() instead of pci_enable_msix()
      pm8001: Use pci_enable_msix_exact() instead of pci_enable_msix()

Maurizio Lombardi (1):
      qla4xxx: check the return value of dma_alloc_coherent()

Mike Christie (5):
      iscsi class: Fix freeing of skb in get host error path
      libiscsi: return new error code when nop times out
      iscsi class: fix get_host_stats return code when not supported
      iscsi class: fix get_host_stats error handling
      qla4xxx: fix get_host_stats error propagation

Randy Dunlap (1):
      scsi: fix u14-34f printk format warnings

Rickard Strandqvist (2):
      scsi: qla4xxx: ql4_mbx.c: Cleaning up missing null-terminate in conjunction with strncpy
      scsi: qla4xxx: ql4_os.c: Cleaning up missing null-terminate in conjunction with strncpy

Suresh Thiagarajan (1):
      pm8001: Update MAINTAINERS list

Tomas Henzl (2):
      pm8001: fix pm8001_store_update_fw
      pm8001: Fix erratic calculation in update_flash

And the diffstat

 MAINTAINERS                         |   1 +
 drivers/scsi/libiscsi.c             |   2 +-
 drivers/scsi/pm8001/pm8001_ctl.c    | 144 ++++++++++++++++++------------------
 drivers/scsi/pm8001/pm8001_hwi.c    |   4 +-
 drivers/scsi/pm8001/pm8001_init.c   |  39 +++++-----
 drivers/scsi/qla4xxx/ql4_init.c     |   6 ++
 drivers/scsi/qla4xxx/ql4_mbx.c      |  14 ++--
 drivers/scsi/qla4xxx/ql4_nx.c       |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c       |  16 ++--
 drivers/scsi/scsi_transport_iscsi.c |   6 +-
 drivers/scsi/u14-34f.c              |   4 +-
 include/scsi/iscsi_if.h             |   1 +
 12 files changed, 125 insertions(+), 114 deletions(-)

James
