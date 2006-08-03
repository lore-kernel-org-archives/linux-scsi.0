From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 0/4] aacraid: Driver updates
Date: Thu, 03 Aug 2006 08:02:04 -0700
Message-ID: <1154617324.31319.18.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28388 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932561AbWHCPCJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2006 11:02:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

The following 4 patches contain various updates described in each mail.

Patches apply o the scsi-misc-2.6 tree.

 aachba.c   |   54 ++++++++----
 aacraid.h  |    5 -
 commctrl.c |   25 ++++-
 comminit.c |    2 
 commsup.c  |  273 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 dpcsup.c   |   10 +-
 linit.c    |   18 ++--
 rkt.c      |   18 ++--
 rx.c       |   18 ++--
 9 files changed, 375 insertions(+), 48 deletions(-)

-- 
Mark Haverkamp <markh@osdl.org>

