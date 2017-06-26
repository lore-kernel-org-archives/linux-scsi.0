From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Mon, 26 Jun 2017 20:55:49 +0200
Message-ID: <1498503349.27347.15.camel@suse.com>
References: <20170616082755.22832-1-hch@lst.de>
         <1498143933.6002.18.camel@suse.com> <1498479220.8799.0.camel@wdc.com>
         <1498491078.8799.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:39929 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdFZS4c (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 26 Jun 2017 14:56:32 -0400
In-Reply-To: <1498491078.8799.2.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,

On Mon, 2017-06-26 at 15:31 +0000, Bart Van Assche wrote:
> On Mon, 2017-06-26 at 12:13 +0000, Bart Van Assche wrote:
> > On Thu, 2017-06-22 at 17:05 +0200, Martin Wilck wrote:
> > > On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
> > > > Remove the SCSI_MQ_DEFAULT config option and default to the
> > > > blk-mq
> > > > I/O
> > > > path now that we had plenty of testing, and have I/O schedulers
> > > > for
> > > > blk-mq.  The module option to disable the blk-mq path is kept
> > > > around
> > > > for now.
> > > 
> > > Could you explain why you remove the option entirely rather than
> > > just
> > > changing the default? Some distributions may wish to keep the
> > > ability
> > > to choose the compiled-in default.
> > 
> > Hello Martin,
> > 
> > Would it work for you to keep this patch as a distro-private patch?
> 
> What I meant is: apply this patch to the upstream kernel and keep 
> CONFIG_SCSI_MQ_DEFAULT as a distro-private patch.

First, let me clarify that I was not speaking for SUSE when I asked
this question, just expressing my personal concerns, partly motivated
by my previous employment at a hardware manufacturer.

Of course distro-makers can deal with this in various ways, for example
the way you suggest, although that sounds like a rather painful route
to choose.

I personally find it odd that the compile-time choice goes away while
the run-time choice remains available. I understand what Christoph is
trying to achieve, but if it was up to me, I'd prefer to change the
default and mark the "n" setting as deprecated.

Again, please do not take this as an official SUSE statement. I just
happen to be subscribed to linux-scsi with my suse.com address.

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
