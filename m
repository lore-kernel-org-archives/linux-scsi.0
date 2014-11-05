From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Large disk drives
Date: Wed, 05 Nov 2014 17:07:48 +0100
Message-ID: <1415203668.13212.2.camel@jarvis>
References: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42404 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193AbaKEQHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 11:07:51 -0500
In-Reply-To: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Tue, 2014-11-04 at 11:14 -0500, Alan Stern wrote:
> On Tue, 4 Nov 2014, James Bottomley wrote:
> 
> > On Mon, 2014-11-03 at 16:06 -0500, Dale R. Worley wrote:
> > > Was there any resolution as to how large disk drives would be handled
> > > if their interface did not support the "capacity" request that would
> > > tell how large they were?
> > 
> > Realistically no ... unless someone comes up with a reliable heuristic
> > to give us the size.
> 
> I posted a patch to allow the user to override the reported capacity:
> 
> 	http://marc.info/?l=linux-scsi&m=140993840113445&w=2
> 
> Nobody responded to it.

Sorry, meant to.  In principle I'm OK with this as the lever for the
hack (largely because it means we don't need to do anything) but will
the distributions support it?

> > > Unfortunately, such devices work OK with Windows (since Windows trusts
> > > what the partition table says), you can't just say to the salesperson
> > > "It has to work on drives over 3 TB."
> > 
> > This is a stopgap: your 3TB drive can be guessed as the 16 bit capacity
> > plus 2TB, but the same won't happen for a 5TB device.  Believing the
> > partition table gives us a chicken and egg problem because something
> > still has to get the partition table on to the device.
> > 
> > I don't think "don't buy something that doesn't work" is a hugely
> > unreasonable response to this.
> 
> The problem is knowing beforehand whether it will work.  Once you buy 
> the device and can test it, returning it is annoying and time-consuming 
> at best.

OK, but I still don't understand how windows gets the partition table on
there in the first place ... that must surely be some sort of guess the
disk size hack.

James


> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


