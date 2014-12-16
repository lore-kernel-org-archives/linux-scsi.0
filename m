From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/4] Drivers: scsi: storvsc: Fix miscellaneous issues
Date: Tue, 16 Dec 2014 13:21:20 -0800
Message-ID: <1418764880-11183-1-git-send-email-kys@microsoft.com>
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
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The first two patches in this series are a resend; these were submitted
some months ago and as far as I know, there were no outstanding issues.

Win8 and win8 r2 hosts do support SPC-3 features but claim SPC-2 compliance.
This issue is fixed here as well.

K. Y. Srinivasan (4):
  Drivers: scsi: storvsc: In responce to a scan event, scan the host
  Drivers: scsi: storvsc: Force discovery of LUNs that may have been
    removed.
  Drivers: scsi: storvsc: Fix a bug in storvsc limits
  Drivers: scsi: storvsc: Force SPC-3 compliance on win8 and win8 r2
    hosts

 drivers/scsi/storvsc_drv.c |   71 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 57 insertions(+), 14 deletions(-)

-- 
1.7.4.1
