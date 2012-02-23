From: Spencer Krum <nibz@cat.pdx.edu>
Subject: [PATCH] Changed alocate to allocate in Documentation/target/tcm_mod_builder.py
Date: Thu, 23 Feb 2012 15:50:39 -0800
Message-ID: <1330041039-26284-1-git-send-email-nibz@cat.pdx.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from expn.cat.pdx.edu ([131.252.208.110]:39794 "EHLO
	expn.cat.pdx.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2BWX6e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2012 18:58:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, rdunlap@xenotime.net
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, nibz@cat.pdx.edu, MostAwesomeDude@gmail.com, Spencer O Krum <krum.spencer@gmail.com>

From: Spencer O Krum <krum.spencer@gmail.com>

Signed-off-by: Spencer Krum <nibz@cat.pdx.edu>
---
 Documentation/target/tcm_mod_builder.py |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 6e21b8b..a78879b 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -775,7 +775,7 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 			buf += "	struct " + fabric_mod_name + "_nacl *nacl;\n\n"
 			buf += "	nacl = kzalloc(sizeof(struct " + fabric_mod_name + "_nacl), GFP_KERNEL);\n"
 			buf += "	if (!nacl) {\n"
-			buf += "		printk(KERN_ERR \"Unable to alocate struct " + fabric_mod_name + "_nacl\\n\");\n"
+			buf += "		printk(KERN_ERR \"Unable to allocate struct " + fabric_mod_name + "_nacl\\n\");\n"
 			buf += "		return NULL;\n"
 			buf += "	}\n\n"
 			buf += "	return &nacl->se_node_acl;\n"
-- 
1.7.4.1

