From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] SCSI-HPSA: Adjustments for hpsa_big_passthru_ioctl()
Date: Mon, 5 Mar 2018 09:30:15 +0100
Message-ID: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Don Brace <don.brace@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 5 Mar 2018 09:14:32 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Use memdup_user() rather than duplicating its implementation
  Less function calls in hpsa_big_passthru_ioctl() after error detection
  Delete an unnecessary initialisation
  Move a variable assignment

 drivers/scsi/hpsa.c | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

-- 
2.16.2
