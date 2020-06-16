Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BC6C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E61D20B80
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgFPMSf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 08:18:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:37472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbgFPMSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 08:18:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38287ADCD;
        Tue, 16 Jun 2020 12:18:33 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] gdth: bring driver into this century
Date:   Tue, 16 Jun 2020 14:18:17 +0200
Message-Id: <20200616121821.99113-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

the gdth driver has long seen no updates, and has a very peculiar
coding style.
Here's an attempt to (slowly) move it towards the linux coding style,
and fixup some oddities within the driver itself.

Adaptec has been defunct for several years now, so I doubt the maintainer
address is still working; so I'll leave it out for now.
Achim, if you are still around, do speak up :-)

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  gdth: reindent and whitespace cleanup
  gdth: do not use struct scsi_cmnd as argument for bus reset
  gdth: kill __gdth_execute()
  gdth: stop abusing ->request pointer for completion

 drivers/scsi/gdth.c       | 6520 ++++++++++++++++++++++-----------------------
 drivers/scsi/gdth.h       | 1377 +++++-----
 drivers/scsi/gdth_ioctl.h |  378 +--
 drivers/scsi/gdth_proc.c  | 1109 ++++----
 drivers/scsi/gdth_proc.h  |    8 +-
 5 files changed, 4695 insertions(+), 4697 deletions(-)

-- 
2.16.4

