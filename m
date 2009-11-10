From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Thin provisioning update
Date: Tue, 10 Nov 2009 14:10:09 -0500
Message-ID: <1257880209.4184.438.camel@mulgrave.site>
References: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com>
	 <20091109142051.GC4855@infradead.org>
	 <20091109193409.GA26596@infradead.org> <yq13a4nos7y.fsf@sermon.lab.mkp.net>
	 <20091110131649.GA4516@infradead.org>  <yq18weenr4y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35161 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757845AbZKJTKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2009 14:10:09 -0500
In-Reply-To: <yq18weenr4y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

On Tue, 2009-11-10 at 13:58 -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> >> Ok.  Jens, please queue the patch below.  And then we'll have to see
> >> about getting James to rebase and/or postpone the SCSI portion to
> >> round #2.
> 
> Christoph> Can't we please get both patches in through one tree?
> Christoph> Everything else is a bit of a pain to manage.
> 
> I'm intimately familiar with said pain.  Pretty much everything I do
> touches both block and scsi :/
> 
> But James has been pretty good about rebasing scsi-misc on top of Jens'
> tree.  That's how we've done all the other tricky merges.
> 
> James, what do you think?

SCSI pretty much pioneered the use of postmerge trees, which is how I do
this ... if everyone's happy, that's what I'll do this time.

James



