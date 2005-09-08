From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [GIT PATCH] SCSI merge for 2.6.13
Date: Wed, 7 Sep 2005 17:41:02 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0509071738050.11102@g5.osdl.org>
References: <1126053452.5012.28.camel@mulgrave> <Pine.LNX.4.58.0509071730490.11102@g5.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42629 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932438AbVIHAlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 20:41:09 -0400
In-Reply-To: <Pine.LNX.4.58.0509071730490.11102@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>



On Wed, 7 Sep 2005, Linus Torvalds wrote:
>
> You meant 
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-for-linus-2.6.git
> 
> I do believe,

And also, this fails to compile due to the klist problem.

Quite frankly, what's the point in asking people to pull a tree that is 
known to not compile?

Now I made the mistake of pushing the thing out before I realized that the 
thing that you asked me to pull was the same thing that was known to be 
incomplete and non-working. That just makes me irritated.

		Linus
