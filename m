From: Pat LaVarre <p.lavarre@ieee.org>
Subject: dvd-ram open succeeds despite write-protect
Date: 17 Aug 2004 09:19:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092755959.4517.5.camel@patlinux.iomegacorp.com>
References: <20040804045839.GA8139@suse.de><1091619347.5681.6.camel@patibmrh
	9>  <20040804113829.GJ10340@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:53167 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268296AbUHQPUa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 11:20:30 -0400
In-Reply-To: <20040804113829.GJ10340@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> Subject: Re: [PATCH] DVD-RAM rewritable again
> ...
> ... with everything, test ...

In 2.6 Linux, do we care about write-protected DVD/CD discs?  Do we
agree they don't quite work yet?  Can I help best by working to fix
them?

Just now I specifically tried toggling the invisible MMC PWP
write-protect switch found inside of DVD-RAM discs, Iomega REV discs,
etc.  In Linux-2.6.8.1, with write-protected discs,

I'm glad to see EROFS correctly fail open to write of Iomega REV discs,
no matter PATAPI or USB.  But I'm sorry to see open, write, and close of
DVD-RAM discs succeed, no matter PATAPI or USB.  Only in my dmesg do I
see that the DVD-RAM disc is actually not changing, e.g.

kernel: hdd: command error: status=0x51 { DriveReady SeekComplete Error }
kernel: hdd: command error: error=0x70
kernel: end_request: I/O error, dev hdd, sector 0

kernel: SCSI error : <0 0 0 0> return code = 0x8000002
kernel: Current sr0: sense key Data Protect
kernel: Additional sense: Write protected
kernel: end_request: I/O error, dev sr0, sector 0

Pat LaVarre
http://linux-pel.blog-city.com/read/771746.htm


