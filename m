From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Feral Qlogic ISP driver up for testing
Date: Thu, 15 May 2003 10:25:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030515102358.L12807@wonky.in0.lcl>
References: <1053017923.2267.76.camel@mulgrave>  <20030515180341.A30444@infradead.org>
 <1053018832.2265.81.camel@mulgrave>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from beppo.feral.com ([192.67.166.79]:11528 "EHLO beppo.feral.com")
	by vger.kernel.org with ESMTP id S264150AbTEORND (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 13:13:03 -0400
In-Reply-To: <1053018832.2265.81.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@digeo.com>



The tarball doesn't get updated as frequently as my BK tree, and the BK
tree for 2.5 is different...



bk://bitkeeper.feral.com:9002

On Thu, 15 May 2003, James Bottomley wrote:

> On Thu, 2003-05-15 at 12:03, Christoph Hellwig wrote:
> > On Thu, May 15, 2003 at 11:58:41AM -0500, James Bottomley wrote:
> > > I've taken Matthew Jacob's latest drop of the Feral ISP driver and put
> > > it up under bitkeeper at
> > >
> > > http://linux-scsi.bkbits.net/scsi-isp-2.5
> >
> > Could ypu please submitt a diff for review?  Some people don't like to
> > be lost in a maze of BK trees, all almost the same..
>
> Well, it's all new files, there's not much to diff.
>
> The tarball is here:
>
> ftp://ftp.feral.com/pub/isp/isp_dist.tgz
>
> (I think that corresponds to what I pulled out of the feral BK tree)
> except that I flattened common, linux and firmware into a single
> directory.
>
> And the patches I did are below.
>
> James
>
>
