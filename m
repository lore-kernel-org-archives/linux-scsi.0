From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
Date: Thu, 10 Jan 2008 12:33:22 -0700
Message-ID: <20080110193321.GH18741@parisc-linux.org>
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <1199991828.3141.82.camel@localhost.localdomain> <20080110193227.GH747@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36342 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYAJTdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 14:33:23 -0500
Content-Disposition: inline
In-Reply-To: <20080110193227.GH747@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andre Noll <maan@systemlinux.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

On Thu, Jan 10, 2008 at 08:32:27PM +0100, Andi Kleen wrote:
> Not many really in the core kernel. Hardly any. Grep for 
> lock_kernel to be sure, but there is not much.
> 
> It's mostly drivers that still need it.
> 
> How about the low level SCSI drivers that might called from the high
> level SCSI code? 
> 
> Anyways starting these kinds of discussions was the goal of the proposal.
> Even if Andre's patch ends up not being merged it would have reached
> its goal.

If your goal is to get rid of the BKL everywhere, sure.  It's not clear
to me this is the most productive way of spending our time though.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
