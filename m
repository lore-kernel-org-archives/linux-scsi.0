From: Steven Dake <sdake@mvista.com>
Subject: Re: Newbie: multiple initiator contention resolution?
Date: Thu, 01 Apr 2004 13:58:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080853086.9534.104.camel@persist.az.mvista.com>
References: <406C63F7.3060009@ecs.soton.ac.uk>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:5405 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S263161AbUDAU6N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 15:58:13 -0500
In-Reply-To: <406C63F7.3060009@ecs.soton.ac.uk>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Patton <djp101@ecs.soton.ac.uk>
Cc: linux-scsi@vger.kernel.org

On Thu, 2004-04-01 at 11:48, Daniel Patton wrote:
> Hello all,
> 
> I'm an undergraduate at a UK university, and I'm very much a newbie to 
> kernel development, so my apologies in advance if my questions sound 
> daft or have been answered before, etc.
> 
> I'm doing a project on something which involves writing a LLD for a 
> "fake" disk, similar to scsi_debug.  However, the LLD may loaded on 
> multiple hosts, and they all see the same fake disk.  Does the sd driver 
> have any kind of built-in contention resolution mechanism for such 
> multiple initiator setups?  That is, if I mount a partition on my fake 
> disk simultaneously on more than one host, how do I stop the filesystem 
> from getting corrupted?
> 

You have to use some form of external locking mechanism, most often. 
Most filesystems do not support such a thing.  Check out opengfs (use
google) for an example of one that does.

> Many thanks in advance.
> 
> Dan Patton
> djp101@ecs.soton.ac.uk
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

