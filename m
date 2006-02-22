From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: [Bugme-new] [Bug 6114] New: Initio sbp2 causes: "slab error
 in cache_free_debugcheck(): cache `size-512(DMA)': double free, or memory
 outside" object was overwritten
Date: Tue, 21 Feb 2006 19:53:28 -0500
Message-ID: <43FBB608.5060202@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:11672 "EHLO
	tomts43-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S1751221AbWBVAya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 19:54:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Stefan Richter wrote:

> What I don't understand is why mode page 8 is still accessed in your
> log: http://bugzilla.kernel.org/attachment.cgi?id=7432&action=view
> (Log lines "command: Mode Sense (10): 5a 00 08 00 00 00 00 00 d9 00",
> "SCSI transfer size = 17d9" --- yeah, into a 512 Bytes big buffer, "sda:
> got wrong page".)

Stefan,
That sounds familiar. My guess is that a MODE SENSE (6)
response is being returned for a MODE SENSE (10) cdb.
"sdparm -f" can decode that in some contexts.

Doug Gilbert

P.S. I'm forced to use a broken smtp server hence my truncated reply.
