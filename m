From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/5] Drivers: scsi: storvsc: Support FC devices
Date: Mon,  3 Jun 2013 16:21:27 -0700
Message-ID: <1370301688-27286-4-git-send-email-kys@microsoft.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
 <1370301688-27286-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1370301688-27286-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add support for synthetic Fiber Channel devices.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index c89acf5..a728179 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1704,6 +1704,7 @@ static struct scsi_host_template scsi_driver = {
 enum {
 	SCSI_GUID,
 	IDE_GUID,
+	SFC_GUID,
 };
 
 static const struct hv_vmbus_device_id id_table[] = {
@@ -1715,6 +1716,11 @@ static const struct hv_vmbus_device_id id_table[] = {
 	{ HV_IDE_GUID,
 	  .driver_data = IDE_GUID
 	},
+	/* Fibre Channel GUID */
+	{
+	  HV_SYNTHFC_GUID,
+	  .driver_data = SFC_GUID
+	},
 	{ },
 };
 
-- 
1.7.4.1
