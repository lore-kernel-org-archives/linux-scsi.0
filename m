From: Andrew Morton <akpm@osdl.org>
Subject: Re: lots and lots of disks again
Date: Wed, 11 Feb 2004 13:28:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211132848.49eece0d.akpm@osdl.org>
References: <20040204024512.5bf68428.akpm@osdl.org>
	<20040210110417.GB4010@tpkurt.garloff.de>
	<20040210112658.GC4010@tpkurt.garloff.de>
	<20040210133932.A3870@infradead.org>
	<20040210154751.GH4010@tpkurt.garloff.de>
	<20040210102603.0c835212.akpm@osdl.org>
	<20040211145614.GA4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:29846 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266188AbUBKV1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 16:27:05 -0500
In-Reply-To: <20040211145614.GA4010@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com

Kurt Garloff <garloff@suse.de> wrote:
>
> Hi Andrew,
> 
> On Tue, Feb 10, 2004 at 10:26:03AM -0800, Andrew Morton wrote:
> > Kurt Garloff <garloff@suse.de> wrote:
> > >
> > > Since when is 4k huge?
> > >  Sorry, I don't see any benefit in adding complexity to avoid a 4k array.
> > 
> > Well yes, but we do have lib/idr.c which I believe does what you need.  It
> > is simple to use.
> 
> It can store a pointer per ID. One that I don't need, unless I overlook
> some possibility to put an already existing pointer in there.
> 
> If we really allocate thousands of disks, the overhead of this solution
> will be higher than the bitmap, I'm afraid.

Four (or eight) bytes per disk!  I perceive a lack of perspecitve here ;)

I'd trade clarity of implementation for that.  (As well as, possibly,
reduced memory use on low-end machines).
