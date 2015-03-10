From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] scsi: storvsc: Increase the tablesize based on host's
 capabilities
Date: Mon,  9 Mar 2015 20:42:21 -0700
Message-ID: <1425958941-23374-1-git-send-email-kys@microsoft.com>
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
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com
List-Id: linux-scsi@vger.kernel.org

Presently, storvsc limits the I/O size arbitrarily. Make this configurable
based on what the host advertises.

K. Y. Srinivasan (3):
  scsi: storvsc: Retrieve information about the capability of the
    target
  scsi: storvsc: Set the tablesize based on the information given by
    the host
  scsi: storvsc: Enable clustering

 drivers/scsi/storvsc_drv.c |   78 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 62 insertions(+), 16 deletions(-)

-- 
1.7.4.1
