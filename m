From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 22:53:12 +0200
Message-ID: <479F9238.9070307@panasas.com>
References: <200801291531.39825.oliver@neukum.org>	 <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>	 <20080129191024.GO14375@one-eyed-alien.net>	 <1201635195.3069.36.camel@localhost.localdomain>	 <20080129193520.GQ15220@kernel.dk> <20080129194543.GR15220@kernel.dk>	 <479F856C.4090900@panasas.com> <20080129200311.GV15220@kernel.dk>	 <1201637090.3069.38.camel@localhost.localdomain>	 <20080129200651.GW15220@kernel.dk> <1201638257.3069.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4403 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751027AbYA2UyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2008 15:54:11 -0500
In-Reply-To: <1201638257.3069.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jan 29 2008 at 22:24 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-01-29 at 21:06 +0100, Jens Axboe wrote:
>>> I will ... but it will cause an explosion in the bidirectional tree
>>> again.  I think the bidi updates also fix this.  However, give me time
>>> to rebase and verify.
>> OK thanks, just wanted to make sure that we didn't both expect each
>> other to handle it :-)
> 
> Yes, confirm that; I think this is already fixed in scsi-misc-2.6.
> Could you pull from
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> and verify with your device?
> 
> Thanks,
> 
> James
> 
> 
I still don't see these changes, I wanted to check, make sure...
Are there mirrors on the way to here?

James I would like to remind you that one small piece is missing 
from the bidi tree, as I saw it from here, it's the few patches from
scsi-pending. Mainly arm will break which is a grate loss.

I'm going home now, I'll review all the patches tomorrow and compare
to what I have, to make sure nothing was forgotten. What a waste of a day
I pulled from Linus this morning apparently minutes before the merge, and
chased a none existent bug in my tree. Sigh

Bye
Boaz

