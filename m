From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH] scsi: ufs: dev_attr_ufs_provision can be static
Date: Sat, 9 Jun 2018 19:50:42 +0800
Message-ID: <20180609115042.GA149407@athens>
References: <1528455990-24572-4-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1528455990-24572-4-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, linux-scsi@vger.kernel.org, Sayali Lokhande <sayalil@codeaurora.org>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Adrian Hunter <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Fixes: 2f7e32b8cdc9 ("scsi: ufs: Add sysfs support for ufs provision")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 ufs-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 8b68813..36c28cc 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -264,7 +264,7 @@ static ssize_t ufs_provision_store(struct device *dev,
 	return ufshcd_desc_config_store(dev, attr, buf, count);
 }
 
-DEVICE_ATTR_RW(ufs_provision);
+static DEVICE_ATTR_RW(ufs_provision);
 
 static struct attribute *ufs_sysfs_config_descriptor[] = {
 	&dev_attr_ufs_provision.attr,
