From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] Sync SCSI bugfix tree
Date: 23 Oct 2003 12:14:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066929269.1831.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:37126 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263641AbTJWROm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 13:14:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is the current set of SCSI bugfixes only for 2.6

you can pull it from

bk://linux-scsi.bkbits.net/scsi-bugfixes-2.6

I've added the justifications into the short changelogs:



<p.lavarre:ieee.org>:
  o SG_SET_RESERVED_SIZE negative oops

- can oops the kernel if incorrect parameters passed

Douglas Gilbert:
  o SCSI constants.c

- fixes a mismerge that lost us the report luns sense

Mark Haverkamp:
  o Work around aacraid FW problem

- can corrupt data for >4GB machines

Mike Anderson:
  o Add release function to sd for scsi_disk structure

- Ongoing fixes to refcounting issues which cause oopses on surprise
ejection of USB (and other) SCSI devices.

Mike Christie:
  o fix oops caused when writing to the rescan attribute

Patrick Mansfield:
  o SCSI: limit mode sense usage

- required to make some USB devices work by preventing them from
receiving the cache mode sense command

James


