From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 3 Aug 2007 17:39:32 -0400
Message-ID: <200708031639.32343.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <200708031407.31175.rob@landley.net> <46B383DE.9060408@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50931
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762266AbXHCVlP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 17:41:15 -0400
In-Reply-To: <46B383DE.9060408@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Friday 03 August 2007 2:37:02 pm Stefan Richter wrote:
> Rob Landley wrote:
> > They keep using the fact that they're exporting random kernel data as an
> > excuse for not documenting a stable subset of this as an API userspace
> > can rely on.
>
> At least sysfs-rules.txt is a start, although it contains more Don'ts
> than Dos.

I've noticed this. :)

> > This is a bug, not a feature.  Linux has always had a
> > stable _USERSPACE_ API.  This is exposed to userspace, and userspace is
> > expected to be able to use this.  If they're exporting stuff they
> > shouldn't be exporting, then they should stop exporting it.
>
> The kernel log is exported to userspace too.

The kernel log is debug info, and nothing but debug info.  You should only 
ever need to look at if something bad has happened.  Attempts to extract 
information from it in an automated fashion during the normal operation of 
the system are a bad idea, and always have been.

Sysfs _claims_ to provide information for use by userspace programs.  It 
claims to do so without providing a stable API.  This is a contradiction in 
terms.

I realize that the easy way to see what name the scsi layer assigned to the 
USB key you just plugged in is dmesg | tail and then look at it a bit, but 
this is a horrible workaround for the scsi layer's tendency to conflate 
different classes of devices into a single arbitrarily ordered sequence, and 
there are less horrible workarounds.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
