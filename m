From: Pete Clements <clem@clem.clem-digital.net>
Subject: Re: 2.6.0-test9-bk26 fails boot -- aic7890 detection
Date: Sat, 22 Nov 2003 16:09:51 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311222109.QAA10536@clem.clem-digital.net>
References: <1069528226.1664.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clem.clem-digital.net ([68.16.168.10]:46084 "EHLO
	clem.clem-digital.net") by vger.kernel.org with ESMTP
	id S262772AbTKVVJy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Nov 2003 16:09:54 -0500
In-Reply-To: <1069528226.1664.5.camel@mulgrave> from James Bottomley at "Nov 22, 2003  1:10:24 pm"
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: clem@clem.clem-digital.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Quoting James Bottomley
  > On Sat, 2003-11-22 at 09:09, Pete Clements wrote:
  > > 2.6.0-test9-bk26 boot hangs after ide detection. Next detect normally
  > > scsi AIC7XXX.  Has been good for all prior test9-bk's.
  > 
  > I'm assuming bk26 contains the latest set of SCSI diffs (they were
  > merged on 21 Nov around 14:00 PST)?
  > 
  > I've never successfully managed to get the aic7xxx driver to work on my
  > parisc platform.  However, both with and without the latest SCSI diffs
  > the behaviour seems the same (it does print out the driver banner before
  > failing to connect to the drives).  I take it you aren't seeing this
  > banner?

Correct, no banner and bk26 has a scsi_scan change.
-- 
Pete Clements 
