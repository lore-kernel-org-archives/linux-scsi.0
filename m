From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] SCSI-sg: Adjustments for two function implementations
Date: Fri, 25 Aug 2017 22:22:42 +0200
Message-ID: <0fffccee-7cc1-1321-2c6b-00ac06b304b8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61631 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754416AbdHYUWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 16:22:55 -0400
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 25 Aug 2017 22:20:02 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in sg_alloc()
  Improve a size determination in sg_alloc()
  Fix a typo in a comment line in sg_ioctl()

 drivers/scsi/sg.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

-- 
2.14.0
