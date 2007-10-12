From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Thu, 11 Oct 2007 17:10:42 -0700
Message-ID: <20071011171042.582a22d4.randy.dunlap@oracle.com>
References: <200710110552.49129.rob@landley.net>
	<200710110817.22344.rob@landley.net>
	<20071011152149.GZ16424@stusta.de>
	<200710111737.30420.rob@landley.net>
	<20071011235659.GB3620@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39681 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXJLAMe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Oct 2007 20:12:34 -0400
In-Reply-To: <20071011235659.GB3620@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Rob Landley <rob@landley.net>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 01:56:59 +0200 Adrian Bunk wrote:

> On Thu, Oct 11, 2007 at 05:37:30PM -0500, Rob Landley wrote:
> > On Thursday 11 October 2007 10:21:49 am Adrian Bunk wrote:
> > > I assume you have the full .config in your build directory, and could
> > > have taken it from there?
> > 
> > Actually I don't.  (The extracted source tree is in a temporary directory 
> > which the script deletes afterwards unless I tell it not to.  I just followed 
> > my own instructions to create the .config and attach it, but I see that James 
> > Bottomley already diagnosed it and you came up with a patch.  Off to try 
> > it...)
> 
> I was able to follow your instructions for generating it.
> 
> But I hope you got my point that it's much easier to debug such issues 
> when you generate the .config yourself and attach it when sending the 
> bug report.

I use the mini-config method quite a bit (probably not as much
as Rob does), but I agree with Adrian, it should have just been
included here in full (not mini).

---
~Randy
