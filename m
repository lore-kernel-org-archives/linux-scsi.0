From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 16:47:42 +0200
Message-ID: <200904141647.43049.bzolnier@gmail.com>
References: <49E335BA.3020103@panasas.com> <200904132340.21525.bzolnier@gmail.com> <49E40362.1070405@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:32828 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZDNOvV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 10:51:21 -0400
Received: by fxm2 with SMTP id 2so2468380fxm.37
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 07:51:19 -0700 (PDT)
In-Reply-To: <49E40362.1070405@kernel.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday 14 April 2009 05:30:42 Tejun Heo wrote:
> Hello, Bartlomiej.
> 
> Bartlomiej Zolnierkiewicz wrote:
> > I've started reading it and immediately noticed a thing which made by day. :-)
> > 
> > Sorry if it will sound off-topic or undiplomatic but it is the best occasion
> > to straighten up some facts:
> > 
> >  "Discussion then moved on to the current status of getting libata out of
> >   SCSI: we have had several successes, notably timer handling and pieces of
> >   error handling have moved up to block. Unfortunately, the current progress
> >   has reached the point where it's being impeded by the legacy IDE subsystem
> > 
> > Heh, you can also blame the lack of world peace on the legacy IDE subsystem.
> > 
> > I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).
> 
> Eh... It was my session.  It probably is a bit too summarized.  I
> wans't really trying to blame IDE.  The point was that, at this point,
> adding any feature to the block layer is pretty precarious because in
> many places block layer API has become somewhat ambiguous and many
> users have been abusing in interesting ways for quite some time.  IDE,
> due to its history and complexity, happens to be the most complex one
> to clean up, so that was why IDE was mentioned in the session.
> 
> It's not like IDE has been preventing libata separation for all those
> years.  It's more like, when finally I got my lazy ass moving about
> moving features from SCSI midlayer to block layer, I realized I better
> clean up block API before moving forward and IDE was the most
> difficult user of block API in the process.

Right, this is the proper way of doing it.

> I apologize if it sounded like an attack on IDE.  It's true that IDE
> is the biggest block API abuser but it's mostly due to its long
> history and inherent complexity and you have been doing a lot to clean
> it up, so let's get it done.

No worries, lets focus on cleaning this up.

Thanks,
Bart
