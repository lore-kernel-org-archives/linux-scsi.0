From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Thu, 10 Jul 2008 16:35:06 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0807101631370.2936@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>  <Pine.LNX.4.64.0807101908390.1756@lancer.cnet.absolutedigital.net>  <alpine.LFD.1.10.0807101623070.2936@woody.linux-foundation.org>
 <1215732525.3353.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbYGJXfu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 19:35:50 -0400
In-Reply-To: <1215732525.3353.102.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Cal Peake <cp@absolutedigital.net>, Alan Stern <stern@rowland.harvard.edu>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>



On Thu, 10 Jul 2008, James Bottomley wrote:
> 
> It's one of the two patches in scsi-rc-fixes.  I'm just seeing if any
> problems show up in linux-next.  I'm playing the usual game of trying to
> judge how long I have left ... so I'm thinking on Monday ... is that
> about right?

I'm not planning on a -rc10, there's not any real justification for it. 

Yes, we've had changes since -rc9, but apart from 1300+ lines of 
documentation, the rest is all really small fixes (some for problems that 
have been pending for a longish while - today has been a good day, for 
example).

Lacking a -rc10 due to major changes (which quite frankly do not look 
likely based on current regression lists or other activity), 2.6.26 would 
probably happen over the weekend. So it would be better to get any trivial 
changes in _now_, and at least give them a couple of days in -git.

		Linus
