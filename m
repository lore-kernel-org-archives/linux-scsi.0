From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 0/2] storvsc: changes for scsi next
Date: Thu, 18 May 2017 09:18:10 -0700
Message-ID: <20170518161812.14124-1-sthemmin@microsoft.com>
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
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, kys@microsoft.com
Cc: devel@linuxdriverproject.org, Stephen Hemminger <sthemmin@microsoft.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

These are refactoring changes to the Hyper-V scsi driver.

Stephen Hemminger (2):
  storvsc: use in place iterator function
  storvsc: remove unnecessary channel inbound lock

 drivers/hv/channel_mgmt.c  |  1 -
 drivers/scsi/storvsc_drv.c | 52 ++++++++++++++++------------------------------
 include/linux/hyperv.h     |  1 -
 3 files changed, 18 insertions(+), 36 deletions(-)

-- 
2.11.0
