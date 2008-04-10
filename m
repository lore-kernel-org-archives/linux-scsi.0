From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: + aacraid-fix-unchecked-down_interruptible.patch added to -mm
	tree
Date: Thu, 10 Apr 2008 16:57:37 -0500
Message-ID: <1207864657.4915.40.camel@localhost.localdomain>
References: <200804102037.m3AKb2g4016314@imap1.linux-foundation.org>
	 <1207860882.4915.35.camel@localhost.localdomain>
	 <18656C81-9F7B-47D8-B02C-9E7667349500@adaptec.com>
	 <20080410142929.3be73136.akpm@linux-foundation.org>
	 <69D7FE1A-36E3-4BA4-8B54-728B50E7E6B7@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48029 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbYDJV5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 17:57:44 -0400
In-Reply-To: <69D7FE1A-36E3-4BA4-8B54-728B50E7E6B7@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2008-04-10 at 17:44 -0400, Mark Salyzyn wrote:
> 	if (down_interruptible(&fibptr->event_wait) == 0) {
> 		fibptr->done = 2;
>                 up(&fibptr->event_wait);
> 	}
> 
> would make me feel much more comfortable ... The fib can never be  
> 'freed'. The fib is owned by the adapter until it completes it on it's  
> own (if ever, the assumption here is that the adapter is misbehaving  
> on this 'one' fib). Setting the value of 2 allows us to report back to  
> the ioctl caller a failed operation without actually closing out the  
> fib.
> 
> I am having a problem with my bandwidth right now to do a unit test to  
> see if this gets the job done.

That's OK ... send the patch when you're ready; I'll make sure it gets
upstream.  We'll do the standard put it into scsi-misc and backport if
it seems stable, so we'll have time to shake out any problems.

James


