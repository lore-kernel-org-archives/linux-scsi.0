From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 0/7] aacraid: DRiver updates
Date: Thu, 15 Mar 2007 10:25:45 -0700
Message-ID: <1173979545.30374.20.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXCORZs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:25:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

The following 7 patches contain various updates described in each mail.

Patches apply to the scsi-misc-2.6 tree.

 aachba.c   |  386 ++++++++++++++++++++++++++++++---------------------
 aacraid.h  |    9 -
 commctrl.c |  282 ++++++++++++++++++++++---------------
 commsup.c  |  106 +++++---------
 dpcsup.c   |   32 ++--
 linit.c    |   64 +++++++-
 rx.c       |   43 +++--

-- 
Mark Haverkamp <markh@linux-foundation.org>

