From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx kobject crap
Date: 27 Apr 2004 11:22:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1083082974.2020.20.camel@mulgrave>
References: <20040427141401.GF2089@suse.de>
	<20040427160304.GA20664@kroah.com>  <20040427160741.GB764@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:46553 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264246AbUD0QXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 12:23:03 -0400
In-Reply-To: <20040427160741.GB764@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>

On Tue, 2004-04-27 at 11:07, Jens Axboe wrote:
> I wish I could say more, I'll have to ask to get more info. All I know
> is that it happens during install. So my current assumption is that it
> happens the very first time the module is loaded, and the machine does
> have some sort of aic7xxx device attached (or onboard). I'll get
> confirmation on that.

Actually, there's already a report of a kobject screw up in aic7xxx if
the module is loaded with no hardware present:

http://marc.theaimsgroup.com/?t=107754715800005&r=1&w=2

There's also a patch here if it is the reported problem:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107760949410870&w=2

James


