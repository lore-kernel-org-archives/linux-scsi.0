From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH target] nvme_of: nvme_of_fabric_configfs can be static
Date: Wed, 7 Jan 2015 03:35:56 +0800
Message-ID: <20150106193556.GA50610@snb>
References: <201501070334.EgwC5iey%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201501070334.EgwC5iey%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 nvme_of_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/nvme_of/nvme_of_configfs.c b/drivers/target/nvme_of/nvme_of_configfs.c
index c34603c..43a3abc1 100644
--- a/drivers/target/nvme_of/nvme_of_configfs.c
+++ b/drivers/target/nvme_of/nvme_of_configfs.c
@@ -22,7 +22,7 @@
 #include "nvme_of_fabric.h"
 
 /* Local pointer to allocated TCM configfs fabric module */
-struct target_fabric_configfs *nvme_of_fabric_configfs;
+static struct target_fabric_configfs *nvme_of_fabric_configfs;
 
 static struct se_node_acl *nvme_of_make_nodeacl(
 	struct se_portal_group *se_tpg,
