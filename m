From: Pete Clements <clem@clem.clem-digital.net>
Subject: Re: 2.6.0-test9-bk26 fails boot -- aic7890 detection
Date: Sat, 22 Nov 2003 20:58:12 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311230158.UAA13162@clem.clem-digital.net>
References: <1069546688.2667.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clem.clem-digital.net ([68.16.168.10]:61188 "EHLO
	clem.clem-digital.net") by vger.kernel.org with ESMTP
	id S263158AbTKWB6P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 20:58:15 -0500
In-Reply-To: <1069546688.2667.11.camel@mulgrave> from James Bottomley at "Nov 22, 2003  6:18: 7 pm"
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: clem@clem.clem-digital.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Quoting James Bottomley
  > On Sat, 2003-11-22 at 15:09, Pete Clements wrote:
  > > Quoting James Bottomley
  > >   > On Sat, 2003-11-22 at 09:09, Pete Clements wrote:
  > >   > > 2.6.0-test9-bk26 boot hangs after ide detection. Next detect normally
  > >   > > scsi AIC7XXX.  Has been good for all prior test9-bk's.
  > >   > 
  > >   > I'm assuming bk26 contains the latest set of SCSI diffs (they were
  > >   > merged on 21 Nov around 14:00 PST)?
  > >   > 
  > >   > I've never successfully managed to get the aic7xxx driver to work on my
  > >   > parisc platform.  However, both with and without the latest SCSI diffs
  > >   > the behaviour seems the same (it does print out the driver banner before
  > >   > failing to connect to the drives).  I take it you aren't seeing this
  > >   > banner?
  > > 
  > > Correct, no banner and bk26 has a scsi_scan change.
  > 
  > Hmm, I can't reproduce this.  However, when I alter the aic7xxx driver
  > actually to work on my 2944W card, I do see a kobject badness error
  > (although it still boots up for me).
  > 
  > Could you try this patch (from Mike Anderson).  It makes the kobject
  > badness go away for me, and so may fix your problem.  If it doesn't,
  > I'll have to defer to people who have aic cards and x86 hardware.

Patch applied, no change, same hang.
-- 
Pete Clements 
