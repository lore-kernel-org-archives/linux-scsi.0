From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 07:17:05 -0700
Message-ID: <1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
References: <20140714083547.GA6315@infradead.org> <53C3A170.1070101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55031 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbaGNORH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 10:17:07 -0400
In-Reply-To: <53C3A170.1070101@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-scsi@vger.kernel.org

On Mon, 2014-07-14 at 11:22 +0200, Hannes Reinecke wrote:
> On 07/14/2014 10:35 AM, Christoph Hellwig wrote:
> > Back when the mpt3sas driver was first posted I suggested that it should
> > be merged into mpt2sas, but my proposal didn't get much traction.
> >
> > Illumos has now produced a shared driver and shown that the difference
> > are basically limited to a different S/G list format [1], and a quick
> > experiment on the Linux drivers confirms this mostly - the additional
> > differences are various smaller workarounds for specific hardware
> > revisions.
> >
> > I think we'd all be served much better with a merged driver.
> >
> > [1] http://thread.gmane.org/gmane.os.illumos.devel/17341
> 
> Please. Pretty please.

I support the concept, since I think everyone told LSI at the time that
splitting the drivers would become a maintenance nightmare.

> I've started a merge myself, but then never found time to finalize it.
> 
> Carrying three basically identical drivers just creates a 
> maintenance overhead for everyone involved.
> 
> The original idea of splitting the driver and just maintaining the 
> latest has never really worked out; all fixes to the latest driver 
> turned out to be applicable to the others, too.
> So it just increased the workload for the maintainer for no real 
> gain. I would _strongly_ vote for it.

This isn't really a democracy; it's about who maintains the drivers and
right now it's LSI (or whatever their new name is).

One of the big reasons we don't have a lot of leverage with them is that
they always seem to slide updates around upstream via the distros
(often,  it has to be admitted the DKM route), so if Red Hat, SUSE,
Oracle and Canonical can agree not to accept LSI updates until the
driver is done this way, we'd have a lot more leverage.

James


