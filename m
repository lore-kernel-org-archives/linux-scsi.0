From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux tape drivers
Date: Tue, 3 Apr 2007 14:57:28 -0700
Message-ID: <20070403145728.d8f83320.akpm@linux-foundation.org>
References: <200704031508.37222.kern@sibbald.com>
	<20070403133904.0029ccd2.akpm@linux-foundation.org>
	<200704032330.16399.kern@sibbald.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945999AbXDCV6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Apr 2007 17:58:17 -0400
In-Reply-To: <200704032330.16399.kern@sibbald.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kern Sibbald <kern@sibbald.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Willem Riede <wrlk@riede.org>

On Tue, 3 Apr 2007 23:30:15 +0200
Kern Sibbald <kern@sibbald.com> wrote:

> > 
> > Kai maintains the scsi tape driver and Willem looks after OSST.  Perhaps 
> they
> > can comment on some of the issues which you identify?
> 
> Thanks for pointing me to the correct places.  I will be interested to hear 
> their thoughts ...
> 
> I have already had the pleasure to work with Willem, and thanks to his 
> efforts, his OSST driver does work with Bacula.  I hope that he or some 
> others would like to fix the other "broken" non-scsi drivers.  I'll get  the 
> names of the drivers that do not work and report back.

OK.  The non-scsi drivers are more problematic.  If we're meaning
ide-tape.c here then I don't know of any developers who are really working
on that.  I guess it's nominally Bartlomiej Zolnierkiewicz, but I suspect
he's flat out looking after regular old disk dives.

> Andrew, do you want to be copied on future email exchanges?

Yes please.

> Does anyone object if I copy a Bacula developer who does have a 
> non-scsi tape drive that does not work on Linux, but does work 
> on Windows?

If it's purely a driver problem then it's presumably not relevant to the
scsi developers.  Raising a report at bugzilla.kernel.org would probably be
appropriate - I will then route it to the appropriate developer (if any)
and we'll at least know that we have an issue to be addressed.


