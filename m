From: Pat LaVarre <p.lavarre@ieee.org>
Subject: cdrom sr ide-cd - CDC_WR, 1999 op x46 GPCMD_GET_CONFIGURATION
Date: 28 Nov 2003 13:05:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070049902.11739.3.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:21758 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263364AbTK1UFf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 15:05:35 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

Am I correct to think we/you have no interest in going ahead and merging
into 2.6.1 a purely restructuring patch that supposedly changes no
results?  That is,

1) I should Not construct a patch that does no more than add op x46
GPCMD_GET_CONFIGURATION.

2) Nor should I construct a patch that does no more than add a new
CDC_WR flag to control pass thru of writes without overloading
CDC_DVD_RAM.

Instead I should wait to write such code until After we actually do
dream up a good way to discover, without waiting for the disc to arrive,
that some PDT x05 DVD/CD devices besides DVD-RAM are randomly rewritable
in place.

Right?  That's what I've been doing, without anyone's explicit
agreement, but then suddenly I thought perhaps I should ask Someone With
Change Authority, hi.

Pat LaVarre


