From: Lukas Herbolt <lherbolt@redhat.com>
Subject: [PATCH] scsi_debug: Add OPTIMAL TRANSFER LENGTH GRANULARITY option.
Date: Sat,  7 Jan 2017 09:50:26 +0100
Message-ID: <1483779027-10052-1-git-send-email-lherbolt@redhat.com>
References: <lherbolt@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755071AbdAGIvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 7 Jan 2017 03:51:42 -0500
In-Reply-To: <lherbolt@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Lukas Herbolt <lherbolt@redhat.com>

Hello,
I have been playing with scsi_debug and found that there is no way how to change the
minimum_io_size (OPTIMAL TRANSFER LENGTH GRANULARITY reported by VPD 0xb0).

The current module has minimum_io_size always set to physical_block_size.
So here comes a small patch which add a new option to this module to be
able to set it independently to the physical_block_size. Default behavior
is to keep the minimum_io_size equal to the physical_block_size.

Lukas

Lukas Herbolt (1):
  scsi_debug: Add OPTIMAL TRANSFER LENGTH GRANULARITY option.

 drivers/scsi/scsi_debug.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
2.7.4

