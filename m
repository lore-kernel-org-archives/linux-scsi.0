From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND V2 0/7] scsi: storvsc: Some miscellaneous cleanup
Date: Thu, 13 Aug 2015 08:43:29 -0700
Message-ID: <1439480609-11099-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

Cleanup version handling as well as base feature detection on storage
version as opposed to host version.

In this version, I have addressed comments from Dan Carpenter.

K. Y. Srinivasan (1):
  scsi: storvsc: Set the error code correctly in failure conditions

Keith Mange (6):
  scsi: storvsc: Rather than look for sets of specific protocol
    versions, make decisions based on ranges.
  scsi: storvsc: Use a single value to track protocol versions
  scsi: storvsc: Untangle the storage protocol negotiation from the
    vmbus protocol negotiation.
  scsi: storvsc: use correct defaults for values determined by protocol
    negotiation
  scsi: storvsc: use storage protocol version to determine storage
    capabilities
  scsi: storvsc: Allow write_same when host is windows 10

 drivers/scsi/storvsc_drv.c |  206 ++++++++++++++++++++++++++++----------------
 1 files changed, 132 insertions(+), 74 deletions(-)

-- 
1.7.4.1
