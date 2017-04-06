From: Martin Wilck <mwilck@suse.com>
Subject: hpsa patches in mkp/4.12/scsi-queue and mkp/4.11/scsi-fixes
Date: Thu, 06 Apr 2017 14:19:49 +0200
Message-ID: <1491481189.5348.12.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57176 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753779AbdDFMUF (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 6 Apr 2017 08:20:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

Hi Martin,

I noticed that the following commits

eb94588dabec scsi: hpsa: fix volume offline state
2ef288498087 scsi: hpsa: do not timeout reset operations
87b9e6aa87d9 scsi: hpsa: limit outstanding rescans
85b29008d8af scsi: hpsa: update check for logical volume status

are included in mkp/4.11/scsi-fixes but not in mkp/4.12/scsi-queue.
Is there a specific reason for that?

Best regards
Martin W

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
