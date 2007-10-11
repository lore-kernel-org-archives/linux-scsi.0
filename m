From: Adrian Bunk <bunk@kernel.org>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Fri, 12 Oct 2007 01:56:59 +0200
Message-ID: <20071011235659.GB3620@stusta.de>
References: <200710110552.49129.rob@landley.net> <200710110817.22344.rob@landley.net> <20071011152149.GZ16424@stusta.de> <200710111737.30420.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59611 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753264AbXJKX4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 19:56:30 -0400
Content-Disposition: inline
In-Reply-To: <200710111737.30420.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 05:37:30PM -0500, Rob Landley wrote:
> On Thursday 11 October 2007 10:21:49 am Adrian Bunk wrote:
> > I assume you have the full .config in your build directory, and could
> > have taken it from there?
> 
> Actually I don't.  (The extracted source tree is in a temporary directory 
> which the script deletes afterwards unless I tell it not to.  I just followed 
> my own instructions to create the .config and attach it, but I see that James 
> Bottomley already diagnosed it and you came up with a patch.  Off to try 
> it...)

I was able to follow your instructions for generating it.

But I hope you got my point that it's much easier to debug such issues 
when you generate the .config yourself and attach it when sending the 
bug report.

> Rob

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

