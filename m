From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: 18 Jul 2003 09:00:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1058536838.1863.2.camel@mulgrave>
References: <20030716132036.GB833@suse.de>
	<1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de>
	<20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de>
	<3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de>
	<3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>
	<3F1683F5.4030107@cyberone.com.au> <20030717111059.GI833@suse.de>
	<3F168846.90902@cyberone.com.au>
	<1058474814.4638.11.camel@markh1.pdx.osdl.net>
	<1058481553.19508.5.camel@markh1.pdx.osdl.net>
	<1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>
	<20030717170055.5dbe20c1.akpm@osdl.org> <3F17821A.307@cyberone.com.au>
	<20030717222534.0295c44e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:26630 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270085AbTGRNqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 09:46:00 -0400
In-Reply-To: <20030717222534.0295c44e.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Nick Piggin <piggin@cyberone.com.au>, daniel@osdl.org, markh@osdl.org, Jens Axboe <axboe@suse.de>, cliffw@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-07-18 at 00:25, Andrew Morton wrote:
> Guys, it's been three days and I'm getting a dribble of sad little messages
> from various people whose boxes are stuck with everything in D state.
> 
> Can we please get this thing wrapped up within the next 12 hours so we
> don't spend all of next week with Linus's tree in such a blatantly buggy
> state?

I'm ready to ship the SCSI tree with Jens' enabler now.  However, can I
have more time to test the proposed fix?  The SCSI code has four other
queue cases that the aacraid problem didn't hit but which my test
harness does.  I'm worried that yesterday I saw the hang where Mark got
a crash.

The workaround is simply to boot the kernel with elevator=deadline.

James


