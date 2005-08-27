From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 6/7] [PATCH] sg.c: fix a memory leak in devices
	seq_file implementation (2nd)
Date: Fri, 26 Aug 2005 21:19:51 -0500
Message-ID: <1125109191.5079.157.camel@mulgrave>
References: <20050826191755.052951000@localhost.localdomain>
	 <20050826191942.444423000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22763 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751632AbVH0CUC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:20:02 -0400
In-Reply-To: <20050826191942.444423000@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org, Ingo Oeser <ioe-lkml@rameria.de>, Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Chuck Wolber <chuckw@quantumlinux.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jan Blunck <j.blunck@tu-harburg.de>

On Fri, 2005-08-26 at 12:18 -0700, Chris Wright wrote:
> plain text document attachment (fix-memory-leak-in-sg.c-
> seq_file.patch)
> -stable review patch.  If anyone has any  objections, please let us know.

Looks fine to me.

James


