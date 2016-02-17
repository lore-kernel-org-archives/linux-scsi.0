From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 0/2] mpt3sas driver fix and updated MAINTAINERS list:
Date: Wed, 17 Feb 2016 16:55:24 +0530
Message-ID: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34305 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161157AbcBQLZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 06:25:53 -0500
Received: by mail-pf0-f181.google.com with SMTP id x65so10074801pfb.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Feb 2016 03:25:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

Here is the change list:
Posting 2 patches for mpt3sas driver fix and updated MAINTAINERS list.
 * Deallocates resources before reallocating of the same in retry_allocation
   path of _base_allocate_memory_pools().
 * Updated MAINTAINERS list for MPT FUSION DRIVERS.

Chaitra P B (2):
  mpt3sas: Deallocate resources before trying reallocation of the
  same in _base_allocate_memory_pools().
  Modified Maintainers list for MPT FUSION DRIVERS.

 MAINTAINERS                         | 7 +++----
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
1.8.3.1

