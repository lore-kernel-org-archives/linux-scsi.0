From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Thu, 10 Jul 2008 16:23:41 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0807101623070.2936@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0807101908390.1756@lancer.cnet.absolutedigital.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbYGJXYl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 19:24:41 -0400
In-Reply-To: <Pine.LNX.4.64.0807101908390.1756@lancer.cnet.absolutedigital.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cal Peake <cp@absolutedigital.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>



On Thu, 10 Jul 2008, Cal Peake wrote:
> 
> It looks like we're getting down to the last -rc; can this patch please 
> make it into main-line before 2.6.26 goes final?

James said he was pushing it out to his scsi-rc-fixes tree, but I haven't 
seen a pull request.

But you're right, final is near. Maybe I should just merge it directly.

		Linus
