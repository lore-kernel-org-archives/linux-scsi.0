From: Mattia Dongili <malattia@linux.it>
Subject: Re: oops in lbmIODone, fails to boot [Re: 2.6.23-mm1]
Date: Sun, 21 Oct 2007 14:44:28 +0900
Message-ID: <20071021054427.GA4164@inferi.kami.home>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071020045753.GA4660@inferi.kami.home> <20071019223440.3bf845ef.akpm@linux-foundation.org> <1192882706.9464.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:44898 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbXJUFol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Oct 2007 01:44:41 -0400
Content-Disposition: inline
In-Reply-To: <1192882706.9464.1.camel@norville.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

On Sat, Oct 20, 2007 at 07:18:26AM -0500, Dave Kleikamp wrote:
> On Fri, 2007-10-19 at 22:34 -0700, Andrew Morton wrote:
> > On Sat, 20 Oct 2007 13:57:54 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > 
> > > On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > > > 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > 
> > > Hey there!!
> > > fails to boot here with this friendly oops:
> > > http://oioio.altervista.org/linux/dsc01702.jpg
> > > 
> > > .config: http://oioio.altervista.org/linux/config-2.6.23-mm1-1
> > > 
> > > 2.6.23-rc8-mm2 booted ok but had other problems I haven't reported yet
> > > (no s2ram with mysql running and some net WARNING).
> > > Let's see if .23-mm1 still has those first.
> > > 
> > > I'm adding Cc: linux-scsi
> > > 
> > > PS: I'll hardly be able to bisect in the next days... :P
> > 
> > That looks like a Jens and Dave production to me.
> 
> Yes, and it's been fixed:
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8d8fe64237646fdd2c2de2722ec4189a5999119d

thanks this fixes it
-- 
mattia
:wq!
