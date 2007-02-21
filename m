From: Srdjan Todorovic <todorovic.s@googlemail.com>
Subject: Re: initio.h header user confusion
Date: Wed, 21 Feb 2007 16:36:59 +0000 (GMT)
Message-ID: <Pine.LNX.4.63.0702211632160.5167@thor.lan>
References: <Pine.LNX.4.63.0702211558220.5167@thor.lan>
 <20070221162008.GA26111@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:52122 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030351AbXBUQgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 11:36:04 -0500
Received: by nf-out-0910.google.com with SMTP id o25so252327nfa
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 08:36:03 -0800 (PST)
In-Reply-To: <20070221162008.GA26111@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, 21 Feb 2007, Matthew Wilcox wrote:

> On Wed, Feb 21, 2007 at 04:12:06PM +0000, Srdjan Todorovic wrote:
> > So how is it possible that other drivers such as aha1542.c use these defines?
> 
> Possibly, they don't.  I just looked at the ncr53c8xx driver, and the
> only uses of SCSI_ABORT_* are inside an #if 0 block.  The same is true
> for aha1542.

Those pesky #if 0 blocks are annoying.
I just looked at aha1542.c and saw layered #if 0 blocks. :-|

I'll recheck the other drivers then. It would seem the only users then
are initio and sun3*. What's the best thing to do about it?
Should I keep things as they are with SCSI_ABORT_* or should I
move them to include/scsi/ or something entirely different?

Thanks,

Srdjan
