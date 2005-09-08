From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI merge for 2.6.13
Date: Wed, 07 Sep 2005 19:53:50 -0500
Message-ID: <1126140830.4823.61.camel@mulgrave>
References: <1126053452.5012.28.camel@mulgrave>
	 <Pine.LNX.4.58.0509071730490.11102@g5.osdl.org>
	 <Pine.LNX.4.58.0509071738050.11102@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932497AbVIHAyA@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0509071738050.11102@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2005-09-07 at 17:41 -0700, Linus Torvalds wrote:
> And also, this fails to compile due to the klist problem.
> 
> Quite frankly, what's the point in asking people to pull a tree that is 
> known to not compile?
> 
> Now I made the mistake of pushing the thing out before I realized that the 
> thing that you asked me to pull was the same thing that was known to be 
> incomplete and non-working. That just makes me irritated.

That would be why I told you the tree was still waiting for the klist
fix, and why I waited to request a pull until I saw Andrew send it to
you.

James
