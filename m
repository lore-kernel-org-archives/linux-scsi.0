From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/7] aacraid: Fine-tuning for a few functions
Date: Sun, 21 Aug 2016 09:14:04 +0200
Message-ID: <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@microsemi.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 09:03:21 +0200

Several update suggestions were taken into account
from static source code analysis.

Markus Elfring (7):
  Use memdup_user() rather than duplicating its implementation
  One function call less in aac_send_raw_srb() after error detection
  Delete unnecessary initialisations in aac_send_raw_srb()
  Delete unnecessary braces
  Add spaces after control flow keywords
  Improve determination of a few sizes
  Apply another recommendation from "checkpatch.pl"

 drivers/scsi/aacraid/commctrl.c | 140 +++++++++++++++++++---------------------
 1 file changed, 67 insertions(+), 73 deletions(-)

-- 
2.9.3
