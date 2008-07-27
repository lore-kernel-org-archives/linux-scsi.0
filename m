From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] final SCSI pieces for 2.6.27
Date: Sun, 27 Jul 2008 10:12:27 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0807271004440.3486@nehalem.linux-foundation.org>
References: <1217170150.3503.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbYG0RPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2008 13:15:30 -0400
In-Reply-To: <1217170150.3503.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>



On Sun, 27 Jul 2008, James Bottomley wrote:
> 
> and the diffstat:
> 
>  drivers/md/dm-mpath.c                       |   13 
>  drivers/scsi/3w-9xxx.c                      |   40 +
...

Hmm. This diffstat does not match what I get at all. You seem to have 
added a lot of changes to drivers/message/fusion/* at a minimum, and the 
diffstat must have been an earlier version.

It seems to be that last "SCSI] replace __FUNCTION__ with __func__" thing 
that is where all the changes are, even though you did list it:

	Harvey Harrison (1):
	      replace __FUNCTION__ with __func__

you seem to later then have changed it.

		Linus
