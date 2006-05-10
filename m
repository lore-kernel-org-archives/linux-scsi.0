From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 0/5] aacraid: Driver updates
Date: Wed, 10 May 2006 09:11:26 -0700
Message-ID: <1147277486.29108.30.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53635 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964929AbWEJQLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:11:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

The following 5 patches contain various updates described in each mail.

Patches apply to the scsi-misc-2.6 tree.

 aachba.c   |   12 +++++++++---
 aacraid.h  |    4 ++--
 comminit.c |    1 -
 commsup.c  |    6 +-----
 dpcsup.c   |    2 --
 linit.c    |    8 --------
 rkt.c      |    4 ++--
 rx.c       |    4 ++--
 sa.c       |    8 ++++----
 9 files changed, 20 insertions(+), 29 deletions(-)


-- 
Mark Haverkamp <markh@osdl.org>

