From: Jens Axboe <axboe@suse.de>
Subject: Re: aic7xxx kobject crap
Date: Tue, 27 Apr 2004 19:09:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040427170953.GD764@suse.de>
References: <20040427141401.GF2089@suse.de> <20040427160304.GA20664@kroah.com> <20040427160741.GB764@suse.de> <1083082974.2020.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:14829 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264198AbUD0RJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 13:09:58 -0400
Content-Disposition: inline
In-Reply-To: <1083082974.2020.20.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Tue, Apr 27 2004, James Bottomley wrote:
> On Tue, 2004-04-27 at 11:07, Jens Axboe wrote:
> > I wish I could say more, I'll have to ask to get more info. All I know
> > is that it happens during install. So my current assumption is that it
> > happens the very first time the module is loaded, and the machine does
> > have some sort of aic7xxx device attached (or onboard). I'll get
> > confirmation on that.
> 
> Actually, there's already a report of a kobject screw up in aic7xxx if
> the module is loaded with no hardware present:
> 
> http://marc.theaimsgroup.com/?t=107754715800005&r=1&w=2
> 
> There's also a patch here if it is the reported problem:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107760949410870&w=2

The post you link to is one where kobject_unregister() craps out, my
post was for loading. The 'fix' appears to just keep the module loaded,
I don't think that'll do much here :-)

-- 
Jens Axboe

