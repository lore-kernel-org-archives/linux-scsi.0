From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/5] block-cciss: Fine-tuning for two function implementations
Date: Thu, 18 Aug 2016 11:48:49 +0200
Message-ID: <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: esc.storagedev@microsemi.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 18 Aug 2016 11:40:04 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Use memdup_user()
  Less function calls after error detection
  Delete unnecessary initialisations
  Move an assignment for the variable "sg_used"
  Replace three kzalloc() calls by kcalloc()

 drivers/block/cciss.c | 66 ++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 35 deletions(-)

-- 
2.9.3
