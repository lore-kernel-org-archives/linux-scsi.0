From: kys@exchange.microsoft.com
Subject: [PATCH 0/6] storvsc: Miscellaneous fixes and enhancements
Date: Wed, 14 Dec 2016 18:45:28 -0800
Message-ID: <1481769928-2026-1-git-send-email-kys@exchange.microsoft.com>
Reply-To: kys@microsoft.com
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
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

From: K. Y. Srinivasan <kys@microsoft.com>

Miscellaneous fixes and enhancements.

K. Y. Srinivasan (3):
  storvsc: Enable tracking of queue depth
  storvsc: Remove the restriction on max segment size
  storvsc: Enable multi-queue support

Long Li (3):
  storvsc: use tagged SRB requests if supported by the device
  storvsc: properly handle SRB_ERROR when sense message is present
  storvsc: properly set residual data length on errors

 drivers/scsi/storvsc_drv.c |  148 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 140 insertions(+), 8 deletions(-)

-- 
1.7.4.1
