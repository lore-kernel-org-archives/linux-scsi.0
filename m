From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 0/28] Sync up drivers/scsi/aic7xxx
Date: Tue, 28 Sep 2004 14:36:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928143652.A2144@infradead.org>
References: <4159611C.4030106@adaptec.com> <20040928141228.A1815@infradead.org> <415964D2.80808@adaptec.com> <20040928142133.A1956@infradead.org> <41596793.6040900@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:33555 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267730AbUI1Ngy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 09:36:54 -0400
Content-Disposition: inline
In-Reply-To: <41596793.6040900@adaptec.com>; from luben_tuikov@adaptec.com on Tue, Sep 28, 2004 at 09:30:59AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Sep 28, 2004 at 09:30:59AM -0400, Luben Tuikov wrote:
> > Then please don't bother us with the intermediate versions. Diff the
> > current scsi-misc tree (which is ahead of mainline) vs your final version
> > and split the patch into logical pieces.
> 
> Hm, ok, you're the first one to mention doing it like this.
>  From our previous emails I thought you wanted to see
> a gradual progression.

Yes, a gradual progression is exactly what I want to see.  But based on
_logical_ changes, aka fix this, rearchitect that, cleanup this.

I don't care about your SCM history at all.

