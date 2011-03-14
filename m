From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 14/21] target: Fix FILEIO fd_buffered_io= token typo
Date: Mon, 14 Mar 2011 04:06:08 -0700
Message-ID: <1300100775-10012-15-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a token typo for the TCM/FILEIO match_table_t used
for toggling O_SYNC usage for individual struct file backend access.

Reported-by: Christophe Fergeau <cfergeau@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ae2bf71..b10db0c 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -515,7 +515,7 @@ enum {
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
-	{Opt_fd_buffered_io, "fd_buffered_id=%d"},
+	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
-- 
1.7.4.1
