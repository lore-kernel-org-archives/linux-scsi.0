From: Doug Chapman <doug.chapman@hp.com>
Subject: Re: [Bugme-new] [Bug 8426] New: massive slowdown on SCSI CD/DVD
	drive connected to mptspi driver
Date: Thu, 03 May 2007 22:21:27 -0400
Message-ID: <1178245287.29087.4.camel@phobos>
References: <200705032226.l43MQfl1029235@fire-2.osdl.org>
	 <20070503172001.617460e6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:51662 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767579AbXEDCVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 May 2007 22:21:38 -0400
In-Reply-To: <20070503172001.617460e6.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

On Thu, 2007-05-03 at 17:20 -0700, Andrew Morton wrote:
> (Switching to email - please use reply-to-all)
> 
> On Thu, 3 May 2007 15:26:41 -0700
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8426
> > 
> >            Summary: massive slowdown on SCSI CD/DVD drive connected to
> >                     mptspi driver
> >   
... snip ...
> That's a bit surprising - all the patch allegedly does is move stuff
> around.  Here's my version of a backout patch against 2.6.21 - can anyone
> spot any bloopers in it?
> 

I thought the same thing at first and didn't suspect this patch until I
tried it.  Looks like it does a little more than move stuff around.  It
adds mptspi_initTarget.  I will try backing out just that bit tomorrow
to see if that fixes the issue.

- Doug


