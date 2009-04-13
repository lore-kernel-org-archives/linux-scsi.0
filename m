From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: LSF Papers online?
Date: Mon, 13 Apr 2009 23:40:21 +0200
Message-ID: <200904132340.21525.bzolnier@gmail.com>
References: <49E335BA.3020103@panasas.com> <49E34F41.6050903@panasas.com> <20090413121137.5c5d259c@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42634 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZDMViG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2009 17:38:06 -0400
Received: by fxm2 with SMTP id 2so2167143fxm.37
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2009 14:38:04 -0700 (PDT)
In-Reply-To: <20090413121137.5c5d259c@bike.lwn.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Monday 13 April 2009 20:11:37 Jonathan Corbet wrote:
> On Mon, 13 Apr 2009 17:42:09 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > Rrrr lwn.net costs money! I don't see why it has to be there?
> 
> Perhaps because *I* was there? :)
> 
> As others have noted, the coverage will become free on Thursday.  For
> those who can't wait, here's a couple of free links:
> 
>  day 1:	http://lwn.net/SubscriberLink/327601/58395fefaebea3b5/
>  day 2: http://lwn.net/SubscriberLink/327740/a4f5f4ae07981cec/
> 
> James has also sent me his notes from the storage track; I've formatted
> them up and put them at:
> 
>  http://lwn.net/Articles/328347/
> 
> It's not LWN original content (James wouldn't let us pay him for it),
> so it's free for all readers from the beginning.

Thanks guys!

I've started reading it and immediately noticed a thing which made by day. :-)

Sorry if it will sound off-topic or undiplomatic but it is the best occasion
to straighten up some facts:

 "Discussion then moved on to the current status of getting libata out of
  SCSI: we have had several successes, notably timer handling and pieces of
  error handling have moved up to block. Unfortunately, the current progress
  has reached the point where it's being impeded by the legacy IDE subsystem

Heh, you can also blame the lack of world peace on the legacy IDE subsystem.

I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).

The thing is that during last _five_ years almost nothing was done in this
direction.  Despite the fact that it was #1 condition under which the whole
code has been merged.  Sorry to say it but it seems like the whole merge
strategy was to over-promise things now and worry about delivery later.

To make things worse all the "successes" quoted above are nothing else
like back-ridding on block layer and SCSI improvements which were done by
non-libata developers.

  which is still relying on some very old fields and undocumented behavior
  of the block layer, since the next step is to simplify the block to low level

When it comes to block layer interactions the legacy IDE subsystem is just
another "dumb" (== very simple) block layer driver.

There is a whole lot of SCSI/libata/block things that can be done now but the
real problem seems to be that the strategy to move libata out of SCSI has been
from the start to find somebody else to talk into doing it.

  interface and move to a more exact and well understood API. No solutions were
  proposed, but Tejun will continue on trying to clean up both block and
  drivers/ide in parallel to achieve this."

I'm aware about Tejun's recent work (+ I praise the effort) but it has a very
little to do with moving libata out of SCSI.

Thanks,
Bart
