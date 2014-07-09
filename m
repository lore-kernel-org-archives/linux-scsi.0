From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/8] Drivers: scsi: storvsc: Bug fixes and improvements
Date: Tue,  8 Jul 2014 17:46:29 -0700
Message-ID: <1404866789-26910-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In this patch set I have fixed a few bugs and implemented some enhancements.


K. Y. Srinivasan (8):
  Drivers: scsi: storvsc: Change the limits to reflect the values on
    the host
  Drivers: scsi: storvsc: Filter commands based on the storage protocol
    version
  Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
  Drivers: scsi: storvsc: Filter WRITE_SAME_16
  Drivers: scsi: storvsc: Fix a bug in the handling of SRB status flags
  Drivers: scsi: storvsc: Implement an abort handler
  drivers: scsi: storvsc: Set srb_flags in all cases
  drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

 drivers/scsi/storvsc_drv.c |  125 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 93 insertions(+), 32 deletions(-)

-- 
1.7.4.1
