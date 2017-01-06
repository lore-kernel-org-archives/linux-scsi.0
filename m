From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/4] cxlflash: Enhancements, cleanup and fixes
Date: Fri,  6 Jan 2017 08:02:59 -0600
Message-ID: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

This patch series includes an enhancement to support a new command queuing
model and also cleans up prints throughout the driver. The last patch in
the series fixes a racing issue.

The series is based upon v4.10-rc2, intended for 4.11 and is bisectable.

Matthew R. Ochs (3):
  cxlflash: Refactor context reset to share reset logic
  cxlflash: Support SQ Command Mode
  cxlflash: Cleanup prints

Uma Krishnan (1):
  cxlflash: Cancel scheduled workers before stopping AFU

 drivers/scsi/cxlflash/common.h     |  32 ++-
 drivers/scsi/cxlflash/lunmgt.c     |  31 +--
 drivers/scsi/cxlflash/main.c       | 465 +++++++++++++++++++++----------------
 drivers/scsi/cxlflash/sislite.h    |  19 +-
 drivers/scsi/cxlflash/superpipe.c  | 183 ++++++++-------
 drivers/scsi/cxlflash/vlun.c       | 169 +++++++-------
 include/uapi/scsi/cxlflash_ioctl.h |   1 +
 7 files changed, 518 insertions(+), 382 deletions(-)

-- 
2.1.0
