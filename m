From: Randy Dunlap <rd.dunlab@gmail.com>
Subject: [PATCH v3 0/5] FireWire: clean up kernel-doc,
 add Documentation chapter
Date: Tue,  4 Sep 2018 17:02:20 -0700
Message-ID: <20180905000225.10733-1-rd.dunlab@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
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

This patch series cleans up kernel-doc warnings in several
FireWire source files and then adds a Documentation driver-api
chapter for FireWire.

[PATCH v4 1/5] FireWire: clean up firewire-cdev.h kernel-doc
[PATCH v4 2/5] FireWire: clean up core-iso.c kernel-doc
[PATCH v4 3/5] FireWire: clean up core-transaction.c kernel-doc
[PATCH v4 4/5] FireWire: add a Documentation driver-api chapter
[PATCH v4 5/5] FireWire: add driver-api Introduction section

The only changes in v4 are (a) respin against current -next and
(b) add more Cc:s so that someone will please merge the series.(*)

I think that Jon is the best choice to merge this series, but
someone please do so.  It has already missed 2 merge windows.

(*): Stefan hasn't replied to patches in the linux1394-devel
mailing list recently.  E.g., see:
https://sourceforge.net/p/linux1394/mailman/message/36406886/

 Documentation/driver-api/firewire.rst |   50 +++++++++++++++++++++++-
 Documentation/driver-api/index.rst    |    1 
 drivers/firewire/core-iso.c           |    7 +++
 drivers/firewire/core-transaction.c   |   10 ++++
 include/uapi/linux/firewire-cdev.h    |   22 ++++++----
 5 files changed, 81 insertions(+), 9 deletions(-)

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
