From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Mon, 19 May 2008 10:27:17 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0805191026120.32253@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0805191106270.15266-100000@iolanthe.rowland.org> <4831A60A.5010308@panasas.com> <alpine.LFD.1.10.0805190929170.32253@woody.linux-foundation.org> <4831B2E2.8030700@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbYESRcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2008 13:32:47 -0400
In-Reply-To: <4831B2E2.8030700@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Maciej Rutecki <maciej.rutecki@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>



On Mon, 19 May 2008, Boaz Harrosh wrote:
> 
> Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
> spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
> places that initiate a MODE_SENSE command, specifically at
> scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)

I was actualyl more thinking that the safest thing to do would be to just 
pre-clear the sense buffer. Then, if some driver doesn't fill it 
correctly, big deal..

It's not like pre-clearing the bugger is a performance issue.

		Linus
