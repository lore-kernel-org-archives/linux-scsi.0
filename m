From: "Willem Riede" <wrlk@riede.org>
Subject: Re: Linux tape drivers
Date: Tue, 3 Apr 2007 20:00:59 -0700
Message-ID: <150283e90704032000p7f447a26pe3752b22024a1b67@mail.gmail.com>
References: <200704031508.37222.kern@sibbald.com>
	 <20070403133904.0029ccd2.akpm@linux-foundation.org>
	 <200704032330.16399.kern@sibbald.com>
	 <20070403145728.d8f83320.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:25140 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992553AbXDDDBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2007 23:01:00 -0400
Received: by an-out-0708.google.com with SMTP id b33so68968ana
        for <linux-scsi@vger.kernel.org>; Tue, 03 Apr 2007 20:01:00 -0700 (PDT)
In-Reply-To: <20070403145728.d8f83320.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kern Sibbald <kern@sibbald.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On 4/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 3 Apr 2007 23:30:15 +0200
> Kern Sibbald <kern@sibbald.com> wrote:
>
> > > Kai maintains the scsi tape driver and Willem looks after OSST.  Perhaps
> > > they can comment on some of the issues which you identify?
> >
> > Thanks for pointing me to the correct places.  I will be interested to hear
> > their thoughts ...
> >
> > I have already had the pleasure to work with Willem, and thanks to his
> > efforts, his OSST driver does work with Bacula.  I hope that he or some
> > others would like to fix the other "broken" non-scsi drivers.  I'll get  the
> > names of the drivers that do not work and report back.
>
> OK.  The non-scsi drivers are more problematic.  If we're meaning
> ide-tape.c here then I don't know of any developers who are really working
> on that.  I guess it's nominally Bartlomiej Zolnierkiewicz, but I suspect
> he's flat out looking after regular old disk dives.
>
> > Andrew, do you want to be copied on future email exchanges?
>
> Yes please.
>
> > Does anyone object if I copy a Bacula developer who does have a
> > non-scsi tape drive that does not work on Linux, but does work
> > on Windows?
>
> If it's purely a driver problem then it's presumably not relevant to the
> scsi developers.  Raising a report at bugzilla.kernel.org would probably be
> appropriate - I will then route it to the appropriate developer (if any)
> and we'll at least know that we have an issue to be addressed.

Osst supports both scsi and ide models of the Onstream dirves it is
designed for.
It uses ide-scsi for the ide model. In the past, I did look at
ide-tape to see if it could be made to work properly for the ide
Onstream tape, but that would have taken so much work, I decided to
limit myself to ide-scsi.

For other ide tape drives, the same could be done, using Kai's st
driver (of which osst is a clone). Ide-tape could be deprecated, left
to use for drives/applications it happens to work for. Given that the
new sata world is using st also, this concentrates effort where it has
maximum leverage.

If there are issues using Bacula on ide drives with ide-scsi and st,
we should debug those. If my previous experience getting osst to work
properly with Bacula can be of any use, I'll be happy to help where I
can.

Regards, Willem Riede.
