From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH hch-scsi-queue] megaraid_sas:
 megasas_complete_outstanding_ioctls() can be static
Date: Fri, 9 Jan 2015 23:54:30 +0800
Message-ID: <20150109155430.GA124315@lkp-sb04>
References: <201501092322.aenpxV0o%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201501092322.aenpxV0o%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>
Cc: kbuild-all@01.org, Christoph Hellwig <hch@lst.de>, Sumit Saxena <sumit.saxena@avagotech.com>, Chaitra Basappa <chaitra.basappa@avagotech.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'megasas_complete_outstanding_ioctls' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d4e9c4e..031921e7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1698,7 +1698,7 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 * @instance:				Adapter soft state
 *
 */
-void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
+static void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
 {
 	int i;
 	struct megasas_cmd *cmd_mfi;
