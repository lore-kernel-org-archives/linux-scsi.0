From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: 09 Jun 2004 10:22:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086798154.7074.24.camel@patibmrh9>
References: <1086710016.3647.4.camel@patibmrh9><20040609080013.GS13836@suse
	.de>  <20040609082045.GT13836@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:37021 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265824AbUFIQWp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 12:22:45 -0400
In-Reply-To: <20040609082045.GT13836@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

> Hmm fudge.

Sorry, this English I do not understand.

> --- 1.149/drivers/ide/ide.c     2004-06-04 21:14:59 +02:00
> +++ edited/drivers/ide/ide.c    2004-06-09 10:07:46 +02:00

Patch!  Cool, thank you.

> Pat, can you test

Gladly.  Unless redirected, I will try combining:

a) kernel.org 2.6.7-rc3 plus the patch of this thread,
b) PATAPI drive connected as /dev/hdd,
c) open of /dev/hdd with flags O_NONBLOCK|O_RDWR, ioctl SG_IO
d) cdb = x 1B 00:00:00 00 00 // Stop
e) cdb = x 1B 00:00:00 01 00 // Start

Pat LaVarre


