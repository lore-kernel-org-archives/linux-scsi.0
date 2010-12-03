From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Thu, 2 Dec 2010 19:16:35 -0700
Message-ID: <201012021916.35904.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <201012020249.00367.thomas@fjellstrom.ca> <4CF79C60.9030107@shiftmail.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:34032 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312Ab0LCCQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Dec 2010 21:16:42 -0500
In-Reply-To: <4CF79C60.9030107@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On December 2, 2010, Spelic wrote:
> On 12/02/2010 10:48 AM, Thomas Fjellstrom wrote:
> >>> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blo
> >>> b_ pl
> >>> ain;f=queue-2.6.33/libsas-fix-ncq-mixing-with-non-ncq.patch;h=b6d7c9209
> >>> 4 d95 ad67a3b23c2e09c25d4fbd0f46b;hb=HEAD
> >>> 
> >>> The fix is queued up for the next 2.6.36 and 2.6.35 stable
> >>> point-releases.
> >> 
> >> Ahah. I wonder how I missed that when I first read it. I'll have to give
> >> the stable .36 kernel a try. Thanks!
> > 
> > No fix so far:
> If you tried v2.6.36 or v2.6.36.1 like you said you are not getting the
> above mentioned commit.
> It's already applied only in 2.6.37-rc1..rc4
> What version have you tried exactly?

I see I misread a message again. I checked the 2.6.36.1 release changelog and 
it mentions a "libsas fix ncq mixing with non ncq" changeset.

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=commit;h=82fa8bea5ecadf3c2278f677b500905f9ddb7ac0

That seems to be part of 2.6.36.1, so if theres a different patch that I'm 
missing, please let me know.

Thank you :)

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
