From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: advansys driver vs 2.6 breakage
Date: Tue, 12 Aug 2003 09:54:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030812095418.3672568b.rddunlap@osdl.org>
References: <200308070422.41412.gene.heskett@verizon.net>
	<20030807112157.GF22222@parcelfarce.linux.theplanet.co.uk>
	<200308071444.55616.gene.heskett@verizon.net>
	<20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:23206 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S271150AbTHLQ5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 12:57:20 -0400
In-Reply-To: <20030807195656.GJ22222@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: gene.heskett@verizon.net, linux-scsi@vger.kernel.org

On Thu, 7 Aug 2003 20:56:56 +0100 Matthew Wilcox <willy@debian.org> wrote:

| So you're willing to help debug this properly?  OK.  I'd like you to
| turn on ADVANSYS_DEBUG (around line 828 of the driver).  Then send me
| the debug messages the driver emits during bootup.
| 
| For comparison, I'd also like to see them from 2.4.

Gene, did you make a 2.4 ADVANSYS_DEBUG module and run it
and post the log from it?  I'd like to see that.

--
~Randy				For Linux-2.6, see:
http://www.kernel.org/pub/linux/kernel/people/davej/misc/post-halloween-2.5.txt
