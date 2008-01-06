From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] tgt: Use scsi_init_io instead of scsi_alloc_sgtable
Date: Sun, 06 Jan 2008 11:18:43 -0600
Message-ID: <1199639923.5205.61.camel@localhost.localdomain>
References: <47611977.5080702@panasas.com>  <47611B01.4010505@panasas.com>
	 <1199487754.17877.99.camel@localhost.localdomain>
	 <47810B26.1090709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49182 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbYAFRTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2008 12:19:03 -0500
In-Reply-To: <47810B26.1090709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, 2008-01-06 at 19:08 +0200, Boaz Harrosh wrote:
> On Sat, Jan 05 2008 at 1:02 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Thu, 2007-12-13 at 13:44 +0200, Boaz Harrosh wrote:
> >> - If we export scsi_init_io()/scsi_release_buffers() instead of
> >>     scsi_{alloc,free}_sgtable() from scsi_lib than tgt code is
> >>     much more insulated from scsi_lib changes. As a bonus it will
> >>     also gain bidi capability when it comes.
> >>
> >> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> >> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > 
> > I'm afraid the reversion of ->done removal broke the application of this
> > yet again ... could you respin.
> > 
> > Thanks,
> > 
> > James
> > 
> It looks like the revert is to be reverted ;)
> I have rebased, but should I wait a while to
> see if they're needed?

Yes, let's just wait a while to see what the outcome is ...

James


