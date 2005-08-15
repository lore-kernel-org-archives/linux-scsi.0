From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: LLDD: scatterlists only?
Date: Sun, 14 Aug 2005 17:08:33 -0700 (PDT)
Message-ID: <20050815000834.95746.qmail@web51611.mail.yahoo.com>
References: <1124063460.18802.27.camel@mulgrave>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51611.mail.yahoo.com ([68.142.224.84]:41067 "HELO
	web51611.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932581AbVHOAIo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2005 20:08:44 -0400
In-Reply-To: <1124063460.18802.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Sun, 2005-08-14 at 16:24 -0700, Luben Tuikov wrote:
> > Did someone have a patch or was there a talk
> > that SCSI Core is moving towards sending _only_ scatterlists
> > down to LLDDs?  (effectively BUG_ON(!cmd->use_sg))
> 
> Yes, you can already see the beginnings in the -mm tree.
> 
> Jens is maintaining a block tree with this in here:
> 
>
http://www.kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=shortlog;h=rq-map
> 
> And I have a scsi-block-2.6 tree based off this here:
> 
>
http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-block-2.6.git;a=summary
> 
> The missing (and frankly really nasty) pieces are pulling all the sg
> handling out of sg and st, but fortunately Mike Christie is working on
> that.

Ok, thanks James.

    Luben

