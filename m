From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: advansys driver vs 2.6 breakage
Date: Wed, 13 Aug 2003 13:25:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030813132526.465b646e.rddunlap@osdl.org>
References: <20030810224402.5c7fa063.rddunlap@osdl.org>
	<200308111729.04184.gene.heskett@verizon.net>
	<20030811143402.1df9184c.rddunlap@osdl.org>
	<200308120328.38835.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:28841 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S275501AbTHMU2o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Aug 2003 16:28:44 -0400
In-Reply-To: <200308120328.38835.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: gene.heskett@verizon.net
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Tue, 12 Aug 2003 03:28:38 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:

| On Monday 11 August 2003 17:34, Randy.Dunlap wrote:
| >On Mon, 11 Aug 2003 17:29:04 -0400 Gene Heskett 
| <gene.heskett@verizon.net> wrote:
| >| On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
| >| >Gene,
| >| >
| >| >This patch should make the advansys driver build on 2.6.0-test3
| >| >after you #define ADVANSYS_DEBUG so that run-time debug output
| >| >can be generated.
| >| >
| >| >--
| >|
| >| Ok Randy, I have some logs, stripped down to about 1650 lines from
| >| just under half a million.
| >|
| >| Should I send them privately?
| >
| >How many bytes?  If <= roughly 60 KB, I'd say just post them here.
| 
| I've done some more trimming, taking it down to a single bootup as a 
| module, and its now 58k, so its attached.

Gene,

Both the 2.4 and 2.6 logs show lots of successful IOs and a few
IO errors.  The IO errors look like this in both of them:

Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11

This is a timeout as I read the source file.
Maybe I'm misreading the logs, but I don't see any other errors
being reported.  What are the symptoms of the errors that you are
seeing on 2.6.0-test?

--
~Randy				For Linux-2.6, see:
http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-halloween-2.5.txt
