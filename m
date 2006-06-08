From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 0/3] aacraid: Driver updates (update)
Date: Thu, 08 Jun 2006 13:55:08 -0700
Message-ID: <1149800108.22364.34.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63181 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965003AbWFHUzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 16:55:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

The following 3 patches contain various updates described in each mail.
Patch 1 and 3 updated based on comments.  Patch 2 is just a re-send.

Patches apply to the scsi-misc-2.6 tree.

 Documentation/scsi/aacraid.txt  |    8 ++++----
 drivers/scsi/aacraid/aacraid.h  |    6 +-----
 drivers/scsi/aacraid/comminit.c |    2 +-
 drivers/scsi/aacraid/dpcsup.c   |    4 ++--
 drivers/scsi/aacraid/linit.c    |   10 ++++------
 5 files changed, 12 insertions(+), 18 deletions(-)

-- 
Mark Haverkamp <markh@osdl.org>

