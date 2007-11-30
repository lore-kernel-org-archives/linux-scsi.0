From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sat, 1 Dec 2007 00:26:07 +0100
Message-ID: <200712010026.08086.rjw@sisk.pl>
References: <20071126134819.8FE56DBA2@gherkin.frus.com> <47508EE9.9030304@orcon.net.nz> <20071130144250.e89335f3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:60947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbXK3XHr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Nov 2007 18:07:47 -0500
In-Reply-To: <20071130144250.e89335f3.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Cree <mcree@orcon.net.nz>, rct@gherkin.frus.com, linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>

On Friday, 30 of November 2007, Andrew Morton wrote:
> On Sat, 01 Dec 2007 11:30:01 +1300
> Michael Cree <mcree@orcon.net.nz> wrote:
> 
> > Bob Tracy wrote:
> > > Andrew Morton wrote:
> > >> Could be something change in sysfs.  Please double-check the config
> > >> options, make sure that something important didn't get disabled.
> > >>
> > >  Here's
> > > hoping someone else is seeing this or can replicate it in the meantime.
> > 
> > Snap.
> > 
> > 2.6.24-rc2 works fine.   2.6.24-rc3 boots on Alpha but once /dev is 
> > populated no partitions of the scsi sub-system are seen.  Looks like ide 
> > sub-system similarly affected.
> 
> Rafael, I assume you have this regression in the list?

Yes, http://bugzilla.kernel.org/show_bug.cgi?id=9457
