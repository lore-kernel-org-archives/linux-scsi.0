From: Jamie Lenehan <lenehan@twibble.org>
Subject: dc395x updated for latest bk
Date: Wed, 11 Jun 2003 18:00:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030611080039.GA2064@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charon.twibble.org ([203.217.29.134]:5250 "EHLO
	egwene.twibble.org") by vger.kernel.org with ESMTP id S264201AbTFKHrA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2003 03:47:00 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

For anyone using this driver some changes have been included (pushed
by Oliver) in the main bk tree. I've re-created all my outstanding
patches against 2.5.70-bk9 and tested it against 2.5.70-bk9 and
2.5.70-bk15.

Available in the usual place:

  http://twibble.org/dist/dc395x/

No new changes have been added. It's too time consuming to rediff as
things change so I'm waiting until all the existing changes get
included before making any more changes.

The included changes were:

 2.5.70-bk1 included the sharded IRQ crashing fix
            (00-irq-crash-fix.patch) with some minor NULL/whitepsace
            changes.

 2.5.70-bk9 included the debugging cleanup (01-debug-cleanup.patch),
            the module cleanup (02-module-cleanup.patch), some
            changes from linux-scsi to the proc function (hch) and a
            lot of unrelated white space and for/while conversions.

-- 
 Jamie Lenehan              Work Phone: +61 3 9843 8817
 lenehan@twibble.org        Work Email: jamie.lenehan@activcard.com.au
