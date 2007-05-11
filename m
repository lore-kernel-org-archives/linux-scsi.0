From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 25/28] Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Fri, 11 May 2007 09:23:38 -0500
Message-ID: <1178893418.3692.19.camel@mulgrave.il.steeleye.com>
References: <200705110601.l4B619oS008190@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49941 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752326AbXEKOXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 10:23:43 -0400
In-Reply-To: <200705110601.l4B619oS008190@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com

On Thu, 2007-05-10 at 23:01 -0700, akpm@linux-foundation.org wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> The CD-ROM layer doesn't bounce requests for old ISA controllers (and nor
> should it).  However they get injected into the SCSI layer via sr_ioctl
> which also doesn't bounce them and SCSI then passes the buffer along to a
> device with unchecked_isa_dma set which either panics or truncates the
> buffer to 24bits.
> 
> According to Jens the right long term fix is for the CD layer to route the
> requests differently but in the mean time this has been tested by a victim
> and verified to sort the problem out.  For the other 99.9% of users it's a
> no-op and doesn't bounce data.
> 
> (akpm: placeholder fix.  Apparently the metaphorical Mike is working on a real
> fix).

No, we fixed this in a different way ... the fix should already be in
git head.

James


