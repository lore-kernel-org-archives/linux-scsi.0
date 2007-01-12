From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: IO transfer limits
Date: Fri, 12 Jan 2007 01:54:05 +0100 (CET)
Message-ID: <tkrat.2c7c7f62e5e34ac3@s5r6.in-berlin.de>
References: <8260533.post@talk.nabble.com> <45A5250E.3020205@cs.wisc.edu>
 <8269227.post@talk.nabble.com> <45A58FA5.2090003@torque.net>
 <45A6620C.3040807@s5r6.in-berlin.de> <45A6B120.7070903@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54077 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXALAyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 19:54:16 -0500
In-Reply-To: <45A6B120.7070903@torque.net>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: john clyne <clyne@ucar.edu>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> There are cheap external boxes out there that have 1394,
> USB and (e)SATA interfaces. I wonder what would happen
> if one tried to use two interfaces connected to different
> machines at the same time :-)

AFAIK these are all based on the OXUF924 series of bridge chips. Their
FireWire side supports multiple initiators, at least if OxSemi's
firmware is used, like all but the very earliest OxSemi SBP-2 target
devices. However my _guess_ is the different interconnects---FireWire,
USB, eSATA---cannot be used together at once. (John, sorry for straying
off the subject.)
-- 
Stefan Richter
-=====-=-=== ---= -==--
http://arcgraph.de/sr/

