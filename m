From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: udf folders pointing to self and above
Date: 29 Sep 2003 16:03:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064872992.5458.50.camel@patehci2>
References: <1064864262.4262.49.camel@patehci2>
	 <1064870151.5458.20.camel@patehci2>
	 <20030929143457.3def59f4.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:51873 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262985AbTI2WCy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 18:02:54 -0400
In-Reply-To: <20030929143457.3def59f4.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: rddunlap@osdl.org
Cc: linux-scsi@vger.kernel.org

> Linux filesystems ... in the kernel tree)
> should be discussed on open mailing lists [such as]
> linux-fsdevel@vger.kernel.org ...

Thanks for that prompt correction, sorry I needed it.  Accordingly now,

To linux-fsdevel@vger.kernel.org I have forwarded my post noting
"lost+found" "shall not point to itself or to a higher parent in the
directory hierarchy".

Sounds like I'm getting confused somewhere near finding udf-0.9.7/ and
linux/fs/udf/ simultaneously available.  Perhaps we intend for newbies
to use udftools-1.0.0b2/ together with linux/fs/udf/ no matter that
udftools-1.0.0b2/ appears together with udf-0.9.7/.

Or maybe we're not supposed to use the udftools-1.0.0b2/mkudffs/mkudffs
that mostly works.  Maybe we're supposed to begin by discovering how to
overcome:

$ uname -r
2.6.0...
$ sudo /sbin/mkfs -t udf /dev/loop0
mkfs.udf: No such file or directory
$

Pat LaVarre



