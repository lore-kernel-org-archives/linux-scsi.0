From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 0/3] aacraid: Driver updates
Date: Thu, 08 Jun 2006 09:50:21 -0700
Message-ID: <1149785421.22364.15.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43491 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964778AbWFHQu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 12:50:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

The following 3 patches contain various updates described in each mail.

Patches apply to the scsi-misc-2.6 tree.

 Documentation/scsi/aacraid.txt  |    8 ++++----
 drivers/scsi/aacraid/aacraid.h  |    6 +-----
 drivers/scsi/aacraid/comminit.c |    4 ++--
 drivers/scsi/aacraid/dpcsup.c   |    4 ++--
 drivers/scsi/aacraid/linit.c    |   10 +++++-----
 drivers/scsi/aacraid/rkt.c      |    2 ++
 drivers/scsi/aacraid/rx.c       |    2 ++
 7 files changed, 18 insertions(+), 18 deletions(-)

-- 
Mark Haverkamp <markh@osdl.org>

