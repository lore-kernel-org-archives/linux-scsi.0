From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] scsi_lib: rate-limit the error message from failing
 commands
Date: Sat, 22 Sep 2012 09:11:31 +0100
Message-ID: <1348301491.2476.3.camel@dabdike.int.hansenpartnership.com>
References: <20120830210607.28119.96438.stgit@localhost6.localdomain6>
	 <503FF64C.6040409@kernel.dk>
	 <CAMM=eLdhuqKij12zXxTWJ9wMEHp3HxZJxbCHGCRbzBE647WK8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60389 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab2IVILf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Sep 2012 04:11:35 -0400
In-Reply-To: <CAMM=eLdhuqKij12zXxTWJ9wMEHp3HxZJxbCHGCRbzBE647WK8A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Yi Zou <yi.zou@intel.com>, Jens Axboe <axboe@kernel.dk>, "www.Open-FCoE.org" <devel@open-fcoe.org>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org

On Fri, 2012-09-21 at 15:15 -0400, Mike Snitzer wrote:
> On Thu, Aug 30, 2012 at 7:25 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On 2012-08-30 14:06, Yi Zou wrote:
> >> [
> >> Jens/James,
> >>
> >> This is a rather old rate limt patch but never gets picked up in upstream, so I
> >> am resending it here as v3, with some minor changes so it is directly applicable
> >> to the current linux-2.6.git tree. I don't have that many LUNs that the original
> >> issue was reported but the patch was already reviewed and acked in the past,
> >> I did retest w/ stress I/O on 4 LUNs I have right now.
> >>
> >> Original thread can be found at:
> >> http://comments.gmane.org/gmane.linux.scsi/73497
> >> http://www.open-fcoe.org/patchwork/patch/2436/
> >>
> >> Can you please pull this patch in? it's been hanging there for a long time.
> >> Original patch description is below.
> >
> > I've pulled in the block bit.
> 
> James,
> 
> Do you intend to pick up the scsi_lib.c change?

Possibly, if someone resends.  The original v3 patch isn't actually on
the list that I can find.

James


