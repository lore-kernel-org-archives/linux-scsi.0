From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH mkp-scsi] scsi: libsas: sas_destruct_ports() can be static
Date: Tue, 9 Jan 2018 15:51:58 +0800
Message-ID: <20180109075158.GA143587@lkp-ib03>
References: <201801091521.r3DztdJM%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201801091521.r3DztdJM%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Yijing Wang <wangyijing@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Fixes: 99cfdc04c12e ("scsi: libsas: direct call probe and destruct")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 sas_discover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 190108e..e4fd078 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -361,7 +361,7 @@ void sas_destruct_devices(struct asd_sas_port *port)
 	}
 }
 
-void sas_destruct_ports(struct asd_sas_port *port)
+static void sas_destruct_ports(struct asd_sas_port *port)
 {
 	struct sas_port *sas_port, *p;
 
