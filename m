From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Questions about your scsi-mq prototype
Date: Fri, 26 Jul 2013 11:03:55 -0700
Message-ID: <1374861835.7397.1494.camel@haakon3.risingtidesystems.com>
References: <20130715214143.GN24437@beardog.cce.hp.com>
	 <1373996340.7397.818.camel@haakon3.risingtidesystems.com>
	 <1374804999.7397.1476.camel@haakon3.risingtidesystems.com>
	 <20130726132940.GL24664@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59393 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3GZR6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 13:58:15 -0400
In-Reply-To: <20130726132940.GL24664@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: chayan.biswas@sandisk.com, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliot <Elliott@hp.com>

On Fri, 2013-07-26 at 08:29 -0500, scameron@beardog.cce.hp.com wrote:
> On Thu, Jul 25, 2013 at 07:16:39PM -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2013-07-16 at 10:39 -0700, Nicholas A. Bellinger wrote:

<SNIP>

> > Hi Stephen & Robert,
> > 
> > Just curious if you've been able to make any progress here..?
> 
> Only just started to try to make the scsi variant of the sop driver
> work again yesterday and start bringing it up to date since it was
> last touched in December, and so I haven't done anything with the
> scsi-mq code yet.  Too many other things demanding my attention at
> work lately, but at least I was able to spend nearly all day yesterday
> working on the scsi SOP driver.
> 

Great, thanks for the update.  Looking forward to seeing the drivers
synced.

> > 
> > Also as per our earlier off-list discussion, you should be able to
> > safely run existing scsi_request_fn() based LLDs along side new
> > SHT->scsi_mq=true enabled code for prototyping purposes.
> 
> Thanks, good to know.
> 
> > 
> > Btw, any chance to get an SOP sample to hack on..?  I'd like to connect
> > one of these to IvyBridge-EP silicon for various scsi-mq and target mode
> > performance testing.  ;)
> 
> You mean hardware?

Yes!

>  Not for me to answer, but I'd say it's not very likely at the moment.

If you can point me to a person off-list to chat with about such an
arrangement, it would be appreciated.  I'm happy to sign an NDA and
whatever legal bits are necessary to make a scsi-mq enabled SOP driver a
reality.

--nab

