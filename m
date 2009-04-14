From: Tejun Heo <tj@kernel.org>
Subject: Re: LSF Papers online?
Date: Tue, 14 Apr 2009 12:30:42 +0900
Message-ID: <49E40362.1070405@kernel.org>
References: <49E335BA.3020103@panasas.com> <49E34F41.6050903@panasas.com> <20090413121137.5c5d259c@bike.lwn.net> <200904132340.21525.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZDNDaH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2009 23:30:07 -0400
In-Reply-To: <200904132340.21525.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello, Bartlomiej.

Bartlomiej Zolnierkiewicz wrote:
> I've started reading it and immediately noticed a thing which made by day. :-)
> 
> Sorry if it will sound off-topic or undiplomatic but it is the best occasion
> to straighten up some facts:
> 
>  "Discussion then moved on to the current status of getting libata out of
>   SCSI: we have had several successes, notably timer handling and pieces of
>   error handling have moved up to block. Unfortunately, the current progress
>   has reached the point where it's being impeded by the legacy IDE subsystem
> 
> Heh, you can also blame the lack of world peace on the legacy IDE subsystem.
> 
> I wonder who came up with this ridiculous excuse (I'm sure it wasn't James!).

Eh... It was my session.  It probably is a bit too summarized.  I
wans't really trying to blame IDE.  The point was that, at this point,
adding any feature to the block layer is pretty precarious because in
many places block layer API has become somewhat ambiguous and many
users have been abusing in interesting ways for quite some time.  IDE,
due to its history and complexity, happens to be the most complex one
to clean up, so that was why IDE was mentioned in the session.

It's not like IDE has been preventing libata separation for all those
years.  It's more like, when finally I got my lazy ass moving about
moving features from SCSI midlayer to block layer, I realized I better
clean up block API before moving forward and IDE was the most
difficult user of block API in the process.

I apologize if it sounded like an attack on IDE.  It's true that IDE
is the biggest block API abuser but it's mostly due to its long
history and inherent complexity and you have been doing a lot to clean
it up, so let's get it done.

I just came back and am still recovering from time difference.  As the
block map thing kind of became unnecessary, I'll soon test IDE tape
support and repost them.

Thanks.

-- 
tejun
