From: Dave Jones <davej@redhat.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 1 Jul 2011 14:40:46 -0400
Message-ID: <20110701184046.GA2118@redhat.com>
References: <20110701170531.GA3693@tassilo.jf.intel.com>
 <20110701181406.GA1614@redhat.com>
 <20110701183227.GF23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1GASlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2011 14:41:02 -0400
Content-Disposition: inline
In-Reply-To: <20110701183227.GF23059@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl

On Fri, Jul 01, 2011 at 08:32:27PM +0200, Andi Kleen wrote:
 > On Fri, Jul 01, 2011 at 02:14:06PM -0400, Dave Jones wrote:
 > > On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
 > > 
 > >  > I found I can reliably crash a 3.0 system by pulling the
 > >  > USB cable of a mounted USB cdrom (or rather a USB device which
 > >  > has a builtin fake CD-ROM) 
 > >  > 
 > >  > I suspect it's a regression too.
 > > 
 > > We've been seeing a lot of similar bugs in Fedora since we pushed
 > > a 2.6.38.8 update.  Some of the traces are different, but some
 > 
 > I've also seen one with an earlier kernel where the NULL 
 > reference was in elv_.* something.  Don't have a written down backtrace
 > for this, but perhaps you have.

We had a bazillion reports of elv_may_queue oopses that looked like
https://bugzilla.redhat.com/show_bug.cgi?id=elv_may_queue

That should be fixed in .39 and newer.

	Dave

