From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 10:06:25 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29933 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751394AbWG2RGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 13:06:37 -0400
In-Reply-To: <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sat, 29 Jul 2006, James Bottomley wrote:
> 
> I concur.  If we're going to allow users access to burn CDs, it's
> impossible to police them with certainty as this case indicates.

Not so. I can (and have) written tons of CD's as a normal user, with 
perfect security.

No, the kernel shouldn't allow device-specific commands. That goes without 
saying. Whether this is a sg.c problem, or a cdrecord problem is unclear, 
I suspect it's the latter. 

		Linus
