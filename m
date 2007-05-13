From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 13:45:22 -0500
Message-ID: <1179081922.3723.61.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain>
	 <1179073670.3723.48.camel@mulgrave.il.steeleye.com>
	 <46474E1A.6080904@simon.arlott.org.uk>
	 <1179078537.3723.53.camel@mulgrave.il.steeleye.com>
	 <46475857.4010509@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34680 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757999AbXEMSpl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 May 2007 14:45:41 -0400
In-Reply-To: <46475857.4010509@simon.arlott.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, 2007-05-13 at 19:26 +0100, Simon Arlott wrote:
> On 13/05/07 18:48, James Bottomley wrote:
> > On Sun, 2007-05-13 at 18:42 +0100, Simon Arlott wrote:
> >>> If you set CONFIG_MODULE=y and build SCSI we assume you could have a
> >>> SCSI driver module at some point, which would necessitate the wait scan
> >>> module.
> >> This should be implemented like "Library routines" and only added if such 
> >> a SCSI driver module is actually selected. Why can't it at least be a 
> >> visible option in the menu? (Although even then it looks like it's 
> >> impossible to disable).
> > 
> > There's out of tree modules to consider.
> 
> Ok, I propose we make dozens of modules default 'm' in case an out of 
> tree module requires it.
> 
> SCSI_SCAN_ASYNC ("Asynchronous SCSI scanning"): "You can load the 
> scsi_wait_scan module to ensure that all scans have completed."
> 
> It looks like SCSI_WAIT_SCAN is pointless unless SCSI_SCAN_ASYNC 
> is selected - so it should depend on it:

Why don't you just actually read the thread?  Then you'd understand why
this isn't correct.

James


