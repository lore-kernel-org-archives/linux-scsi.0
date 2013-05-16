From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 6/7] Drivers: scsi: storvsc: Support FC devices
Date: Thu, 16 May 2013 05:21:18 -0700
Message-ID: <1368706879-32321-6-git-send-email-kys@microsoft.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1368706879-32321-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

Add support for synthetic Fiber Channel devices.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6bc4e3b..124cf0b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1698,6 +1698,7 @@ static struct scsi_host_template scsi_driver = {
 enum {
 	SCSI_GUID,
 	IDE_GUID,
+	SFC_GUID,
 };
 
 static const struct hv_vmbus_device_id id_table[] = {
@@ -1709,6 +1710,11 @@ static const struct hv_vmbus_device_id id_table[] = {
 	{ HV_IDE_GUID,
 	  .driver_data = IDE_GUID
 	},
+	/* Fiber Channel GUID */
+	{
+	  HV_SYNTHFC_GUID,
+	  .driver_data = SFC_GUID
+	},
 	{ },
 };
 
-- 
1.7.4.1
