From: mchristi@redhat.com
Subject: [PATCH 01/32] block/fs: add REQ_OP definitions.
Date: Wed,  4 Nov 2015 10:32:56 -0600
Message-ID: <1446654807-6935-2-git-send-email-mchristi@redhat.com>
References: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch adds definitions for request/bio operations which
will be used in the next patches.

In the initial patches the REQ_OPs match the REQ ones for compat reasons
while all the code is converted in this set. In the last patches
that will be removed.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 include/linux/blk_types.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e813013..d7b6009 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -244,4 +244,11 @@ enum rq_flag_bits {
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
 #define REQ_NO_TIMEOUT		(1ULL << __REQ_NO_TIMEOUT)
 
+enum req_op {
+	REQ_OP_READ,
+	REQ_OP_WRITE		= REQ_WRITE,
+	REQ_OP_DISCARD		= REQ_DISCARD,
+	REQ_OP_WRITE_SAME	= REQ_WRITE_SAME,
+};
+
 #endif /* __LINUX_BLK_TYPES_H */
-- 
1.8.3.1
