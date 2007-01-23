From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 0/4] aacraid: Driver updates
Date: Tue, 23 Jan 2007 14:58:49 -0800
Message-ID: <1169593129.10440.20.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33647 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965523AbXAWW6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 17:58:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

The following 4 patches contain various updates described in each mail.

Patches apply to the scsi-misc-2.6 tree.

 Makefile   |    2 
 aachba.c   |  672 ++++++++++++++++++++++++++++++++++++-------------------------
 aacraid.h  |   46 +++-
 comminit.c |   14 -
 commsup.c  |   40 ---
 linit.c    |    7 
 rkt.c      |   64 +++--
 rx.c       |  263 +++++++++++++++--------
 sa.c       |   33 ++
 9 files changed, 682 insertions(+), 459 deletions(-)


-- 
Mark Haverkamp <markh@linux-foundation.org>

