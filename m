From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/3] NCR5380 patches from mailing list
Date: Mon, 9 Mar 2015 16:48:09 +1100
Message-ID: <cover.1425880089.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44143 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbCIIBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2015 04:01:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

As requested by James, these are the NCR5380 patches that were reviewed
on the linux-scsi mailing list.

I've changed my acked-by tags to signed-off-by tags. git am and
git format-patch helpfully moved the email From: headers to the
message bodies, but not the Date: headers, and it chucked out the
recipient headers found in the email submissions and everything
after the "---" cut lines, which might make further review
more difficult...

Geert Uytterhoeven (1):
  g_NCR5380: Kill compiler warning if builtin

Nicholas Mc Guire (1):
  ncr5380: Harmonize jiffies conversion with msecs_to_jiffies

Wolfram Sang (1):
  ncr5380: Drop owner assignment from platform_drivers

 drivers/scsi/NCR5380.c       | 10 +++++-----
 drivers/scsi/atari_NCR5380.c |  2 +-
 drivers/scsi/atari_scsi.c    |  1 -
 drivers/scsi/g_NCR5380.c     |  8 ++++----
 drivers/scsi/mac_scsi.c      |  1 -
 drivers/scsi/sun3_scsi.c     |  1 -
 6 files changed, 10 insertions(+), 13 deletions(-)

-- 
2.0.5
