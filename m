From: Daniel Patton <djp101@ecs.soton.ac.uk>
Subject: Re: Newbie: multiple initiator contention resolution?
Date: Fri, 02 Apr 2004 21:00:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406DC64C.4030405@ecs.soton.ac.uk>
References: <406C63F7.3060009@ecs.soton.ac.uk> <1080853086.9534.104.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta3.sucs.soton.ac.uk ([152.78.128.142]:36320 "EHLO
	mta3.sucs.soton.ac.uk") by vger.kernel.org with ESMTP
	id S264069AbUDBUBH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 15:01:07 -0500
In-Reply-To: <1080853086.9534.104.camel@persist.az.mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sdake@mvista.com

Steven Dake wrote:

> You have to use some form of external locking mechanism, most often. 
> Most filesystems do not support such a thing.  Check out opengfs (use
> google) for an example of one that does.
> 

Many thanks, I will look into this.  I don't understand why SCSI 
RESERVE/RELEASE can't be used as the locking mechanism though.  Call me 
stupid, but I'm only a student.

As an aside, can you (or anyone) see even the *vaguest* possible use for 
my project?  It basically allows you to construct a "virtual" switching 
fabric with an arbitrary topology, attach a few fake disks to it, then 
load an LLD on various hosts and they all see all the fake disks.

Dan Patton
djp101@ecs.soton.ac.uk

