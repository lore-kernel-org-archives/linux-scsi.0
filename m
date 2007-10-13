From: Rob Landley <rob@landley.net>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Sat, 13 Oct 2007 14:09:35 -0500
Message-ID: <200710131409.36164.rob@landley.net>
References: <200710110552.49129.rob@landley.net> <200710111737.30420.rob@landley.net> <20071011235659.GB3620@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35596
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbXJMTJm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Oct 2007 15:09:42 -0400
In-Reply-To: <20071011235659.GB3620@stusta.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org

On Thursday 11 October 2007 6:56:59 pm Adrian Bunk wrote:
> On Thu, Oct 11, 2007 at 05:37:30PM -0500, Rob Landley wrote:
> > On Thursday 11 October 2007 10:21:49 am Adrian Bunk wrote:
> > > I assume you have the full .config in your build directory, and could
> > > have taken it from there?
> >
> > Actually I don't.  (The extracted source tree is in a temporary directory
> > which the script deletes afterwards unless I tell it not to.  I just
> > followed my own instructions to create the .config and attach it, but I
> > see that James Bottomley already diagnosed it and you came up with a
> > patch.  Off to try it...)
>
> I was able to follow your instructions for generating it.
>
> But I hope you got my point that it's much easier to debug such issues
> when you generate the .config yourself and attach it when sending the
> bug report.

*shrug*  I find miniconfig much easier to read because I can see what the 50 
or so intentional options are, not just the 1000 or so background options set 
to various default values.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
