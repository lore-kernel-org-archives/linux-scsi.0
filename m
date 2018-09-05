From: Randy Dunlap <rd.dunlab@gmail.com>
Subject: [PATCH v4 3/5] FireWire: clean up core-transaction.c kernel-doc
Date: Tue,  4 Sep 2018 17:02:23 -0700
Message-ID: <20180905000225.10733-4-rd.dunlab@gmail.com>
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

Clean up kernel-doc warnings in <drivers/firewire/core-transaction.c>
so that it can be added to a Firewire/IEEE 1394 driver-api chapter
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
 drivers/firewire/core-transaction.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- linux-next-20180904.orig/drivers/firewire/core-transaction.c
+++ linux-next-20180904/drivers/firewire/core-transaction.c
@@ -410,6 +410,14 @@ static void transaction_callback(struct
 
 /**
  * fw_run_transaction() - send request and sleep until transaction is completed
+ * @card:		card interface for this request
+ * @tcode:		transaction code
+ * @destination_id:	destination node ID, consisting of bus_ID and phy_ID
+ * @generation:		bus generation in which request and response are valid
+ * @speed:		transmission speed
+ * @offset:		48bit wide offset into destination's address space
+ * @payload:		data payload for the request subaction
+ * @length:		length of the payload, in bytes
  *
  * Returns the RCODE.  See fw_send_request() for parameter documentation.
  * Unlike fw_send_request(), @data points to the payload of the request or/and
@@ -604,6 +612,7 @@ EXPORT_SYMBOL(fw_core_add_address_handle
 
 /**
  * fw_core_remove_address_handler() - unregister an address handler
+ * @handler: callback
  *
  * To be called in process context.
  *
@@ -828,6 +837,7 @@ EXPORT_SYMBOL(fw_send_response);
 
 /**
  * fw_get_request_speed() - returns speed at which the @request was received
+ * @request: firewire request data
  */
 int fw_get_request_speed(struct fw_request *request)
 {

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
