From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs
	disabled - dmesg filled with warnings
Date: Sat, 16 Feb 2008 08:52:15 -0600
Message-ID: <1203173535.3182.11.camel@localhost.localdomain>
References: <47ADC74B.9080009@control.aau.dk>
	 <1202580076.4254.24.camel@localhost.localdomain>
	 <20080209193518.GC11299@hoblitt.com>
	 <1202586219.4254.35.camel@localhost.localdomain>
	 <20080212205345.GB7640@hoblitt.com> <20080212222109.GC7640@hoblitt.com>
	 <1202855436.3137.153.camel@localhost.localdomain>
	 <20080215205657.GB23625@hoblitt.com>
	 <1203112643.3058.48.camel@localhost.localdomain>
	 <1203113047.3058.50.camel@localhost.localdomain>
	 <47B6CDDB.8000605@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46510 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYBPOwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Feb 2008 09:52:24 -0500
In-Reply-To: <47B6CDDB.8000605@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: Joshua Hoblitt <josh@hoblitt.com>, Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, j_gentoo@hoblitt.com, nick.cheng@areca.com.tw


On Sat, 2008-02-16 at 11:49 +0000, Daniel Drake wrote:
> I assume you're aware that this patch is just a subset of commit 
> 76d78300a6eb8 which you've already pushed up to Linus. Adding Nick Cheng 
> (commit author) to CC so that he can go over the feedback.

Well, in case it's not obvious by now:  The way to get bad code upstream
is to send a patch that combines many changes (the more the better) so
that any potential reviewer has no idea which change is meant by which
hunk and then to make sure Andrew picks it up so he'll hound the
subsystem Maintainer until it's applied.  Best of all, mention that it
fixes a bug and you're made.

In this case, the problems with the changes weren't obvious to me until
I saw the broken out diff for the backport. (And incidentally, never
send URLs to code; 95% of people don't click on them.  If you inline the
code, most people at least glance over it).

The odd thing is, it should have triggered a might_sleep() warning under
testing ... do you know why it didn't?

James

