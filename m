From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 19:03:30 +0200
Message-ID: <20051020170330.GA16458@lst.de>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com> <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49827 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932488AbVJTRDk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:03:40 -0400
Content-Disposition: inline
In-Reply-To: <4357CB03.4020400@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Thu, Oct 20, 2005 at 12:51:15PM -0400, Luben Tuikov wrote:
> On 10/20/05 12:01, Christoph Hellwig wrote:
> > 
> > As you mentioned doing link reset and reporting stats on expanders
> > is done using SMP, and thus totally independent of the driver used.
> 
> Not quite. "Dispatching to" would be driver dependent.  If you implement
> sdi_register_provider(struct ...); then you can make everyone happy
> in the _shortest_ amount of time.
> 
> I'd suggest a reading of the SDI, SAS and SAM specs for an insight
> of how it all ties together.

Thanks Luben.  You might not be able to imagine it, but there are people
other than you who are able to read specs, and despite having read them
they can actually talk like a normal human without referencing them in
every second sentence.  That beeing said SDI is not a final
specification.  It's a draft that's probablt not going to make it as a
t10 standard because the main pushers have backed of a bit again.

We are not going to implement SDI in the kernel.  Long before SDI or
it's predecessor, HP CSMI were designed we made it clear we're not going
to accept wide ioctl-APIs, especially when they're even bad for old
ioctl API standards.  The CSMI spec has been passed around in an early
phase and been totally rejected, I think even publically on linux-scsi.
HP decided to move ahead despite that and did a huge mis-services to
their customers.  It's not my problem if big companies can't listen and
do things their customers have to pay for, and it's certainly not our
job to work around their idiocy.

