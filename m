From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] libiscsi regression in 2.6.25: fix setting of recv
	timer
Date: Fri, 09 May 2008 10:04:47 -0500
Message-ID: <1210345487.3069.23.camel@localhost.localdomain>
References: <1210295734-6278-1-git-send-email-michaelc@cs.wisc.edu>
	 <1210295734-6278-2-git-send-email-michaelc@cs.wisc.edu>
	 <e2e108260805090757s4ed00c29w21da11a38515ab57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41868 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbYEIPEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 11:04:51 -0400
In-Reply-To: <e2e108260805090757s4ed00c29w21da11a38515ab57@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Fri, 2008-05-09 at 16:57 +0200, Bart Van Assche wrote:
> On Fri, May 9, 2008 at 3:15 AM,  <michaelc@cs.wisc.edu> wrote:
> > From: Mike Christie <michaelc@cs.wisc.edu>
> >
> > If the ping tmo is longer than the recv tmo then we could miss a window
> > where we were supposed to check the recv tmo. This happens because
> > the ping code will set the next timeout for the ping timeout, and if the
> > ping executes quickly there will be a long chunk of time before the
> > timer wakes up again.
> >
> > This patch has the ping processing code kick off a recv
> > tmo check when getting a nop in response to our ping.
> >
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> Hello Mike,
> 
> Did you already consider to submit this patch for inclusion in a
> 2.6.25.x stable release ? See also
> Documentation/stable_kernel_rules.txt for the details.

He can't; if you actually read the rules, the last one says:

 - It or an equivalent fix must already exist in Linus' tree.  Quote the
   respective commit ID in Linus' tree in your patch submission to -stable.

This requires that it be upstream.

There's an automatic tag I do which sends the patch to the stable tree
when it goes upstream from my tree, but the author cannot himself
simultaneously submit it to me and to stable because it's not eligible
until it is upstream.

James


