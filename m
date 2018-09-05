From: Randy Dunlap <rd.dunlab@gmail.com>
Subject: [PATCH v4 2/5] FireWire: clean up core-iso.c kernel-doc
Date: Tue,  4 Sep 2018 17:02:22 -0700
Message-ID: <20180905000225.10733-3-rd.dunlab@gmail.com>
References: <20180905000225.10733-1-rd.dunlab@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180905000225.10733-1-rd.dunlab@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
 <mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: Jonathan Corbet <corbet@lwn.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Clean up kernel-doc warnings in <drivers/firewire/core-iso.c> so that
it can be added to a Firewire/IEEE 1394 driver-api chapter
without adding lots of noisy warnings to the documentation build.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: linux-doc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/firewire/core-iso.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-next-20180904.orig/drivers/firewire/core-iso.c
+++ linux-next-20180904/drivers/firewire/core-iso.c
@@ -337,9 +337,16 @@ static void deallocate_channel(struct fw
 
 /**
  * fw_iso_resource_manage() - Allocate or deallocate a channel and/or bandwidth
+ * @card: card interface for this action
+ * @generation: bus generation
+ * @channels_mask: bitmask for channel allocation
+ * @channel: pointer for returning channel allocation result
+ * @bandwidth: pointer for returning bandwidth allocation result
+ * @allocate: whether to allocate (true) or deallocate (false)
  *
  * In parameters: card, generation, channels_mask, bandwidth, allocate
  * Out parameters: channel, bandwidth
+ *
  * This function blocks (sleeps) during communication with the IRM.
  *
  * Allocates or deallocates at most one channel out of channels_mask.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
