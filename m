From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: twa generates WARNING upon boot
Date: Wed, 30 Sep 2015 09:43:28 -0700
Message-ID: <1443631408.2185.32.camel@HansenPartnership.com>
References: <CAHtARFHdFOVHZ2_-JT9_nvRZmbF+cffRrtaaE4DSZSrJwU6BCA@mail.gmail.com>
	 <d8e4bcdc939f0926a63f5c4a35fb8e0c.squirrel@atoth.sote.hu>
	 <1443548266.2207.19.camel@HansenPartnership.com>
	 <1443549768.2207.22.camel@HansenPartnership.com>
	 <95d34bcc4c0fcf84d02d76a4443ba07c.squirrel@atoth.sote.hu>
	 <1443551581.2207.26.camel@HansenPartnership.com>
	 <20150930160835.GA16534@infradead.org>
	 <1443629730.2185.25.camel@HansenPartnership.com>
	 <20150930163147.GA2928@infradead.org>
	 <1443630984.2185.27.camel@HansenPartnership.com>
	 <20150930164123.GA24596@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41403 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbbI3Qna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 12:43:30 -0400
In-Reply-To: <20150930164123.GA24596@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "\"T?th Attila\"" <atoth@atoth.sote.hu>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2015-09-30 at 09:41 -0700, Christoph Hellwig wrote:
> On Wed, Sep 30, 2015 at 09:36:24AM -0700, James Bottomley wrote:
> > Are you sure?  The init trace that kicked all this off still has
> > twa_init in it.  I was figuring the most likely suspect is
> > twa_get_param().
> 
> That one doesnt set ->srb at all, but given that it's called before
> any SCSI commands can sent ->srb will be all NULL.  It certainly
> doesn't use a scsi_cmnd anywhere and does not expect to hit any
> code path calling scsi_dma_unmap.  If it ends up there it's a bad bug
> and would blow up a lot more spectacularly.

OK, post a compilable version of the patch and lets get the reporter to
try it out.  Not resurrecting esoteric flags suits me.

James


