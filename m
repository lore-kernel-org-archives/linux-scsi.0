From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 03/32] target: Allocate more room for port default groups
Date: Fri, 13 Dec 2013 15:58:51 -0800
Message-ID: <1386979160-6928-4-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

See target_stat_setup_port_default_groups, we need a 4 element array.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_fabric_configfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index dae2ad6..fdadc4d 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -906,7 +906,7 @@ static struct config_group *target_fabric_make_lun(
 	lun_cg->default_groups[1] = NULL;
 
 	port_stat_grp = &lun->port_stat_grps.stat_group;
-	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 3,
+	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 4,
 				GFP_KERNEL);
 	if (!port_stat_grp->default_groups) {
 		pr_err("Unable to allocate port_stat_grp->default_groups\n");
-- 
1.7.1
