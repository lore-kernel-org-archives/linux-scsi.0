From: maximilian attems <janitor@sternwelten.at>
Subject: Re: [patch-kj] remove old ifdef'd code from
Date: Tue, 22 Jun 2004 16:19:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622141933.GA1558@sputnik.stro.at>
References: <20040621182918.GX1545@sputnik.stro.at> <20040621183140.GA22588@infradead.org> <20040622084440.GB1531@sputnik.stro.at> <20040622084714.GA31811@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:42915 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S264061AbUFVOTa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 10:19:30 -0400
Content-Disposition: inline
In-Reply-To: <20040622084714.GA31811@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: garloff@suse.de, linux-scsi@vger.kernel.org

On Tue, 22 Jun 2004, Christoph Hellwig wrote:

> On Tue, Jun 22, 2004 at 10:44:40AM +0200, maximilian attems wrote:
> > > While the changes are okay, this driver is beeing changed rapidly and I
> > > have a patch pending that's a supertset of yours.  So please don't apply
> > > James.
> > 
> > are you referring to the dc390 driver patches?
> 
> Yes.

ok i'll drop that.
 
> > what about the aic7xxx and the aic79xx?
> 
> There have been rumors on linux-scsi that adaptec is starting to maintain
> them again. OTOH they'll need to redo their patches in small steps anyway
> so your patches look fine to me.

thanks for the review,
so  i'll sent them to andrew.

a++ maks
 
