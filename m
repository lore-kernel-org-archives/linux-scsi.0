From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Fri, 17 Dec 2010 08:13:31 -0500
Message-ID: <1292591611.2820.1.camel@mulgrave.site>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
	 <4D0A1AD0.1040703@redhat.com>
	 <AANLkTikEB02WAiHTYe=FLm9EKhjTdaLLd97NQvWg2Y9t@mail.gmail.com>
	 <AANLkTin5=YL2mQxtGKQUTRCvnb2N29B32+J2ds8t-xPP@mail.gmail.com>
	 <4D0B3E9F.5000101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57520 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0LQNNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 08:13:37 -0500
In-Reply-To: <4D0B3E9F.5000101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Fri, 2010-12-17 at 11:42 +0100, Tomas Henzl wrote:
> On 12/16/2010 06:13 PM, adam radford wrote:
> > On Thu, Dec 16, 2010 at 8:58 AM, adam radford <aradford@gmail.com> wrote:
> >   
> >> On Thu, Dec 16, 2010 at 5:57 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> >>     
> >>> Hi Adam, Bo,
> >>>
> >>> The function megasas_fusion_ocr_wq seems to be used already in patch 6/11
> >>> and declared in 7/11 - this breaks bisectability.
> >>>
> >>> Further my compiler complains about a large frame size.
> >>> Probably the 'struct scsi_device dev' is too large to be on stack.
> >>> make checkstack
> >>> ...
> >>> 0x000090f4 megasas_fusion_ocr_wq [megaraid_sas]:        1696
> >>>
> >>>       
> >> Tomas,
> >>
> >> Thanks, we will fix this and repost patches 6 thru 10.
> >>
> >> -Adam
> >>
> >>     
> > Tomas,
> >
> > Actually, if you look the patch 6, we put a note in there, that
> > patches 6 thru 10 must be applied 'at once' for the build to work:
> >
> > "Note: Patches 6 thru 10 have to be applied at once in order to build."
> >   
> I'm not sure if git-bisect can understand this.

He means I apply them all at once as a single commit.  We had to do this
with the first five patches of Online Controller Reset which were
likewise unbisectable.   It's a way of getting around the mailing list
patch size limite (currently about $150k, I think) and making the
patches more reviewable.

What I do want for this is a rolled up change log for the entire commit,
please.

James

> > This has been allowed on this list before.  Otherwise, we would have a
> > very large patch while turning on the new support for this controller,
> > making the patch less review-able by the community.
> >   
> If the maintainer accepts this, than I'm fine too. 
> 
> > I will look into and fix the large frame size compile issue you are
> > seeing and re-post the appropriate patches.
> >   
> Thanks.
> Tomas
> 
> > -Adam
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
> 


