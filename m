From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: advansys driver vs 2.6 breakage
Date: Mon, 11 Aug 2003 14:34:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811143402.1df9184c.rddunlap@osdl.org>
References: <20030810224402.5c7fa063.rddunlap@osdl.org>
	<200308111729.04184.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59272 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S273403AbTHKVg4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 17:36:56 -0400
In-Reply-To: <200308111729.04184.gene.heskett@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: gene.heskett@verizon.net
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Mon, 11 Aug 2003 17:29:04 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:

| On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
| >Gene,
| >
| >This patch should make the advansys driver build on 2.6.0-test3
| >after you #define ADVANSYS_DEBUG so that run-time debug output
| >can be generated.
| >
| >--
| 
| Ok Randy, I have some logs, stripped down to about 1650 lines from 
| just under half a million.
| 
| Should I send them privately?

How many bytes?  If <= roughly 60 KB, I'd say just post them here.

--
~Randy				For Linux-2.6, see:
http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-halloween-2.5.txt
