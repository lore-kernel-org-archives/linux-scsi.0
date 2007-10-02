From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.23-rc9 boot failure (megaraid?)
Date: Tue, 2 Oct 2007 21:55:19 +0200
Message-ID: <200710022155.20287.rjw@sisk.pl>
References: <Pine.LNX.4.64.0710021242510.6275@postal> <20071002181518.GC10852@stusta.de> <Pine.LNX.4.64.0710021442450.6275@postal>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:34179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXJBTk2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 15:40:28 -0400
In-Reply-To: <Pine.LNX.4.64.0710021442450.6275@postal>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Burton Windle <bwindle@fint.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Sumant Patro <sumant.patro@lsi.com>, James Bottomley <James.Bottomley@steeleye.com>, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Tuesday, 2 October 2007 20:46, Burton Windle wrote:
> On Tue, 2 Oct 2007, Adrian Bunk wrote:
> 
> > Cc's added, the complete bug report is at
> >  http://lkml.org/lkml/2007/10/2/243
> >
> > On Tue, Oct 02, 2007 at 12:48:26PM -0400, Burton Windle wrote:
> >> 2.6.23-rc9 fails to boot for me; 2.6.22.9 works fine.
> >>
> >> System is a Dell Poweredge with PERC 2/DC with RAID1 volume.
> >> ...
> >
> > Thanks for your report.
> >
> > Does reverting the commit below fix the problem?
> >
> > cu
> > Adrian
> >
> >
> > commit 3f6270ef76f2ce5c134615a470685d6c2a66c07e
> > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date:   Mon May 14 20:17:27 2007 +0900
> >
> 
> Confirmed; reverting the above (snipped) patch does fix the issue.

I've created a bugzilla entry for your report at:

http://bugzilla.kernel.org/show_bug.cgi?id=9113

Please add a summary of your observations in there.

Greetings,
Rafael
