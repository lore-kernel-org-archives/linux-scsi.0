From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/8] Drivers: scsi: storvsc: Bug fixes and improvements
Date: Wed,  9 Jul 2014 23:33:28 -0700
Message-ID: <1404974008-4984-1-git-send-email-kys@microsoft.com>
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
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In this patch set I have fixed a few bugs and implemented some enhancements.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

K. Y. Srinivasan (8):
  Drivers: scsi: storvsc: Change the limits to reflect the values on
    the host
  Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by
    the Host
  Drivers: scsi: storvsc: Filter commands based on the storage protocol
    version
  Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
  Drivers: scsi: storvsc: Fix a bug in the handling of SRB status flags
  Drivers: scsi: storvsc: Implement an abort handler
  drivers: scsi: storvsc: Set srb_flags in all cases
  drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

 drivers/scsi/storvsc_drv.c |  128 ++++++++++++++++++++++++++++++++------------
 1 files changed, 93 insertions(+), 35 deletions(-)

-- 
1.7.4.1
