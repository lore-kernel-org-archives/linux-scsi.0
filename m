From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/6] isci: Fix a typo for the word "destroy"
Date: Mon, 24 Nov 2014 18:08:32 +0100
Message-ID: <54736610.9090203@users.sourceforge.net>
References: <54736422.90409@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54736422.90409@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>, "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, intel-linux-scu@intel.com
Cc: kernel-janitors@vger.kernel.org, trivial@kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 24 Nov 2014 15:35:48 +0100

A word was corrected in the description for
the sci_remote_device_destruct() function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/isci/remote_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index cc51f38..f54bb98 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1008,7 +1008,7 @@ static void sci_remote_device_initial_state_enter(struct sci_base_state_machine
  * successfully destructed or if some failure occurred. enum sci_status This value
  * is returned if the device is successfully destructed.
  * SCI_FAILURE_INVALID_REMOTE_DEVICE This value is returned if the supplied
- * device isn't valid (e.g. it's already been destoryed, the handle isn't
+ * device isn't valid (e.g. it's already been destroyed, the handle isn't
  * valid, etc.).
  */
 static enum sci_status sci_remote_device_destruct(struct isci_remote_device *idev)
-- 
2.1.3
