From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
Date: Mon, 18 Aug 2003 11:56:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030818185607.64948.qmail@web21108.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21108.mail.yahoo.com ([216.136.227.110]:51077 "HELO
	web21108.mail.yahoo.com") by vger.kernel.org with SMTP
	id S272252AbTHRS4I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2003 14:56:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mdharm-scsi@one-eyed-alien.net, p.lavarre@ieee.org

I see mount -w -t udf works with my dvd-ram in
late Linux 2.4 and early 2.6, but mistakenly
sees my dvd+rw as read-only.

To make my dvd+rw work, I find I can apply
patches much like:
http://fy.chalmers.se/~appro/linux/DVD+RW/
http://fy.chalmers.se/~appro/linux/DVD+RW/linux-2.4.patch

Can I somehow help ... to get a patch like this
finished & merged into the kernel.org kernel?

I'm new to drivers/scsi/sr_vendor.c ... but I
first glanced thru www.t10.org back in 1994.

Looks to me like this patch begins to expand the
awareness of Linux beyond the "mode page" x2A of
dvd-ram/cd-rw into the "profile"s and "feature"s
that distinguish dvd+rw etc. from other dvd/cd,
so that with my dvd+rw I achieve:

scsi_CDs[minor].device->writeable = 1;
scsi_CDs[minor].cdi.mask &= ~CDC_DVD_RAM;

In particular, in the patch I see 3 mmc3_profile
values from among the 7 values that mmc4r02c.pdf
says imply the "feature" "0020h" =
"Random Writable".

Can I help somehow?

Pat LaVarre
http://members.aol.com/plscsi/tools/knoppix/

P.S. Reply-to-all will reach me faster than
reply to p.lavarre@ieee.org or linux-scsi alone.


__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
