From: Arne Redlich <agr@powerkom-dd.de>
Subject: Re: [Scst-devel] [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Thu, 08 May 2008 17:54:03 +0200
Message-ID: <1210262043.12678.9.camel@blackadder>
References: <200805021638.42972.bart.vanassche@gmail.com>
	 <20080502153306.GB7376@infradead.org>
	 <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com>
	 <20080502155525.GA16353@infradead.org>
	 <e2e108260805040830i7d797c53o9757bae7243d6e27@mail.gmail.com>
	 <e2e108260805080802r1ad75926idc8654e2acfe014f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pow-web.powerkom-dd.de ([212.80.237.131]:55223 "EHLO
	mail.powerkom-dd.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753186AbYEHQ2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 12:28:52 -0400
In-Reply-To: <e2e108260805080802r1ad75926idc8654e2acfe014f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel@lists.sourceforge.net, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

Am Donnerstag, den 08.05.2008, 17:02 +0200 schrieb Bart Van Assche:
> On Sun, May 4, 2008 at 5:30 PM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
> > On Fri, May 2, 2008 at 5:55 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >> On Fri, May 02, 2008 at 05:53:22PM +0200, Bart Van Assche wrote:
> >>> Regarding scsi_execute_async(): I didn't know that this API is on its
> >>> way out. What will it be replaced by, and when ?
> >>
> >> blk_execute_rq/blk_execute_rq_nowait plus the block level helpers built
> >> ontop to build requests.
> >
> > Source reading learned me that the function scsi_execute_async() calls
> > blk_execute_rq_nowait() with 1 as fourth argument, which means that
> > the request is inserted at the head of the queue. This means that
> > requests queued with scsi_execute_async() are executed before other
> > queued requests, and that this function has LIFO (last in first out)
> > semantics.
> >
> > All non-SCSI calls to blk_execute_rq() / blk_execute_rq_nowait() add
> > requests at the end of the queue (except those calls for terminating
> > I/O).
> >
> > What is the background of this special behavior of the SCSI subsystem ?
> 
> Is the linux-scsi mailing list the appropriate mailing list to post
> questions like the above ?

I guess this should
 http://marc.info/?l=linux-scsi&m=116668527804801&w=2
answer your question.

HTH,
Arne

