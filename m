From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] iscsit_wait_for_tag() can be static
Date: Wed, 16 May 2018 20:47:21 +0800
Message-ID: <20180516124721.GA27100@ivb43.lkp.intel.com>
References: <20180515160043.27044-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, kbuild-all@01.org, qla2xxx-upstream@qlogic.com, linux1394-devel@lists.sourceforge.net, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Fixes: 5aff7a710f13 ("Convert target drivers to use sbitmap")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 iscsi_target_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 28bcffa..e147aef 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -147,7 +147,7 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->r2t_lock);
 }
 
-int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
+static int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
 {
 	int tag = -1;
 	DEFINE_WAIT(wait);

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
