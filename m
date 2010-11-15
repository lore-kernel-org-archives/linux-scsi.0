From: Joe Perches <joe@perches.com>
Subject: [PATCH 23/44] drivers/scsi/bfa: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:42 -0800
Message-ID: <71d0d7db4197f7b6f6b946a295648dc18bd559e0.1289789605.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 377cbff..55b3f74 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1683,7 +1683,7 @@ bfa_fcs_lport_fdmi_build_rhba_pyld(struct bfa_fcs_lport_fdmi_s *fdmi, u8 *pyld)
 	memcpy(attr->value, fcs_hba_attr->driver_version, attr->len);
 	attr->len = fc_roundup(attr->len, sizeof(u32));
 	curr_ptr += sizeof(attr->type) + sizeof(attr->len) + attr->len;
-	len += attr->len;;
+	len += attr->len;
 	count++;
 	attr->len = cpu_to_be16(attr->len + sizeof(attr->type) +
 			     sizeof(attr->len));
-- 
1.7.3.1.g432b3.dirty
