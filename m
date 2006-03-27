From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 0/11] aacraid: Driver updates
Date: Mon, 27 Mar 2006 09:43:10 -0800
Message-ID: <1143481390.21975.34.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:8127 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751095AbWC0RnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:43:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

The following 11 patches contain various aacraid driver updates
described in each mail.

Patches apply to the scsi-misc-2.6 tree.

 aachba.c   |   94 +++++++++++++++++++++++++++++++------------------------------
 aacraid.h  |   11 ++++++-
 commctrl.c |   12 +++++++
 commsup.c  |   41 ++++++++++++++++++--------
 linit.c    |   64 +++++++++++++++++++++++++++++++----------
 rkt.c      |    4 +-
 rx.c       |    4 +-
 sa.c       |    2 -
 8 files changed, 152 insertions(+), 80 deletions(-)

-- 
Mark Haverkamp <markh@osdl.org>

