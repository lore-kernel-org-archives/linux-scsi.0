From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/7] Miscellaneous patches and bug fixes
Date: Fri, 11 May 2018 14:04:00 -0500
Message-ID: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
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
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This patch series adds few improvements to the cxlflash driver and
it also contains couple of bug fixes.

This patch series is intended for 4.18 and is bisectable.

Matthew R. Ochs (1):
  cxlflash: Use local mutex for AFU serialization

Uma Krishnan (6):
  cxlflash: Yield to active send threads
  cxlflash: Limit the debug logs in the IO path
  cxlflash: Acquire semaphore before invoking ioctl services
  cxlflash: Add include guards to backend.h
  cxlflash: Abstract hardware dependent assignments
  cxlflash: Isolate external module dependencies

 drivers/scsi/cxlflash/Kconfig     |  2 +-
 drivers/scsi/cxlflash/Makefile    |  4 +++-
 drivers/scsi/cxlflash/backend.h   |  5 +++++
 drivers/scsi/cxlflash/common.h    |  1 +
 drivers/scsi/cxlflash/lunmgt.c    |  4 +++-
 drivers/scsi/cxlflash/main.c      | 21 +++++++++------------
 drivers/scsi/cxlflash/main.h      | 20 ++++++++++++++++++++
 drivers/scsi/cxlflash/superpipe.c |  9 ++++++++-
 drivers/scsi/cxlflash/vlun.c      |  3 ++-
 9 files changed, 52 insertions(+), 17 deletions(-)

-- 
2.1.0
