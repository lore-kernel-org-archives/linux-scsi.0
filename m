From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.8+ merge window
Date: Fri, 14 Oct 2016 14:33:48 +0800
Message-ID: <1476426828.22309.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35518 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757089AbcJNGfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 02:35:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is just a set of minor updates and fixes which weren't quite ready
in time for the first pull request.  The only real thing of note is
Mike Christie is stepping down as Maintainer of iscsi to be replaced by
Lee Duncan and Chris Leech.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Baoyou Xie (1):
      scsi: be2iscsi: mark symbols static where possible

Joao Pinto (1):
      scsi: ufs: Kconfig fix

Kyuho Choi (1):
      scsi: ufs: Enable no vccq quirk for skhynix device

Lee Duncan (1):
      MAINTAINERS: Update open-iscsi maintainers

Ondrej Zary (3):
      scsi: g_NCR5380: Stop using scsi_module.c
      scsi: g_NCR5380: Reduce overrides[] from array to struct
      scsi: g_NCR5380: Remove deprecated __setup

Varun Prakash (1):
      scsi: cxgb4i: Set completion bit in work request

Wei Yongjun (1):
      scsi: ufs: Fix error return code in ufshcd_init()

Zang Leigang (1):
      scsi: ufs: Data Segment only needed for WRITE DESCRIPTOR

And the diffstat:


 Documentation/scsi/g_NCR5380.txt   |  34 +-
 MAINTAINERS                        |   6 +-
 drivers/scsi/be2iscsi/be_main.c    |  12 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   5 +
 drivers/scsi/g_NCR5380.c           | 699 ++++++++++++++++---------------------
 drivers/scsi/g_NCR5380.h           |   8 -
 drivers/scsi/ufs/Kconfig           |   2 +-
 drivers/scsi/ufs/ufs_quirks.h      |   2 +
 drivers/scsi/ufs/ufshcd.c          |  10 +-
 9 files changed, 345 insertions(+), 433 deletions(-)

James

