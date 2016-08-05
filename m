From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.7+ merge window
Date: Fri, 05 Aug 2016 16:21:01 -0700
Message-ID: <1470439261.2337.63.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is seven basic fixes (plus one MAINTAINERS update) which came in
close to the merge window.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Brian King (1):
      ipr: Wait to do async scan until scsi host is initialized

Hannes Reinecke (1):
      fcoe: Use default VLAN for FIP VLAN discovery

Johannes Thumshirn (1):
      lpfc: Fix possible NULL pointer dereference

Mauricio Faria de Oliveira (1):
      lpfc: fix oops in lpfc_sli4_scmd_to_wqidx_distr() from lpfc_send_taskmgmt()

Uma Krishnan (2):
      MAINTAINERS: Update cxlflash maintainers
      cxlflash: Verify problem state area is mapped before notifying shutdown

Wei Yongjun (2):
      ipr: Fix error return code in ipr_probe_ioa()
      fcoe: add missing destroy_workqueue() on error in fcoe_init()

And the diffstat:

 MAINTAINERS                   |  1 +
 drivers/scsi/cxlflash/main.c  | 10 ++++++++-
 drivers/scsi/fcoe/fcoe.c      | 52 +++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/fcoe/fcoe.h      |  1 +
 drivers/scsi/ipr.c            | 10 +++++++++
 drivers/scsi/ipr.h            |  1 +
 drivers/scsi/lpfc/lpfc_scsi.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 15 +++++--------
 8 files changed, 79 insertions(+), 13 deletions(-)

James
