From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Feral Qlogic ISP driver up for testing
Date: Thu, 15 May 2003 10:32:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030515103127.K12807@wonky.in0.lcl>
References: <1053017923.2267.76.camel@mulgrave>  <20030515180341.A30444@infradead.org>
 <1053018832.2265.81.camel@mulgrave>  <20030515102358.L12807@wonky.in0.lcl>
 <1053019841.2267.85.camel@mulgrave>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:18440 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S264124AbTEORUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 13:20:42 -0400
In-Reply-To: <1053019841.2267.85.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@digeo.com>


Oh- okay. The 2.5 tree I had that was different isn't all *that*
different. But I was taken a bit by surprise again. By all means- test
away as much as you like and send bug reports.

I'm sure that there are boatloads of issues. For example, I just fixed a
bug yesterday that had threads getting left around after module unload
for 2.4.


On Thu, 15 May 2003, James Bottomley wrote:

> On Thu, 2003-05-15 at 12:25, Matthew Jacob wrote:
> >
> >
> > The tarball doesn't get updated as frequently as my BK tree, and the BK
> > tree for 2.5 is different...
> >
> > bk://bitkeeper.feral.com:9002
>
> Hmm, well, the bitkeeper tree is where I got the files from.
>
> We can certainly hold off on integrating it (that's why I put it into a
> separate BK tree).  However, unless there are any really nasty lurking
> bugs, I'd like to get those people who can at least to test it.
>
> James
>
>
>
