From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 39/41] block: remove the WRITE_BARRIER flag
Date: Fri,  3 Sep 2010 12:29:54 +0200
Message-ID: <1283509796-1510-40-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

It's unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/fs.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 352c486..d6add69 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -135,7 +135,6 @@ struct inodes_stat_t {
  *			immediately after submission. The write equivalent
  *			of READ_SYNC.
  * WRITE_ODIRECT_PLUG	Special case write for O_DIRECT only.
- * WRITE_BARRIER	DEPRECATED. Always fails. Use FLUSH/FUA instead.
  * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
  * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
  *			non-volatile media on completion.
@@ -157,8 +156,6 @@ struct inodes_stat_t {
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)
 #define WRITE_ODIRECT_PLUG	(WRITE | REQ_SYNC)
 #define WRITE_META		(WRITE | REQ_META)
-#define WRITE_BARRIER		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-				 REQ_HARDBARRIER)
 #define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_FLUSH)
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-- 
1.7.1
