From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v5 0/2] ibmvscsi parameter cleanup
Date: Mon,  9 Nov 2015 17:49:07 +0100
Message-ID: <1447087749-10828-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbbKIQtM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 11:49:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com

v5 set directly max_lun to 32
   remove patch 1/3 "make parameters max_id and max_channel read-only"

v4 udpates 3/3 description
   max_lun can be less or equal to 32

v3 checks that max_lun is less or equal to 31

v2 of this series only fix the format type of max_lun:

drivers/scsi/ibmvscsi/ibmvscsi.c:2298:4:
warning: format '%d' expects argument of type 'int',
but argument 4 has type 'u64 {aka long long unsigned int}' [-Wformat=]
       "Maximum ID: %d Maximum LUN: %d Maximum Channel: %d\n",

Laurent Vivier (2):
  ibmvscsi: display default value for max_id, max_lun and max_channel.
  ibmvscsi: set max_lun to 32

 drivers/scsi/ibmvscsi/ibmvscsi.c | 10 +++++++---
 drivers/scsi/ibmvscsi/ibmvscsi.h |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.1.0

