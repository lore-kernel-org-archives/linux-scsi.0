From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] mpt3sas: mpt3sas_scsih_enclosure_find_by_handle can be
 static
Date: Wed, 21 Mar 2018 05:06:52 +0800
Message-ID: <20180320210652.GA40906@xian>
References: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521540956-42347-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Bart.VanAssche@wdc.com, Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org


Fixes: 793a6223beef ("mpt3sas: Cache enclosure pages during enclosure add.")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 mpt3sas_scsih.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c93c5c5..67a43957 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1370,7 +1370,7 @@ mpt3sas_scsih_expander_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
  * This searches for enclosure device based on handle, then returns the
  * enclosure object.
  */
-struct _enclosure_node *
+static struct _enclosure_node *
 mpt3sas_scsih_enclosure_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _enclosure_node *enclosure_dev, *r;
