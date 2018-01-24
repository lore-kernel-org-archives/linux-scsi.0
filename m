From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] Patch Submission process and Handling Internal
 Conflict
Date: Wed, 24 Jan 2018 13:36:00 -0800
Message-ID: <1516829760.3073.43.camel@HansenPartnership.com>
References: <1516820744.3073.30.camel@HansenPartnership.com>
         <c4598a9a-6995-d67a-dd1c-8e946470eeb4@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37122 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932539AbeAXVgD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 16:36:03 -0500
In-Reply-To: <c4598a9a-6995-d67a-dd1c-8e946470eeb4@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Kravetz <mike.kravetz@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lsf-pc@lists.linux-foundation.org

On Wed, 2018-01-24 at 11:20 -0800, Mike Kravetz wrote:
> On 01/24/2018 11:05 AM, James Bottomley wrote:
> > 
> > I've got two community style topics, which should probably be
> > discussed
> > in the plenary
> > 
> > 1. Patch Submission Process
> > 
> > Today we don't have a uniform patch submission process across
> > Storage, Filesystems and MM.  The question is should we (or at
> > least should we adhere to some minimal standards).  The standard
> > we've been trying to hold to in SCSI is one review per accepted
> > non-trivial patch.  For us, it's useful because it encourages
> > driver writers to review each other's patches rather than just
> > posting and then complaining their patch hasn't gone in.  I can
> > certainly think of a couple of bugs I've had to chase in mm where
> > the underlying patches would have benefited from review, so I'd
> > like to discuss making the one review per non-trival patch our base
> > minimum standard across the whole of LSF/MM; it would certainly
> > serve to improve our Reviewed-by statistics.
> 
> Well, the mm track at least has some discussion of this last year:
> https://lwn.net/Articles/718212/

The pushback in your session was mandating reviews would mean slowing
patch acceptance or possibly causing the dropping of patches that
couldn't get reviewed.  Michal did say that XFS didn't have the
problem, however there not being XFS people in the room, discussion
stopped there.  Having this as a plenary would allow people outside mm
to describe their experiences and for us to look at process based
solutions using our shared experience.

James
