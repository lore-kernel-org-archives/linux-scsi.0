From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 09:42:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41596A58.1060208@adaptec.com>
References: <4159611C.4030106@adaptec.com> <20040928141228.A1815@infradead.org> <415964D2.80808@adaptec.com> <20040928142133.A1956@infradead.org> <41596793.6040900@adaptec.com> <20040928143652.A2144@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:20445 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267725AbUI1Nm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:42:56 -0400
In-Reply-To: <20040928143652.A2144@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


Christoph Hellwig wrote:
> On Tue, Sep 28, 2004 at 09:30:59AM -0400, Luben Tuikov wrote:
>  > > Then please don't bother us with the intermediate versions. Diff the
>  > > current scsi-misc tree (which is ahead of mainline) vs your final 
> version
>  > > and split the patch into logical pieces.
>  >
>  > Hm, ok, you're the first one to mention doing it like this.
>  >  From our previous emails I thought you wanted to see
>  > a gradual progression.
> 
> Yes, a gradual progression is exactly what I want to see.  But based on
> _logical_ changes, aka fix this, rearchitect that, cleanup this.

This isn't quite possible to be generated from a difference
of the latest version which I have from the version in
the linux kernel.  They are just too far apart.

I'll give it a try, not sure how possible it would
be to separate the difference into "logical" pieces.

	Luben

> I don't care about your SCM history at all.
> 


