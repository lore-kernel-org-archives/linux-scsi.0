From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] essential SCSI fixes for 2.6.5-rc2
Date: 20 Mar 2004 09:30:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079793048.1778.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:39135 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263422AbUCTOaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2004 09:30:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

These are the two oops related fixes from the scsi-misc-2.6 tree that
testing has shaken out.  They are available at

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

The shortlog is:



Brian King:
  o SCSI: Fix Oops in sg with lots of SG_IO activity

Kai M=E4kisara:
  o Fix SCSI + st regressions problem


And the diffstat:

 sg.c |    4 ++--
 st.c |   15 ++++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
