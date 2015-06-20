From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.1
Date: Sat, 20 Jun 2015 16:08:08 -0700
Message-ID: <1434841688.7460.11.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54742 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbbFTXIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2015 19:08:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus,

Apologies for the late PULL request.

Here are the outstanding target-pending fixes for v4.1 code.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The series contains three patches from Sagi + Co that address a few
iser-target issues that have been uncovered during recent testing at
Mellanox.

Patch #1 has a v3.16+ stable tag, and #2-3 have v3.10+ stable tags.

Thank you,

--nab

Sagi Grimberg (3):
  iser-target: Fix variable-length response error completion
  iser-target: release stale iser connections
  iser-target: Fix possible use-after-free

 drivers/infiniband/ulp/isert/ib_isert.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
